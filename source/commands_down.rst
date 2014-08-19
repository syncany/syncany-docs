``sy down``: Retrieve and apply remote changes
----------------------------------------------
This command detects changes made by other clients and applies them
locally. If there are remote changes, the command downloads the relevant
metadata, evaluates which multichunks are required and then downloads them.
It then determines what files need to be created, moved, changed or deleted,
and performs these actions, if possible.

In some cases, file conflicts may occur if the local file differs from the
expected file. If that happens, this command can either automatically rename
conflicting files and append a filename suffix, or it can ask the user what
to do.

Example 1: Download and apply remote changes (no conflicts)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	 $ sy down
	 A testfile.txt
	 A testfile2.txt
	 Sync down finished.
	 
	 $ ls
	 testfile.txt
	 testfile2.txt


Example 2: Download and apply remote changes (with conflicts)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	 $ echo "conflicting content" > testfile.txt
	 testfile.txt
	 
	 $ sy down
	 A testfile.txt
	 A testfile2.txt
	 Sync down finished.
	 
	 $ ls
	 testfile2.txt
	 testfile (pheckel's conflicted copy, 27 Apr 14, 6-46 PM).txt
	 testfile.txt


Help page
^^^^^^^^^
::

	$ sy down --help
	NAME
	  sy-down - fetch remote changes from Syncany repository and apply locally
	
	SYNOPSIS
	  sy down [-C | --conflict-strategy=<rename|ask>] [-A | --no-apply]
	 
	DESCRIPTION
	  This command detects changes made by other clients and applies them
	  locally. If there are remote changes, the command downloads the relevant
	  metadata, evaluates which multichunks are required and then downloads them.
	  It then determines what files need to be created, moved, changed or deleted,
	  and performs these actions, if possible.
	  
	  In some cases, file conflicts may occur if the local file differs from the
	  expected file. If that happens, this command can either automatically rename
	  conflicting files and append a filename suffix, or it can ask the user what
	  to do.
	 
	  To determine the remote changes, the 'ls-remote' command is used.
	 
	OPTIONS
	  -A, --no-apply
	    All local file system actions are skipped, i.e. the local folder will not
	    be changed. Only the new/unknown database versions will be downloaded and
	    persisted to the database.  
	   
	  -C, --conflict-strategy=<rename|ask>
	    Chooses the conflict resolve strategy if a local file does not match the
	    expected local file (as per the local database). The conflict strategy
	    describes the behavior of this command.
	   
	    * The 'rename' strategy automatically renames conflicting files to a
	      conflicting file name (e.g. "Italy (Philipp's conflicted copy).txt").
	   
	    * The 'ask' strategy lets the user decide whether to keep the local file,
	      apply the remote file, or create a conflicting file (as above).
	     
	    The default strategy is 'rename'.
	    The 'ask' strategy is currently NOT implemented! 
	   
	COPYRIGHT
	  Syncany 0.1.7-alpha+SNAPSHOT.1407211951.git4a2d264, Distributed under GPLv2,
	  Copyright (c) 2011-2014 Philipp C. Heckel