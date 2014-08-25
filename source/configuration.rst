Configuration
=============
Syncany differentiates between three types of configuration:

- **Managed Folder Config**: Each folder that is synchronized and managed by Syncany contains a ``.syncany/config.xml`` file. This file defines the per-folder config options such as the backend storage credentials or the machine name.
- **User Config**: The user config defines central settings valid only for the logged in user. Examples include the proxy configuration or the standby settings.
- **Daemon Config**: The daemon config contains which Syncany folders are managed by the background daemon, and where the web frontend and REST/WS API is running.

Syncany stores the managed folder configuration options in `.syncany` of the synchronized folder, and other general user-specific configurations (such as the user and daemon config) in ``%AppData%\Syncany\`` or ``~/.config/syncany/``. 

.. contents::

Managed Folder Configuration (``config.xml``)
---------------------------------------------

Common Settings and Storage Connection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. code-block:: xml

	<config xmlns="http://syncany.org/config/1">
		<machinename>PCiqLdSQiampovfBfSZZ</machinename>
		<displayname>pheckel</displayname>
		<connection type="local">
			<property name="path">/tmp/tx/c</property>
		</connection>
	</config>

Excluding/Ignoring Files and Folders
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``.syignore``

::

	*.bak
	*.tmp
	.git
	regex:files/[0-9a-f]+


User Configuration (``userconfig.xml``)
---------------------------------------

Prevent standby/hibernate
^^^^^^^^^^^^^^^^^^^^^^^^^

To make sure that your workstation doesn't go into standby/hibernate while Syncany is uploading/downloading changes, the `userconfig.xml` needs to contain the following setting:

.. code-block:: xml

	<preventStandby>true</preventStandby>

Add proxy configuration
^^^^^^^^^^^^^^^^^^^^^^^
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

Daemon Configuration (``daemon.xml``)
-------------------------------------
The main purpose of the daemon configuration is to tell the Syncany daemon (started by ``syd start``) what folders should be monitored and automatically synced whenever something changes. 

Simple Daemon Config Example
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
---------------------

Private Keys
^^^^^^^^^^^^

- keystore.jks	

.. _configuration_truststore:

Trusted Certificates
^^^^^^^^^^^^^^^^^^^^
Syncany maintains a user-specific trust store of trusted X.509 certificates at ``~/.config/syncany/truststore.jks`` (Linux) or ``%AppData\Syncany\truststore.jks`` (Windows). This trust store is mainly used by plugins that communicate via SSL/TLS (such as the :ref:`WebDAV plugin <plugin_webdav>`). 

Syncany trusts all SSL/TLS certificates in this trust store: When a connection to this store is opened, Syncany will not ask for user confirmation before it continues communication. If, however, the remote certificate is unknown, Syncany will ask the user what to do (if that is implemented in the plugin).

The trust store format is in the **Java Key Store** (JKS) format. No password is used to protect the key store. To analyze this file and its entries, you may use the ``keytool`` util.
