My AiPri Collection Cloud（メール＋パスワード版）
=================================================

この版はSupabaseを使うクラウド保存版です。GitHub Pagesだけでは動かず、最初にSupabaseの無料プロジェクトを設定する必要があります。

重要：このZIPにカード図鑑の全カードデータはまだ収録されていません。
シリーズ・弾・スペシャルカードを登録できる器と、アカウント別のクラウド管理機能を用意しています。公式カード一覧の全件・画像を正確に収録するには、公式データの確認と個別のデータ整備が別途必要です。存在しないカード情報を捏造していません。

1. Supabaseを用意
------------------
1) https://supabase.com/ を開いて無料アカウントを作成
2) New project → 名前とDBパスワードを設定 → 作成
3) Project Settings → API（またはConnect）から Project URL と anon/public key をコピー
4) SupabaseのSQL Editor → New query を開き、同梱の supabase_setup.sql の内容を貼り付けてRun
5) Authentication → URL Configurationで Site URL にGitHub PagesのURLを設定
   例：https://あなたのGitHubユーザー名.github.io/my-aipri-collection/
   Redirect URLsにも同じURLを追加
6) Authentication → Providers → Emailを有効にする。メール確認を有効にする場合、登録確認メールのリンクから認証する
7) Storageにcard-imagesバケットが作成されていることを確認（SQLで作成）

2. index.htmlに接続情報を設定
--------------------------------
index.htmlをテキストエディタで開き、次の2行を置き換えます。

const SUPABASE_URL='YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY='YOUR_SUPABASE_ANON_KEY';

SupabaseのProject URLとanon/public keyをそれぞれ貼り付けます。
service_role keyは絶対に貼らないでください。anon/public keyはブラウザ公開用ですが、データ保護はSQLのRLSポリシーで行います。

3. GitHubへ更新
----------------
GitHubリポジトリで index.html と supabase_setup.sql を含むファイルをアップロードし、既存ファイルを置き換えてCommit changes。
このZIPの index.html、manifest.webmanifest、sw.js、catalog.json、README.txt、supabase_setup.sql をリポジトリのルートに配置します。
公開後、GitHub PagesのURLをSafariで開きます。

4. アカウント登録
-----------------
サイトでメールアドレスとパスワードを入力し「新規登録」。
確認メールが有効ならメール内リンクを開き、その後ログインします。
パスワード再設定もログイン画面から行えます。

使い方
------
・カード追加フォームから手入力でカードを登録
・＋／−で所持枚数変更
・検索、シリーズ、所持状況で絞り込み
・JSONバックアップを書き出し／読み込み
・カード情報はログイン中のアカウントにクラウド保存

注意点
------
・Supabaseの無料枠には容量・通信量などの上限があります。最新の上限はSupabase公式料金ページで確認してください。
・画像は公開URLとして保存する構成です。画像URLを知る人が画像を閲覧できる可能性があります。個人情報や顔写真などはアップロードしないでください。
・アカウントごとのカード行はRow Level Securityで分離しています。
・画像はアカウントIDのフォルダに分けていますが、公開バケットのため画像自体は完全非公開ではありません。
・クラウドでも障害・誤操作・サービス終了のリスクはゼロではありません。定期的にJSONバックアップを保存してください。
・このサイトは現時点で公式全カードカタログを自動取得しません。新弾追加は公式情報を確認し、手入力またはCSV取込機能の追加が必要です。


5. 新弾データの更新について
--------------------------
・アプリは起動／ログイン時に同じGitHub Pages上の catalog.json を確認します。新しい未登録カードがあれば「新しいカードを一括追加」が有効になります。
・新弾データを公開する担当者が、公式ページを確認して catalog.json にカード情報を追加し、GitHubへ更新する必要があります。アプリ側は自動で差分を検出し、ユーザーは一括追加ボタンだけで登録できます。
・現状、公式サイトを機械的に完全解析して全カードを自動登録する機能ではありません。公式ページの構造変更や画像利用条件もあるため、誤登録防止のため人による確認を挟みます。
・catalog.json の1件の例：
  {"catalog_id":"himitsu-1-001","name":"カード名","character":"キャラクター名","series":"ひみつのアイプリ","release":"1だん","number":"カード番号","rarity":"レアリティ","kind":"通常","image_url":"公式画像のURL（利用条件を確認できる場合のみ）"}
・同じcatalog_idは同じアカウントに重複登録されません。既存カードの所持数・お気に入りは保持されます。
・自動チェックはサイトを開いた時／ログイン時に行います。Safariを閉じている間のプッシュ通知はこの構成では行いません。
