# Azure Artifacts CLI Reference

## Table of Contents
- [Feeds](#feeds)
- [Universal Packages](#universal-packages)
- [NuGet Packages](#nuget-packages)
- [npm Packages](#npm-packages)
- [Maven Packages](#maven-packages)
- [Python Packages](#python-packages)

## Feeds

```bash
# フィード一覧
az artifacts feed list --output table

# フィード詳細
az artifacts feed show --feed {feed-name}

# フィード作成
az artifacts feed create --name {feed-name}

# スコープ付きフィード作成（プロジェクト限定）
az artifacts feed create \
  --name {feed-name} \
  --scope project

# 上流ソースを含むフィード作成
az artifacts feed create \
  --name {feed-name} \
  --include-upstream-sources

# フィード更新
az artifacts feed update \
  --feed {feed-name} \
  --description "Updated description"

# フィード削除
az artifacts feed delete --feed {feed-name} --yes
```

## Universal Packages

```bash
# パッケージ公開
az artifacts universal publish \
  --feed {feed-name} \
  --name {package-name} \
  --version {version} \
  --path {path-to-files}

# パッケージダウンロード
az artifacts universal download \
  --feed {feed-name} \
  --name {package-name} \
  --version {version} \
  --path {download-path}

# 最新バージョンをダウンロード
az artifacts universal download \
  --feed {feed-name} \
  --name {package-name} \
  --version "*" \
  --path {download-path}
```

## NuGet Packages

Azure Artifacts NuGet フィードの認証設定:

```bash
# NuGet ソース追加（PAT認証）
nuget sources add \
  -Name "AzureArtifacts" \
  -Source "https://pkgs.dev.azure.com/{org}/{project}/_packaging/{feed}/nuget/v3/index.json" \
  -Username "any" \
  -Password "{PAT}"

# 資格情報プロバイダーのインストール
# https://github.com/microsoft/artifacts-credprovider
```

## npm Packages

```bash
# .npmrc 設定の取得
az artifacts npm credential \
  --feed {feed-name}

# npmrc ファイル生成（プロジェクト用）
az artifacts npm credential \
  --feed {feed-name} \
  --project-level
```

`.npmrc` 設定例:
```
registry=https://pkgs.dev.azure.com/{org}/_packaging/{feed}/npm/registry/
always-auth=true
; begin auth token
//pkgs.dev.azure.com/{org}/_packaging/{feed}/npm/registry/:username={org}
//pkgs.dev.azure.com/{org}/_packaging/{feed}/npm/registry/:_password={BASE64_PAT}
//pkgs.dev.azure.com/{org}/_packaging/{feed}/npm/registry/:email=any@email.com
; end auth token
```

## Maven Packages

Maven の `settings.xml` 設定:
```xml
<servers>
  <server>
    <id>azure-artifacts</id>
    <username>{org}</username>
    <password>{PAT}</password>
  </server>
</servers>

<repositories>
  <repository>
    <id>azure-artifacts</id>
    <url>https://pkgs.dev.azure.com/{org}/_packaging/{feed}/maven/v1</url>
  </repository>
</repositories>
```

## Python Packages

```bash
# pip.conf / pip.ini 設定
[global]
index-url=https://{org}:{PAT}@pkgs.dev.azure.com/{org}/_packaging/{feed}/pypi/simple/
```

twine でのアップロード:
```bash
twine upload \
  --repository-url https://pkgs.dev.azure.com/{org}/_packaging/{feed}/pypi/upload/ \
  -u {org} \
  -p {PAT} \
  dist/*
```

## Feed Permissions

```bash
# フィードのアクセス許可一覧
az artifacts feed permission list --feed {feed-name}

# アクセス許可追加
az artifacts feed permission add \
  --feed {feed-name} \
  --role contributor \
  --identity {user-or-group}

# アクセス許可削除
az artifacts feed permission delete \
  --feed {feed-name} \
  --identity {user-or-group}
```

### 役割（Roles）
- `reader` - 読み取り専用
- `contributor` - パッケージの公開・削除
- `owner` - フィード設定の管理

## Upstream Sources

```bash
# 上流ソース追加
# （注：REST API または Azure DevOps UI で設定）

# 一般的な上流ソース:
# - nuget.org
# - npmjs.com
# - pypi.org
# - Maven Central
```

## Retention Policies

フィードの保持ポリシーは Azure DevOps UI または REST API で設定:
- 最大パッケージバージョン数
- 古いプレリリースバージョンの自動削除
