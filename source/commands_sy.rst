The ``sy`` command
------------------
The ``sy`` command is not just a single command, but instead offers a variety of actions to manage a Syncany folder. In general, it can be called by ``sy <action> [args]``, where ``action`` is any of the available sub-commands and ``args`` is a list of optional global or sub-command specific options.

Available sub-commands:

- ``init``: Initialize the current folder as a Syncany folder.
- ``connect``: Connect the current folder to an existing Syncany repository.
- ``status``: Detect local changes and print to STDOUT.
- ``up``: Detect local changes and upload to repository.
- ``ls-remote``: Detect remote changes and print to STDOUT.
- ``down``: Detect remote changes and apply locally.
- ``watch``: Automatically synchronizes the local folder with the repo.
- ``cleanup``: Remove old versions from the local database and the repo.
- ``restore``: Restore the given file paths from the remote repository.
- ``genlink``: Create a syncany:// link from an existing local folder.
- ``ls``: Print parts of the local database to STDOUT.
- ``plugin``: List, install and remove storage backend plugins.


Command scope:
- Within a managed folder
- Outside of a managed folder
