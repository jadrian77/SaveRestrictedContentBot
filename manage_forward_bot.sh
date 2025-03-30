#!/bin/bash

FORWARD_BOT="./forward_bot"
LOG_FILE="bot.log"
PID_FILE="forward_bot.pid"
TEMP_FILES=("SaveRestricted.session" "SaveRestricted.session-journal" "bot.session" "bot.session-journal")
REPO_API="https://api.github.com/repos/LiangJiQi/SaveRestrictedContentBot/releases/latest"
ARCHIVE_NAME="forward_bot.tar.gz"

start_bot() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "Bot is already running (PID $(cat $PID_FILE))"
        exit 1
    fi

    nohup "$FORWARD_BOT" > "$LOG_FILE" 2>&1 &
    echo $! > "$PID_FILE"
    echo "Bot started with PID $(cat $PID_FILE)"
}

stop_bot() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        kill $(cat "$PID_FILE")
        rm -f "$PID_FILE"
        echo "Bot stopped."

        for file in "${TEMP_FILES[@]}"; do
            if [ -f "$file" ]; then
                rm -f "$file"
                echo "Deleted temporary file: $file"
            fi
        done
    else
        echo "Bot is not running."
    fi
}

status_bot() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "Bot is running (PID $(cat $PID_FILE))"
    else
        echo "Bot is not running."
    fi
}

tail_log() {
    tail -20f "$LOG_FILE"
}

update_bot() {
    echo "Fetching latest release from GitHub..."
    
    DOWNLOAD_URL=$(curl -s $REPO_API | grep "browser_download_url" | grep "$ARCHIVE_NAME" | cut -d '"' -f 4)

    if [ -z "$DOWNLOAD_URL" ]; then
        echo "Failed to get latest release download URL."
        exit 1
    fi

    echo "Downloading latest release from: $DOWNLOAD_URL"
    
    wget -O "$ARCHIVE_NAME" "$DOWNLOAD_URL"

    if [ $? -ne 0 ]; then
        echo "Download failed!"
        exit 1
    fi

    echo "Extracting archive..."
    
    tar --exclude='.env' -xf "$ARCHIVE_NAME"

    echo "Update complete!"
}

case "$1" in
    start) start_bot ;;
    stop) stop_bot ;;
    status) status_bot ;;
    log) tail_log ;;
    update) update_bot ;;
    *) echo "Usage: $0 {start|stop|status|log|update}" ;;
esac
