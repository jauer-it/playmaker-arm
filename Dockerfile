FROM arm32v7/openjdk:8

RUN apt-get update && \
    apt-get install -y git \
    python3 \
    python3-pip \
    libstdc++6 \
    libgcc1 \
    libz1 \
    libncurses5 \
    libffi-dev \
    libssl-dev \
    libjpeg-dev \
    libxml2-dev \
    libxslt1-dev \
#    openjdk-8-jdk-headless \
    virtualenv \
    wget \
    unzip \
    fdroidserver \
    zlib1g-dev \
    aapt


RUN mkdir -p /data/fdroid/repo && \
    mkdir -p /opt/playmaker

COPY README.md setup.py pm-server /opt/playmaker/
ADD playmaker /opt/playmaker/playmaker

WORKDIR /opt/playmaker
RUN pip3 install . && \
    cd /opt && rm -rf playmaker

RUN groupadd -g 987 pmuser && \
    useradd -m -u 987 -g pmuser pmuser
RUN chown -R pmuser:pmuser /data/fdroid && \
    chown -R pmuser:pmuser /opt/playmaker
USER pmuser

VOLUME /data/fdroid
WORKDIR /data/fdroid

EXPOSE 5000
ENTRYPOINT python3 -u /usr/local/bin/pm-server --fdroid --debug
