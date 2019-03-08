#!/bin/sh
#
# usage:
#
#    gen_edited_mapfiles.sh [--all] <project> <output_list_file>
#
# For every raw copy of the remote mapfile, if an edited mapfile does not 
# exist (or unconditionally if "--all" is specified), generate the edited
# mapfile for local publication.
#
# Also writes a list of newly created edited mapfiles, using the filename
# provided as <output_list_file>


do_all=0

while true
do
    case $1 in
	--all)
	    do_all=1
	    ;;

	*)
	    break
	    ;;
    esac
    shift
done


project=$1
out_list=$2

scriptdir=`dirname $0`
. $scriptdir/funcs.sh
set_vars $project
check_num_args 2 $*

ensure_dir $edited_mapfile_dir
ensure_parent_dir $out_list

cat <<EOF
Generating edited mapfiles
   under $edited_mapfile_dir
   writing list to $out_list
EOF

find $raw_mapfile_dir -type f -name '*.map' | sed "s,$raw_mapfile_dir/,," | while read relative_path
do
    
    in_path=$raw_mapfile_dir/$relative_path
    out_path=$edited_mapfile_dir/$relative_path

    if [ $do_all -eq 1 ] || [ ! -e $out_path ]
    then
	ensure_parent_dir $out_path
	sed "s,$remote_data_root,$local_data_root,g" $in_path > $out_path
	echo $out_path
    fi

done > $out_list
