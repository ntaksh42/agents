use crate::error::{AppError, Result};
use std::path::Path;

/// レビュー結果をファイルに書き出す
/// テンプレートがあれば `{{review_content}}` を置換する
pub fn write_review(output_path: &Path, review: &str, template: Option<&str>) -> Result<()> {
    let content = match template {
        Some(tmpl) => tmpl.replace("{{review_content}}", review),
        None => review.to_string(),
    };

    if let Some(parent) = output_path.parent() {
        std::fs::create_dir_all(parent).map_err(|e| AppError::Output {
            path: parent.display().to_string(),
            message: format!("出力ディレクトリを作成できません: {e}"),
        })?;
    }

    std::fs::write(output_path, &content).map_err(|e| AppError::Output {
        path: output_path.display().to_string(),
        message: format!("レビュー結果をファイルに書き込めません: {e}"),
    })?;

    tracing::info!(path = %output_path.display(), "レビュー結果を保存しました");
    Ok(())
}
