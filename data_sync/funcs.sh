
ensure_dir() {
    dir_path=$1
    [ -d $dir_path ] || mkdir -p $dir_path
}

ensure_parent_dir() {
    ensure_dir `dirname $1`
}


get_timestamp() {
    date +%Y%m%d.%H%M%S
}

set_vars() {
    project=$1
    file=$scriptdir/vars_$project
    if [ -z "$project" ]
    then
	echo "need project name to set configuration variables"
	exit 1
    fi
    if [ ! -e "$file" ]
    then
	echo "cannot find config file $file"
	exit 1
    fi
    . $file

    # override the mapfile dirs for a dry run, saving the 
    # real values in $real_<variable>
    if [ ${dry_run-0} -eq 1 ]
    then
	tmp_mapfile_dir=${TMPDIR-/tmp}/mapfiles

	real_raw_mapfile_dir=$raw_mapfile_dir
	real_edited_mapfile_dir=$edited_mapfile_dir

	raw_mapfile_dir=$tmp_mapfile_dir/raw
	edited_mapfile_dir=$tmp_mapfile_dir/edited
    fi
}


ensure_cert() {
    if ! openssl x509 -in $cert_path -checkend `expr $cert_min_hours \* 3600` > /dev/null 2>&1
    then
	myproxy-logon -s $myproxy_server -l $myproxy_username -t $cert_max_hours -o $cert_path || exit 1
    fi
}


check_num_args() {
    nargs=$1
    shift
    args=$*
    nused=$#
    if [ $nargs -ne $nused ]
    then
	echo "Script requires $nargs args; $nused supplied"
	exit 1
    fi
}
