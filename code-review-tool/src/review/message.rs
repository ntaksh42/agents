/// diff + ファイルコンテキストからレビュー用メッセージを構築
pub fn build_user_message(
    diff: &str,
    file_contents: &[(String, String)],
    source: &str,
    target: &str,
) -> String {
    let mut msg = String::new();

    msg.push_str(&format!(
        "## Code Review Request\n\n\
         **Source branch**: `{source}`\n\
         **Target branch**: `{target}`\n\n"
    ));

    msg.push_str("### Diff\n\n```diff\n");
    msg.push_str(diff);
    msg.push_str("\n```\n\n");

    if !file_contents.is_empty() {
        msg.push_str("### Changed File Contents (full source from source branch)\n\n");
        for (path, content) in file_contents {
            let ext = path.rsplit('.').next().unwrap_or("");
            msg.push_str(&format!("#### `{path}`\n\n```{ext}\n{content}\n```\n\n"));
        }
    }

    msg
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_build_user_message_basic() {
        let diff = "+fn hello() {}";
        let files = vec![("src/main.rs".to_string(), "fn hello() {}".to_string())];
        let msg = build_user_message(diff, &files, "feature", "main");

        assert!(msg.contains("**Source branch**: `feature`"));
        assert!(msg.contains("**Target branch**: `main`"));
        assert!(msg.contains("+fn hello() {}"));
        assert!(msg.contains("#### `src/main.rs`"));
        assert!(msg.contains("fn hello() {}"));
    }

    #[test]
    fn test_build_user_message_empty_files() {
        let diff = "+fn hello() {}";
        let files: Vec<(String, String)> = vec![];
        let msg = build_user_message(diff, &files, "feature", "main");

        assert!(msg.contains("**Source branch**: `feature`"));
        assert!(msg.contains("### Diff"));
        assert!(!msg.contains("### Changed File Contents"));
    }
}
