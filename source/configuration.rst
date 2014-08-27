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

Common Settings and Storage Connection (``config.xml``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The ``config.xml`` file is initially created by the ``sy init`` or ``sy connect`` command. Changing its settings is typically not necessary -- unless your connection/storage details (such as credentials or hostname) change. 

Options for ``config.xml``
""""""""""""""""""""""""""
+----------------------+------------+---------------+-------------------------------------------+
| Option               | Mand.      | Def.          | Description                               |
+======================+============+===============+===========================================+
| ``<machinename>``    | yes        | *none*        | Random local machine identifier           |
+----------------------+------------+---------------+-------------------------------------------+
| ``<displayname>``    | yes        | *none*        | Human readable user name                  |
+----------------------+------------+---------------+-------------------------------------------+
| ``<cacheKeepBytes>`` | no         | 524288000     | Size of cache in bytes                    |
+----------------------+------------+---------------+-------------------------------------------+
| ``<connection>``     | yes        | *none*        | Key/value based storage settings          |
+----------------------+------------+---------------+-------------------------------------------+

The ``<machinename>`` property represents a local machine identifier to technically identify a computer/user. It is purely random and carries no logic. This identifier is created during folder initialization and **should not be changed**. 

The ``<displayname>`` is the human readable user name of the user. It is currently only used locally to create conflict files. As of today, this property is not transferred to other users, but it might be in the future. The property can safely be changed.

The ``<cacheKeepBytes>`` property depicts the maximum size of the local ``.syncany/cache/`` folder (in bytes, default is 500 MB). After each synchronization, the cache is cleaned if it exceeds the keep size. The cache mechanism is least recently used (LRU).

The ``<connection>`` property represents the :ref:`storage plugin <plugins_storage>` configuration. The ``type="<plugin-id>"`` attribute defines the plugin used to synchronize this folder. The definition of these properties is described in the corresponding plugin sub-chapter.

Example ``config.xml``
""""""""""""""""""""""
.. code-block:: xml

	<config xmlns="http://syncany.org/config/1">
		<machinename>PCiqLdSQiampovfBfSZZ</machinename>
		<displayname>pheckel</displayname>
		<connection type="ftp">
			<property name="hostname">ftp.example.com</property>
			<property name="username">armin</property>
			<property name="password">cr0/ChRisTiAn</property>
			<property name="path">/syncany/repo2</property>
			<property name="port">21</property>
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
The user config defines central settings valid only for the logged-in user. Unlike the folder-specific settings, the user configuration settings apply to the entire user. There are two general categories of user-specific configuration files:

- **General User Configuration** (``userconfig.xml``): Define central user-specific config options such as proxy settings, standby settings or other system properties. 
- **Daemon Configuration** (``daemon.xml``): Define settings specific to the Syncany background process (the daemon), such as which folders are managed by the daemon.

The configuration can be found at ``%AppData%\Syncany\`` (Windows) and at ``~/.config/syncany/`` (Linux).

User Config (``userconfig.xml``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The ``userconfig.xml`` config file is a defines global user config settings -- valid only for this user, but regardless of whether or not Syncany is run in daemon mode or manually. The options are pretty limited are right now. More config options will probably be added in future releases.

Options for ``userconfig.xml``
""""""""""""""""""""""""""""""
+------------------------+------------+---------------+--------------------------------------------+
| Option                 | Mand.      | Def.          | Description                                |
+========================+============+===============+============================================+
| ``<preventStandby>``   | no         | false         | Prevent standby/shutdown during sync       |
+------------------------+------------+---------------+--------------------------------------------+
| ``<systemProperties>`` | yes        | *none*        | Set any Java system properties (e.g proxy) |
+------------------------+------------+---------------+--------------------------------------------+

If the ``<preventStandby>`` option is set to ``true``, Syncany will make sure that your system doesn't go into standby/hibernate if the synchronization process is run. This option will not prevent your system from going to sleep if no upload/download process is taking place. Since this option might also prevent the screensaver or screen lock, it is not enabled by default. 

The ``<systemProperties>`` option allows you to set Java system properties via the Syncany configuration. Any of the ``<property>`` options will be passed to Java's ``System.setProperty()`` method. This can be used to set proxy settings, log settings, and so on.

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
| **https.proxyHost**         | Sets HTTPS proxy hostname                                               |
+-----------------------------+-------------------------------------------------------------------------+
| **https.proxyPort**         | Sets HTTPS proxy port                                                   |
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
	</userConfig>

.. _configuration_daemon:

Daemon Config (``daemon.xml``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The main purpose of the daemon configuration is to tell the Syncany daemon (started by ``syd start``) what folders should be monitored and automatically synced whenever something changes. 

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

The ``<folders>`` option can contain multiple ``<folder>`` definitions, each of which represent a Syncany folder managed by the daemon. To add a new Syncany folder, simply initialize or connect to a repository (using ``sy init`` or ``sy connect``) and add the folder here. Then restart the daemon. Find details to this option below in :ref:`configuration_daemon_folders`:.

The ``<webServer>`` option controls the internal Syncany web server (bind port and address, certificates). The web server is used for the web interface as well as for the Syncany API. Find details to this option below in :ref:`configuration_daemon_webserver`:

The ``<users>`` option defines the users that can access the web interface and the API. Each ``<user>`` has full read/write access to the API and all managed folders. Find details to this option below in :ref:`configuration_daemon_users`:

.. _configuration_daemon_folders:

Managed Folder Configuration (``<folders>``)
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

.. note::

	We're currently still in an alpha version of Syncany and the options inside the ``<folder>`` tag change more often than we desire. Please forgive us for not documenting all of the options.

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
	
.. _configuration_keys_certificates:
	
Keys and Certificates
---------------------
Syncany maintains its own user-specific key store for private keys and trust store foreign X.509 certificates. Both key store and trust store are used by the internal web server and plugins that use SSL/TLS (e.g. the :ref:`WebDAV plugin <plugin_webdav>`).

Both files are located at the user-specific configuration directory at ``~/.config/syncany/`` (Linux) or ``%AppData\Syncany\`` (Windows). The files are stored in the **Java Key Store** (JKS) format. No password is used to protect the key/trust store. To analyze this file and its entries, you may use the ``keytool`` util.

Private Keys
^^^^^^^^^^^^
As of today, Syncany only stores one entry in the ``keystore.jks`` file -- namely the private key part of the RSA keypair used to serve the HTTPS API and web interface. 

TODO

.. _configuration_truststore:

Trusted Certificates
^^^^^^^^^^^^^^^^^^^^
TODO 
Syncany maintains a user-specific trust store of trusted X.509 certificates at ``~/.config/syncany/truststore.jks`` (Linux) or ``%AppData\Syncany\truststore.jks`` (Windows). This trust store is mainly used by plugins that communicate via SSL/TLS (such as the :ref:`WebDAV plugin <plugin_webdav>`). 

Syncany trusts all SSL/TLS certificates in this trust store: When a connection to this store is opened, Syncany will not ask for user confirmation before it continues communication. If, however, the remote certificate is unknown, Syncany will ask the user what to do (if that is implemented in the plugin).

The trust store format is in the **Java Key Store** (JKS) format. No password is used to protect the key store. To analyze this file and its entries, you may use the ``keytool`` util.
