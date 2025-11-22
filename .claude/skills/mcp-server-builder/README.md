# MCP Server Builder Skill

Model Context Protocol (MCP) サーバーを簡単に構築するClaude Code スキルです。

## 概要

Anthropicの**Model Context Protocol (MCP)**に準拠したサーバーを自動生成し、LLMが外部ツール、データベース、APIと対話できるようにします。

## 主な機能

- ✅ Python/TypeScript/C#/Go サーバー生成
- ✅ Tools、Resources、Prompts の3機能実装
- ✅ ベストプラクティス適用（ログ、バリデーション、エラーハンドリング）
- ✅ Claude Desktop統合設定自動生成
- ✅ テストコード付属
- ✅ 本番環境対応

## クイックスタート

### 基本的な使い方

```
TypeScript MCPサーバーを作成：
名前: weather-server
ツール: get_forecast, get_alerts
```

### Python サーバー

```
Python MCPサーバーを作成：
名前: github-analyzer
機能:
- リポジトリ情報取得ツール
- コミット履歴リソース
- PRレビュープロンプト
```

### フル機能サーバー

```
本番環境向けMCPサーバー：
名前: database-manager
言語: TypeScript
Tools: データベースクエリ、スキーマ取得
Resources: テーブル一覧
Prompts: SQL最適化
認証: API Key
テスト: 含む
```

## MCPの3つの機能

1. **Tools**: LLMが呼び出せる関数（API呼び出し、計算など）
2. **Resources**: ファイル的なデータ（ドキュメント、設定など）
3. **Prompts**: 再利用可能なプロンプトテンプレート

## ベストプラクティス

### ロギング（重要）

```typescript
// ❌ NG: stdout はプロトコル通信用
console.log("Server started");

// ✅ OK: stderr にログ出力
console.error("Server started");
```

### スキーマ検証

```typescript
// TypeScript + Zod
const ArgsSchema = z.object({
  name: z.string(),
  age: z.number().positive(),
});
```

```python
# Python + Pydantic
class Args(BaseModel):
    name: str
    age: int = Field(gt=0)
```

## 対応言語

| 言語 | SDK | バリデーション | 優先度 |
|------|-----|----------------|--------|
| TypeScript | `@modelcontextprotocol/sdk` | Zod | 最優先 |
| Python | `mcp` | Pydantic | 高 |
| C# | 公式SDK | System.Text.Json | 中 |
| Go | 公式SDK | - | 低 |

## Claude Desktop 統合

生成されたサーバーをClaude Desktopに統合：

**設定ファイル**: `~/Library/Application Support/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["/path/to/server/dist/index.js"]
    }
  }
}
```

## 生成されるファイル

```
my-server-mcp/
├── package.json / pyproject.toml
├── tsconfig.json (TypeScript)
├── src/
│   ├── index.ts/server.py
│   ├── tools.ts/tools.py
│   └── types.ts/types.py
├── tests/
├── README.md
└── .env.example
```

## 使用例

### 例1: Calculator

```
MCPサーバー作成:
名前: calculator
ツール: add, subtract, multiply, divide
言語: TypeScript
```

### 例2: File Manager

```
Python MCPサーバー:
名前: file-manager
ツール: read_file, write_file
リソース: ディレクトリ一覧
```

### 例3: Code Reviewer

```
MCPサーバー:
名前: code-reviewer
ツール: analyze_code
プロンプト: security-review, performance-review
```

## トラブルシューティング

**Q: サーバーが起動しない**
- A: stdout にログ出力していないか確認（stderr使用）

**Q: ツールが見つからない**
- A: ListTools と CallTool の名前が一致しているか確認

**Q: スキーマエラー**
- A: Zod/Pydantic のスキーマ定義を確認

## 詳細ドキュメント

詳しい使い方、実装例、高度な機能は [SKILL.md](SKILL.md) を参照してください。

## 参考リンク

- [公式ドキュメント](https://modelcontextprotocol.io/)
- [GitHub - MCP](https://github.com/modelcontextprotocol)
- [サーバー例集](https://github.com/modelcontextprotocol/servers)

## バージョン

- Version: 1.0.0
- MCP Spec: 2025-01-01
- Last Updated: 2025-11-22
