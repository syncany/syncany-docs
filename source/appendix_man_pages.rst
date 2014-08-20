Appendix A: Manual pages
========================

This appendix lists all the manual/help pages available for the ``sy`` command, its sub-commands, as well as for the ``syd`` command. These help pages are available by calling ``sy <action> --help`` or ``man sy-<action>`` (Linux only).

.. contents::

``sy --help``
^^^^^^^^^^^^^
::

	NAME
	  sy - secure file sync software for arbitrary storage backends
	 
	SYNOPSIS
	  sy [-l|--localdir=<path>] [--log=<path>] [-v]
	     [-vv] [--loglevel=<level>] [--print]
	     [-d|--debug] [-h|--help] <command> [<args>]
	 
	DESCRIPTION
	  Syncany is an open-source cloud storage and filesharing application. It
	  allows users to backup and share certain folders of their workstations
	  using any kind of storage.
	 
	  Command overview:
	    init       Initialize the current folder as a Syncany folder.
	    connect    Connect the current folder to an existing Syncany repository.
	    status     Detect local changes and print to STDOUT.
	    up         Detect local changes and upload to repository.
	    ls-remote  Detect remote changes and print to STDOUT.
	    down       Detect remote changes and apply locally.
	    watch      Automatically synchronizes the local folder with the repo.
	    cleanup    Remove old versions from the local database and the repo.
	    restore    Restore the given file paths from the remote repository.
	    genlink    Create a syncany:// link from an existing local folder.
	    log        Print parts of the local database to STDOUT.
	    plugin     List, install and remove storage backend plugins.
	
	  Short command descriptions and options can be found below. Detailed
	  explanations can be queried with `sy <command> --help`.
	
	GLOBAL OPTIONS
	  -l, --localdir=<path>
	      Use <path> instead of the current directory as local sync folder.
	      Syncany searches for a '.syncany' folder in the given and all parent
	      directories.
	
	  -d, --debug
	      Sets the log level to ALL, and print the log to the console.
	      Alias to: --loglevel=ALL --print
	
	  -h, --help
	      Print this help screen and exit.
	
	  -v, -vv
	      Print application version exit.
	
	  --log=<path>
	      Log output to the file given by <path>. If - is given, the
	      output will be logged to STDOUT (default).
	
	  --loglevel=<level>
	      Change log level to <level>. Level can be either of the
	      following: OFF, SEVERE, WARNING, INFO, FINE, FINER, FINEST, ALL
	
	  --print
	      Print the log to the console (in addition to the log file).
	
	AUTHORS
	  Written by Philipp C. Heckel and many others
	
	REPORTING BUGS
	  Please report bugs to the GitHub issues page at
	     https://www.github.com/syncany/syncany/issues
	
	COPYRIGHT
	  Syncany 0.1.7-alpha+SNAPSHOT.1407211951.git4a2d264, Distributed under GPLv2,
	  Copyright (c) 2011-2014 Philipp C. Heckel
	  
``sy init --help``
^^^^^^^^^^^^^^^^^^
::
  
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
	  	  
``sy connect --help``
^^^^^^^^^^^^^^^^^^^^^
::
	
	NAME
	  sy-connect - connect to an existing Syncany repository
	 
	SYNOPSIS
	  sy connect <syncany-link>
	
	  sy connect [-P | --plugin=<plugin>] [-o | --plugin-option=<key=value>]
	             [-I | --no-interaction] 
	           
	DESCRIPTION
	  This command connects to an existing remote repository and initializes
	  the local directory.
	 
	  The command can be called as follows:
	 
	  1. Using a syncany:// link generated by either 'init' or 'genlink',
	     the command connects to the repository given in the link. If the link
	     is encrypted, the link/repo password must be entered.
	    
	  2. If no link is given, the command acts like 'init', i.e. it queries the
	     user for storage plugin and connection details of the repository to
	     connect to.
	     
	  Once the repository is connected, the initialized local folder can be synced
	  with the newly created repository. The commands 'up', 'down', 'watch', etc.
	  can be used. Other clients can then be connected using the 'connect' command.
	 
	OPTIONS
	  -P, --plugin=<plugin>           
	    Selects a plugin to use for the repository. Local files will be synced via
	    the storage specified by this plugin.
	    
	  -o, --plugin-option=<key=value> (multiple options possible)
	    Sets a plugin-specific setting in the form of a key/value pair. Each
	    plugin defines different mandatory and optional settings that must/can
	    either be specified by this option, or interactively. All mandatory and
	    optional settings can be listed using the 'plugin' command.
	   
	  -I, --no-interaction            
	    Runs the command in a non-interactive mode. The user will not be queried
	    for any input. The command will fail if not all mandatory options are
	    given on the command line. This option can be used to automate repository
	    creation.
	                
	COPYRIGHT
	  Syncany 0.1.7-alpha+SNAPSHOT.1407211951.git4a2d264, Distributed under GPLv2,
	  Copyright (c) 2011-2014 Philipp C. Heckel     	  

``sy status --help``
^^^^^^^^^^^^^^^^^^^^
::

	NAME
	  sy-status - list new and changed files in local Syncany folder
	   
	SYNOPSIS
	  sy status [-f | --force-checksum]
	 
	DESCRIPTION
	  This command compares the local file tree on the disk with the local
	  database and detects local changes. These changes are printed to the
	  console.
	 
	  Local changes are detected using the last modified date and the file size
	  of a file. If they match the local database, the command assumes that the
	  content has not changed (no checksum comparison). If -f is enabled, the
	  checksum is additionally compared.
	 
	  This command is used by the 'up' command to detect local changes. 
	 
	OPTIONS
	  -f, --force-checksum
	    Enforces this command to compare files by checksum, not by file size
	    and last modified date only. This option is particularly useful if
	    files are modified in-place very often (last modified date and size
	    do not change). For large local folders, this option can tremendously
	    decrease the performance of this command and increase I/O significantly. 

	COPYRIGHT
	  Syncany 0.1.7-alpha+SNAPSHOT.1407211951.git4a2d264, Distributed under GPLv2,
	  Copyright (c) 2011-2014 Philipp C. Heckel
	  
``sy up --help``
^^^^^^^^^^^^^^^^
::

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

``sy ls-remote --help``
^^^^^^^^^^^^^^^^^^^^^^^
::

	NAME
	  sy-ls-remote - list changes on remote repository
	    
	SYNOPSIS
	  sy ls-remote
	 
	DESCRIPTION
	  This command compares the list of locally known remote databases with the
	  remotely available client databases and prints new/unknown files to the
	  console.
	   
	  This command is used by the 'down' command to detect which remote databases
	  to download and compare.
	 
	COPYRIGHT
	  Syncany 0.1.7-alpha+SNAPSHOT.1407211951.git4a2d264, Distributed under GPLv2,
	  Copyright (c) 2011-2014 Philipp C. Heckel   
	  	    	      	  	  	  	  
``sy down --help``
^^^^^^^^^^^^^^^^^^
::

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
	  
``sy watch --help``
^^^^^^^^^^^^^^^^^^^
::

	NAME
	  sy-watch - monitor local Syncany folder and automatically sync changes
	 
	SYNOPSIS
	  sy watch [-i | --interval=<sec>] [-s | --delay=<sec>] [-W | --no-watcher]
		   [-a | --announce=<host>:<port>] [-N | --no-announcements]
		   [<status-options> | <up-options> | <down-options>]
	 
	DESCRIPTION
	  Automatically synchronizes the local folder with the repository. The
	  command performs the up and down command in an interval, watches the
	  file system for changes and subscribes to the Syncany pub/sub server.
	 
	  In the default configuration (no options), the command subscribes to the
	  Syncany pub/sub server and registers local file system watches in the
	  locally synced folder (and all of its subfolders). When local events are
	  registered, the command waits a few seconds (waiting for settlement) and
	  then triggers the 'up' command. After the upload has finished, a message
	  is published to the pub/sub server, telling other clients of this repo
	  that there is new data. Clients subscribed to the repository's channel
	  will receive this notification and immediately perform a 'down' command.
	  This mechanism allows instant synchronization among clients even if a dumb
	  storage server (such as FTP) is used.
	 
	  In case file system events or pub/sub notifications are missed, the
	  periodic synchronization using the 'down' and 'up' command is implemented
	  as a fallback.
	 
	  Note: The messages exchanged through the pub/sub server do not include any
	  confidential data. They only include the repository identifier (randomly
	  generated in the 'init' phase), and a client identifier (randomly generated
	  on every restart).  
	 
	OPTIONS   
	  -s, --delay=<sec>               
	    Waits for <sec> seconds for file system watcher to settle before starting
	    to index newly added files. If many file system actions are executed (e.g.
	    copying a large folder), waiting a few seconds ensures that actions
	    belonging together are uploaded in a single new database version.
	    Default value is 3 seconds.
	   
	  -W, --no-watcher                
	    Disables folder watcher entirely. Local changes in the synced folder (and
	    its subfolders) will not be registered right away. Instead, local changes
	    will only be detected by the periodic synchronization loop. Unless other
	    clients have also set this option, changes by other clients will still be
	    detected through the pub/sub server. If -W is set, the -i/--interval
	    option becomes more relevant as local synchronization entirely relies on
	    the interval.
	   
	  -a, --announce=<host>:<port>    
	    Defines the hostname and the port of the pub/sub server. The pub/sub
	    server is used to notify other clients if the local client uploaded new
	    data, and to get notified if other clients did so. Default is the central
	    Syncany pub/sub server at notify.syncany.org:8080. The SparkleShare
	    pub/sub server can be used interchangeably. To set up your own server,
	    install a fanout instance from https://github.com/travisghansen/fanout/.
	   
	  -N, --no-announcements          
	    Disables the pub/sub server entirely. Syncany will not connect to the
	    server and changes that are published to the pub/sub server are not
	    detected. Instead, remote changes will only be detected by the periodic
	    synchronization loop. If -N is set, the -i/--interval option becomes more
	    relevant as remote synchronization entirely relies on the interval.

	  -i, --interval=<sec>            
	    Sets the synchronization interval of the periodic 'down'/'up' loop to be
	    run every <sec> seconds. The sync loop is a fallback only and is not
	    relevant if the pub/sub server and the file system watching is enabled.
	    Default value is 120 seconds.

	  In addition to these options, all arguments of the commands 'status',
	  'ls-remote', 'up' and 'down' can be used.

	COPYRIGHT
	  Syncany 0.1.9-alpha+SNAPSHOT.1408201834.git965cd65, Distributed under GPLv3,
	  Copyright (c) 2011-2014 Philipp C. Heckel

``sy cleanup --help``
^^^^^^^^^^^^^^^^^^^^^
::

	NAME
	  sy-cleanup - remove old versions and free remote disk space 

	SYNOPSIS
	  sy cleanup [-M | --no-database-merge] [-V | --no-version-remove]
		     [-k | --keep-versions=<count>] [<status-options>]
		   
	DESCRIPTION
	  This command performs different operations to cleanup the local database as
	  well as the remote store. It removes old versions from the local database,
	  deletes unused multichunks (if possible) and merges a client's own remote
	  database files (if necessary).
	   
	  Merge remote databases: Unless -M is specified, the remote databases of the
	  local client are merged together if there are more than 15 remote databases.
	  The purpose of this is to avoid endless amounts of small database files on
	  the remote storage and a quicker download process for new clients.
	 
	  Remove old file versions: Unless -V is specified, file versions marked as
	  'deleted' and files with as history longer than <count> versions will be
	  removed from the database, and the remote storage. This will cleanup the
	  local database and free up remote storage space. Per default, the number of
	  available file versions per file is set to 5. This value can be overridden
	  by setting -k.    
	 
	  This command uses the 'status' and 'ls-remote' commands and is only executed
	  if there are neither local nor remote changes.
	 
	  This command is used by the 'up' command.
	 
	OPTIONS
	  -M, --no-database-merge         
	    Turns off database file merging for the local client. If this is set, this
	    command will not merge this client's metadata files even if there are more
	    than 15 database files on the remote storage.
	   
	  -V, --no-version-remove  
	    Turns off the removal of old versions for the command. If this is set, this
	    command will not shorten file histories to the <count> given by -k, and it
	    will not delete file versions marked as 'deleted' in the database.      
	       
	  -k, --keep-versions=<count>     
	    Sets the number of file versions per file to keep in the database and the
	    remote storage. The file histories of all files in the database will be
	    shortened to <count> file versions. Metadata and file content of these old
	    versions will be deleted, and cannot be restored! This option only works if
	    -V is not set.

	  -t, --time-between-cleanups=<seconds>
	    Sets the minimal amount of time between two cleanups. If the last cleanup
	    from this client is less then <seconds> seconds ago, no database files
	    will be merged. Versions will still be removed.

	  -x, --max-database-files=<count>
	    Sets the number of database files per client. If the total number of
	    databases exceeds <count> times the number of clients, all database
	    files will be merged to one per client.
	   
	COPYRIGHT
	  Syncany 0.1.9-alpha+SNAPSHOT.1408201834.git965cd65, Distributed under GPLv3,
	  Copyright (c) 2011-2014 Philipp C. Heckel
	   
``sy restore --help``
^^^^^^^^^^^^^^^^^^^^^
::

	NAME
	  sy-restore - restore old or deleted files
	  
	SYNOPSIS
	  sy restore [-r | --revision=<revision>] [-t | --target=<filename>]
		     <file-identifier>
	 
	DESCRIPTION
	  This command restores old or deleted files from the remote storage.
	 
	  As long as a file is known to the local database and the corresponding
	  chunks are available on the remote storage, it can be restored using this
	  command. The command downloads the required chunks and assembles the file.
	 
	  If no target revision is given with -r, the last version is restored. To
	  select a revision to restore, the `sy ls` command can be used.  
	 
	OPTIONS
	  -r, --revision=<revision>
	    Selects a certain revision/version to restore. If no revision is given,
	    the last revision is used.
	 
	  -t, --target=<file>           
	    Defines the target output filename to restore the file to. If this option
	    is not given, the default filename is the filename of the restored file
	    version, appended with a "restored" suffix. All folders given in the
	    target filename will be created.
	   
	  <file-identifier>
	   Identifier of the file history as printed by the `sy ls` command. The
	   file identifier and a revision/version number uniquely identify a single
	   version of a file at a certain point in time. The identifier can be
	   abbreviated if it is unique in the database.  
	  
	EXAMPLES  
	  sy restore 3168ab663e
	    Restores the last version of the file with identifier 3168ab663e. If the
	    database knows three versions of this file, the second file will be
	    restored. Assuming that the original filename was 'folder/file.txt', the
	    target filename will be 'folder/file (restored).txt'. If 'folder' does not
	    exist, it will be created.
	   
	  sy restore --revision=1 --target=restored-file.txt 3168ab663e
	    Restores version 1 of the file with the identifier 3168ab663e to the
	    target file 'restored-file.txt'. If this file exists, an error will be
	    thrown.
	   
	COPYRIGHT
	  Syncany 0.1.9-alpha+SNAPSHOT.1408201834.git965cd65, Distributed under GPLv3,
	  Copyright (c) 2011-2014 Philipp C. Heckel
	  
``sy genlink --help``
^^^^^^^^^^^^^^^^^^^^^
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
	  

``sy ls --help``
^^^^^^^^^^^^^^^^
::

	NAME
	  sy-ls - lists and filters the current and past file tree
	  
	SYNOPSIS
	  sy ls [-V | --versions] [-t | --types=<types>] [-D | --date=<date>]
		[-r | --recursive] [-f | --full-checksums] [-g | --group]
		[<path-expression>]
	 
	DESCRIPTION
	  This command lists and filters the file tree based on the local database.
	  The file tree selection can be performed using the following selection
	  criteria:
	 
	  (1) Using the <path-expression>, one can select a file pattern (such as
	  `*.txt`) or sub tree (such as `subfolder/`, only with -r). (2) Using -r,
	  the command does not only list the folder relative to the
	  <path-expression>, but to all sub trees of it. (3)  The -t option limits
	  the result set to a certain file type ('f' for files, 'd' for directories,
	  and 's' for symlinks). Types can be combined, e.g. `sy ls -tfs` selects
	  files and symlinks. (4) The -D option selects the date/time at which to
	  select the file tree, e.g. `sy ls -D20m` to select the file tree 20 minutes
	  ago or `sy ls -D2014-05-02` to select the file tree at May 2.
	 
	  Using the --versions flag, the command also displays the entire version
	  history for the selected files. Using --group, the result can be grouped by
	  the file history identifier. 
	 
	OPTIONS
	  -V, --versions
	    Select and display the entire history of the matching files instead of only
	    the last version. Useful with --group.
	 
	  -t, --types=<t|d|s>           
	    Limits the result set to a certain file type ('f' for files, 'd' for
	    directories, and 's' for symlinks). Types can be combined, e.g.
	    `sy ls -tfs` selects files and symlinks. Default setting is 'tds'.
	    
	  -D, --date=<relative-date|absolute-date>
	    Selects the file tree at a certain date. The date can be given as a
	    relative date to the current time, or an absolute date in form of a
	    timestamp.
	   
	    Absolute date format: <yy-MM-dd HH:mm:ss>

	    Relative date format: <value><unit>, for which <value> may be any
	    floating point number and <unit> may be any of the following: s(econds),
	    m(inutes), h(ours), d(ays), w(eeks), mo(nths), y(ears). Units may be
	    shortened if they are unique. Examples: 5h30m or 1y1mo2d
	   
	  -r, --recursive
	    Not only selects the folder relative to the <path-expression>, but to all
	    sub trees of it.
	   
	  -g, --group
	    Only works with --versions. Displays the file versions grouped by file
	    history.
	 
	  -f, --full-checksums
	    Displays full/long checksums instead of shortened checksums.   
	   
	  <path-expression>
	    Selects a file pattern or sub tree of the database using substring and
	    wildcard mechanisms. The expression is applied to the relative slash-
	    separated path. The only possible wildcard is * (equivalent: ^).
	   
	    If <path-expression> does not contain a wildcard, it is interpreted as
	    prefix and extended to `<path-expression>*`. If a wildcard is present, no
	    wildcard is appended.
	   
	    Note: The Linux shell expands the * wildcard if a matching file is
	    present. Either use single quotes (e.g. '*.txt') or use ^ instead.
	   
	EXAMPLES  
	  sy ls -r subfolder/
	    Selects all file entries of the current file tree in the folder
	    'subfolder/', including for instance 'subfolder/some/other/file.txt'.
	   
	  sy ls --recursive --types=fs --date=1h30m '*.txt'
	    Selects all files and symlinks in the entire file tree that end with .txt
	    and existed one and 30 minutes hour ago.
	   
	  sy ls --versions --group --recursive
	    Selects and displays all file versions and their file histories.
	    This selects the entire database. Use with caution.
	   
	COPYRIGHT
	  Syncany 0.1.7-alpha+SNAPSHOT.1407211951.git4a2d264, Distributed under GPLv2,
	  Copyright (c) 2011-2014 Philipp C. Heckel
	  	  
``sy plugin --help``
^^^^^^^^^^^^^^^^^^^^
::

	NAME
	  sy-plugin - list, install and remove Syncany plugins
	   
	SYNOPSIS
	  sy plugin list [-R | --remote-only] [-L | --local-only] [-s | --snapshots]
		         [<plugin-id>]
		        
	  sy plugin install [-s | --snapshot] (<URL> | <file> | <plugin-id>)
	 
	  sy plugin remove <plugin-id>
		   
	DESCRIPTION
	  This command performs three different actions:
	 
	  - It lists the locally installed and remotely available plugins, including
	  version information and whether plugins can be upgraded. The 'list' action
	  connects to the Syncany host to retrieve remote plugin information. By
	  default, only plugin releases will be listed in the result. If instead
	  daily snapshots are desired, the -s option can be used.
	 
	  - It installs new plugins from either a given URL or a local file. URL and
	  local file must point to a valid Syncany plugin JAR file to be installable.
	  If <plugin-id> is given, the command will connect to the Syncany host and
	  download the desired plugin from there. If instead of the release version
	  the daily snapshot shall be installed, the -s option can be used.
	   
	  Plugins installed by the 'install' action will be copied to the Syncany
	  user directory. On Unix-based systems, this directory is located at
	  ~/.config/syncany/plugins, and on Windows at %AppData%\Syncany\plugins.
	   
	  - It removes locally installed plugins from the user's local plugin
	  directory. Only plugins installed by the 'install' action can be removed.
	  The plugins shipped with Syncany (e.g. the 'local' plugin) cannot be
	  removed.
	   
	ACIONS
	  The following actions are available within the 'plugin' command:
	 
	  list [<args>] [<plugin-id>]
	    Lists locally installed plugins and/or remotely available plugins
	    on api.syncany.org. If <plugin-id> is given, the result list will
	    be shortened to the selected plugin.
	   
	    -R, --remote-only
	      Turns off local plugin discovery. In particular, the result list will
	      not include any information about the locally installed plugins.
	      Instead only remotely available plugins will be listed. Cannot be used
	      in combination with -L.
	     
	    -L, --local-only             
	      Turns off remote plugin discovery. Contrary to -R, the result list will
	      only include information about the locally installed plugins, and no
	      information about remote plugins. The Syncany host will not be queried.
	      Cannot be used in combination with -R.
	     
	    -s, --snapshots              
	      Instead of listing only plugin release versions (default), the result
	      list will also include daily snapshots (if newer snapshots exist).
	   
	  install [<args>] (<URL> | <file> | <plugin-id>)
	    Installs a plugin from an arbitrary URL, local file or from the
	    available plugins on api.syncany.org (with a plugin identifier)
	   
	    -s, --snapshot
	      Installs the daily snapshot instead of the release version. Only if
	      <plugin-id> is given. Not for <URL> or <file>.

	  remove <plugin-id>
	    Uninstalls a plugin entirely (removes the JAR file). This action can
	    only be used for plugins that were installed by the user, and not for
	    system-wide plugins.   

	COPYRIGHT
	  Syncany 0.1.7-alpha+SNAPSHOT.1407211951.git4a2d264, Distributed under GPLv2,
	  Copyright (c) 2011-2014 Philipp C. Heckel		 

