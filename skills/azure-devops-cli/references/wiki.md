# Azure DevOps Wiki CLI Reference

## Table of Contents
- [Wiki Management](#wiki-management)
- [Wiki Pages](#wiki-pages)

## Wiki Management

```bash
# Wiki 一覧
az devops wiki list --output table

# Wiki 詳細
az devops wiki show --wiki {wiki-name}

# プロジェクト Wiki 作成
az devops wiki create \
  --name {wiki-name} \
  --type projectWiki

# コード Wiki 作成（リポジトリベース）
az devops wiki create \
  --name {wiki-name} \
  --type codeWiki \
  --repository {repo-name} \
  --mapped-path "/" \
  --version "main"

# Wiki 削除
az devops wiki delete --wiki {wiki-name} --yes
```

## Wiki Pages

### ページ作成・更新
```bash
# ページ作成
az devops wiki page create \
  --wiki {wiki-name} \
  --path "Page Title" \
  --content "# Heading\n\nContent here"

# ファイルからページ作成
az devops wiki page create \
  --wiki {wiki-name} \
  --path "Page Title" \
  --file-path ./content.md

# サブページ作成
az devops wiki page create \
  --wiki {wiki-name} \
  --path "Parent/Child Page" \
  --content "Child page content"

# ページ更新
az devops wiki page update \
  --wiki {wiki-name} \
  --path "Page Title" \
  --content "Updated content" \
  --version {etag}
```

### ページ参照
```bash
# ページ表示
az devops wiki page show \
  --wiki {wiki-name} \
  --path "Page Title"

# ページ内容のみ取得
az devops wiki page show \
  --wiki {wiki-name} \
  --path "Page Title" \
  --include-content

# サブページ一覧（再帰的）
az devops wiki page show \
  --wiki {wiki-name} \
  --path "/" \
  --recursive
```

### ページ削除
```bash
# ページ削除
az devops wiki page delete \
  --wiki {wiki-name} \
  --path "Page Title" \
  --yes
```

## Wiki Page Format

Azure DevOps Wiki は Markdown 形式をサポート:

```markdown
# 見出し1
## 見出し2

**太字** と *斜体*

- 箇条書き
- リスト

1. 番号付き
2. リスト

[リンク](https://example.com)

![画像](/image.png)

| 表 | ヘッダー |
|----|---------|
| A  | B       |

`inline code`

​```python
code block
​```

> 引用

[[_TOC_]] <!-- 目次 -->

::: mermaid
graph LR
    A --> B
:::
```

## Tips

- ページパスには `/` を使用してサブページを作成
- ページ更新時は `--version` (ETag) が必要
- 画像は Wiki に直接アップロードするか、リポジトリ内の画像を参照
- Mermaid 図がサポートされている
