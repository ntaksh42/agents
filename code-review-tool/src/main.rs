mod config;
mod error;
mod git;
mod output;
mod review;

use clap::Parser;
use git::GitOperations;
use std::path::PathBuf;
use std::process::ExitCode;
use tracing_subscriber::EnvFilter;

#[derive(Parser, Debug)]
#[command(name = "code-review-tool")]
#[command(about = "GitHub Copilot を使ったコードレビューCLIツール")]
struct Args {
    /// レビュー対象のgitリポジトリパス
    #[arg(long)]
    repo: PathBuf,

    /// ソースブランチ（レビュー対象の変更が含まれるブランチ）
    #[arg(long)]
    source: String,

    /// ターゲットブランチ（比較先、通常はmain）
    #[arg(long)]
    target: String,

    /// 設定ファイルのパス
    #[arg(long)]
    config: PathBuf,

    /// レビュー結果の出力先ファイル（省略時はstdoutのみ）
    #[arg(long)]
    output_file: Option<PathBuf>,

    /// API呼び出しをスキップし、構築されたプロンプトを表示する
    #[arg(long)]
    dry_run: bool,
}

fn init_logging() {
    tracing_subscriber::fmt()
        .with_writer(std::io::stderr)
        .with_env_filter(
            EnvFilter::try_from_default_env().unwrap_or_else(|_| EnvFilter::new("info")),
        )
        .without_time()
        .with_target(false)
        .init();
}

#[tokio::main]
async fn main() -> ExitCode {
    init_logging();

    if let Err(e) = run().await {
        tracing::error!("{e}");
        return ExitCode::FAILURE;
    }
    ExitCode::SUCCESS
}

async fn run() -> crate::error::Result<()> {
    let args = Args::parse();

    // 設定読み込み
    let config_dir = args
        .config
        .parent()
        .unwrap_or_else(|| std::path::Path::new("."))
        .to_path_buf();

    let cfg = config::load_config(&args.config)?;
    cfg.validate()?;
    let system_prompt = config::load_prompt(&cfg, &config_dir)?;
    let template = config::load_template(&cfg, &config_dir)?;

    let model = cfg
        .agent
        .model
        .as_deref()
        .unwrap_or("gpt-4.1")
        .to_string();

    // git diff取得
    let git = git::RealGit;
    tracing::info!("git diffを取得中...");
    let diff = git.get_diff(
        &args.repo,
        &args.target,
        &args.source,
        cfg.review.max_diff_lines,
    )?;

    if diff.trim().is_empty() {
        tracing::warn!("diffが空です。ブランチ間に差分がありません。");
        return Ok(());
    }

    // 変更ファイルの内容取得
    tracing::info!("変更ファイルの内容を取得中...");
    let changed_files = git.get_changed_files(&args.repo, &args.target, &args.source)?;
    let file_contents =
        git.get_changed_file_contents(&args.repo, &args.source, &changed_files)?;

    // レビュー用メッセージ構築
    let user_message =
        review::build_user_message(&diff, &file_contents, &args.source, &args.target);

    // dry-runモード: プロンプトを表示して終了
    if args.dry_run {
        tracing::info!(chars = system_prompt.chars().count(), "=== System Prompt ===");
        let truncated: String = system_prompt.chars().take(500).collect();
        eprintln!("{truncated}");
        if system_prompt.chars().count() > 500 {
            eprintln!("... (truncated)");
        }
        eprintln!();
        tracing::info!(chars = user_message.chars().count(), "=== User Message ===");
        print!("{user_message}");
        tracing::info!(model = %model, changed_files = changed_files.len(), "dry-run完了");
        return Ok(());
    }

    // レビュー実行
    let agent_name = cfg.agent.name.as_deref();
    let review_result =
        review::run_review(&system_prompt, &user_message, &model, agent_name).await?;

    // ファイル出力（オプション）
    if let Some(output_path) = &args.output_file {
        output::write_review(output_path, &review_result, template.as_deref())?;
    }

    Ok(())
}
