use crate::error::{AppError, Result};
use serde::Deserialize;
use std::path::{Path, PathBuf};

#[derive(Debug, Deserialize)]
pub struct Config {
    pub agent: AgentConfig,
    pub review: ReviewConfig,
    #[serde(default)]
    pub output: OutputConfig,
}

#[derive(Debug, Deserialize)]
pub struct AgentConfig {
    pub name: Option<String>,
    pub model: Option<String>,
    pub system_prompt_file: String,
    #[serde(default)]
    pub perspectives_files: Vec<String>,
}

#[derive(Debug, Deserialize)]
pub struct ReviewConfig {
    #[serde(default = "default_max_diff_lines")]
    pub max_diff_lines: usize,
}

#[derive(Debug, Default, Deserialize)]
pub struct OutputConfig {
    pub template_file: Option<String>,
}

fn default_max_diff_lines() -> usize {
    5000
}

/// TOMLファイルを読み込みConfigを返す
pub fn load_config(config_path: &Path) -> Result<Config> {
    let content = std::fs::read_to_string(config_path).map_err(|e| AppError::Config {
        message: format!("設定ファイルを読み込めません: {}", config_path.display()),
        source: Some(Box::new(e)),
    })?;
    let config: Config = toml::from_str(&content).map_err(|e| AppError::Config {
        message: "設定ファイルのパースに失敗しました".to_string(),
        source: Some(Box::new(e)),
    })?;
    Ok(config)
}

/// 設定ファイルの親ディレクトリ基準で相対パスを解決する
fn resolve_path(base_dir: &Path, relative: &str) -> PathBuf {
    let p = Path::new(relative);
    if p.is_absolute() {
        p.to_path_buf()
    } else {
        base_dir.join(p)
    }
}

/// system_prompt_file + perspectives_filesを結合して1つのプロンプトを生成
pub fn load_prompt(config: &Config, config_dir: &Path) -> Result<String> {
    let prompt_path = resolve_path(config_dir, &config.agent.system_prompt_file);
    let mut prompt = std::fs::read_to_string(&prompt_path).map_err(|e| AppError::Config {
        message: format!("プロンプトファイルを読み込めません: {}", prompt_path.display()),
        source: Some(Box::new(e)),
    })?;

    for perspective_file in &config.agent.perspectives_files {
        let path = resolve_path(config_dir, perspective_file);
        let content = std::fs::read_to_string(&path).map_err(|e| AppError::Config {
            message: format!("観点ファイルを読み込めません: {}", path.display()),
            source: Some(Box::new(e)),
        })?;
        prompt.push_str("\n\n---\n\n");
        prompt.push_str(&content);
    }

    Ok(prompt)
}

/// 出力テンプレートの読み込み（オプション）
pub fn load_template(config: &Config, config_dir: &Path) -> Result<Option<String>> {
    match &config.output.template_file {
        Some(template_file) => {
            let path = resolve_path(config_dir, template_file);
            let content = std::fs::read_to_string(&path).map_err(|e| AppError::Config {
                message: format!(
                    "テンプレートファイルを読み込めません: {}",
                    path.display()
                ),
                source: Some(Box::new(e)),
            })?;
            Ok(Some(content))
        }
        None => Ok(None),
    }
}

impl Config {
    pub fn validate(&self) -> Result<()> {
        if self.agent.system_prompt_file.is_empty() {
            return Err(AppError::Validation(
                "system_prompt_file が空です".to_string(),
            ));
        }
        if self.review.max_diff_lines < 1 {
            return Err(AppError::Validation(
                "max_diff_lines は1以上である必要があります".to_string(),
            ));
        }
        if let Some(ref model) = self.agent.model {
            if model.is_empty() {
                return Err(AppError::Validation(
                    "model が空文字列です".to_string(),
                ));
            }
        }
        for (i, pf) in self.agent.perspectives_files.iter().enumerate() {
            if pf.is_empty() {
                return Err(AppError::Validation(
                    format!("perspectives_files[{i}] が空文字列です"),
                ));
            }
        }
        Ok(())
    }
}
