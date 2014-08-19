``sy genlink``: Create a syncany:// link from an existing local folder
----------------------------------------------------------------------
This command creates a Syncany link (syncany://..) from an existing local
folder. The link can then be sent to someone else to connect to the
repository.

Syncany links contain the connection information of the storage backend,
so in case of an FTP backend, host/user/pass/etc. would be contained in
a link. If the link is shared, be aware that you are giving this information
to the other users.

Example 1: Normal usage of 'genlink'
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy genlink

	To share the same repository with others, you can share this link:

	   syncany://storage/1/IOl4XYsdjHRazvUJCB4GPOSA+/CDhpE8ooYNkpSCSU8Bh...

	This link is encrypted with the given password, so you can safely share it.
	using unsecure communication (chat, e-mail, etc.)

	WARNING: The link contains the details of your repo connection which typically
		 consist of usernames/password of the connection (e.g. FTP user/pass).

Example 2: Short output of 'genlink'
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy genlink --short
	syncany://storage/1/IOl4XYsdjHRazvUJCB4GPOSA+/CDhpE8ooYNkpSCSU8Bh5knX78HiGFVfa1bofUD6a0RjDyNMyr3LXGRFE4T1Q==-U3kCBQEMvF...

Help page
^^^^^^^^^
::

	NAME
	  sy-genlink - generate Syncany link for initialized local directory
	   
	SYNOPSIS
	  sy genlink [-s | --short]
	 
	DESCRIPTION
	  This command creates a Syncany link (syncany://..) from an existing local
	  folder. The link can then be sent to someone else to connect to the
	  repository.
	 
	  Syncany links contain the connection information of the storage backend,
	  so in case of an FTP backend, host/user/pass/etc. would be contained in
	  a link. If the link is shared, be aware that you are giving this information
	  to the other users.
	   
	OPTIONS
	  -S, --short
	    Only prints the link and leaves out any explanatory text. Useful if the
	    link is used in a script.
	   
	COPYRIGHT
	  Syncany 0.1.7-alpha+SNAPSHOT.1407211951.git4a2d264, Distributed under GPLv2,
	  Copyright (c) 2011-2014 Philipp C. Heckel
