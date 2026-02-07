use thiserror::Error;

#[derive(Debug, Error)]
pub enum AppError {
    #[error("設定エラー: {message}")]
    Config {
        message: String,
        #[source]
        source: Option<Box<dyn std::error::Error + Send + Sync>>,
    },

    #[error("gitコマンドエラー: git {command}: {detail}")]
    Git { command: String, detail: String },

    #[error("gitの出力をUTF-8として解釈できません: {path}")]
    GitEncoding { path: String },

    #[error("Copilot SDKエラー ({phase}): {detail}")]
    CopilotSdk { phase: String, detail: String },

    #[error("出力エラー ({path}): {message}")]
    Output { path: String, message: String },

    #[error("バリデーションエラー: {0}")]
    Validation(String),
}

pub type Result<T> = std::result::Result<T, AppError>;
