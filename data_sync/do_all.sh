#!/bin/sh
#
# usage:
#
#   do_all.sh [--dry-run] [--rebuild] <project>
#
# e.g.
#
#   do_all.sh cp4cds
#
#
# Syncs the mapfiles, generates any new edited mapfiles, uses these to 
# generate a list of datafiles to be transferred, and then transfers these
# data files

export dry_run=0
rebuild=0

while true
do
    case $1 in
	--dry-run)
	    dry_run=1
	    ;;

	--rebuild)
	    rebuild=1
	    ;;
	
	*)
	    break
	    ;;
    esac
    shift
done


project=$1

scriptdir=`dirname $0`
. $scriptdir/funcs.sh
check_num_args 1 $*
set_vars $project

list_suffix=`get_timestamp`

if [ $dry_run -eq 1 ]
then
    # With export dry_run=1, the set_vars script will have pointed the
    # relevant mapfile_dir variables at temporary areas, with the
    # master copies in $real_*.  Now copy the actual files.

    ensure_dir $raw_mapfile_dir
    ensure_dir $edited_mapfile_dir

    echo "Dry run - using copy of mapfile dirs under $tmp_mapfile_dir"
    rsync -a --delete $real_raw_mapfile_dir/ $raw_mapfile_dir/ 
    rsync -a --delete $real_edited_mapfile_dir/ $edited_mapfile_dir/ 

    list_suffix=$list_suffix.DRYRUN
fi


# 1) Sync the mapfiles
$scriptdir/sync_mapfiles.sh $project


# 2) Generate edited mapfiles
mapfile_list=$lists_dir/mapfile_list_$list_suffix

if [ $rebuild -eq 1 ]
then
    $scriptdir/gen_edited_mapfiles.sh --all $project $mapfile_list
else
    $scriptdir/gen_edited_mapfiles.sh $project $mapfile_list
fi

echo "`wc -l < $mapfile_list` new edited mapfiles generated"

if [ ! -s $mapfile_list ]
then
    echo "No new edited mapfiles, so no data to fetch. (Removing empty list.)"
    rm -f $mapfile_list
    exit
fi


# 3) Generate list of URLs and destinations for transfer
transfer_list=$lists_dir/transfer_$list_suffix
$scriptdir/gen_transfer_list.sh $project $mapfile_list $transfer_list
echo "`wc -l < $transfer_list` data files to transfer"


# 4) Transfer the data files
if [ $dry_run -eq 1 ]
then
    echo "Dry run: skipping data fetch"
else
    $scriptdir/fetch_datafiles.sh $project $transfer_list
fi

echo "Done"
