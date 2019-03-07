# data sync tools

To use (for cp4cds):

 * edit vars_cp4cds to set:
    * local_data_root : where you want to sync the data to
    * myproxy_username

 * run `do_all.sh cp4cds`

----
This will:

* maintain _two_ local mapfile directory trees; one ("orig") is a verbatim copy of the remote mapfiles, the other ("edited") has the data file paths edited to reflect the local paths, and can be used for publication

Each time:
* do a sync of the "orig" mapfiles directory from the remote in order to obtain any new mapfiles
* compare the "orig" and "edited" mapfiles directories to see which mapfiles were downloaded for which a corresponding edited mapfile does not yet exist
* for each of these, create the edited mapfile. Also create a list of all the newly fetched mapfiles.
* use the list of newly fetched mapfiles to create a list of new datafiles which need to be fetched
* fetch these new datafiles
