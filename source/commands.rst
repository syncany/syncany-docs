Commands
========
The Syncany command line client (CLI) comes with one single main command: ``sy`` (or: ``syncany``). This command is the central tool to perform all of the Syncany actions, e.g. creating a new managed folder, syncing files, or restoring them. It also offers a way start and stop the Syncany user daemon, which will then run Syncany in the background. 

.. contents::
   :depth: 2
   
The ``sy`` command
------------------
The ``sy`` command is not just a single command, but instead offers a variety of actions to manage a Syncany folder. In general, it can be called by ``sy <action> [args]``, where ``action`` is any of the available sub-commands and ``args`` is a list of optional global or sub-command specific options.

Available sub-commands:

- ``init``: Initialize the current folder as a Syncany folder
- ``connect``: Connect the current folder to an existing Syncany repository
- ``status``: List new and changed files in local Syncany folder
- ``up``: Detect local changes and upload to repository
- ``ls-remote``: List changes on remote repository
- ``down``: Detect remote changes and apply locally
- ``watch``: Automatically synchronizes the local folder with the repo
- ``cleanup``: Remove old versions from the local database and the repo
- ``restore``: Restore the given file paths from the remote repository
- ``genlink``: Create a syncany:// link from an existing local folder
- ``ls``: Lists and filters the current and past file tree
- ``plugin``: List, install and remove storage backend plugins
- ``daemon``: Start and stop the background process (daemon)

Because the ``init`` and ``connect`` command initialize the current folder to a Syncany folder, they cannot be executed inside an already initialized Syncany folder. Most of the other commands behave exactly opposite to that: The commands ``status``, ``up``, ``ls-remote``, ``down``, ``watch``, ``cleanup``, ``restore``, ``genlink`` and ``ls`` can only be execute inside an initialized Syncany folder. The only command that doesn't care where it's executed is the ``plugin`` command.

For a detailed command reference including all command-specific options, please refer to the manual page of this command at :ref:`man_sy`.

`daemon``: Start and stop the background process (daemon)
---------------------------------------------------------
This command manages the Syncany background process (starts, stops, etc.), also called the Syncany daemon. The command itself only offers the typical start/stop-script sub-commands, namely:

- ``start``: Starts the Syncany background process (daemon), if it's not already running
- ``stop``: Stop the Syncany daemon (if it is running)
- ``status``: Displays whether the daemon is running and if it is, its PID
- ``restart``: Restarts the daemon process by calling ``stop``, then ``start`` (Linux only)
- ``reload``: Reloads the daemon configuration (``daemon.xml``) without restarting the daemon (Linux only)
- ``force-stop``: Kills the Syncany daemon; can be used if ``stop`` doesn't respond (Linux only)

The Syncany daemon is a user-level daemon. That means that it does not run as system service, but rather that each user may have its own daemon process running and that the daemon config is user-specific. The daemon configuration can be found at ``%AppData%\Syncany\daemon.xml`` (Windows) or at ``~/.config/syncany/daemon.xml`` (Linux). 

Example: Starting and stopping the daemon
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy daemon start
	Starting daemon: .. syncanyd (pid 16336).

	$ sy daemon status
	Checking daemon: syncanyd running (pid 16336).

	$ sy daemon stop
	Stopping daemon: .. syncanyd.

.. _command_init:

``sy init``: Initializing a repository
--------------------------------------
This command creates a new remote repository using the specified plugin, and
initializes the local directory. Unless -I is set, the command is
interactive and queries the user for input. Depending on the chosen plugin chosen (with -P or interactively), different plugin-specific options are required or optional.

Once the 'init' command was successfully executed, the initialized local
folder can be synced with the newly created repository. The commands
'up', 'down', 'watch', etc. can be used. Other clients can then be connected
using the 'connect' command.

For a detailed command reference including all command-specific options, please refer to the manual page of this command at :ref:`man_init`.

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
	
	   syncany://storage/1/y8aqJUCsXqPtH9Ku+aoAKAKO0vccIUH32k/tPRCineNLLc...
	
	This link is encrypted with the given password, so you can safely share it.
	using unsecure communication (chat, e-mail, etc.)
	
	WARNING: The link contains the details of your repo connection which typically
	         consist of usernames/password of the connection (e.g. FTP user/pass).
	
Example 2: Create new repository (with prefilled settings) 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy init --plugin=s3 -o accessKey=AKIAJL7... -o secretKey=... \
	                      -o bucket=syncanytest3 -o location=EU
	...

.. _command_connect:

``sy connect``: Connecting to an existing repository
----------------------------------------------------
This command connects to an existing remote repository and initializes
the local directory. The command can be called as follows:

1. Using a syncany://-link generated by either 'init' or 'genlink',
the command connects to the repository given in the link. If the link
is encrypted, the link/repo password must be entered.

2. If no link is given, the command acts like 'init', i.e. it queries the
user for storage plugin and connection details of the repository to 
connect to.

Once the repository is connected, the initialized local folder can be synced
with the newly created repository. The commands 'up', 'down', 'watch', etc.
can be used. Other clients can then be connected using the 'connect' command.

For a detailed command reference including all command-specific options, please refer to the manual page of this command at :ref:`man_connect`.

Example 1: Connect to an existing repository (with a syncany://-link)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	sy connect syncany://storage/1/y8aqJUCsXqPtH9Ku+aoAKAKO0vcc...
	
	Password: (user enters password)
	
	Creating master key from password (this might take a while) ...
	
	Repository connected, and local folder initialized.
	You can now use the 'syncany' command to sync your files.

Example 2: Connect to an existing repository (interactive)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy connect
	Choose a storage plugin. Available plugins are: local, s3, webdav
	Plugin: local
	
	Connection details for Local connection:
	- Local Folder: /tmp/x
	
	Password: (user enters password)
	
	Creating master key from password (this might take a while) ...
	
	Repository connected, and local folder initialized.
	You can now use the 'syncany' command to sync your files.

Example 3: Connect to an existing repository (with prefilled settings) 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	sy connect --plugin=webdav --plugin-option=url=http://dav.example.com/repo1 \
	           --plugin-option=username=pheckel --plugin-option=password=<somepass>
	
	Password: (user enters password)
	
	Creating master key from password (this might take a while) ...
	
	Repository connected, and local folder initialized.
	You can now use the 'syncany' command to sync your files.
	
.. _command_status:	
	
``sy status``: Detect and display local changes
-----------------------------------------------
This command compares the local file tree on the disk with the local
database and detects local changes. These changes are printed to the
console.

Local changes are detected using the last modified date and the file size
of a file. If they match the local database, the command assumes that the
content has not changed (no checksum comparison). If -f is enabled, the
checksum is additionally compared.

This command is used by the 'up' command to detect local changes. 

For a detailed command reference including all command-specific options, please refer to the manual page of this command at :ref:`man_status`.

Example 1: Basic usage (display new/changed file content)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ echo "new file content" > newfile.txt
	$ echo "changed content" > testfile.txt 
	$ sy status
	? newfile.txt
	M testfile.txt

Example 2: Force checksum calculation per in 'status'
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Forcing checksum calculation means that we don't want to rely on last modified date and size. If size and last modified date are equal, changes in local files will not be detected unless ``--force-checksum`` is set.

Create a file ``one-thousand.txt`` containing ``1000``, and setting the last modified date to a specific date:

::

	$ echo 1000 > one-thousand.txt 
	$ touch --date="Sun, 27 Apr 2014 11:11:11 +0200" one-thousand.txt
	$ sy up
	A one-thousand.txt
	Sync up finished.

Now we change the ``one-thousand.txt`` file, but change the timestamp back to the same date as before:

::

	$ echo 9999 > one-thousand.txt 
	$ touch --date="Sun, 27 Apr 2014 11:11:11 +0200" one-thousand.txt

As you can see below, the regular `sy status` command does not detect the changes. The command with the ``--force-checksum`` detects the changes:

::

	$ sy status
	No local changes.
	$ sy status --force-checksum
	M one-thousand.txt
	
.. _command_up:		
	
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

For a detailed command reference including all command-specific options, please refer to the manual page of this command at :ref:`man_up`.

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
	
.. _command_ls_remote:
	
``sy ls-remote``: Detect and display remote changes
---------------------------------------------------
This command detects changes in the local folder, indexes new files and
uploads changes to the remote repository. If there are local changes, the
command determines what has changed, packages these changes in new
multichunks, and uploads them to the remote storage alongside with a delta
metadata database. 

To determine the local changes, the 'status' command is used. All options
of the 'status' command can also be used in this command.

If there are no local changes, the 'up' command will not upload anything -
no multichunks and no metadata.

For a detailed command reference including all command-specific options, please refer to the manual page of this command at :ref:`man_ls_remote`.

Example: Using the ls-remote command
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy ls-remote
	? db-2kjuahomsfgjmpft-0000000002
	
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

For a detailed command reference including all command-specific options, please refer to the manual page of this command at :ref:`man_down`.

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

.. _command_watch:

``sy watch``: Automatically synchronizes the local folder with the repo
-----------------------------------------------------------------------
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

For a detailed command reference including all command-specific options, please refer to the manual page of this command at :ref:`man_watch`.

Example: Automatically syncing a folder with ``sy watch``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The ``watch`` command is a blocking command. That means when it is run, the command will not run in the background. If you desire the folder to be synced in the background, use the Syncany daemon. Details at :ref:`overview_daemon`.

::

	$ cd ~/Syncany
	$ sy watch
	   (This command blocks, use the daemon if you don't want this to happen)

.. _command_cleanup:

``sy cleanup``: Remove old versions from the local database and the repo
------------------------------------------------------------------------
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

For a detailed command reference including all command-specific options, please refer to the manual page of this command at :ref:`man_cleanup`.

Example 1: Default cleanup
^^^^^^^^^^^^^^^^^^^^^^^^^^
The default cleanup command can be run manually, or triggered automatically if run in daemon mode. It'll delete old multichunks, shorten file histories and thereby free up space on the offsite storage.

::

	$ sy cleanup 
	15 database files merged.
	8 multichunk(s) deleted on remote storage (freed 12.91 MB)
	19 file histories shortened.
	Cleanup successful.

Example 2: Shorten file histories to one version
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Syncany stores multiple file versions for each file (default is 5). If ``sy cleanup`` is run without any options, it will still keep the last 5 versions unless ``--keep-versions=N`` is given, where ``N`` is the number of versions to keep. If you've run cleanup in the last 6 hours, you'll need to also apply ``--force``.

::

	$ echo version1 > file
	$ sy up
	A file
	Sync up finished.

	$ echo version2 > file
	$ sy up
	M file
	Sync up finished.

	$ sy cleanup --keep-versions=1 --force
	3 database files merged.
	1 multichunk(s) deleted on remote storage (freed 0.00 MB)
	1 file histories shortened.
	Cleanup successful.

.. _command_restore:

``sy restore``: Restore older versions of files from the repository
-------------------------------------------------------------------
This command restores old or deleted files from the remote storage.

As long as a file is known to the local database and the corresponding
chunks are available on the remote storage, it can be restored using this
command. The command downloads the required chunks and assembles the file.

If no target revision is given with -r, the last version is restored. To
select a revision to restore, the `sy ls` command can be used. 

For a detailed command reference including all command-specific options, please refer to the manual page of this command at :ref:`man_restore`.

Example 1: Restoring a previous version of a file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ echo version1 > somefile
	$ sy up
	A somefile
	Sync up finished.

	$ echo version2 > somefile
	$ sy up
	M somefile
	Sync up finished.

	$ sy ls --versions somefile
	14-08-23 13:11:11    rw-r--r-- --a- 9     FILE bce8ce9ce1 69101d4e4d 1 somefile
	14-08-23 13:11:22    rw-r--r-- --a- 9     FILE 48a2c49dd8 69101d4e4d 2 somefile

	$ sy restore --revision=1 69101d4e4d
	File restored to /tmp/ssh/a/somefile (restored version 1)

	$ cat "somefile (restored version 1)"
	version1

Example 2: Restoring a deleted file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::
	
	$ rm somefile
	$ sy up
	D somefile
	Sync up finished.

	$ sy restore --revision=2 69101d4e4d
	File restored to somefile (restored version 2)
	
	$ cat "somefile (restored version 2)"
	version2

.. _command_ls:

``sy ls``: Display current and historic local database
------------------------------------------------------
This command lists and filters the file tree based on the local database.
The file tree selection can be performed using the following selection
criteria:
 
1. Using the <path-expression>, one can select a file pattern (such as
`*.txt`) or sub tree (such as ``subfolder/``, only with -r). 

2. Using -r, the command does not only list the folder relative to the
<path-expression>, but to all sub trees of it. 

3. The -t option limits the result set to a certain file type ('f' for files,
'd' for directories, and 's' for symlinks). Types can be combined, e.g. 
``sy ls -tfs`` selects files and symlinks.

4. The -D option selects the date/time at which to select the file tree,
e.g. ``sy ls -D20m`` to select the file tree 20 minutes ago or 
``sy ls -D2014-05-02`` to select the file tree at May 2.

For a detailed command reference including all command-specific options, please refer to the manual page of this command at :ref:`man_ls`.

Example 1: Create new repository (interactive mode)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy ls
	14-07-23 22:54:07    rw-r--r--      2174138     FILE 941494aa52 3910ca5c8a 1 140628161200_IMG_3575.jpg
	14-07-23 09:08:08    rwxr-xr-x         4096   FOLDER            6ba412f98b 1 Code
	14-07-23 22:45:58    rwxr-xr-x         4096   FOLDER            9027a43b2b 1 Pictures
	14-07-23 22:54:07    rwxr-xr-x         4096   FOLDER            08319c3f16 1 Untitled Folder
	14-07-23 21:10:05    rwxr-xr-x         4096   FOLDER            6215d124dd 1 repeatedly_compiling_test
	14-07-23 22:12:11    rw-r--r--          353     FILE 3a0a1ccbba faebf2beb1 1 userconfig.xml

Example 2: Listing a specific subtree (as per database)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy ls Code/
	14-07-23 09:08:08    rwxr-xr-x      4096   FOLDER            4b25720447 1 Code/fanout

Example 3: Listing all directories, recursively
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy ls --recursive --types=d
	14-07-23 09:08:08    rwxr-xr-x      4096   FOLDER            6ba412f98b 1 Code
	14-07-23 09:08:08    rwxr-xr-x      4096   FOLDER            4b25720447 1 Code/fanout
	14-07-23 09:08:08    rwxr-xr-x      4096   FOLDER            7adc2e20c5 1 Code/fanout/fanout
	14-07-23 09:08:08    rwxr-xr-x      4096   FOLDER            98f8df9aec 1 Code/fanout/fanout/debian
	14-07-23 09:08:08    rwxr-xr-x      4096   FOLDER            09fe5113f1 1 Code/fanout/fanout/debian/source
	14-07-23 22:45:58    rwxr-xr-x      4096   FOLDER            9027a43b2b 1 Pictures
	14-07-23 22:54:07    rwxr-xr-x      4096   FOLDER            08319c3f16 1 Untitled Folder
	14-07-23 21:10:05    rwxr-xr-x      4096   FOLDER            6215d124dd 1 repeatedly_compiling_test
	14-07-23 21:10:05    rwxr-xr-x      4096   FOLDER            fc5a5966bb 1 repeatedly_compiling_test/scriptie

Example 4: Listing all versions of all PDF files in a certain folder
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy ls --versions --group repeatedly_compiling_test/scriptie/^.pdf
	File 33b1042a91, repeatedly_compiling_test/scriptie/Scriptie.pdf
	   14-07-23 10:28:25    rw-r--r--      273966     FILE a1d3b30444 33b1042a91 1 repeatedly_compiling_test/scriptie/Scriptie.pdf
	   14-07-23 18:48:19    rw-r--r--      273966     FILE a1d3b30444 33b1042a91 2 Code/repeatedly_compiling_test/scriptie/Scriptie.pdf
	 * 14-07-23 21:10:05    rw-r--r--      273966     FILE a1d3b30444 33b1042a91 3 repeatedly_compiling_test/scriptie/Scriptie.pdf

	File 593a67cd5e, repeatedly_compiling_test/scriptie/VoorlopigeScriptie.pdf
	   14-07-23 10:28:25    rw-r--r--      247367     FILE 4b66adf265 593a67cd5e 1 repeatedly_compiling_test/scriptie/VoorlopigeScriptie.pdf
	   14-07-23 18:48:19    rw-r--r--      247367     FILE 4b66adf265 593a67cd5e 2 Code/repeatedly_compiling_test/scriptie/VoorlopigeScriptie.pdf
	 * 14-07-23 21:10:05    rw-r--r--      247367     FILE 4b66adf265 593a67cd5e 3 repeatedly_compiling_test/scriptie/VoorlopigeScriptie.pdf


Example 5: Listing all PDF files at a certain time
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy ls --date='14-07-23 18:48:20' --recursive ^.pdf
	14-07-23 18:48:19    rw-r--r--      273966     FILE a1d3b30444 33b1042a91 2 Code/repeatedly_compiling_test/scriptie/Scriptie.pdf
	14-07-23 18:48:19    rw-r--r--      247367     FILE 4b66adf265 593a67cd5e 2 Code/repeatedly_compiling_test/scriptie/VoorlopigeScriptie.pdf

.. _command_genlink:

``sy genlink``: Create a syncany:// link from an existing local folder
----------------------------------------------------------------------
This command creates a Syncany link (syncany://..) from an existing local
folder. The link can then be sent to someone else to connect to the
repository.

Syncany links contain the connection information of the storage backend,
so in case of an FTP backend, host/user/pass/etc. would be contained in
a link. If the link is shared, be aware that you are giving this information
to the other users.

For a detailed command reference including all command-specific options, please refer to the manual page of this command at :ref:`man_genlink`.

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

Example 2: Short output (for scripts)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy genlink --short
	syncany://storage/1/IOl4XYsdjHRazvUJCB4GPOSA+/CDhpE8o...


.. _command_plugin:

``sy plugin``: List, install and remove storage backend plugins
---------------------------------------------------------------

This command performs three different actions: It lists the locally installed and remotely available plugins, including version information and whether plugins can be upgraded. It installs new plugins from either a given URL or a local file. It removes locally installed plugins from the user's local plugin directory. 

For a detailed command reference including all command-specific options, please refer to the manual page of this command at :ref:`man_plugin`. For a detailed explanations of plugins, refer to the chapter :doc:`plugins`.

Example 1: List all available plugins
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

List only released plugins (no snapshots):

::

	$ sy plugin list
	Id     | Name      | Local Version | Remote Version | Inst. | Upgr.
	-------+-----------+---------------+----------------+-------+------
	ftp    | FTP       |               | 0.1.0-alpha    |       | yes  
	local  | Local     | 0.1.2-alpha   |                | yes   |      
	s3     | Amazon S3 |               | 0.1.0-alpha    |       | yes  
	sftp   | SFTP      |               | 0.1.0-alpha    |       | yes  
	webdav | WebDAV    |               | 0.1.0-alpha    |       | yes  

List released plugins and snapshots:

::

	$ sy plugin list --snapshots
	Id     | Name      | Local Version                              | Remote Version                             | Inst. | Upgr.
	-------+-----------+--------------------------------------------+--------------------------------------------+-------+------
	ftp    | FTP       |                                            | 0.1.0+SNAPSHOT.1404181428.git1a14769       |       | yes  
	local  | Local     | 0.1.2-alpha+SNAPSHOT.1404200229.gitadd2848 |                                            | yes   |      
	s3     | Amazon S3 | 0.1.0+SNAPSHOT.1404182252.git78f0f1a       | 0.1.0+SNAPSHOT.1404182149.gitb7b2918       | yes   |      
	sftp   | SFTP      |                                            | 0.1.0-alpha+SNAPSHOT.1404191549.git10ae8b7 |       | yes  
	webdav | WebDAV    | 0.1.0-alpha+SNAPSHOT.1404200235.git79d610f | 0.1.0-alpha+SNAPSHOT.1404192343.git93fdc0b | yes   | yes  

Example 2: Install an available plugin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install plugin (release version):

::

	$ sy plugin install webdav
	Plugin successfully installed from https://www.syncany.org/dist/plugins/releases/webdav/syncany-plugin-webdav-0.1.0-alpha.jar
	Install location: /home/pheckel/.config/syncany/plugins/syncany-plugin-webdav-0.1.0-alpha.jar

	Plugin details:
	- ID: webdav
	- Name: WebDAV
	- Version: 0.1.0-alpha

Install latest snapshot of a plugin:

::

	$ sy plugin install sftp --snapshot
	Plugin successfully installed from https://www.syncany.org/dist/plugins/snapshots/sftp/syncany-plugin-sftp-0.1.0-alpha+SNAPSHOT.1404191549.git10ae8b7.jar
	Install location: /home/pheckel/.config/syncany/plugins/syncany-plugin-sftp-0.1.0-alpha+SNAPSHOT.1404191549.git10ae8b7.jar

	Plugin details:
	- ID: sftp
	- Name: SFTP
	- Version: 0.1.0-alpha+SNAPSHOT.1404191549.git10ae8b7


Example 3: Remove installed plugin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy plugin remove sftp
	Plugin successfully removed.
	Original local was /home/pheckel/.config/syncany/plugins/syncany-plugin-sftp-0.1.0-alpha+SNAPSHOT.1404191549.git10ae8b7.jar

