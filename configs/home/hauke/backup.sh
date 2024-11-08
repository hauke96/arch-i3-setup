#!/bin/sh

# Copied and adjusted from here:
# https://borgbackup.readthedocs.io/en/stable/quickstart.html#automating-backups

# Usage: ./backup.sh <repo> <folder> [passphrase]
# Examples:
#	./backup.sh /media/backup-data/data /media/data 1 2 3 4
#	./backup.sh /backup/whatever /home/hauke/idontknow 1 2 3 4 superS3cürePassfrase

export BORG_REPO="$1"
FOLDER="$2"
KEEP_DAILY=$3
KEEP_WEEKLY=$4
KEEP_MONTHLY=$5
KEEP_YEARLY=$6
export BORG_PASSPHRASE="$7"

NOW=$(date +"%Y%m%d_%H%M%S")

# some helpers and error handling:
info()
{
	printf "%s %s\n" "$( date )" "$*" >&2
}
trap 'echo Backup $NOW interrupted >&2; exit 2' INT TERM


# Create new backup
HOME_HAUKE="/home/hauke"
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
	--exclude '*/Downloads'         \
	--exclude '*/.npm'              \
	--exclude '*/.nuget'            \
	--exclude '*/.local/share/Steam' \
	--exclude '*/dotTraceSnapshots' \
	--exclude '*/.Trash*'           \
	--exclude '*/target'            \
	--exclude '*/node_modules'      \
	--exclude '*/.angular'          \
	--exclude 'var/lib/docker'      \
	--exclude '*/soq-index*'        \
	--exclude '*/import-temp-cell*' \
	--exclude '*.pbf'               \
	--exclude '$HOME_HAUKE/Projekte/C#/MARS' \
	--exclude '$HOME_HAUKE/Videos'  \
	--exclude '$HOME_HAUKE/.i3.log*'\
	::"$NOW"                        \
	$FOLDER                         
backup_exit=$?
info "Done ($backup_exit): Creating backup $BORG_REPO::$NOW"


# Prune to remove old backups
info "Pruning repository"
borg prune                          \
	--list                          \
	--show-rc                       \
	--keep-daily   $KEEP_DAILY      \
	--keep-weekly  $KEEP_WEEKLY     \
	--keep-monthly $KEEP_MONTHLY    \
	--keep-yearly  $KEEP_YEARLY     \
	"$BORG_REPO"
prune_exit=$?
info "Done ($prune_exit): Pruning repository"


# Actually free repo disk space by compacting segments
info "Compacting repository"
borg compact --progress
compact_exit=$?
info "Done ($compact_exit): Compacting repository"


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

exit ${global_exit}
