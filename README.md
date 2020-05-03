# セットアップ方法

## 環境構築（Docker）

```
$ git clone git@github.com:kazama1209/apple-login-sample.git
$ cd apple-login-sample
$ make init
$ make install
$ make run
```

## 「config/initializers/omniauth.rb」内に4つの値(CLIENT_ID、TEAM_ID、KEY_ID、PRIVATE_KEY)を記述

Sign in with Appleを実装するためには、[Apple Developer](https://developer.apple.com/jp/)に登録して4つの値(CLIENT_ID、TEAM_ID、KEY_ID、PRIVATE_KEY)を取得する必要がある。

```
# config/initializers/omniauth.rb

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :apple, ENV['CLIENT_ID'], '',
           {
             scope: 'email name',
             team_id: ENV['TEAM_ID'],
             key_id: ENV['KEY_ID'],
             pem: ENV['PRIVATE_KEY']
           }
end

```

※各値の取得方法については次の記事を参照。（[Sign in with Apple を実装するために必要な証明書の作り方](https://www.ginzaitlab.com/posts/6889998/)）

※実際に運用する場合は「dotenv」などで環境変数を管理。

## Return URLsの設定

最後に、認証が許可された後のリダイレクト先を指定。

Apple Developerのダッシュボードから「Certifications, Identifers & Profiles」へ飛ぶ。

![2020-05-03 17 27 22](https://user-images.githubusercontent.com/51913879/80911786-8d52f100-8d73-11ea-8bbd-39af246f5aee.png)

「Identifers」タブを開き、右のプルダウンメニューから「Services IDs」を選択。

![スクリーンショット 2020-05-03 19 24 23](https://user-images.githubusercontent.com/51913879/80911889-25e97100-8d74-11ea-8220-b0fe6ba46875.png)

「Sign in with Apple」の右にある「configure」をクリックすると「Domains and Sub domains」「Return URLs」を登録する画面が出てくるので、それぞれ記述していきます。

![2020-05-03 17 40 28](https://user-images.githubusercontent.com/51913879/80912065-4403a100-8d75-11ea-89fc-86b32979c947.png)

```
Domains and Sub domains：「http://」「.com」などを除外した部分
Return URLs：後ろに「users/auth/apple/callback」を追加したもの
```
※注意点として、Sign in with Appleでは「localhost」が使用できない。

したがって、

```
localhost:3000
http://localhost:3000/users/auth/apple/callback
```

などと記述しても、不正な値として弾かれてしまう。

そこで、「ngrok」などを使ってローカルサーバーに適当なドメインを割り当ててもらう。（参照記事：[ngrokが便利すぎる](https://qiita.com/mininobu/items/b45dbc70faedf30f484e)）

<img width="1108" alt="2020-05-03 17 42 13" src="https://user-images.githubusercontent.com/51913879/80912200-4e726a80-8d76-11ea-9ca3-a87b3deb3854.png">

今回の場合はターミナルで

```
$ ngrok http 3000
```

と叩き、生成されたURLを先ほどのページに記述すればOK。

※ngrokは実行するたびにURLが変更されるので注意。


## 動作確認

ngrokを使って生成されたURLにアクセスし、次のような画面になる事を確認。

![2020-05-03 17 44 09](https://user-images.githubusercontent.com/51913879/80911416-27fe0080-8d71-11ea-9e92-5dc9fe05cc4e.png)

「login」ボタンを押すとSign in with Appleのページへ飛ぶので、AppleIDとパスワードをそれぞれ入力。

![2020-05-03 17 44 24](https://user-images.githubusercontent.com/51913879/80911472-8dea8800-8d71-11ea-8b4d-0fd215100e15.png)

認証に成功すると、自身のメールアドレスが表示された画面に切り替わる。

![2020-05-03 17 44 50](https://user-images.githubusercontent.com/51913879/80911570-10734780-8d72-11ea-93da-403da0f95af3.png)

お疲れさまでした。
