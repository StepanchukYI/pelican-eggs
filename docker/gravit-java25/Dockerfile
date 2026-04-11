FROM        --platform=$TARGETOS/$TARGETARCH ubuntu:noble

LABEL       org.opencontainers.image.source="https://github.com/StepanchukYI/pelican-eggs"
LABEL       org.opencontainers.image.description="GravitLauncher core on BellSoft Liberica JDK 25 Full (bundled OpenJFX jmods)"
LABEL       org.opencontainers.image.licenses="MIT"

# Why Liberica JDK Full instead of eclipse-temurin:25-jdk-noble:
#  1. Temurin docker images strip $JAVA_HOME/jmods/ → GravitLauncher's
#     ProGuardComponent throws "Java path: X is not JDK! Please install JDK"
#     (checks jmods/java.base.jmod, see ProGuardComponent.java:201).
#  2. Adoptium release tarballs also ship without jmods (verified).
#  3. Liberica "jdk-full" tarball bundles the full JDK jmods AND OpenJFX jmods
#     (javafx.*.jmod) inside the same JAVA_HOME, so both ProGuardComponent
#     jmods check and checkFXJMods(JVM_DIR/jmods) pass without extra work.
#  4. Consistent with the client side: client/prestarter already downloads
#     Liberica JRE 25 jre-full for end-user machines.

USER        root

RUN         apt-get update -y \
            && apt-get install -y --no-install-recommends \
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
                libasound2t64 \
                libxext6 \
                libxrender1 \
                libxtst6 \
                libxi6 \
                tini \
                zip \
                unzip \
                osslsigncode \
                bash \
                jq \
            && rm -rf /var/lib/apt/lists/*

ENV         JAVA_HOME=/opt/java/openjdk
ENV         PATH=${JAVA_HOME}/bin:${PATH}

# Download Liberica JDK 25 Full (latest GA) for the current build arch.
# The API returns multiple builds per feature version; pick the one whose
# downloadUrl contains "amd64-full"/"aarch64-full" and take the last entry
# (most recent).
RUN         set -eux; \
            ARCH="$(dpkg --print-architecture)"; \
            case "$ARCH" in \
                amd64) LIB_ARCH="x86";    LIB_BITS="64"; URL_ARCH="amd64-full" ;; \
                arm64) LIB_ARCH="arm";    LIB_BITS="64"; URL_ARCH="aarch64-full" ;; \
                *) echo "unsupported arch: $ARCH" >&2; exit 1 ;; \
            esac; \
            API="https://api.bell-sw.com/v1/liberica/releases?version-feature=25&bundle-type=jdk-full&os=linux&arch=${LIB_ARCH}&bitness=${LIB_BITS}&package-type=tar.gz"; \
            URL="$(curl -fsSL "$API" | jq -r --arg m "$URL_ARCH" '[.[] | select(.downloadUrl | contains($m))] | last | .downloadUrl')"; \
            test -n "$URL" && test "$URL" != "null"; \
            echo "Liberica URL: $URL"; \
            curl -fL "$URL" -o /tmp/jdk.tar.gz; \
            mkdir -p "$JAVA_HOME"; \
            tar -xzf /tmp/jdk.tar.gz -C "$JAVA_HOME" --strip-components=1; \
            rm /tmp/jdk.tar.gz; \
            test -f "$JAVA_HOME/bin/javac"; \
            test -f "$JAVA_HOME/jmods/java.base.jmod"; \
            test -f "$JAVA_HOME/jmods/javafx.base.jmod"; \
            "$JAVA_HOME/bin/java" -version

RUN         useradd -m -d /home/container -s /bin/bash container
USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        --chown=container:container ./entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
