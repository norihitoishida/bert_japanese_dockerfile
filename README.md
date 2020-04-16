## Usage
- マシンのCUDAバージョンに合わせて、適宜ベースイメージを変更
    - マシンのCUDAバージョンは`$ nvidia-smi`で確認
    - ベースイメージはNvidiaのDockerhubから探す
    - 今回はKERNEL HONGOのAWSに合わせて`cuda10.1-cudnn7-tuntime-ubuntu18.04`を使用
- Dockerfileと同じディレクトリに以下の3つのファイルを用意
    - mecab-0.996.tar.gz
    - mecab-ipadic-2.7.0-20070801.tar.gz
    - BERT-base_mecab-ipadic-bpe-32k_whole-word-mask.tar.xz
- Dockerfileと同じディレクトリに入る
- イメージをビルドする
    - 例 : `sudo docker build nlp:1.0 .` (最後のピリオドを忘れない様に注意)
- イメージからコンテナを作る
    - 例 : `sudo docker run --gpus all -it -p 8888:8888 nlp:1.0`
- jupyter-labを開始
    - 例 : `jupyter-lab --port=8888 --ip=0.0.0.0 --allow-root`
    - `<グローバルIP>:8888`をブラウザで開き、token=hogehogeの部分を入力する
    - ssh接続する際に `ssh <ユーザ名>@<IP> -L 8888:localhost:8888 -p 2211`でポートフォワーディングしている場合は、jupyter-lab開始時にターミナルに出てくるアドレス`http://127.0.0.1:8888/?token=hogehoge`をそのままブラウザで開けばOK
- [サンプルコード](https://github.com/cl-tohoku/bert-japanese/blob/master/masked_lm_example.ipynb)を実行して確認
- torchをインポート後、セルに`torch.cuda.is_available()`と入力して実行し、GPUが有効になっているか確認(TrueならOK)

## ファイルの説明とDL先

- mecab-0.996.tar.gz
    - 形態素解析エンジン
    - BERT日本語版を動かすのに必要
    - DL : https://taku910.github.io/mecab/
- mecab-ipadic-2.7.0-20070801.tar.gz
    - mecabの辞書
    - DL : https://taku910.github.io/mecab/
- BERT-base_mecab-ipadic-bpe-32k_whole-word-mask.tar.gz
    - BERTのpretrainモデル
    - 最終の全結合層だけ取り替えてfine tuningして使う
    - DL : https://github.com/cl-tohoku/bert-japanese
    - モデルは4種類有るので間違えないように注意
