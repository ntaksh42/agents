use crate::error::{AppError, Result};
use copilot_sdk::{
    Client, CustomAgentConfig, SessionConfig, SessionEventData, SystemMessageConfig,
    SystemMessageMode,
};

/// Copilot CLIを起動し、セッション経由でコードレビューを実行する
pub async fn run_review(
    system_prompt: &str,
    user_message: &str,
    model: &str,
    agent_name: Option<&str>,
) -> Result<String> {
    // 1. Client構築・起動
    tracing::info!("Copilot CLIを起動中...");
    let client = Client::builder()
        .use_stdio(true)
        .build()
        .map_err(|e| AppError::CopilotSdk {
            phase: "クライアント構築".to_string(),
            detail: e.to_string(),
        })?;

    client.start().await.map_err(|e| AppError::CopilotSdk {
        phase: "CLI起動".to_string(),
        detail: format!(
            "{e}. GitHub Copilot CLIがインストールされ、認証済みか確認してください"
        ),
    })?;

    // 2. セッション設定
    let agent_name = agent_name.unwrap_or("code-reviewer");

    let session_config = SessionConfig {
        model: Some(model.to_string()),
        streaming: true,
        system_message: Some(SystemMessageConfig {
            mode: Some(SystemMessageMode::Replace),
            content: Some(system_prompt.to_string()),
        }),
        custom_agents: Some(vec![CustomAgentConfig {
            name: agent_name.to_string(),
            prompt: system_prompt.to_string(),
            display_name: Some("Code Reviewer".to_string()),
            description: Some("Performs code review on git diffs".to_string()),
            ..Default::default()
        }]),
        ..Default::default()
    };

    // 3. セッション作成
    tracing::info!(model = %model, "レビューセッションを作成中...");
    let session = client
        .create_session(session_config)
        .await
        .map_err(|e| AppError::CopilotSdk {
            phase: "セッション作成".to_string(),
            detail: e.to_string(),
        })?;

    // 4. イベント購読（送信前に）
    let mut events = session.subscribe();

    // 5. メッセージ送信
    tracing::info!("レビューを実行中...");
    session
        .send(user_message)
        .await
        .map_err(|e| AppError::CopilotSdk {
            phase: "メッセージ送信".to_string(),
            detail: e.to_string(),
        })?;

    // 6. イベントループ: ストリーミングでレビュー結果を受信
    let mut buffer = String::new();

    loop {
        match events.recv().await {
            Ok(event) => match &event.data {
                SessionEventData::AssistantMessageDelta(delta) => {
                    // stdoutにリアルタイム出力
                    print!("{}", delta.delta_content);
                    buffer.push_str(&delta.delta_content);
                }
                SessionEventData::SessionIdle(_) => {
                    // 完了
                    break;
                }
                SessionEventData::SessionError(err) => {
                    // クリーンアップしてからエラーを報告
                    let _ = session.destroy().await;
                    let _ = client.stop().await;
                    return Err(AppError::CopilotSdk {
                        phase: "セッション実行".to_string(),
                        detail: format!("{}: {}", err.error_type, err.message),
                    });
                }
                _ => {
                    // その他のイベントは無視
                }
            },
            Err(e) => {
                let _ = session.destroy().await;
                let _ = client.stop().await;
                return Err(AppError::CopilotSdk {
                    phase: "イベント受信".to_string(),
                    detail: e.to_string(),
                });
            }
        }
    }

    // 改行でストリーミング出力を締める
    println!();

    // 7. クリーンアップ（destroy失敗してもstopは必ず実行）
    let destroy_result = session.destroy().await;
    let stop_result = client.stop().await;
    if let Err(e) = destroy_result {
        tracing::warn!("セッション破棄失敗: {e}");
    }
    if let Err(e) = stop_result {
        tracing::warn!("CLI停止失敗: {e}");
    }

    Ok(buffer)
}
