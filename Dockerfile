
# ベースイメージ。
FROM ubuntu:18.04

#----------------------------------------------------------------

# メンテナー。MAINTAINERコマンドは非推奨。(https://github.com/moby/moby/pull/25466)
LABEL  maintainer "Ishida Norihito <norihitoishida@gmail.com>"

#----------------------------------------------------------------

# ARGはimage build時だけ使用する変数。
# build時にdocker image build --build-arg hoge=fuga のように引数渡しもできる。
# build時にproxyが必要なので引数で渡す。
# UbuntuUSERNAME, UbuntuPASSWORDはコンテナ内でのユーザ名とパスワード。自由に決めて良い。

# 個人設定
ARG USERNAME=ishida.norihito
ARG PASSWORD
ARG UbuntuUSERNAME
ARG UbuntuPASSWORD

# Proxy設定
ARG http_proxy="http://all%5c${USERNAME}:${PASSWORD}@proxy.all.fanuc.co.jp:8080/"
ARG https_proxy="https://all%5c${USERNAME}:${PASSWORD}@proxy.all.fanuc.co.jp:8080/"
ARG no_proxy="127.0.0.1, localhost"
ARG HTTP_PROXY=${http_proxy}
ARG HTTPS_PROXY=${https_proxy}
ARG NO_PROXY="127.0.0.1, localhost"

#----------------------------------------------------------------

# ENVはDockerコンテナ内で使える環境変数。
# run時にdocker container run -e hoge=123 -e huga=456 のように引数渡しもできる。

# 非インタラクティブに設定(y/nなどを表示しない)。自動インスコの際に便利。
ENV DEBIAN_FRONTEND=noninteractive

# 最初のapt-utilsのインストールの時にapt-utilsが無いというエラーが必ず出るので、それを出さないようにする。
ENV DEBCONF_NOWARNINGS=yes 

# 日本語設定。
ENV LANG=ja_JP.UTF-8

#----------------------------------------------------------------

# RUNはimage build時に走るコマンド。
# Docker1.10以降では、RUN、COPY、ADDを実行するたびにイメージのレイヤーが作成されるため、可能なら&&でまとめる。
# 参考:Dockerfile のベストプラクティス
# http://docs.docker.jp/engine/articles/dockerfile_best-practice.html
# apt update, upgradeをまとめないとキャッシュの関係でエラーになる可能性があるので注意。
# apt cleanとrmはイメージのサイズを削減のため。
# locale~はCLIの日本語対応のため。
# pip3 install --upgrade pipはしない。2020年1月現在、aptでpipを入れてpipでpipをupgrade(9→10)するとaptに対応しなくなるため。

RUN apt update -y \
    && apt upgrade -y \
    && apt install -y \
	build-essential \
	cifs-utils \
	cmake \
	curl \
	dnsutils \
	gedit \
	git \
	graphviz \
	iputils-ping \
	libblas-dev \
	libblas3 \
	libsm6 \
	libxext6 \
	libxrender-dev \
	locales \
	net-tools \
        nodejs \
        npm \
	pciutils \
	python3-dev \
	python3-pip \
	python3-setuptools \
	python3-wheel \
	samba \	
	software-properties-common \
	sudo \
	unzip \
	vim \
	wget \
	zip \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* \
    && locale-gen ja_JP.UTF-8 \
    && echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc 

RUN pip3 install \
        fastparquet \
        ipywidgets \
	jupyterlab \
	matplotlib \
	numpy \
	opencv-python \
        openpyxl \
	optuna \
        pyarrow \
	pyknp \
	scikit-learn \
	seaborn \
        xlrd 

# jupyterlabでtqdm.pandas()をきちんと表示させる
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension


#----------------------------------------------------------------


# runする docker run --privileged -it --name コンテナ名 -p 8888:8888 イメージ名
# --privilegedはマウントするために必要なオプション。
# -itでコンソールに入る。
# -p 8888:8888(ホストのポート:コンテナのポート)はポートフォワーディングのオプション。ホスト側の8888ポートとコンテナ側の8888ポートを紐付ける。
# ローカル機なので、両方とも何でも良い。ポート番号を合わせれば、コンソールの出力のリンクからすぐ表示できて便利。
# 8888はjupyterlabのデフォのポート。--port オプションで変更可能。

# コンテナのコンソールでjupyterlabを実行 jupyter-lab --port 8888 --ip=0.0.0.0 --allow-root
# --port 8888 は明示のために書いている。
# --ip=0.0.0.0 --allow-rootがないと動かない。理由は不明。
# 実行したらコンソールに表示されるURLを開けばOK。http://localhost:8888/?token=hogehoge

#----------------------------------------------------------------

