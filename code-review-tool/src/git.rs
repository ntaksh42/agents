use crate::error::{AppError, Result};
use std::path::Path;
use std::process::Command;

pub trait GitOperations {
    fn get_diff(
        &self,
        repo: &Path,
        target: &str,
        source: &str,
        max_diff_lines: usize,
    ) -> Result<String>;
    fn get_changed_files(
        &self,
        repo: &Path,
        target: &str,
        source: &str,
    ) -> Result<Vec<String>>;
    fn get_changed_file_contents(
        &self,
        repo: &Path,
        source: &str,
        files: &[String],
    ) -> Result<Vec<(String, String)>>;
}

pub struct RealGit;

impl GitOperations for RealGit {
    fn get_diff(
        &self,
        repo: &Path,
        target: &str,
        source: &str,
        max_diff_lines: usize,
    ) -> Result<String> {
        let diff_range = format!("{target}...{source}");
        let diff = run_git(repo, &["diff", &diff_range])?;

        let lines: Vec<&str> = diff.lines().collect();
        if lines.len() > max_diff_lines {
            let truncated: String = lines[..max_diff_lines].join("\n");
            Ok(format!(
                "{truncated}\n\n... (diff truncated at {max_diff_lines} lines, total {} lines)",
                lines.len()
            ))
        } else {
            Ok(diff)
        }
    }

    fn get_changed_files(
        &self,
        repo: &Path,
        target: &str,
        source: &str,
    ) -> Result<Vec<String>> {
        let diff_range = format!("{target}...{source}");
        let output = run_git(repo, &["diff", "--name-only", &diff_range])?;

        let files: Vec<String> = output
            .lines()
            .filter(|l| !l.is_empty())
            .map(|l| l.to_string())
            .collect();
        Ok(files)
    }

    fn get_changed_file_contents(
        &self,
        repo: &Path,
        source: &str,
        files: &[String],
    ) -> Result<Vec<(String, String)>> {
        let mut results = Vec::new();
        for file in files {
            let ref_path = format!("{source}:{file}");
            match run_git(repo, &["show", &ref_path]) {
                Ok(content) => {
                    results.push((file.clone(), content));
                }
                Err(AppError::Git { detail, .. })
                    if detail.contains("does not exist")
                        || detail.contains("not exist")
                        || detail.contains("fatal: path") =>
                {
                    tracing::debug!(file = %file, "sourceブランチに存在しないためスキップ");
                }
                Err(e) => return Err(e),
            }
        }
        Ok(results)
    }
}

/// gitコマンドを指定リポジトリで実行し、stdoutを返す
fn run_git(repo: &Path, args: &[&str]) -> Result<String> {
    let command_str = args.join(" ");
    let output = Command::new("git")
        .args(args)
        .current_dir(repo)
        .output()
        .map_err(|e| AppError::Git {
            command: command_str.clone(),
            detail: format!("gitコマンドの実行に失敗しました: {e}"),
        })?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        return Err(AppError::Git {
            command: command_str,
            detail: stderr.trim().to_string(),
        });
    }

    let stdout = String::from_utf8(output.stdout).map_err(|_| AppError::GitEncoding {
        path: command_str,
    })?;
    Ok(stdout)
}
