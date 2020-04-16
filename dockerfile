FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04

ENV NVIDIA_VISIBLE_DEVICES=all \
    DISPLAY=:0 \
    DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NOWARNINGS=yes 

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        build-essential \
        software-properties-common \
        python3-dev \
        python3-pip \
        python3-wheel \
        python3-setuptools \
        git \
        cmake \
        libblas3 \
        libblas-dev \
        libsm6 \
        libxext6 \
        libxrender-dev \
        sudo \
        graphviz \
        dnsutils \
	net-tools \
	iputils-ping \
	wget \
	curl \
	gcc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    git config --global user.email "norihitoishida@gmail.com" && \
    git config --global user.name "norihitoishida" 

RUN pip3 install --no-cache-dir \
        Pillow \
        h5py \
        ipykernel \
        jupyterlab \
        matplotlib \
	seaborn \
        numpy \
        torch \
        gensim \
        scikit-learn \
        optuna \
	flask \
	janome \
	transformers \
	tensorboard \
	nltk \
	ipywidgets \
	mecab-python3

RUN jupyter nbextension enable --py widgetsnbextension

COPY ./mecab-0.996.tar.gz / 
RUN tar zxfv /mecab-0.996.tar.gz \
    &&  /mecab-0.996/configure \
    && make \
    && make install \
    && ldconfig

COPY ./mecab-ipadic-2.7.0-20070801.tar.gz /
RUN tar zxfv /mecab-ipadic-2.7.0-20070801.tar.gz
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
RUN cd /mecab-ipadic-2.7.0-20070801 && ./configure --with-charset=utf8 && make && make install

COPY ./BERT-base_mecab-ipadic-bpe-32k_whole-word-mask.tar.xz /
RUN xz -dv /BERT-base_mecab-ipadic-bpe-32k_whole-word-mask.tar.xz
RUN tar xfv /BERT-base_mecab-ipadic-bpe-32k_whole-word-mask.tar



