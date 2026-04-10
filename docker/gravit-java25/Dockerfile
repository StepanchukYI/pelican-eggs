FROM        --platform=$TARGETOS/$TARGETARCH eclipse-temurin:25-jdk-noble

LABEL       org.opencontainers.image.source="https://github.com/StepanchukYI/pelican-eggs"
LABEL       org.opencontainers.image.description="GravitLauncher core on Java 25"
LABEL       org.opencontainers.image.licenses="MIT"

USER        root

RUN         apt update -y \
            && apt install -y --no-install-recommends \
                curl \
                lsof \
                ca-certificates \
                openssl \
                git \
                tar \
                sqlite3 \
                fontconfig \
                tzdata \
                iproute2 \
                libfreetype6 \
                tini \
                zip \
                unzip \
                osslsigncode \
                bash \
            && rm -rf /var/lib/apt/lists/*

ENV         JMODS_DIR=/usr/share/openjfx/jmods
ENV         JMODS_URL=https://download2.gluonhq.com/openjfx/25/openjfx-25_linux-x64_bin-jmods.zip

RUN         ln -s /opt/java/openjdk-* /opt/java/openjdk || true

RUN         curl -L ${JMODS_URL} -o /tmp/openjfx.zip \
            && unzip /tmp/openjfx.zip -d /tmp/ \
            && rm /tmp/openjfx.zip \
            && mkdir -p ${JMODS_DIR} \
            && cp /tmp/javafx-jmods-25/* ${JMODS_DIR}/ \
            && rm -rf /tmp/javafx-jmods-25

RUN         useradd -m -d /home/container -s /bin/bash container
USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        --chown=container:container ./entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
