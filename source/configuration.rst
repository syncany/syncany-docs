Configuration
=============
Syncany differentiates between two types of configuration:

- **Folder-specific Configuration**: Each folder that is synchronized and managed by Syncany contains a ``.syncany`` folder. The files in this folder define the per-folder config options such as the backend storage credentials or the machine name.
- **User-specific Configuration**: The user config defines central settings valid only for the logged in user -- this includes proxy configuration or the standby settings, but also daemon-specific configuration such as which Syncany folders are managed by the background daemon, and where the web frontend and REST/WS API is running.

Syncany stores the folder-specific configuration options in ``.syncany`` of the synchronized folder, and other general user-specific configurations (such as the user and daemon config) in ``%AppData%\Syncany\`` or ``~/.config/syncany/``. 

.. contents::
   :depth: 3

Folder-specific Configuration
-----------------------------
Whenever a new Syncany folder is initialized via ``sy init`` or ``sy connect``, Syncany creates a ``.syncany`` folder in that directory. This folder marks the folder as a Syncany folder and contains configuration and metadata information. Typically, **you don't have to touch any of these files**, but it doesn't hurt to know a little bit about them:

- ``.syncany/config.xml`` (main config): Stores client information and the connection details.
- ``.syncany/syncany`` (repo file): Stores common repository information (repo ID, chunking options). 
- ``.syncany/master`` (master salt file): Stores the salt of the master key (if repo encrypted).
- ``.syncany/cache/`` (local cache): Cache folder to store temporarily files.
- ``.syncany/db/`` (local database): Files stored by the local embedded `HSQLDB <http://hsqldb.org/>`_ database. 
- ``.syncany/logs/`` (log files): Stores log files created by Syncany. Log files rotate automatically.
- ``.syignore`` (exclude/ignore files): Lists all the files to be ignored by Syncany.

Since only the ``config.xml`` and ``.syignore`` files should be changed manually, the following chapters only describe these files.

.. _configuration_config_xml:

Common Settings and Storage Connection (``config.xml``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The ``config.xml`` file is initially created by the ``sy init`` or ``sy connect`` command. Changing its settings is typically not necessary -- unless your connection/storage details (such as credentials or hostname) change. 

Options for ``config.xml``
""""""""""""""""""""""""""
+----------------------+------------+---------------+-------------------------------------------+
| Option               | Mand.      | Def.          | Description                               |
+======================+============+===============+===========================================+
| ``<machineName>``    | yes        | *none*        | Random local machine identifier           |
+----------------------+------------+---------------+-------------------------------------------+
| ``<displayName>``    | yes        | *none*        | Human readable user name                  |
+----------------------+------------+---------------+-------------------------------------------+
| ``<masterKey>``      | no         | *none*        | Master key used to derive enc. keys       |
+----------------------+------------+---------------+-------------------------------------------+
| ``<cacheKeepBytes>`` | no         | 524288000     | Size of cache in bytes                    |
+----------------------+------------+---------------+-------------------------------------------+
| ``<connection>``     | yes        | *none*        | Key/value based storage settings          |
+----------------------+------------+---------------+-------------------------------------------+

The ``<machineName>`` property represents a local machine identifier to technically identify a computer/user. It is purely random and carries no logic. This identifier is created during folder initialization and **should not be changed**. 

The ``<displayName>`` is the human readable user name of the user. It is currently only used locally to create conflict files. As of today, this property is not transferred to other users, but it might be in the future. The property can safely be changed.

The ``<masterKey>`` represents the master key generated from the repository password. It is required if the repository is encrypted, and it must not be changed. To learn more about the master key, check out the :doc:`security` chapter.

The ``<cacheKeepBytes>`` property depicts the maximum size of the local ``.syncany/cache/`` folder (in bytes, default is 500 MB). After each synchronization, the cache is cleaned if it exceeds the keep size. The cache mechanism is least recently used (LRU).

The ``<connection>`` property represents the :ref:`storage plugin <plugins_storage>` configuration. The ``type="<plugin-id>"`` attribute defines the plugin used to synchronize this folder. The definition of these properties is described in the corresponding plugin sub-chapter.

Example ``config.xml``
""""""""""""""""""""""
.. code-block:: xml

	<config xmlns="http://syncany.org/config/1">
		<machineName>PCiqLdSQiampovfBfSZZ</machineName>
		<displayName>pheckel</displayName>
		<masterKey salt="51d32e99230581e2..." key="ba2f6725d2ce7d90822..."/>
		<connection type="ftp">
			<hostname>ftp.example.com</hostname>
			<username>armin</username>
			<password encrypted="true">87abc68afe1428319fad...</password>
			<path>/syncany/repo2</path>
			<port>21</port>
		</connection>
		<cacheKeepBytes>524288000</cacheKeepBytes>
	</config>

Excluding/Ignoring Files and Folders (``.syignore``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The ``.syignore`` file allows you to ignore certain files and folders from the synchronization process. It must be created manually by the user if any exclude/ignore logic is desired. The file resides in the root of the managed folder and is itself synchronized to other clients using Syncany. 


.. note::

	As of today, new entries in the ``.syignore`` file are not picked up by Syncany (files are not ignored!) if the to-be-ignored-file has already been synchronized. We are aware that this is not a desired behavior and are `working on it to fix it <https://github.com/syncany/syncany/issues/189>`_.

The file has a simple line-based structure, in which each line represents a path to be ignored by Syncany. The file supports the typical wildcards (``*`` and ``?``) as well as regular expression based patterns:

- **Wildcard-based exclusions:** ``*`` matches any amount of characters (including none), ``?`` matches exactly one character.
- **Regular expression based exclusions:** Lines prefixed ``regex:`` exclude files matching the given regular expression. 

If ``C:\Users\Steffen\Syncany`` is the managed Syncany folder, the following file (if located at ``C:\Users\Steffen\Syncany\.syignore``) will ignore files/folders ending with ``.bak``, file/folders named ``.git`` as well as files/folders matching the regular expression ``private/20[0-9]{2}`` (e.g. ``private/2099`` or ``private/2000``):

::

	*.bak
	.git
	regex:private/20[0-9]{2}

User-specific Configuration
---------------------------
The user config defines central settings valid only for the logged-in user. Unlike the folder-specific settings, the user configuration settings apply to the entire user. There are three general categories of user-specific configuration files:

- **General User Configuration** (``userconfig.xml``): Define central user-specific config options such as proxy settings, standby settings or other system properties. 
- **Daemon Configuration** (``daemon.xml``): Define settings specific to the Syncany background process (the daemon), such as which folders are managed by the daemon.
- **GUI Configuration** (``gui.xml``): Define settings specific to the Syncany graphical user interface (only present if GUI is installed).

The configuration can be found at ``%AppData%\Syncany\`` (Windows) and at ``~/.config/syncany/`` (Linux).

User Config (``userconfig.xml``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The ``userconfig.xml`` config file is a defines global user config settings -- valid only for this user, but regardless of whether or not Syncany is run in daemon mode or manually. The options are pretty limited are right now. More config options will probably be added in future releases.

Options for ``userconfig.xml``
""""""""""""""""""""""""""""""
+---------------------------+------------+---------------+---------------------------------------------------+
| Option                    | Mand.      | Def.          | Description                                       |
+===========================+============+===============+===================================================+
| ``<configEncryptionKey>`` | yes        | *none*        | Encryption key to encrypt repo access credentials |
+---------------------------+------------+---------------+---------------------------------------------------+
| ``<systemProperties>``    | no         | *none*        | Set any Java system properties (e.g proxy)        |
+---------------------------+------------+---------------+---------------------------------------------------+
| ``<preventStandby>``      | no         | false         | Prevent standby/shutdown during sync              |
+---------------------------+------------+---------------+---------------------------------------------------+
| ``<maxMemory>``           | no         | 512M          | Limit memory usage of Syncany                     |
+---------------------------+------------+---------------+---------------------------------------------------+

The ``<configEncryptionKey>`` option is used to encrypt sensitive values in the :ref:`config.xml <configuration_config_xml>` file, e.g. the (S)FTP/WebDAV password, the Amazon S3 / Dropbox access token, and so on. 

The ``<systemProperties>`` option allows you to set Java system properties via the Syncany configuration. Any of the ``<property>`` options will be passed to Java's ``System.setProperty()`` method. This can be used to set proxy settings, log settings, and so on.

If the ``<preventStandby>`` option is set to ``true``, Syncany will make sure that your system doesn't go into standby/hibernate if the synchronization process is run. This option will not prevent your system from going to sleep if no upload/download process is taking place. Since this option might also prevent the screensaver or screen lock, it is not enabled by default. 

The ``<maxMemory>`` option can be used to limit Syncany's memory usage to the given value. Example values are ``1G`` (1 GB) or ``500M`` (500 MB). By default, Syncany will limit the max. memory value to ``512M`` (512 MB). The value will be passed on to the Java Virtual Machine (``-Xmx``). 

Useful System Properties
""""""""""""""""""""""""
This is a non-exhaustive list of useful system properties that can be used in the above mentioned ``<systemProperties>`` option. To add an option, simply add a property tag: 

.. code-block:: xml

	<property name="property-name">property value</property>

+-----------------------------+-------------------------------------------------------------------------+
| System Property             | Description                                                             |
+=============================+=========================================================================+
| **http.proxyHost**          | Sets HTTP proxy hostname                                                |
+-----------------------------+-------------------------------------------------------------------------+
| **http.proxyPort**          | Sets HTTP proxy port                                                    |
+-----------------------------+-------------------------------------------------------------------------+
| **http.proxyUser**          | Sets HTTP proxy username (if proxy needs authentication)                |
+-----------------------------+-------------------------------------------------------------------------+
| **http.proxyPass**          | Sets HTTP proxy password (if proxy needs authentication)                |
+-----------------------------+-------------------------------------------------------------------------+
| **https.proxyHost**         | Sets HTTPS proxy hostname                                               |
+-----------------------------+-------------------------------------------------------------------------+
| **https.proxyPort**         | Sets HTTPS proxy port                                                   |
+-----------------------------+-------------------------------------------------------------------------+
| **https.proxyUser**         | Sets HTTPS proxy username (if proxy needs authentication)               |
+-----------------------------+-------------------------------------------------------------------------+
| **https.proxyPass**         | Sets HTTPS proxy password (if proxy needs authentication)               |
+-----------------------------+-------------------------------------------------------------------------+
| **socksProxyHost**          | Sets SOCKS proxy hostname                                               |
+-----------------------------+-------------------------------------------------------------------------+
| **socksProxyPort**          | Sets SOCKS proxy port                                                   |
+-----------------------------+-------------------------------------------------------------------------+
| **java.net.socks.username** | Sets SOCKS proxy username (if proxy needs authentication)               |
+-----------------------------+-------------------------------------------------------------------------+
| **java.net.socks.password** | Sets SOCKS proxy password (if proxy needs authentication)               |
+-----------------------------+-------------------------------------------------------------------------+
| **org.syncany.test.tmpdir** | Developer property: Uses the given folder for Syncany unit tests        |
+-----------------------------+-------------------------------------------------------------------------+

Example ``userconfig.xml``
""""""""""""""""""""""""""
This example shows how to set the HTTP and HTTPS proxy for all HTTP/HTTPS-traffic by Syncany. In particular, this includes traffic to the Syncany Plugin API and communication by the :ref:`WebDAV plugin <plugin_webdav>`. The example furthermore shows how to enable the standby/hibernate prevention.

.. code-block:: xml

	<userConfig xmlns="http://syncany.org/userconfig/1">
	   <preventStandby>true</preventStandby>
	   <systemProperties>
	      <property name="http.proxyHost">your.proxy.host.tld</property>
	      <property name="http.proxyPort">8080</property>
	      <property name="https.proxyHost">your.proxy.host.tld</property>
	      <property name="https.proxyPort">8080</property>
	   </systemProperties>
	   <configEncryptionKey salt="87d32e99230581e2..." key="652f6725d2ce7d90822..."/>
	</userConfig>

.. _configuration_daemon:

Daemon Config (``daemon.xml``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The main purpose of the daemon configuration is to tell the Syncany daemon (started by ``sy daemon start``) what folders should be monitored and automatically synced whenever something changes. 

Options for ``daemon.xml``
""""""""""""""""""""""""""
+------------------------+------------+---------------+--------------------------------------------+
| Option                 | Mand.      | Def.          | Description                                |
+========================+============+===============+============================================+
| ``<folders>``          | yes        | *none*        | Folders managed by the daemon              |
+------------------------+------------+---------------+--------------------------------------------+
| ``<webServer>``        | yes        | *none*        | Internal web server parameters             |
+------------------------+------------+---------------+--------------------------------------------+
| ``<users>``            | yes        | *none*        | Log-in users for web server and API        |
+------------------------+------------+---------------+--------------------------------------------+

The ``<folders>`` option can contain multiple ``<folder>`` definitions, each of which represent a Syncany folder managed by the daemon. To add a new Syncany folder, simply initialize or connect to a repository (using ``sy init`` or ``sy connect``) and add the folder here. Then restart the daemon. Find details to this option below in :ref:`configuration_daemon_folders`.

The ``<webServer>`` option controls the internal Syncany web server (bind port and address, certificates). The web server is used for the web interface as well as for the Syncany API. Find details to this option below in :ref:`configuration_daemon_webserver`.

The ``<users>`` option defines the users that can access the web interface and the API. Each ``<user>`` has full read/write access to the API and all managed folders. Find details to this option below in :ref:`configuration_daemon_users`.

.. _configuration_daemon_folders:

Managed Folder Configuration (``<folders>``)
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

.. note::

	We're currently still in an alpha version of Syncany and the options inside the ``<folder>`` tag change more often than we desire. Please forgive us for not documenting all of the options. You might want to check out the ``daemon-example.xml`` file to see all available options.

The ``<folders>`` tag can contain multiple ``<folder>`` tags, each of which has a vast amount of configuration options. Typically you don't need to touch any of them. To see a full example (including all available options), see :ref:`configuration_daemon_example_complex`.

The ``<path>`` option defines the local path to the Syncany folder, and the ``<enabled>`` tag lets you enable/disable folders. 

The ``<watch>`` tag defines the behavior for the internal watch operation. That includes the behavior of the index/upload operation (``<up>``), the download/apply operation (``<down>``) as well as the periodic cleanup mechanism (``<clean>``). It also includes general settings about the local file system watcher (``<watcher>``) and the central Syncany pub/sub server (``<announcements>``).

.. _configuration_daemon_webserver:

Web Server Configuration (``<webServer>``)
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
The internal web server is used to serve the Syncany REST and WebSocket API, as well as the web interface (if a :ref:`web interface plugin <plugin_web_interface>` is installed). Both API and web interface are HTTPS-only, meaning that no HTTP traffic is accepted and that all communication is encrypted.

The certificate used by the internal web server is automatically generated by default. Syncany creates a self-signed X.509 certificates based on a generated RSA 2048-bit keypair. The common name (CN) in the certificate is the local hostname by default, but can be changed if needed.

.. note::

	As of today, providing your own certificates and keypair is possible, but not as easy as it should be: First disable the ``<certificateAutoGenerate>`` option, and then import your keypair into ``keystore.jks`` and your certificate into ``truststore.jks``. Also see :ref:`configuration_keys_certificates`.

+-------------------------------+------------+---------------+------------------------------------------------+
| Option                        | Mand.      | Def.          | Description                                    |
+===============================+============+===============+================================================+
| ``<enabled>``                 | yes        | true          | Defines whether the web server will start      |
+-------------------------------+------------+---------------+------------------------------------------------+
| ``<bindAddress>``             | yes        | 127.0.0.1     | Address to which the server socket is bound    |
+-------------------------------+------------+---------------+------------------------------------------------+
| ``<bindPort>``                | yes        | 8443          | Port to which the server socket is bound       |
+-------------------------------+------------+---------------+------------------------------------------------+
| ``<certificateAutoGenerate>`` | yes        | true          | Regenerate certificate if common name changed. |
+-------------------------------+------------+---------------+------------------------------------------------+
| ``<certificateCommonName>``   | yes        | *hostname*    | Common name in the server certificate          |
+-------------------------------+------------+---------------+------------------------------------------------+

The ``<enabled>`` option can switch off the web server entirely, if the option is set to ``false``. However, if the webserver is disabled, neither REST/WS API nor the web interface are available.

The ``<bindAddress>`` and ``<bindPort>`` options define to which IP address, i.e. network interface, and port the server will be bound. For security reasons , the web interface and API is only bound to a local address (``127.0.0.1``) and is therefore not reachable externally. To make the API and web interface publicly available, set the bind address to ``0.0.0.0`` (or a specific IP address).

The ``<certificateAutoGenerate>`` option automatically (re-)generates a keypair and a self-signed certificate for the Syncany web server using the common name (CN) defined in ``<certificateCommonName>``. Whenever ``<certificateCommonName>`` is changed (and ``<certificateAutoGenerate>`` is set to ``true``), Syncany will re-generate a new keypair/certificate.

.. _configuration_daemon_users:

User Authentication (``<users>``)
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
The user authentication capabilities of Syncany to the web server and REST/WS API are very limited. Syncany provides a simple "HTTP Basic"-based user authentication -- using users defined in the ``daemon.xml`` config file. 

All users provided in the ``<users>`` option have full read/write access to the Syncany web interface and REST/WS API. As of today, there are no authorization mechanisms at all:

.. code-block:: xml

	   <users>
	      <user>
		 <username>Pim</username>
		 <password>IOgotcpZzNPh</password>
	      </user>
	      <user>
		 <username>Philipp</username>
		 <password>plaintextpassword</password>
	      </user>
	   </users>
	   
In the example, users Pim and Philipp have the same access rights. Both can access the web interface and execute any REST/WS request.

.. _configuration_daemon_example_simple:

Example 1: Simple ``daemon.xml``
""""""""""""""""""""""""""""""""

.. code-block:: xml

	<daemon xmlns="http://syncany.org/daemon/1">
	   <webServer>
	      <enabled>true</enabled>
	      <bindAddress>0.0.0.0</bindAddress>
	      <bindPort>8443</bindPort>
	      <certificateAutoGenerate>true</certificateAutoGenerate>
	      <certificateCommonName>platop</certificateCommonName>
	   </webServer>
	   <folders>
	      <folder>
		 <path>/home/pheckel/Syncany</path>
		 <enabled>true</enabled>		
	      </folder>
	   </folders>
	   <users>
	      <user>
		 <username>admin</username>
		 <password>IOgotcpZzNPh</password>
	      </user>
	   </users>
	</daemon>

.. _configuration_daemon_example_complex:

Example 2: Complex ``daemon.xml``
"""""""""""""""""""""""""""""""""

.. code-block:: xml

	<daemon xmlns="http://syncany.org/daemon/1">
	   <webServer>
	      <enabled>true</enabled>
	      <bindAddress>0.0.0.0</bindAddress>
	      <bindPort>8443</bindPort>
	      <certificateAutoGenerate>true</certificateAutoGenerate>
	      <certificateCommonName>platop</certificateCommonName>
	   </webServer>
	   <folders>
	      <folder>
		 <path>/tmp/repo4</path>
		 <enabled>true</enabled>
		 <watch>
		    <interval>120000</interval>
		    <announcements>true</announcements>
		    <announcementsHost>notify.syncany.org</announcementsHost>
		    <announcementsPort>8080</announcementsPort>
		    <settleDelay>3000</settleDelay>
		    <cleanupInterval>3600000</cleanupInterval>
		    <watcher>true</watcher>
		    <up>
		       <status>
		          <forceChecksum>false</forceChecksum>
		       </status>
		       <forceUploadEnabled>false</forceUploadEnabled>
		    </up>
		    <down>
		       <conflictStrategy>RENAME</conflictStrategy>
		       <applyChanges>true</applyChanges>
		    </down>
		    <clean>
		       <status>
		          <forceChecksum>false</forceChecksum>
		       </status>
		       <force>false</force>
		       <mergeRemoteFiles>true</mergeRemoteFiles>
		       <removeOldVersions>true</removeOldVersions>
		       <keepVersionsCount>5</keepVersionsCount>
		       <maxDatabaseFiles>15</maxDatabaseFiles>
		       <minSecondsBetweenCleanups>10800</minSecondsBetweenCleanups>
		    </clean>
		 </watch>
	      </folder>
	   </folders>
	   <users>
	      <user>
		 <username>admin</username>
		 <password>IOgotcpZzNPh</password>
	      </user>
	   </users>	   
	</daemon>

.. _configuration_gui:

GUI Config (``gui.xml``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The GUI config file ``gui.xml`` is only present if the graphical user interface is installed and has been started at least once. Its purpose is to store GUI-specific options only. All of the options are **meant to be set by the GUI**.

Options for ``gui.xml``
""""""""""""""""""""""""""
+------------------------+------------+---------------+--------------------------------------------+
| Option                 | Mand.      | Def.          | Description                                |
+========================+============+===============+============================================+
| ``<tray>``             | no         | ``DEFAULT``   | Tray icon engine (Linux only)              |
+------------------------+------------+---------------+--------------------------------------------+
| ``<theme>``            | no         | ``DEFAULT``   | Icon set to use for the tray               |
+------------------------+------------+---------------+--------------------------------------------+
| ``<startup>``          | no         | ``false``     | Run Syncany GUI at startup / user login    |
+------------------------+------------+---------------+--------------------------------------------+
| ``<notifications>``    | no         | ``true``      | Show (or don't show) notifications         |
+------------------------+------------+---------------+--------------------------------------------+

The ``<tray>`` option defines the tray backend used to display Syncany's tray icon. Possible values are ``DEFAULT``, ``APPINDICATOR`` and ``OSX_NOTIFICATION_CENTER``. If ``DEFAULT`` or no value is set, Syncany will try to automatically determine the backend to use for displaying the tray icon. On Linux, the Syncany GUI will use the Python-based app indicator script if the Unity desktop is detected. On Mac OSX, it will try to use the OSX notification center. 

The ``<theme>`` option controls the icon theme used by the tray icon. Possible values are ``DEFAULT`` and ``MONOCHROME``. If ``DEFAULT`` is given, the default color theme will be used for all operating systems except for Mac OSX. On Mac OSX, the ``MONOCHROME`` theme is used.

The ``<startup>`` option indicates whether the Syncany GUI is started when the user logs in, i.e. on startup. Note that changing this value in an editor does not change the autostart settings of your system. Only set this value via the graphical user interface.

The ``<notifications>`` option defines if sync notifications are displayed to the user. Notifications are typically displayed if new files have been added or changed.

.. _configuration_gui_example:

Example: GUI config ``gui.xml``
"""""""""""""""""""""""""""""""

.. code-block:: xml

	<gui>
	   <tray>DEFAULT</tray>
	   <theme>DEFAULT</theme>
	   <startup>true</startup>
	   <notifications>true</notifications>
	</gui>
	
.. _configuration_keys_certificates:
	
Keys and Certificates
---------------------
Syncany maintains its own user-specific key store for private keys and trust store foreign X.509 certificates. Both key store and trust store are used by the internal web server as well as by plugins that use SSL/TLS (e.g. the :ref:`WebDAV plugin <plugin_webdav>`).

Both files are located at the user-specific configuration directory at ``~/.config/syncany/`` (Linux) or ``%AppData\Syncany\`` (Windows). The files are stored in the **Java Key Store** (JKS) format. No password is used to protect the key/trust store. To analyze this file and its entries, you may use the ``keytool`` util.

Private Keys (``keystore.jks``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
As of today, Syncany only stores one entry in the ``keystore.jks`` file -- namely the private key part of the RSA keypair used to serve the HTTPS API and web interface. As described in :ref:`configuration_daemon_webserver`, the keypair is generated by Syncany whenever the common name in the daemon config is changed (unless the ``<certificateAutoGenerate>`` option is disabled). 

In normal situations, you should not have to alter the key store file at all. To use your own keypair and certificate, please see :ref:`configuration_use_own_keypair_certificate`.

.. _configuration_truststore:

Trusted Certificates (``truststore.jks``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Syncany's user-specific trust store holds trusted X.509 certificates of remote servers. This trust store is mainly used by plugins that communicate via SSL/TLS (such as the :ref:`WebDAV plugin <plugin_webdav>`). Whenever ``sy connect`` or ``sy init`` is called with a plugin that uses TLS/SSL, Syncany will ask the user to confirm certificates that are not in the trust store. After the user confirms, these certificates are added to the trust store, so that the next time the server is contacted, no user query is necessary.

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

In normal situations, you should not have to alter the trust store file at all. You may, however, need to do that if you want to your own keypair and certificate. See :ref:`configuration_use_own_keypair_certificate` for details.

.. _configuration_use_own_keypair_certificate:

Using your own Keypair and Certificate
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note::

	Using your own keypair and certificate is not as easy as it should be. Please let us know if you have a better way to do that.
	
To use your own keypair and certificate for Syncany's internal web server, follow the following steps. You can use a tool like ``keytool`` to do that:

1. Set the ``<certificateAutoGenerate>`` option in the ``daemon.xml`` to ``false`` (see :ref:`configuration_daemon_webserver`).
2. Replace the only private key entry (and the associated certificate) in the ``keystore.jks`` file with your own private key and certificate. The private key entry must be the only entry in the file.
3. Import your own certificate in the ``truststore.jks``. You don't have to remove any entries from this file.

After restarting the daemon, Syncany should use your own certificate for the internal web server. You can verify that by opening the browser and checking the certificate.
