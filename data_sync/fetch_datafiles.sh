#!/bin/sh
#
# usage:
#
#    fetch_datafiles.sh <project> <transfer_list>
#
# e.g. 
#
#    fetch_datafiles.sh cp4cds /path/to/transfer_20190307.135439
#
# Transfers the requested data files using gridftp
#
# The transfer list should contain lines with <remote_url> <local_path>
# as required by globus-url-copy


project=$1
transfer_list=$2

scriptdir=`dirname $0`
. $scriptdir/funcs.sh
check_num_args 2 $*
set_vars $project

ensure_cert

echo "Fetching data files"

globus-url-copy -cred $cert_path -vb -c -cd -f $transfer_list

