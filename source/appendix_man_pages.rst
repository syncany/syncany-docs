Appendix A: Manual Pages
========================

This appendix lists all the manual/help pages available for the ``sy`` command, its sub-commands. These help pages are available by calling ``sy <action> --help`` or ``man sy-<action>`` (Linux only).

.. contents::

.. _man_sy:

sy / syncany
^^^^^^^^^^^^

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
	  
	  Main sync commands:
	    init       Initialize the current folder as a Syncany folder
	    connect    Connect the current folder to an existing Syncany repository
	    up         Detect local changes and upload to repository
	    down       Detect remote changes and apply locally
	    
	  Other commands:
	    status     Detect and print local changes 
	    ls-remote  Detect and print remote changes  
	    ls         List and filter the current and past file tree.
	    cleanup    Remove old versions from the local database and the repo 
	    restore    Restore the given file paths from the remote repository 
	    genlink    Create a syncany:// link from an existing local folder 
	    plugin     List, install and remove storage backend plugins
	    update     Manage and check for application updates
	    daemon     Start and stop the background process (daemon)
	    watch      Automatically sync the local folder (in the foreground)
	
	  Short command descriptions and options can be found below. Detailed 
	  explanations can be queried with `sy <command> --help`.
	  
	  An extensive user guide with many examples is also available on the
	  Syncany website: https://syncany.org/r/userguide
	
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
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel

.. _man_cleanup:

sy cleanup
^^^^^^^^^^
::

	NAME
	  sy-cleanup - remove old versions and free remote disk space  
	 
	SYNOPSIS
	  sy cleanup [-o | --delete-older-than=<relative-time>] [-f | --force]
	             [-I | --no-delete-interval] [-O | --no-delete-older-than]
	             [-T | --no-temp-removal] [<status-options>]
	            
	DESCRIPTION 
	  This command performs different operations to cleanup the local database as 
	  well as the remote store. It removes old versions from the local database,
	  deletes unused multichunks (if possible) and merges remote database files, 
	  if necessary.
	  
	  Remove old file versions: File versions are deleted by two criteria. The
	  first is if it is older than 30 days (configurable with -o, disable with -O). 
	  The second is an interval based strategy, to keep the version history 
	  readable. By default, one version is kept per minute in the last hour,
	  one verison is kept per hour in the last three days and one version
	  per day is kept in the last month. This strategy can be disabled with -I. 
	  
	  Merge remote databases: The remote databases of the local client are merged 
	  together if there are more than 15 remote databases per client. The purpose 
	  of this is to avoid endless amounts of small database files on the remote 
	  storage and a quicker download process for new clients. In addition, 
	  databases are merged whenever versions are removed.
	  
	  This command uses the 'status' and 'ls-remote' commands and is only executed
	  if there are neither local nor remote changes.
	  
	OPTIONS
	  -o, --delete-older-than=<relative-time>
	    Sets the time that cleanup waits before deleting all versions that are 
	    older than this time. Until this time, deleted files can still be restored. 
	    Cleanup will fully delete files that were deleted longer ago in the past
	    than this amount of time and they will be gone permanently. In addition,
	    any versions of files which are not the current version, and older than
	    this threshold will also be deleted.
	    Default is 30 days (30d).
	    
	    Relative time format: <value><unit>, for which <value> may be any 
	    floating point number and <unit> may be any of the following: s(econds),
	    m(inutes), h(ours), d(ays), w(eeks), mo(nths), y(ears). Units may be
	    shortened if they are unique. Examples: 5h30m or 1y1mo2d
	  
	  -I, --no-delete-interval
	    Turns off the version removal strategy based on intervals. 
	    By default the following policy is applied:
	    For the last hour,        the last version from each minute is kept.
	    For the last three days,  the last version from each hour   is kept.
	    For the last thirty days, the last version from each day    is kept.
	    
	    With this option, only old file versions (-o) will be deleted. 
	    
	  -O, --no-delete-older-than 
	    Turns off the removal of old versions for the command. If this is set, this
	    command will not delete file versions purely because they are old. 
	    
	  -T, --no-temp-removal   
	    Turns off the removal of leftover temporary files for the command. If this
	    is set, this command will leave temporary files on the offsite storage
	    untouched.   
	    
	  -f, --force
	    Forces a the cleanup, even if the time between cleanups (3 hours) has not 
	    passed. Use this option only if a cleanup is absolutely necessary and you
	    know what you are doing.
	
	COPYRIGHT
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel

.. _man_connect:

sy connect
^^^^^^^^^^
::

	NAME
	  sy-connect - connect to an existing Syncany repository
	
	SYNOPSIS
	  sy connect <syncany-link> 
	             [-n | --add-daemon] [--password]
	
	  sy connect [-P | --plugin=<plugin>] [-o | --plugin-option=<key=value>]
	             [-n | --add-daemon] [--password]
	
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
	    plugin defines different mandatory and optional settings. At least, all
	    mandatory settings must be specified by this option. All mandatory and
	    optional settings can be listed using the 'plugin' command.
	
	  -n, --add-daemon
	    The initialized local folder is automatically added to the daemon
	    configuration for automatic synchronization if this option is used.
	    
	  --password=<password>
	    DO NOT USE THIS OPTION. Set the password to decrypt the repository.
	    This option shouldn't be used, because the password might be visible to 
	    other users or be stored in history files. 
	
	COPYRIGHT
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel

.. _man_daemon:

sy daemon
^^^^^^^^^
::

	NAME
	  sy-daemon - starts and stops the background process (daemon)
	   
	SYNOPSIS
	  sy daemon (start|stop|reload|restart|status|force-stop)
	  
	  sy daemon list
	  
	  sy daemon add <folder-path>
	  
	  sy daemon remove (<folder-path> | <folder-index>)
	  
	DESCRIPTION 
	  This command manages the Syncany background process (aka the daemon). It can
	  start and stop the daemon, display the status and reload the daemon
	  configuration.
	  
	  With the actions `list`, `add` and `remove`, the command furthermore manages
	  the Syncany folders controlled by the daemon. Controlled folders are synced
	  automatically when the daemon is running.
	  
	  This daemon can be started with `sy daemon start`. Once it is running, all
	  registered folders are monitored for changes and remote changes are
	  automatically applied to the local folder(s). All of these actions happen
	  in the background, without the need for any intervention.
	  
	  The daemon is configured using the `daemon.xml` file  at 
	  ~/.config/syncany/daemon.xml.
	  
	OPTIONS
	  start
	    Starts the background process (if it is not already running).
	    
	  stop
	    Stops the background process (if it is running).
	    
	  reload
	    Reloads the daemon configuration without restarting the proces.
	    
	  restart
	    Stops, then starts the daemon again. 
	    
	  status
	    Displays the status and the process ID (PID) of the daemon.
	    
	  force-stop
	    Forces the process to stop. Do not use this unless absolutely necessary!
	    
	  list
	    Lists the folders managed by the daemon.
	    
	  add <folder-path>
	    Adds the given folder to the daemon configuration. The added folder will
	    be managed by the daemon after the config has been reloaded, or the
	    daemon is restarted.
	    
	  remove (<folder-path> | <folder-index>)
	    Removes the given folder from the daemon configuration. The argument can
	    either be the full path of the folder or the index of the folder (as
	    printed by the `list` action). Changes will be applied after a restart
	    of the daemon.
	    
	COPYRIGHT
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel

.. _man_down:

sy down
^^^^^^^
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
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel

.. _man_genlink:

sy genlink
^^^^^^^^^^
::

	NAME
	  sy-genlink - generate Syncany link for initialized local directory
	    
	SYNOPSIS
	  sy genlink [-s | --short] [-m | --machine-readable]
	  
	DESCRIPTION 
	  This command creates a Syncany link (syncany://..) from an existing local
	  folder. The link can then be sent to someone else to connect to the
	  repository.
	  
	  Syncany links contain the connection information of the storage backend, 
	  so in case of an FTP backend, host/user/pass/etc. would be contained in 
	  a link. If the link is shared, be aware that you are giving this information
	  to the other users. 
	    
	OPTIONS
	  -s, --short
	    The generated syncany:// link will be shortened using the Syncany link
	    shortener service. This option stores the encrypted link on the Syncany
	    servers. The option does not work if the repository is not encrypted.
	    
	  -m, --machine-readable
	    Only prints the link and leaves out any explanatory text. Useful if the
	    link is used in a script.
	    
	COPYRIGHT
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel

.. _man_init:

sy init
^^^^^^^
::

	NAME
	  sy-init - intialize local directory and create remote Syncany repository
	
	SYNOPSIS
	  sy init [-P | --plugin=<plugin>] [-o | --plugin-option=<key=value>]
	          [-E | --no-encryption] [-G | --no-compression] [-s | --short]
	          [-t | --create-target] [-a | --advanced] [-n | --add-daemon]
	          [--password]
	
	DESCRIPTION
	  This command creates a new remote repository using the specified plugin, and
	  initializes the local directory. Unless -o is set, the command is
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
	    plugin defines different mandatory and optional settings. At least, all
	    mandatory settings must be specified by this option. All mandatory and
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
	
	  -n, --add-daemon
	    The initialized local folder is automatically added to the daemon
	    configuration for automatic synchronization if this option is used.
	    
	  -s, --short
	    The syncany:// link printed after the initialization will be shortened
	    using the Syncany link shortener service. This option stores the encrypted
	    link on the Syncany servers. The option does not work if -E is enabled.
	
	  --password=<password>
	    DO NOT USE THIS OPTION. Set the password used to encrypt the repository.
	    This option shouldn't be used, because the password might be visible to 
	    other users or be stored in history files.
	
	COPYRIGHT
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel

.. _man_log:

sy log
^^^^^^
::

	NAME
	  sy-log - shows recent changes
	   
	SYNOPSIS
	  sy log [-x | --exclude-empty] [-n | --database-count=<count>]
	         [-s | --database-start=<index>] [-f | --file-count=<count>] 
	  
	DESCRIPTION 
	  This command displays the recent changes to the repository, grouped
	  by the corresponding database versions.
	  
	  By default, the command will display the last 10 database versions
	  and their associated files. This default value can be changed by
	  the -n parameter. The per-database file count can be changed with the
	  -f option (default is 100). To hide potentially empty database versions,
	  the -x option can be used.  
	  
	OPTIONS
	  -n, --database-count=<count>
	    Adjusts the max. number of database versions to be returned and
	    displayed by this command. If this option is not set, max. 10 
	    database versions are displayed. To return all database versions,
	    set this option to -1. 
	    
	  -s, --database-start=<index>
	    Adjusts the start index of the databases to return. In combination
	    with -n, this option can be used for pagination. If -s is not given,
	    the first -n databases will be returned. The default for -s is 0.
	    
	  -f, --file-count=<count>
	    Adjusts the max. number of changed files per database version to be
	    returned and displayed by this command. If this option is not set,
	    max. 100 files are displayed. To return all files per database version,
	    set this option to -1.     
	  
	  -x, --exclude-empty       
	    Excludes empty database version from the result. If this option is
	    not given, empty databases will be listed as '(empty)'.      
	    
	COPYRIGHT
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel

.. _man_ls-remote:

sy ls-remote
^^^^^^^^^^^^
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
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel

.. _man_ls:

sy ls
^^^^^
::

	NAME
	  sy-ls - lists and filters the current and past file tree
	   
	SYNOPSIS
	  sy ls [-V | --versions] [-t | --types=<types>] [-D | --date=<date>]
	        [-r | --recursive] [-f | --full-checksums] [-g | --group]
	        [-H | --file-history] [-q | --deleted] [<path-expression>]
	  
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
	  ago or `sy ls -D2014-05-02` to select the file tree at May 2. (5) The -H
	  option can be used to select a specific file only. If the option is given,
	  the <path-expression> is interpreted as a file history identifier. (6) The
	  -q flag will display files that have been deleted from the file system.
	  
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
	        
	  -H, --file-history
	    If the option is given, the <path-expression> is interpreted as a file
	    history identifier. This option can be used to select one specific
	    file history. If -H is given, -V is automatically switched on.
	 
	  -r, --recursive
	    Not only selects the folder relative to the <path-expression>, but to all
	    sub trees of it.
	    
	  -q, --deleted
	    Also selects files that have been deleted from the file system, but are
	    still kept in the database. These files can be restored using the
	    `sy restore` command. By default, deleted files are not displayed.
	    
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
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel

.. _man_plugin:

sy plugin
^^^^^^^^^
::

	NAME
	  sy-plugin - list, install, update and remove Syncany plugins
	    
	SYNOPSIS
	  sy plugin list [-R | --remote-only] [-L | --local-only] [-s | --snapshots]
	                 [-a | --api-endpoint=<url>] [<plugin-id>]
	                 
	  sy plugin install [-s | --snapshot] [-m | --minimal-output] 
	                    (<URL> | <file> | <plugin-id>)
	
	  sy plugin update [<plugin-id>]
	  
	  sy plugin remove <plugin-id>
	            
	DESCRIPTION 
	  This command performs four different actions:
	  
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
	    
	  - It updates plugins by removing and re-installing them from the Syncany
	  host (if they are updatable). Plugins are updatable if they are out-of-date
	  and are not 'Global' plugins.
	
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
	      
	    -a, --api-endpoint=<url>
	      Selects the API endpoint to query for remote plugins. If not given,
	      the default endpoint URL will be used (https://api.syncany.org/v3).
	    
	  install [<args>] (<URL> | <file> | <plugin-id>) 
	    Installs a plugin from an arbitrary URL, local file or from the 
	    available plugins on api.syncany.org (with a plugin identifier).
	    
	    -s, --snapshot
	      Installs the daily snapshot instead of the release version. Only if
	      <plugin-id> is given. Not for <URL> or <file>.
	            
	    -m, --minimal-output
	      Reduces the output of the command to "OK" or "NOK" instead of reporting
	      detailed progress and download URLs.   
	
	  update [<plugin-id>]
	    Updates the plugin with the plugin identifier <plugin-id> or updates all
	    updatable plugins if no identifier is given. Plugins can only be updated
	    if they are newer than the installed version and if they are 'User'
	    plugins (and not 'Global' plugins). Plugins will be downloaded from
	    api.syncany.org.
	
	  remove <plugin-id>
	    Uninstalls a plugin entirely (removes the JAR file). This action can
	    only be used for plugins that were installed by the user, and not for
	    system-wide plugins.    
	
	COPYRIGHT
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel

.. _man_restore:

sy restore
^^^^^^^^^^
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
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel

.. _man_status:

sy status
^^^^^^^^^
::

	NAME
	  sy-status - list new and changed files in local Syncany folder
	    
	SYNOPSIS
	  sy status [-f | --force-checksum] [-D | --no-delete]
	  
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
	
	  -D, --no-delete
	    With this option, this command will not list locally deleted files. If
	    used with the 'up' command, these changes will not be uploaded.
	    
	COPYRIGHT
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel

.. _man_up:

sy up
^^^^^
::

	NAME
	  sy-up - uploads changes in local Syncany folder to remote repository
	   
	SYNOPSIS
	  sy up [-R | --no-resume] [<status-options>]
	  
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
	  
	  If this command is interrupted during the upload phase, it will try to resume
	  the upload unless -R is given. An interrupted upload can only be resumed if
	  the last 'up' failed and no 'down' or 'cleanup' has been done since then.
	  
	OPTIONS
	  -R, --no-resume
	    With this option, 'up' will not attempt to resume a locally stored
	    transaction. Without this option, an interrupted upload will be resumed.
	
	  All arguments of the 'status' command can be used.
	 
	COPYRIGHT
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel

.. _man_update:

sy update
^^^^^^^^^
::

	NAME
	  sy-update - Manages application updates
	    
	SYNOPSIS
	  sy update check [-s | --snapshots] [-a | --api-endpoint=<url>]                 
	            
	DESCRIPTION 
	  This command manages updates of the application. It currently only 
	  performs update checks, but will likely be extended to automatically
	  update the application. The following actions exist:
	  
	  - The 'check' action checks if a new application version is available. 
	  It queries the Syncany API and outputs whether the local copy of the
	  application is up-to-date. If it is not, it outputs the newest version
	  and a download URL.
	    
	ACIONS
	  check [<args>]
	    Checks with the Syncany API (api.syncany.org) for a new version.
	      
	    -s, --snapshots               
	      Instead of checking against application release versions (default),
	      the command will also include daily snapshots.
	      
	    -a, --api-endpoint=<url>
	      Selects the API endpoint to query against. If not given, the
	      default endpoint URL will be used (https://api.syncany.org/v3).            
	
	COPYRIGHT
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel

.. _man_watch:

sy watch
^^^^^^^^
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
	  Syncany 0.4.4-alpha, Distributed under GPLv3,
	  Copyright (c) 2011-2015 Philipp C. Heckel
