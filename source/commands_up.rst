``sy up``: Detect local changes and upload to repository
--------------------------------------------------------
This command detects changes in the local folder, indexes new files and
uploads changes to the remote repository. If there are local changes, the
command determines what has changed, packages these changes in new
multichunks, and uploads them to the remote storage alongside with a delta
metadata database. 

To determine the local changes, the 'status' command is used. All options
of the 'status' command can also be used in this command.

If there are no local changes, the 'up' command will not upload anything -
no multichunks and no metadata.

Example 1: Basic usage (index and upload locally changed files)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::
	$ sy up
	A testfile.txt
	A testfile2.txt
	Sync up finished.

Example 2: Force checksum calculation per file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Forcing checksum calculation means that we don't want to rely on last modified date and size.

::

	$ sy up --force-checksum
	A testfile.txt
	A testfile2.txt
	Sync up finished.

Help page
^^^^^^^^^
::

	$ sy up --help
	NAME
	  sy-up - uploads changes in local Syncany folder to remote repository
	  
	SYNOPSIS
	  sy up [<status-options>]
	 
	DESCRIPTION
	  This command detects changes in the local folder, indexes new files and
	  uploads changes to the remote repository. If there are local changes, the
	  command determines what has changed, packages these changes in new
	  multichunks, and uploads them to the remote storage alongside with a delta
	  metadata database. 
	 
	  To determine the local changes, the 'status' command is used. All options
	  of the 'status' command can also be used in this command.
	 
	  If there are no local changes, the 'up' command will not upload anything -
	  no multichunks and no metadata.
	 
	OPTIONS
	  All arguments of the 'status' command can be used.

	COPYRIGHT
	  Syncany 0.1.7-alpha+SNAPSHOT.1407211951.git4a2d264, Distributed under GPLv2,
	  Copyright (c) 2011-2014 Philipp C. Heckel
