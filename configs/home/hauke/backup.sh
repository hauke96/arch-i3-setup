#!/usr/bin/env bash

# Copied and adjusted from here:
# https://borgbackup.readthedocs.io/en/stable/quickstart.html#automating-backups

# Usage: ./backup.sh <repo> <folder> [passphrase]
# Examples:
#	./backup.sh /media/backup-data/data /media/data 1 2 3 4
#	./backup.sh /backup/whatever /home/hauke/idontknow 1 2 3 4 superS3cürePassfrase

# some helpers and error handling:
info()
{
	printf "%s -- %s\n" "$( date )" "$*"
}
trap 'echo Backup $NOW interrupted >&2; exit 2' INT TERM

set -e



export BORG_REPO="$1"
FOLDER="$2"
KEEP_DAILY=$3
KEEP_WEEKLY=$4
KEEP_MONTHLY=$5
KEEP_YEARLY=$6
export BORG_PASSPHRASE="$7"

NOW=$(date +"%Y%m%d_%H%M%S")



# Create new backup
backup_exit=0
HOME="/home/hauke"
info "Creating backup $BORG_REPO::$NOW"
borg create                         \
	--verbose                       \
	--filter AMEx                   \
	--list                          \
	--stats                         \
	--show-rc                       \
	--compression lz4               \
	--exclude-caches                \
	--exclude '*/tmp'               \
	--exclude '*/cache'             \
	--exclude '*/.cache'            \
	--exclude '*/.android/avd'      \
	--exclude '*/.Trash*'           \
	--exclude "*/.local/share/Trash" \
	--exclude '*/.local/share/Steam' \
	--exclude '*/.i3.log*'          \
	--exclude '*/Programme/ISO/*.iso' \
	--exclude "$HOME/Downloads"     \
	--exclude "$HOME/Videos"        \
	--exclude '*/Projekte/C#/MARS'  \
	--exclude '*/Projekte/OSM/OpenDroneMap' \
	--exclude '*/.npm'              \
	--exclude '*/.nvm'              \
	--exclude '*/node_modules'      \
	--exclude '*/.angular'          \
	--exclude '*/.nuget'            \
	--exclude '*/dotTraceSnapshots' \
	--exclude '*/target'            \
	--exclude 'var/lib/docker'      \
	--exclude '*/soq-index*'        \
	--exclude '*/import-temp-cell*' \
	--exclude '*.pbf'               \
	::"$NOW"                        \
	$FOLDER || backup_exit=$?
info "Done creating backup $BORG_REPO::$NOW with exit code $backup_exit"



# Prune to remove old backups
prune_exit=0
info "Pruning repository"
borg prune                          \
	--list                          \
	--show-rc                       \
	--keep-daily   $KEEP_DAILY      \
	--keep-weekly  $KEEP_WEEKLY     \
	--keep-monthly $KEEP_MONTHLY    \
	--keep-yearly  $KEEP_YEARLY     \
	"$BORG_REPO" || prune_exit=$?
info "Done pruning repository $BORG_REPO with exit code $prune_exit"



# Actually free repo disk space by compacting segments
compact_exit=0
info "Compacting repository"
borg compact --progress || compact_exit=$?
info "Done compacting repository $BORG_REPO with exit code $compact_exit"



# Use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))
global_exit=$(( compact_exit > global_exit ? compact_exit : global_exit ))

if [ ${global_exit} -eq 0 ]; then
	info "Backup, Prune, and Compact finished successfully"
elif [ ${global_exit} -eq 1 ]; then
	info "Backup, Prune, and/or Compact finished with warnings"
else
	info "Backup, Prune, and/or Compact finished with ERRORS"
	info "Backup $BORG_REPO::$NOW FAILED!"
fi

