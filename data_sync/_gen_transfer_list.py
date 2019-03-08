"""
helper for gen_transfer_list.sh; not intended to be called directly

Standard input is the concatenated mapfiles contents.
Standard output is contents of the file of URL pairs for globus_url_copy
On the command line are the variables local_data_root, url_base
"""

import os
import sys

local_data_root, url_base = sys.argv[1:]

for line in sys.stdin:
    bits = line.split()
    path = bits[2]
    size = int(bits[4])
    
    remote_url = path.replace(local_data_root, url_base)
    local_url = "file://" + path
    
    if ((not os.path.exists(path)) or (os.stat(path).st_size != size)):
        print("{0} {1}".format(remote_url, local_url))
