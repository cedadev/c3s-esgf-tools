#!/bin/sh
#
# usage:
#
#   gen_transfer_list.sh <project> <mapfile_list> <transfer_list>
#
# Takes a list of mapfiles, and creates a transfer list in the format 
# required by globus-url-copy (lines of <remote_url> <local_path>).
#


project=$1
mapfile_list=$2
out_list=$3

scriptdir=`dirname $0`
. $scriptdir/funcs.sh
check_num_args 3 $*
set_vars $project

cat <<EOF
Generating transfer list
  $out_list
  using mapfile list $mapfile_list
EOF

ensure_parent_dir $out_list


xargs cat <  $mapfile_list | \
    python $scriptdir/_gen_transfer_list.py "$local_data_root" "$url_base" \
    > $out_list
