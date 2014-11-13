Plugins
=======
Plugins extend the Syncany functionality is different ways. As of today, there are two types of plugins:

- **Storage plugins** (also: connection / transfer plugins) give Syncany the ability to use a certain storage protocol or storage provider to store its repository files. Already implemented examples include FTP, SFTP, Samba or Amazon S3. 
- **Web interface plugins** implement a web frontend for Syncany. 

.. contents::
   :depth: 3

About Plugins
-------------

.. _plugins_manage:

Installing and Removing Plugins
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
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
^^^^^^^^^^^^^^^^^^^^
Some plugins store per-user config or persist some user-specific state. The SFTP plugin, for instance, stores the known hosts file for all the known and trusted hosts. Other plugins might want to store other information.

On Windows, this per-user plugin configuration can be found at ``%AppData%\Syncany\plugins\userdata\<plugin-id>\``, or at ``~/.config/syncany/plugins/userdata/<plugin-id>/`` on Linux. Depending on the plugin, the files in this folder may differ. 
		
.. _plugins_storage:		
		
Storage Plugins
---------------
Storage plugins are part of the core idea of Syncany: provide a simple interface to make any type of storage usable. This is done by keeping all of the synchronization logic, file size issues and even encryption out of the plugins. Storage plugins only take care of uploading different types of files -- database files, multichunk files, and so on. 

Once a storage plugin is installed (see :ref:`plugins_manage`), it can be used to create a new remote repository (``sy init``) or connect to an existing repository (``sy connect``). After you've successfully connected a local folder to a remote repository, you can synchronize files manually with ``sy up`` or ``sy down``, or configure the daemon to automatically sync the folder in the background.

Storage plugins typically need some connection information to connect to a remote server. The FTP plugin, for instance, needs to know the hostname of the server, its port, the username/password as well as a path/folder where to store the repository. This information, the **connection settings** is stored within the managed Syncany folder in ``.syncany/config.xml``. 

So if your Syncany folder is at ``C:\Users\Fabrice\Syncany``, you'll find the connection settings at ``C:\Users\Fabrice\Syncany\.syncany\config.xml``. Depending on the type of storage plugin, the contents of this file might be different. See below for examples of the ``config.xml`` file.

For other users to connect to a repository, you can either provide them with these storage credentials (e.g. FTP username/password, AWS credentials, etc.), or you can share a ``syncany://`` link (see :ref:`command_genlink`).

.. warning::
	Users sharing a repository typically access that repository **using the same storage credentials**. Be aware that sharing a ``syncany://`` link and the repository password with other users also means giving away these storage credentials. **Only share a repository with people you trust with these credentials!**

Local Plugin
^^^^^^^^^^^^
The local plugin (plugin identifier ``local``) is the only built-in storage plugin. It provides a way to use a local folder as repository for Syncany. That means that instead of connecting to a remote storage and storing the repository files remotely, Syncany will use the predefined folder to store them. While that sounds quite odd at first (*why would I want to sync to a local folder?*), it actually makes quite a lot of sense for a few cases:

* **Removable devices**: If you sync or backup to a removable device, you can use the local plugin to address the target folder on that device. For instance, you'd be specifying ``/mnt/backupdisk/office`` or ``E:\office`` as a target folder.
* **Virtual file systems**: Many storage systems can already be mounted as virtual file systems. NFS, Samba, Google Drive are just a few examples. If you used a mounted folder as target, you won't even need a special Samba or NFS plugin for Syncany, because the local plugin can be used.
* **Testing**: If you want to try out Syncany or test something, the local plugin is a very simple way to do that.

Plugin Security
"""""""""""""""
Syncany assumes that the local machine is secure, so if a regular local folder (removable device or hard disk) is used, there are no security remarkds regarding this plugin. If, however, the target repository folder points to a mounted a virtual file system, it depends on the underlying protocol if/how vulnerable the system is. 

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
			<path>/tmp/tx/c</path>
		</connection>
	</config>

Amazon S3 Plugin
^^^^^^^^^^^^^^^^
The Amazon S3 plugin (plugin identifier ``s3``) uses an Amazon S3 bucket to store the Syncany repository. `Amazon S3 (Simple Storage Service) <http://aws.amazon.com/s3/>`_ is an online file storage web service offered by Amazon Web Services. It's a pretty neat pay-as-you-go service and works very well with Syncany. If you've never tried it, you can get a `free account with 5 GB of storage <http://aws.amazon.com/free/>`_. As of today, the plugin only supports one repository per bucket. It cannot use sub paths of a bucket as repository. 

The plugin is not installed by default, but it can be easily installed using the ``sy plugin install`` command. For details about how to use this command, refer to the command reference at :ref:`command_plugin`.

Plugin Security
"""""""""""""""
The plugin uses the `JetS3t Amazon S3 library <http://www.jets3t.org/>`_ to access the S3 buckets. All communication is HTTPS-only, so access credentials are protected in transit. Since the actual data is encrypted before upload, data confidentiality is not an issue either.

If the Amazon S3 plugin is used, users sharing a repository typically access that repository (i.e. the S3 bucket) **using the same AWS access key and secret key**. Be aware that sharing a ``syncany://`` link and the repository password with other users also means giving away these storage credentials. Only share a repository with people you trust with these credentials.

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
			<accessKey>AKIAIHIALEXANDREUIIE</accessKey>
			<secretKey>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</secretKey>
			<bucket>syncany-demo</bucket>
			<location">us-west-1</location>
		</connection>
	</config>

FTP Plugin
^^^^^^^^^^
The FTP plugin (plugin identifier ``ftp``) uses a single folder on an FTP server as repository. Since only a sub-folder is used, multiple repositories per FTP server are possible. 

The plugin is not installed by default, but it can be easily installed using the ``sy plugin install`` command. For details about how to use this command, refer to the command reference at :ref:`command_plugin`.

Plugin Security
"""""""""""""""
As of today, the FTP plugin does not support FTPS (the TLS extension for FTP). That means that the FTP plugin **does not provide transport security** and FTP credentials might by read by an adversary (man-in-the-middle attack). Since Syncany itself takes care of encrypting the files before they are uploaded, the **confidentiality of your data is not at risk**. However, be aware that this still means that an attacker might get access to your FTP account and simply delete all of your files.

If the FTP plugin is used, users sharing a repository typically access that repository **using the same FTP username/password combination**. Be aware that sharing a ``syncany://`` link and the repository password with other users also means giving away these storage credentials. Only share a repository with people you trust with these credentials.

Options for ``config.xml``
""""""""""""""""""""""""""

+----------------------+------------+---------------+-----------------------------------------------------------+
| Plugin Option        | Mandatory  | Default Value | Description                                               |
+======================+============+===============+===========================================================+
| **hostname**         | yes        | *none*        | Hostname or IP address of the FTP server                  |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **username**         | yes        | *none*        | Username of the FTP user                                  |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **password**         | yes        | *none*        | Password of the FTP user                                  |
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
			<hostname>ftp.example.com</hostname>
			<username>armin</username>
			<password>cr0/ChRisTiAn</password>
			<path>/syncany/repo2</path>
			<port>21</port>
		</connection>
	</config>

SFTP Plugin
^^^^^^^^^^^
The SFTP plugin (plugin identifier ``sftp``) uses a single folder on an SSH/SFTP server as repository. Since only a sub-folder is used, multiple repositories per SFTP server are possible. The plugin supports username/password-based authentication as well as public key based authentication:

* **Password-based authentication:** To use the password-based auth mechanism, a valid SSH user must exist. Initializing a new repository (or connecting to an existing one) is pretty straight forward: Just enter username and password, leave public key related properties empty, and you're good.
* **Public key based authentication:** To authenticate at the SSH/SFTP server using public key authentication, the public key of the local machine must be present in the remote server's authorized keys (use ``ssh-copy-id`` to copy over your public key). If that is the case, the ``password`` setting is interpreted as the private key's password. 

If public key authentication is used, the first time you'll connect to a server, you'll be asked to verify the authenticity of the key fingerprint. If you have verified the key, Syncany will store the key at ``~/.config/syncany/plugins/userdata/sftp/known_hosts`` (Linux) or ``%AppData%\Syncany\plugins\userdata\sftp\known_hosts`` (Windows):

::

	SSH/SFTP Confirmation
	---------------------
	The authenticity of host 'example.com' can't be established.
	RSA key fingerprint is b0:48:b7:9d:a5:56:a6:e5:5a:49:94:29:5e:73:e4:95.
	Are you sure you want to continue connecting?	
	
Note that if public key authentication is used, ``syncany://`` links **will not work**, because the private key isn't (and should not be) part of the link itself. Syncany will generate a link, but it won't work, unless the the public key of the other user/machine is available at the same path and was also copied to the authorized keys at the SSH/SFTP server.

The plugin is not installed by default, but it can be easily installed using the ``sy plugin install`` command. For details about how to use this command, refer to the command reference at :ref:`command_plugin`.

Plugin Security
"""""""""""""""
The plugin uses the `JSch Java Secure Channel <http://www.jcraft.com/jsch/>`_ library. All communication is SSH/SFTP-baed, so access credentials are protected in transit. Since the actual data is encrypted before upload, data confidentiality is not an issue either.

If the SFTP plugin is used, users sharing a repository typically access that repository **using the same SFTP username/password combination** (unless public key authentication is used). Be aware that sharing a ``syncany://`` link and the repository password with other users also means giving away these storage credentials. Only share a repository with people you trust with these credentials.

Options for ``config.xml``
""""""""""""""""""""""""""

+----------------------+------------+---------------+-----------------------------------------------------------+
| Plugin Option        | Mandatory  | Default Value | Description                                               |
+======================+============+===============+===========================================================+
| **hostname**         | yes        | *none*        | Hostname or IP address of the SFTP server                 |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **username**         | yes        | *none*        | Username of the SFTP user                                 |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **privatekey**       | yes        | "none"        | Private key path (if public key auth is used)             |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **password**         | yes        | *none*        | Password of the SFTP user or priv. key password           |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **path**             | yes        | *none*        | Path at which to store the repository                     |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **port**             | no         | 22            | Port of the FTP server                                    |
+----------------------+------------+---------------+-----------------------------------------------------------+

**Please note:** If ``privatekey`` is set to ``"none"``, the ``password`` is interepreted as the ``username``s password. If ``privatekey`` is set, the ``password`` is interpreted as the password of the private key. If the private key is not password protected, leave the password empty.

Example ``config.xml``
""""""""""""""""""""""

**With username/password**

.. code-block:: xml

	<config xmlns="http://syncany.org/config/1">
		...
		<connection type="sftp">
			<hostname>example.com</hostname>
			<username>spikeh</username>
			<privatekey>none</privatekey>
			<password>spikehPassword</password>
			<path>/home/spikeh/SyncanyRepo</path>
			<port>22</port>
		</connection>
	</config>

**With private key authentication**

.. code-block:: xml

	<config xmlns="http://syncany.org/config/1">
		...
		<connection type="sftp">
			<hostname>ftp.example.com</hostname>
			<username>armin</username>
			<privatekey>/home/localuser/.ssh/id_rsa</privatekey>
			<password>PrivateKeyPassword</password>
			<path>/home/spikeh/SyncanyRepo</path>
			<port>22</port>
		</connection>
	</config>

.. _plugin_webdav:

WebDAV Plugin
^^^^^^^^^^^^^
The WebDAV plugin (plugin identifier ``webdav``) uses a single folder on a WebDAV server as repository. Since only a sub-folder is used, multiple repositories per WebDAV server are possible. The plugin supports HTTP and HTTPS connections and authenticates users via username/password.

The HTTP and HTTPS setup are identical in terms of parameters -- only the URL setting differs slightly (``http://`` and ``https://``). However, if HTTPS is used, the first time you connect to the server (during ``sy init`` or ``sy connect``), Syncany will ask you to confirm the server certificate. This will happen for all certificates (even if they are signed by one of the large CAs):

::

	Unknown SSL/TLS certificate
	---------------------------
	Owner: CN=*.syncany.org, OU=Domain Control Validated
	Issuer: CN=GlobalSign Domain Validation CA - SHA256 - G2, O=GlobalSign nv-sa, C=BE
	Serial number: 1492271418628120790652059091142976109636803
	Valid from Mon Apr 14 23:01:38 CEST 2014 until: Wed Apr 15 23:01:38 CEST 2015
	Certificate fingerprints:
	 MD5:  60:FB:F7:F1:E1:9E:D6:74:06:41:03:01:16:D6:19:D3
	 SHA1: DC:A8:5F:FA:1D:9D:92:A7:1C:8E:22:C6:43:9B:96:9E:62:13:C7:25
	 SHA256: 84:DF:92:99:86:15:AF:A6:8D:EC:74:5C:13:BE:18:75:BC:08:34:...

	Do you want to trust this certificate? (y/n)?
	
Once you've accepted this certificate, it is added to the :ref:`user-specific trust store <configuration_truststore>` at ``~/.config/syncany/truststore.jks`` (Linux) or ``%AppData\Syncany\truststore.jks`` (Windows).	

The plugin is not installed by default, but it can be easily installed using the ``sy plugin install`` command. For details about how to use this command, refer to the command reference at :ref:`command_plugin`.

Plugin Security
"""""""""""""""
The WebDAV plugin uses the `Sardine WebDAV library <https://github.com/lookfirst/sardine>`_. Depending on the URL configured during setup, communication is either HTTP or HTTPS. 

If HTTP is used, traffic between the remote server and the local machine is not encrypted -- i.e. in this case, the plugin **does not provide transport security** and WebDAV credentials might by read by an adversary (man-in-the-middle attack). However, since Syncany itself takes care of encrypting the files before they are uploaded, the **confidentiality of your data is not at risk**. Be aware that this still means that an attacker might get access to your WebDAV account and simply delete all of your files.

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
		<connection type="webdav">
			<url>https://dav.example.com:8080/dav/repo1</url>
			<username>christof</username>
			<password>ZAzZZzFL0R1An</password>
		</connection>
	</config>

Samba Plugin
^^^^^^^^^^^^
The Samba plugin (plugin identifier ``samba``) uses a single folder on a SMB/CIFS share (also known as: Windows Share) as repository. Since only a sub-folder is used, multiple repositories per SMB/CIFS server are possible. 

Since Microsoft Windows comes with SMB/CIFS support out of the box, this plugin is most useful in Windows environments. Nevertheless, it works equally well with the Linux implementation Samba.

The plugin is not installed by default, but it can be easily installed using the ``sy plugin install`` command. For details about how to use this command, refer to the command reference at :ref:`command_plugin`.

Plugin Security
"""""""""""""""
The Samba plugin uses the `jCIFS library <http://jcifs.samba.org/>`_ for SMB/CIFS. Since this library only supports `NT LM 0.12 <https://lists.samba.org/archive/jcifs/2013-December/010123.html>`_ (which is `SMBv1 <http://richardkok.wordpress.com/2011/02/03/wireshark-determining-a-smb-and-ntlm-version-in-a-windows-environment/>`_), the plugin currently does not encrypt the communication to the SMB/CIFS server. 

That means that the plugin **does not provide transport security** and credentials might by read by an adversary (man-in-the-middle attack). Since Syncany itself takes care of encrypting the files before they are uploaded, the **confidentiality of your data is not at risk**. However, be aware that this still means that an attacker might get access to your SMB/CIFS account and simply delete all of your files.

If the Samba plugin is used, users sharing a repository typically access that repository **using the same username/password combination**. Be aware that sharing a ``syncany://`` link and the repository password with other users also means giving away these storage credentials. Only share a repository with people you trust with these credentials.

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

This example uses the folder ``Repo1`` on the ``Repositories`` share for storing the files. The UNC path for this would be: ``\\192.168.1.25\Repositories\Repo1``.

.. code-block:: xml

	<config xmlns="http://syncany.org/config/1">
		...
		<connection type="samba">
			<hostname>192.168.1.25</hostname>
			<username>Philipp</username>
			<password>ZuUaI/kt3k!</password>
			<share>Repositories</share>
			<path>Repo1</path>
		</connection>
	</config>

XXXXXXXXXXXx

RAID0 Plugin
^^^^^^^^^^^^
The RAID0 plugin (plugin identifier ``raid0``) virtually combines two storage backends into a single storage. The plugin can use any two storage plugins, e.g. an FTP folder and an Amazon S3 bucket. Unlike a RAID1 (or other RAID forms), it does not mirror the storage or provide protection against the failure of one backend. It merely combines their disk space. If one of the backends fails, all repository data is lost. A RAID1 plugin will be provided eventually.

The plugin is not installed by default, but it can be easily installed using the ``sy plugin install`` command. For details about how to use this command, refer to the command reference at :ref:`command_plugin`.

Plugin Security
"""""""""""""""
The RAID0 plugin uses two other storage plugins, so its security directly depends on the respective plugins. Please refer to their documentation for details.

Options for ``config.xml``
""""""""""""""""""""""""""

+----------------------+------------+---------------+-----------------------------------------------------------+
| Plugin Option        | Mandatory  | Default Value | Description                                               |
+======================+============+===============+===========================================================+
| **storage1:type**    | yes        | *none*        | Plugin identifier of the first storage backend            |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **storage1.<opt>**   | yes        | *none*        | Plugin-specific options of first plugin                   |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **storage1:type**    | yes        | *none*        | Plugin identifier of the second storage backend           |
+----------------------+------------+---------------+-----------------------------------------------------------+
| **storage1.<opt>**   | yes        | *none*        | Plugin-specific options of second plugin                  |
+----------------------+------------+---------------+-----------------------------------------------------------+

Example ``config.xml``
""""""""""""""""""""""
This example uses an Amazon S3 plugin and an SFTP plugin as a backend:

.. code-block:: xml

	<config xmlns="http://syncany.org/config/1">
		...
		<connection type="raid0">
			<storage1 type="s3">
				<accessKey>AKIAIHIALEXANDREUIIE</accessKey>
				<secretKey>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</secretKey>
				<bucket>syncany-demo</bucket>
				<location">us-west-1</location>
			</storage1>
			<storage2 type="sftp">
				<hostname>example.com</hostname>
				<username>spikeh</username>
				<privatekey>none</privatekey>
				<password>spikehPassword</password>
				<path>/home/spikeh/SyncanyRepo</path>
				<port>22</port>
			</storage2>
		</connection>
	</config>

OpenStack Swift Plugin
^^^^^^^^^^^^^^^^^^^^^^
The OpenStack Swift plugin (plugin identifier ``swift``) ....

Dropbox Plugin
^^^^^^^^^^^^^^
The Dropbox plugin (plugin identifier ``dropbox``) ....

Graphical User Interface Plugin
-------------------------------
The GUI plugin ....

.. _plugin_web_interface:

Web Interface Plugins
---------------------
Web Interface plugins are a way to provide a web frontend to Syncany folders managed by a Syncany daemon. If a web interface plugin is installed, a web based frontend will be available via the web browser. Like any other plugin, web interface plugins can be installed with ``sy plugin install`` and are available after restarting the Syncany daemon (see details about the plugin installation at :ref:`command_plugin`).

In the default configuration, the web interface is served by the internal web server at port 8443 and can be accessed at https://localhost:8443. The web server settings can be changed by modifying the ``daemon.xml`` file as described at :ref:`configuration_daemon`.

.. _plugin_simpleweb:

Simple Web Interface Plugin
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note::

	The Simple Web Interface plugin is a proof-of-concept implementation. It is available as a snapshot, but not fully functional. We are still looking for a web frontend developer to take over / rewrite the web frontend. Please refer to the `corresponding GitHub issue <https://github.com/syncany/syncany/issues/207>`_.
	
The Simple Web Interface plugin (plugin identifier ``simpleweb``) provides access to the daemon-managed Syncany folders, i.e. all folders configured in the ``daemon.xml`` (see :ref:`configuration_daemon`). The web frontend currently implements the following functionalities:

- Display the file tree at different times (current and past)
- Display file history of a file (old versions)
- Restore old versions of a file
- Download a file (current or past version)

To install the plugin, use ``sy plugin install simpleweb --snapshot``. Make sure to enable the ``--snapshot`` flag, because there is no official release of the plugin (yet). 

As of today, the web interface looks like this:

.. image:: _static/plugins_simpleweb.png

