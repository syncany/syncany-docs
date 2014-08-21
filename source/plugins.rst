Plugins
=======
Plugins extend the Syncany functionality is different ways. As of today, there are two types of plugins:

- **Storage plugins** (also: connection / transfer plugins) give Syncany the ability to use a certain storage protocol or storage provider to store its repository files. Already implemented examples include FTP, SFTP, Samba or Amazon S3. 
- **Web interface plugins** implement a web frontend for Syncany. 

.. contents::
   :depth: 3

.. _plugins_manage:

Managing Plugins
----------------
The ``sy plugin`` command offers a very easy way to list available plugins (``sy plugin list``), install new plugins (``sy plugin install``) and remove already installed plugins (``sy plugin remove``). For a detailed command reference and examples, please refer to :ref:`command_plugin`.

When installing new plugins or listing available plugins, the plugin command accesses the **Syncany Plugin Repository**, a (still very small) repository in which all available Syncany plugins are registered and can be downloaded from. The repository API provides information about the the newest plugins, their versions and provides a download link where to get them. 

If, for instance, a user wants to install the SFTP plugin, calling ``sy plugin list`` will show a list of locally installed plugins, and remotely available plugins (queried through the plugin repository API):

::

	$ sy plugin list
	Id     | Name      | Local Version | Remote Version | Inst. | Upgr.
	-------+-----------+---------------+----------------+-------+------
	ftp    | FTP       |               | 0.1.0-alpha    |       | yes  
	local  | Local     | 0.1.2-alpha   |                | yes   |      
	s3     | Amazon S3 |               | 0.1.0-alpha    |       | yes  
	sftp   | SFTP      |               | 0.1.0-alpha    |       | yes  
	webdav | WebDAV    |               | 0.1.0-alpha    |       | yes  
	
Installing the plugin with ``sy plugin install sftp`` retrieves the download link (again, via the plugin repository API), downloads the plugin JAR file, verifies its checksum and installs it locally. After that, the plugin can be used:

::

	$ sy plugin install sftp
	Plugin successfully installed from https://www.syncany.org/dist/plugins/releases/webdav/syncany-plugin-sftp-0.1.0-alpha.jar
	Install location: /home/pheckel/.config/syncany/plugins/lib/syncany-plugin-sftp-0.1.0-alpha.jar
	...

Plugins are generally installed to the user specific Syncany plugin folder. On Windows, this folder can be found at ``%AppData%\Syncany\plugins\lib``, on Linux it can be found at ``~/.config/syncany/plugins/lib``. Installing a plugin is nothing more than placing the plugin JAR file in that folder. If you have trouble removing a plugin, simply delete it manually from that folder.
		
Plugin Configuration
--------------------
Some plugins store per-user config or persist some user-specific state. The SFTP plugin, for instance, stores the known hosts file for all the known and trusted hosts. Other plugins might want to store other information.

On Windows, this per-user plugin configuration can be found at ``%AppData%\Syncany\plugins\<plugin-id>\``, or at ``~/.config/syncany/plugins/<plugin-id>/`` on Linux. Depending on the plugin, the files in this folder may differ. 

Storage Plugins
---------------
Storage plugins are part of the core idea of Syncany: provide a simple interface to make any type of storage usable. This is done by keeping all of the synchronization logic, file size issues and even encryption out of the plugins. Storage plugins only take care of uploading different types of files -- database files, multichunk files, and so on. 

Once a storage plugin is installed (see :ref:`plugins_manage`), it can be used to create a new remote repository (``sy init``) or connect to an existing repository (``sy connect``). After you've successfully connected a local folder to a remote repository, you can synchronize files manually with ``sy up`` or ``sy down``, or configure the daemon to automatically sync the folder in the background.

Storage plugins typically need some connection information to connect to a remote server. The FTP plugin, for instance, needs to know the hostname of the server, its port, the username/password as well as a path/folder where to store the repository. This information, the **connection settings** is stored within the managed Syncany folder in ``.syncany/config.xml``. 

So if your Syncany folder is at ``C:\Users\Fabrice\Syncany``, you'll find the connection settings at ``C:\Users\Fabrice\Syncany\.syncany\config.xml``. Depending on the type of storage plugin, the contents of this file might be different. See below for examples of the ``config.xml`` file.

Local Plugin
^^^^^^^^^^^^
The local plugin (plugin identifier ``local``) is the only built-in storage plugin. It provides a way to use a local folder as repository for Syncany. That means that instead of connecting to a remote storage and storing the repository files remotely, Syncany will use the predefined folder to store them. While that sounds quite odd at first (*why would I want to sync to a local folder?*), it actually makes quite a lot of sense for a few cases:

* **Removable devices**: If you sync or backup to a removable device, you can use the local plugin to address the target folder on that device. For instance, you'd be specifying ``/mnt/backupdisk/office`` or ``E:\office`` as a target folder.
* **Virtual file systems**: Many storage systems can already be mounted as virtual file systems. NFS, Samba, Google Drive are just a few examples. If you used a mounted folder as target, you won't even need a special Samba or NFS plugin for Syncany, because the local plugin can be used.
* **Testing**: If you want to try out Syncany or test something, the local plugin is a very simple way to do that.

Options for ``config.xml``
""""""""""""""""""""""""""

+----------------------+------------+---------------+-----------------------------------------------------------+
| Plugin Option        | Mandatory  | Default Value | Description                                               |
+======================+============+===============+===========================================================+
| **path**             | yes        | *none*        | Local folder used to store repository files to.           |
+----------------------+------------+---------------+-----------------------------------------------------------+

Example ``config.xml``
""""""""""""""""""""""

.. code-block:: xml

	<config xmlns="http://syncany.org/config/1">
		...
		<connection type="local">
			<property name="path">/tmp/tx/c</property>
		</connection>
	</config>


Amazon S3 Plugin
^^^^^^^^^^^^^^^^
The Amazon S3 plugin (plugin identifier ``s3``) uses an Amazon S3 bucket to store the Syncany repository. `Amazon S3 (Simple Storage Service) <http://aws.amazon.com/s3/>`_ is an online file storage web service offered by Amazon Web Services. It's a pretty neat pay-as-you-go service and works very well with Syncany. If you've never tried it, you can get a `free account with 5 GB of storage <http://aws.amazon.com/free/>`_.

Options for ``config.xml``
""""""""""""""""""""""""""

+----------------------+------------+---------------+-----------------------------------------------------------+
| Plugin Option        | Mandatory  | Default Value | Description                                               |
+======================+============+===============+===========================================================+
| **accessKey**        | yes        | *none*        | Amazon AWS access key                                     |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **secretKey**        | yes        | *none*        | Amazon AWS secret key                                     |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **bucket**           | yes        | *none*        | Name of the bucket to use as repository                   |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **location**         | no         | us-west-1     | Location of the bucket (details see below)                |
+----------------------+------------+---------------+-----------------------------------------------------------+

The location of the bucket is any valid `Amazon AWS location <http://docs.aws.amazon.com/AmazonS3/latest/API/RESTBucketGETlocation.html>`_. As of today, valid Amazon region values are: 

* Europe: ``EU``, ``eu-west-1``
* United States: ``us-west-1``, ``us-west-2``, empty string (for the US Classic Region)
* Asia/Pacific: ``ap-southeast-1``, ``ap-southeast-2``, ``ap-northeast-1``
* Africa: ``sa-east-1``
 

Example ``config.xml``
""""""""""""""""""""""

.. code-block:: xml

	<config xmlns="http://syncany.org/config/1">
		...
		<connection type="s3">
			<property name="accessKey">AKIAIHIALEXANDREUIIE</property>
			<property name="secretKey">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</property>
			<property name="bucket">syncany-demo</property>
			<property name="location">us-west-1</property>
		</connection>
	</config>

FTP Plugin
^^^^^^^^^^


Options for ``config.xml``
""""""""""""""""""""""""""

+----------------------+------------+---------------+-----------------------------------------------------------+
| Plugin Option        | Mandatory  | Default Value | Description                                               |
+======================+============+===============+===========================================================+
| **hostname**         | yes        | *none*        | Hostname or IP address of the FTP server                  |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **username**         | yes        | *none*        | Username of the FTP user to use                           |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **password**         | yes        | *none*        | Password of the FTP user to use                           |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **path**             | yes        | *none*        | Path at which to store the repository                     |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **port**             | no         | 21            | Port of the FTP server                                    |
+----------------------+------------+---------------+-----------------------------------------------------------+

Example ``config.xml``
""""""""""""""""""""""

.. code-block:: xml

	<config xmlns="http://syncany.org/config/1">
		...
		<connection type="ftp">
			<property name="hostname">ftp.example.com</property>
			<property name="username">armin</property>
			<property name="password">cr0/ChRisTiAn</property>
			<property name="path">/syncany/repo2</property>
			<property name="port">21</property>
		</connection>
	</config>

SFTP Plugin
^^^^^^^^^^^

WebDAV Plugin
^^^^^^^^^^^^^

- HTTP or HTTPS


Options for ``config.xml``
""""""""""""""""""""""""""

+----------------------+------------+---------------+-----------------------------------------------------------+
| Plugin Option        | Mandatory  | Default Value | Description                                               |
+======================+============+===============+===========================================================+
| **url**              | yes        | *none*        | Hostname or IP address of the WebDAV server               |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **username**         | yes        | *none*        | Username of the WebDAV user (basic auth)                  |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **password**         | yes        | *none*        | Password of the WebDAV user (basic auth)                  |
+----------------------+------------+---------------+-----------------------------------------------------------+

Example ``config.xml``
""""""""""""""""""""""

.. code-block:: xml

	<config xmlns="http://syncany.org/config/1">
		...
		<connection type="ftp">
			<property name="url">https://dav.example.com:8080/dav/repo1</property>
			<property name="username">christof</property>
			<property name="password">ZAzZZzFL0R1An</property>
		</connection>
	</config>

Samba Plugin
^^^^^^^^^^^^

Options for ``config.xml``
""""""""""""""""""""""""""

+----------------------+------------+---------------+-----------------------------------------------------------+
| Plugin Option        | Mandatory  | Default Value | Description                                               |
+======================+============+===============+===========================================================+
| **hostname**         | yes        | *none*        | Hostname or IP address of the Samba server                |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **username**         | yes        | *none*        | Username of the Samba user                                |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **password**         | yes        | *none*        | Password of the samba user                                |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **share**            | yes        | *none*        | Name of the Samba share                                   |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **path**             | no         | /             | Sub path of the Samba share                               |
+----------------------+------------+---------------+-----------------------------------------------------------+

Example ``config.xml``
""""""""""""""""""""""

.. code-block:: xml

	<config xmlns="http://syncany.org/config/1">
		...
		<connection type="samba">
			<property name="hostname">ftp.example.com</property>
			<property name="username">Vincent</property>
			<property name="password">ZuUaI/kt3k!</property>
			<property name="share">Pictures</property>
			<property name="path">2014\Germany</property>
		</connection>
	</config>


Web Interface Plugins
---------------------

If installed, the web interface can be accessed at https://localhost:8443 (default configuration).
See :ref:`configuration_daemon`.

Simple Web Interface Plugin
^^^^^^^^^^^^^^^^^^^^^^^^^^^
