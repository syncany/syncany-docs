``sy init``: Initializing a repository
--------------------------------------
This command creates a new remote repository using the specified plugin, and
initializes the local directory. Unless -I is set, the command is
interactive and queries the user for input. Depending on the chosen plugin chosen (with -P or interactively), different plugin-specific options are required or optional.

Once the 'init' command was successfully executed, the initialized local
folder can be synced with the newly created repository. The commands
'up', 'down', 'watch', etc. can be used. Other clients can then be connected
using the 'connect' command.


Example 1: Create new repository (interactive mode)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy init --create-target
	Choose a storage plugin. Available plugins are: local, s3, webdav
	Plugin: local
	
	Connection details for Local connection:
	- Local Folder: /tmp/x
	
	The password is used to encrypt data on the remote storage.
	Choose wisely!
	
	Password (min. 10 chars): 
	Confirm: 
	
	WARNING: The password is a bit short. Less than 12 chars are not future-proof!
	Are you sure you want to use it (y/n)? y
	
	Generating master key from password (this might take a while) ...
	
	Repository created, and local folder initialized. To share the same repository
	with others, you can share this link:
	
	   syncany://storage/1/y8aqJUCsXqPtH9Ku+aoAKAKO0vccIUH32k/tPRCineNLLcCUDGHuGRBklmvhciUCe7WbTNw9M7sHN1z8V0HZ+A==-U3kCBQE6vaV...
	
	This link is encrypted with the given password, so you can safely share it.
	using unsecure communication (chat, e-mail, etc.)
	
	WARNING: The link contains the details of your repo connection which typically
	         consist of usernames/password of the connection (e.g. FTP user/pass).
	
Example 2: Create new repository (with prefilled settings) 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy init --plugin=s3 -o accessKey=AKIAJL7... -o secretKey=... -o bucket=syncanytest3 -o location=EU
	...

Help page
^^^^^^^^^
::
  
	$ sy init --help
	NAME
	  sy-init - intialize local directory and create remote Syncany repository
	
	SYNOPSIS
	  sy init [-P | --plugin=<plugin>] [-o | --plugin-option=<key=value>]
	          [-E | --no-encryption] [-G | --no-compression]
	          [-t | --create-target] [-a | --advanced] [-I | --no-interaction]
	           
	DESCRIPTION
	  This command creates a new remote repository using the specified plugin, and
	  initializes the local directory. Unless -I is set, the command is
	  interactive and queries the user for input. 
	                
	  Depending on the chosen plugin chosen (with -P or interactively), different
	  plugin-specific options are required or optional.
	
	  Once the 'init' command was successfully executed, the initialized local
	  folder can be synced with the newly created repository. The commands
	  'up', 'down', 'watch', etc. can be used. Other clients can then be connected
	  using the 'connect' command.
	 
	OPTIONS
	  -P, --plugin=<plugin>           
	    Selects a plugin to use for the repository. Local files will be synced via
	    the storage specified by this plugin. Any of the following available
	    plugins can be used: %PLUGINS%
	    
	  -o, --plugin-option=<key=value> (multiple options possible)
	    Sets a plugin-specific setting in the form of a key/value pair. Each
	    plugin defines different mandatory and optional settings that must/can
	    either be specified by this option, or interactively. All mandatory and
	    optional settings can be listed using the 'plugin' command.
	   
	  -E, --no-encryption             
	    DO NOT USE THIS OPTION. Turns off the encryption for the newly created
	    remote repository. All files are stored in plaintext. No password is
	    needed for either syncany:// link, multichunk or metadata.
	   
	  -G, --no-compression            
	    Turns off Gzip compression for the newly created remote repository. All
	    files are stored in uncompressed form. Can increase indexing performance,
	    but will also increase transfer times and remote storage space.
	   
	  -t, --create-target             
	    If not existent, creates the target path on the remote storage. If this
	    option is not given, the command will fail if the target folder/path does
	    not exist.
	   
	  -a, --advanced                  
	    Runs the interactive setup in an advanced mode, querying the user for more
	    detailed encryption options. In particular, it is possible to select the
	    available symmetric ciphers and modes of operation to encrypt the
	    repository with.
	   
	  -I, --no-interaction            
	    Runs the command in a non-interactive mode. The user will not be queried
	    for any input. The command will fail if not all mandatory options are
	    given on the command line. This option can be used to automate repository
	    creation.
	                
	COPYRIGHT
	  Syncany 0.1.7-alpha+SNAPSHOT.1407211951.git4a2d264, Distributed under GPLv2,
	  Copyright (c) 2011-2014 Philipp C. Heckel
