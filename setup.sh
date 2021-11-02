#!/usr/bin/env bash

# Setup script to move the rofi theme files to the correct location
# As well as set up the history database
# DO NOT RUN AS ROOT

log() {
    printf "%s\n" "$1"
}

DB="history.sqlite3"

# Set the XDG_CONFIG_HOME locally if not set
if [[ -z "$XDG_CONFIG_HOME" ]]; then
    XDG_CONFIG_HOME="$HOME/.config"
fi

DIR="$XDG_CONFIG_HOME/ani-cli"
MPV_DIR="$XDG_CONFIG_HOME/mpv"

printf "%s\n" "INSTALL DIR: $DIR"

if [[ ! -d "$DIR" ]]; then
    log "Creating directory $DIR"
    mkdir -p "$DIR"
    log "Directory created"
fi

if [[ ! -f "$DIR"/"$DB" ]]; then
    # Create the DB if not exists
    log "Creating history database..."
    sqlite3 "$DIR"/"$DB" <sql/watch_history_tbl.sql
    sqlite3 "$DIR"/"$DB" <sql/search_history_tbl.sql
    log "History database created..."
fi

# Move theme files and skip-intro script to correct locations
log "Moving theme files..."
cp themes/* "$DIR"/
log "Theme files moved..."

log "Creating mpv/scripts/ directory if it doesn't exist..."
mkdir -p "$MPV_DIR/scripts/"
log "Created mpv scripts directory..."
log "Moving skip-intro.lua into mpv scripts directory..."
cp scripts/* "$MPV_DIR/scripts/"
# cp skip-intro.lua "$MPV_DIR/scripts/skip-intro.lua"
log "Moved skip-intro.lua into scripts directory..."

log "Setup Complete...."
