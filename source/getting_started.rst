Getting Started
===============

Usage is pretty similar to a version control system. If you have used Git or
SVN, it should feel a lot alike.


Choose and install a storage plugin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

First choose the storage backend you'd like to use by doing `sy plugin list` and then `sy plugin install`. As of today, we've implemented plugins for [FTP](https://github.com/syncany/syncany-plugin-ftp), [SFTP](https://github.com/syncany/syncany-plugin-sftp), [WebDAV](https://github.com/syncany/syncany-plugin-webdav), [Amazon S3](https://github.com/syncany/syncany-plugin-s3) and [Samba](https://github.com/syncany/syncany-plugin-samba). For this example, we'll install the FTP plugin:

::

	$ sy plugin install ftp


Initialize a local directory
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	$ sy init
	Choose a storage plugin. Available plugins are: ftp, local, webdav, s3, sftp
	Plugin: ftp

	Connection details for FTP connection:
	- Hostname: example.com
	- Username: ftpuser
	- Password (not displayed): 
	- Path: repo-folder
	- Port (optional, default is 21): 

	Password (min. 10 chars): (user enters repo password)
	Confirm: (user repeats repo password)

	Repository created, and local folder initialized. To share the same repository
	with others, you can share this link: syncany://storage/1/csbxyS6AA+bSK7OxbOxYQXyeouMeoU...
        
This sets up a new repository on the given remote storage and initializes the
local folder. You can now use `sy connect` to connect to this repository
from other clients.

Manually syncing files
^^^^^^^^^^^^^^^^^^^^^^
You can also manually trigger the upload of your local files or the download of remote changes:

::

	$ sy up
	$ sy down
	
Automatically syncing files 
^^^^^^^^^^^^^^^^^^^^^^^^^^^

To let Syncany do everything automatically, simple use the `sy watch` command. 
This command will synchronize your local files. 

::

	$ sy watch 
	

Connect other clients 
^^^^^^^^^^^^^^^^^^^^^

To connect new clients to an existing repository, use the `sy connect` command.
This will set up your local folder to sync with the chosen remote repository.

::

	$ sy connect syncany://storage/1/csbxyS6AA+bSK7OxbOxYQXyeouMeoU...

	Password: (user enters repo password)

	Repository connected, and local folder initialized.
	You can now use the 'syncany' command to sync your files.


