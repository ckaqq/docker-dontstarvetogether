#!/usr/bin/env bash

path_log="$CLUSTER_PATH/log_bak"
file_chat="$CLUSTER_PATH/$SHARD_NAME/server_chat_log.txt"
file_log="$CLUSTER_PATH/$SHARD_NAME/server_log.txt"

mkdir -p $path_log

# $(date "+%G_%m_%d_%H_%M_%S")

if [[ -f "$file_chat" ]] && [[ -f "$file_log" ]]; then
    cp $file_chat $path_log/server_chat_log_$(date "+%G_%m_%d_%H_%M_%S").txt
    cp $file_log $path_log/server_log_$(date "+%G_%m_%d_%H_%M_%S").txt
fi
