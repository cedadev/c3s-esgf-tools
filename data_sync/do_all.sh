#!/bin/sh
#
# usage:
#
#   do_all.sh <project>
#
# e.g.
#
#   do_all.sh cp4cds
#
#
# Syncs the mapfiles, generates any new edited mapfiles, uses these to 
# generate a list of datafiles to be transferred, and then transfers these
# data files

project=$1

scriptdir=`dirname $0`
. $scriptdir/funcs.sh
check_num_args 1 $*
set_vars $project


# 1) Sync the mapfiles
$scriptdir/sync_mapfiles.sh $project


# 2) Generate edited mapfiles
timestamp=`get_timestamp`
mapfile_list=$lists_dir/mapfile_list_$timestamp
$scriptdir/gen_edited_mapfiles.sh $project $mapfile_list
echo "`wc -l < $mapfile_list` new edited mapfiles generated"

if [ ! -s $mapfile_list ]
then
    echo "No new edited mapfiles, so no data to fetch. (Removing empty list.)"
    rm -f $mapfile_list
    exit
fi


# 3) Generate list of URLs and destinations for transfer
transfer_list=$lists_dir/transfer_$timestamp
$scriptdir/gen_transfer_list.sh $project $mapfile_list $transfer_list
echo "`wc -l < $transfer_list` data files to transfer"


# 4) Transfer the data files
$scriptdir/fetch_datafiles.sh $project $transfer_list


echo "Done"
