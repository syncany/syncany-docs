Plugins
=======
Plugins extend the Syncany functionality is different ways. As of today, there are two types of plugins:

- **Transfer plugins** (also: connection / storage plugins) give Syncany the ability to use a certain storage protocol or storage provider to store its repository files. Already implemented examples include FTP, SFTP, Samba or Amazon S3. 
- **Web interface plugins** implement a web frontend for Syncany. 

By default, only the *local* plugin is installed. 

.. contents::

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

Plugins are generally installed to the user specific Syncany plugin folder. On Windows, this folder can be found at ``%AppData%%\Syncany\plugins\lib``, on Linux it can be found at ``~/.config/syncany/plugins/lib``. Installing a plugin is nothing more than placing the plugin JAR file in that folder. If you have trouble removing a plugin, simply delete it manually from that folder.
		
Plugin Configuration
--------------------
Some plugins may want to store per-user config settings or persist some user specific state. The SFTP plugin, for instance, stores the known hosts file for all the known and trusted hosts. Other plugins might want to store other information.

This per-user plugin configuration can be found at ~/.config/syncany/plugins/lib and ~/.config/syncany/plugins/<plugin-id>/.

Transfer Plugins
----------------
- Transfer settings in config.xml

Local Plugin
^^^^^^^^^^^^
.. code-block:: xml

	<config xmlns="http://syncany.org/config/1">
		...
		<connection type="local">
			<property name="path">/tmp/tx/c</property>
		</connection>
	</config>


Amazon S3 Plugin
^^^^^^^^^^^^^^^^

FTP Plugin
^^^^^^^^^^

SFTP Plugin
^^^^^^^^^^^

WebDAV Plugin
^^^^^^^^^^^^^

Samba Plugin
^^^^^^^^^^^^


Web Interface Plugins
---------------------

If installed, the web interface can be accessed at https://localhost:8443 (default configuration).
See :ref:`configuration_daemon`.

Simple Web Interface Plugin
^^^^^^^^^^^^^^^^^^^^^^^^^^^
