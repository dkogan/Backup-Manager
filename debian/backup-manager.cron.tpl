#!/bin/sh
# cron script for backup-manager
test -x /usr/sbin/backup-manager || exit 0
/usr/sbin/backup-manager
