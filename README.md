# Algokit

ゲーム制作時に使えるアルゴリズムをまとめたメモ帳みたいな使い方ができるアプリです。
現在はアンドロイドのみ対応です。
Elixirを使用しておりますので、必ずElixirとErlangはインストールをしておいてください。[^1]

# 使い方
1. まず当リポジトリからcloneしてください。`git clone https://github.com/BlackTanuTanuNinjas1035/algokit`
2. 次のコマンドでリポジトリからandroid-example-appをcloneしてください。`git clone https://github.com/elixir-desktop/android-example-app`
  - このとき現在のディレクトリには**alogkit**と**android-example-app**があるはずです。
3. android-studioを開き、2のandroid-example-appを開いてください。
4. android-example-appの中にある/app/run_mixを以下のように書き換えます。
   ```
   #!/bin/bash
   set -e

   BASE=`pwd`
   APP_FILE="$BASE/src/main/assets/app.zip"
   export MIX_ENV=prod
   export MIX_TARGET=android

   cd ../../algokit

   if [ ! -d "deps/desktop" ]; then
     mix local.hex --force
     mix local.rebar
     mix deps.get
   fi

    if [ ! -d "assets/node_modules" ]; then
      cd assets && npm i && cd ..
    fi

   if [ -f "$APP_FILE" ]; then
     rm "$APP_FILE"
   fi

   mix assets.deploy && \
     mix release --overwrite && \
     cd "_build/${MIX_TARGET}_${MIX_ENV}/rel/algokit" && \
     zip -9r "$APP_FILE" lib/ releases/ --exclude "*.so"
   ```
5. 再生ボタンを押して実行してください。
   
[^1]: https://qiita.com/B_tanuki/items/29929a26bca9ab6879f2#%E9%96%8B%E7%99%BA%E7%92%B0%E5%A2%83%E6%A7%8B%E7%AF%89