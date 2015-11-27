#!/bin/sh

set -e

source testlib.sh
# verbose="true"
# warnings="true"

source confs/base.conf

# taken verbatim from file attached to bug #4 that previously lived at
# http://bugzilla.backup-manager.org/cgi-bin/attachment.cgi?id=1&action=view
export BM_REPOSITORY_ROOT="$PWD/repository"
export BM_ARCHIVE_METHOD="pipe"
export BM_ENCRYPTION_METHOD="gpg"
export BM_ENCRYPTION_RECIPIENT="0x1EE5DD34"

source $locallib/sanitize.sh
bm_init_env
bm_init_today

BM_PIPE_COMMAND[0]="cat /etc/passwd" 
BM_PIPE_NAME[0]="passwd" 
BM_PIPE_FILETYPE[0]="txt"
BM_PIPE_COMPRESS[0]="gzip"
files[0]="$BM_REPOSITORY_ROOT/$BM_ARCHIVE_PREFIX-passwd.$TODAY.txt.gz.gpg"

BM_PIPE_COMMAND[1]="echo 'sukria' ; date " 
BM_PIPE_NAME[1]="sukria" 
BM_PIPE_FILETYPE[1]="txt"
BM_PIPE_COMPRESS[1]="bzip2"
files[1]="$BM_REPOSITORY_ROOT/$BM_ARCHIVE_PREFIX-sukria.$TODAY.txt.bz2.gpg"

BM_PIPE_COMMAND[2]="ls -lh /" 
BM_PIPE_NAME[2]="ls-root" 
BM_PIPE_FILETYPE[2]="txt"
BM_PIPE_COMPRESS[2]=""
files[2]="$BM_REPOSITORY_ROOT/$BM_ARCHIVE_PREFIX-ls-root.$TODAY.txt.gpg"

# BM_PIPE_COMMAND[3]="/usr/bin/tototot"
# BM_PIPE_NAME[3]="failure"
# BM_PIPE_FILETYPE[3]="txt"
# BM_PIPE_COMPRESS[3]=""

# clean
if [[ -e $PWD/repository ]]; then
    rm -rf $PWD/repository
fi    

# BM actions
create_directories
make_archives

# test of success/failure
for file in $files
do
    if [[ ! -e $file ]]; then
        warning "file $file does not exist"
        rm -rf $BM_ARCHIVE_ROOT
        exit 10
    fi
done
rm -rf $BM_ARCHIVE_ROOT
exit 0
