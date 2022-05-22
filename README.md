# notion_api_sample



https://user-images.githubusercontent.com/91307335/169681190-188d3d8a-e1c1-400d-8164-f765b6205dbb.mov


<br>
Flutter クライアントアプリから NotionDB を操作することができるアプリ。

## 仕様

特定の DB のデータを取得して表示するのみ

## 使用手順

1. notion にてインテグレーションを作成
   → https://www.notion.so/ja-jp/help/create-integrations-with-the-notion-api
2. プロジェクトルートに.env ファイルを作成
3. .env に下記コードを追加

```
NOTION_API_KEY={YOUR_SEACRET_KEY}
NOTION_DATABASE_ID={DATABASE_ID}
```

## API

NotionAPI
https://developers.notion.com/docs/
