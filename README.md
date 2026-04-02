# Second Path Backend (API)

介護・支援の現場における「記録」「振り返り」「コミュニケーション」のオペレーション負荷を極限まで削減するために構築された、業務支援プラットフォーム **Second Path** のバックエンド（Rails API）です。

- **Backend (this repo)**: Ruby on Rails (API mode)
- **Frontend (separate repo)**: Next.js (App Router) / React / TypeScript

---

## 🛠 技術スタックと選定理由

本プロジェクトでは、単なる機能実装に留まらず、**「運用できる速度」と「破綻しない保守性」**の両立を狙って設計しています。

- **Backend**: Ruby on Rails（API mode）
  - **理由**: CRUDの速度、堅牢なActiveRecord、テスト/運用ノウハウの厚みを活かし、プロダクト価値に直結する開発へ集中するため
- **Database**: PostgreSQL（想定）
  - **理由**: JSON/配列型、インデックス、拡張性を含め、プロダクション運用での選択肢が広い
- **Auth (client-provided)**: `X-User-Id` ヘッダーによるユーザー識別（Supabase等の外部IDを前提）
  - **理由**: 認証基盤は外部に寄せ、API側はドメインロジックに集中（※要件に応じてJWT検証へ拡張可能）
- **Quality**: RuboCop
  - **理由**: 可読性と一貫性を維持し、チーム/将来の自分が変更しやすい状態を保つ

---

## ✨ 核心的な技術的ポイント

- **一覧検索でのN+1回避**: `includes` を使い、必要な関連をまとめてロード
- **運用前提のデータ整合性**: 外部ID（`supabase_id`）を一意に扱い、重複を防ぐ設計（ユニーク制約/インデックス）
- **APIの責務を明確化**: フロントの体験速度はフロントに委ねつつ、バックエンドは整合性・検証・永続化に集中

---

## 📡 API 概要（例）

主に以下のようなリソースを扱います（実装により変わる可能性があります）。

- **Users / Profiles**: ユーザーとプロフィール情報
- **Diaries**: 日次の記録
- **Assessments**: PHQ-9 / レジリエンス / 認知の歪み等の評価データ
- **Admin APIs**: 管理者向けの一覧・検索・アクティビティ参照

---

## 🚀 ローカル開発

### 前提

- Ruby（`.ruby-version` に準拠）
- PostgreSQL

### セットアップ

```bash
bundle install
bin/rails db:create db:migrate
bin/rails s
```

### Lint / Format

```bash
bundle exec rubocop -a
```

---

## 🐳 Docker (recommended)

ローカルにRuby/PostgreSQLを入れずに起動したい場合は Docker を使えます。

### 起動

```bash
docker compose up --build
```

初回は `db:prepare`（DB作成 + migrate）が走った後、Rails が `0.0.0.0:3000` で起動します。

### よく使うコマンド

```bash
# 迁移だけ回す
docker compose run --rm api bin/rails db:migrate

# Rails console
docker compose run --rm api bin/rails c

# RSpec
docker compose run --rm api bundle exec rspec
```

---

## 🔗 Links

- **API (Render)**: `https://secondpath-backend.onrender.com`
- **Frontend (example)**: `second-path-frontend.vercel.app`

