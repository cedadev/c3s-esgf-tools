#!/bin/sh
#
# usage:
#
#    sync_mapfiles.sh <project>
#
# Sync the mapfiles using gridftp


project=$1

scriptdir=`dirname $0`
. $scriptdir/funcs.sh
check_num_args 1 $*
set_vars $project

ensure_cert

ensure_dir $raw_mapfile_dir

cat <<EOF
Syncing mapfiles
   from $mapfiles_url
   to $raw_mapfile_dir
EOF

globus-url-copy -cred $cert_path -sync -r -c -cd $mapfiles_url/ $raw_mapfile_dir/

