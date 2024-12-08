FROM ubuntu:20.04

LABEL version="1.0" maintainer="danphannguyen.contact@gmail.com"

# Configuration de l'environnement
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

ARG APT_FORCE="-q -y"

# ---- Installation des paquets système ----
RUN apt-get update && \
    apt-get install ${APT_FORCE} python3-pip && \
    apt-get install ${APT_FORCE} autoconf && \
    apt-get install ${APT_FORCE} automake && \
    apt-get install ${APT_FORCE} build-essential && \
    apt-get install ${APT_FORCE} gdb && \
    apt-get install ${APT_FORCE} git && \
    apt-get install ${APT_FORCE} libboost-all-dev && \
    apt-get install ${APT_FORCE} libevent-dev && \
    apt-get install ${APT_FORCE} libssl-dev && \
    apt-get install ${APT_FORCE} libtool && \
    apt-get install ${APT_FORCE} pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Définit le répertoire de travail
WORKDIR /app

# Copie le fichier requirements.txt
COPY requirements.txt .

# ---- Installation des dépendances Python ----
RUN pip install --no-cache-dir -r requirements.txt

# Copie le reste des fichiers de l'application
COPY . .


# ---- Repositories git (BTC debugger)
WORKDIR /app/btcdeb/
RUN ./autogen.sh && \
    ./configure && \
    make install

# ---- Repositories git (BTC core)
WORKDIR /app/secp256k1/
RUN ./autogen.sh && \
    ./configure && \
    make install

# ---- Repositories git (BTC miner)
WORKDIR /app/cpp_miner/
RUN ./autogen.sh && \
    ./configure && \
    make install

# ---- Repositories git (Python toolbox)
WORKDIR /app/blockchain-dev-tools/
RUN ./INSTALL.sh 


WORKDIR /app
