FROM debian:9

ENV STEAM_HOME="/root/steamcmd" \
    DST_HOME="/root/dst"

COPY ./sources.list /etc/apt/sources.list

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y lib32gcc1 libcurl4-gnutls-dev:i386 curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -p $DST_HOME && \
    mkdir -p $STEAM_HOME && \
    cd $STEAM_HOME && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - 

# 游戏版本控制
COPY .game-version /

RUN $STEAM_HOME/steamcmd.sh \
    +login anonymous \
    +force_install_dir $DST_HOME \
    +app_update 343050 validate \
    +quit && \
    ln -s $STEAM_HOME/linux32/libstdc++.so.6 $DST_HOME/bin/lib32/ && \
    rm -rf $STEAM_HOME/Steam/logs $STEAM_HOME/Steam/appcache/httpcache && \
    find $STEAM_HOME/package -type f ! -name "steam_cmd_linux.installed" ! -name "steam_cmd_linux.manifest" -delete

ENV DSTA_HOME="/root/dsta" \
    CLUSTER_PATH="/root/cluster" \
    DESCRIPTION="Powered by DST Academy." \
    SERVER_PORT="10999" \
    SHARD_NAME="shard" \
    SHARD_BIND_IP="0.0.0.0"

# Copy common scripts.
COPY /script/* /usr/local/bin/

# Copy static files.
COPY /static $DSTA_HOME

# Create pipe for the game console.
# RUN mkfifo $DSTA_HOME/console

# Copy entrypoint script.
COPY /docker-entrypoint.sh /

# Set up healthcheck.
# HEALTHCHECK --start-period=15m --interval=5m --timeout=1m --retries=3 CMD dst-server version --check

# Set up volumes for configuration files.
VOLUME ["$CLUSTER_PATH", "$DST_HOME/mods"]

# Set entrypoint and default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["dst-server", "start"]
