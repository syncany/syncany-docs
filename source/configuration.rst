Configuration
=============
Syncany differentiates between two types of configuration:

- **Folder-specific Configuration**: Each folder that is synchronized and managed by Syncany contains a ``.syncany`` folder. The files in this folder define the per-folder config options such as the backend storage credentials or the machine name.
- **User-specific Configuration**: The user config defines central settings valid only for the logged in user -- this includes proxy configuration or the standby settings, but also daemon-specific configuration such as which Syncany folders are managed by the background daemon, and where the web frontend and REST/WS API is running.

Syncany stores the folder-specific configuration options in ``.syncany`` of the synchronized folder, and other general user-specific configurations (such as the user and daemon config) in ``%AppData%\Syncany\`` or ``~/.config/syncany/``. 

.. contents::

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
| Plugin Option        | Mand.      | Def.          | Description                               |
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

- **General User Configuration**: Define central user-specific config options such as proxy settings, standby settings or other system properties. 
- **Daemon Configuration**: Define settings specific to the Syncany background process (the daemon), such as which folders are managed by the daemon.

The configuration can be found at ``%AppData%\Syncany\`` (Windows) and at ``~/.config/syncany/`` (Linux).

User Config (``userconfig.xml``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Prevent standby/hibernate
"""""""""""""""""""""""""

To make sure that your workstation doesn't go into standby/hibernate while Syncany is uploading/downloading changes, the `userconfig.xml` needs to contain the following setting:

.. code-block:: xml

	<preventStandby>true</preventStandby>

Add proxy configuration
"""""""""""""""""""""""
The proxy config (and other system properties) can be added by creating/editing the ``%AppData%\Syncany\userconfig.xml`` or ``~/.config/syncany/userconfig.xml`` file:

.. code-block:: xml

	<userConfig xmlns="http://syncany.org/userconfig/1">
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

Simple Daemon Config Example
""""""""""""""""""""""""""""

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

Complex Daemon Config Example
"""""""""""""""""""""""""""""

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
	
Keys and Certificates
^^^^^^^^^^^^^^^^^^^^^

Private Keys
""""""""""""

- keystore.jks	

.. _configuration_truststore:

Trusted Certificates
""""""""""""""""""""
Syncany maintains a user-specific trust store of trusted X.509 certificates at ``~/.config/syncany/truststore.jks`` (Linux) or ``%AppData\Syncany\truststore.jks`` (Windows). This trust store is mainly used by plugins that communicate via SSL/TLS (such as the :ref:`WebDAV plugin <plugin_webdav>`). 

Syncany trusts all SSL/TLS certificates in this trust store: When a connection to this store is opened, Syncany will not ask for user confirmation before it continues communication. If, however, the remote certificate is unknown, Syncany will ask the user what to do (if that is implemented in the plugin).

The trust store format is in the **Java Key Store** (JKS) format. No password is used to protect the key store. To analyze this file and its entries, you may use the ``keytool`` util.
