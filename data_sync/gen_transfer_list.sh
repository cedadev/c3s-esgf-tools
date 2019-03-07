#!/bin/sh
#
# usage:
#
#   gen_transfer_list.sh <project> <mapfile_list> <transfer_list>
#
# Takes a list of mapfiles, and creates a transfer list in the format 
# required by globus-url-copy (lines of <remote_url> <local_path>) and 
# then writes the filename of this transfer list to standard output.
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


# the xargs awk ... command writes a list of datafile paths to stdout

# the perl command turns this into pairs of remote_url, local path
# (\$foo is a variable interpreted inside perl but $bar is a variable
# substituted in this shell script)

xargs awk '{print $3}' <  $mapfile_list | \
    perl -lne "(\$remote_url=\$_) =~ s,$local_data_root,$url_base,; \$local_url=\"file://\$_\"; print \"\$remote_url \$local_url\"" \
    > $out_list
