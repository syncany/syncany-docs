Installation
============
Syncany is written in pure Java, so it available on a number of platforms. To make the installation process as easy as possible, we've pre-bundled distributables for most major operating systems (a Mac OSX bundle is still missing, see `issue #34 <https://github.com/syncany/syncany/issues/34>`_). Whenever we release a new version of Syncany, we regenerate these bundles and publish them on the `distribution site <https://www.syncany.org/dist>`_.

On that site, you can find **releases** and **snapshots**. Releases are built and published in a certain release cycle (currently: 2 weeks), and snapshots are built with every commit. Feel free to try out both, but be aware that snapshots are very volatile and things might break without warning.

Installation requirements
-------------------------
Since Syncany heavily relies on Java, you obviously need an up-to-date version of Java installed. And that is about it. No other requirements. 

* **Java/JRE >= 7**. Follow the directions on the `Oracle Website <java.com/download>`_ to install Java.
* That's it.

Installing the latest release
-----------------------------

Windows
^^^^^^^
On Windows, you can either manually extract the Syncany files from the ZIP archive, or use the installer. The latter is obviously more comfortable, but both variants have their reasons. 

The installation using the Windows installer is easy and very similar to the installation of other applications. 

1. Download the latest release from the `distribution site <https://www.syncany.org/dist>`_ (see folder *releases*). The installer files have the *.exe* ending. You can't miss it.
2. Then run the executable and follow the instructions. 
3. After the installation, open the command prompt and type ``sy``.

When you run the executable, you'll see a typical installer that looks something like that:

.. image:: _static/installation_windows.png
   :align: center
   
Other than where to install Syncany, the installer will only give you two additional options. **If you are not sure what they mean, don't change them.**

* **Add Syncany to PATH environment variable (recommended)**: If you're unsure, leave this as is. For Syncany to be available on the command line, the command line will have to know where to look for it. If this option is unchecked, the ``sy`` and ``syd`` command will not be available unless the installation path is added to the PATH environment variable.

* **Set JAVA_HOME environment variable (recommended)**: If you're unsure, leave this as is. Syncany relies on the Java Runtime Environment (JRE) and this variable tells the Syncany commands where to look for it. 

After the installation is complete, open the command prompt by typing ``cmd`` in the Windows search box, or by navigating to *Extras*, *Command Prompt* in the menu. If everything goes well, you'll see this after typing ``sy -v``:

.. image:: _static/installation_windows_cmd.png
   :align: center
   

Debian/Ubuntu
^^^^^^^^^^^^^

Arch Linux
^^^^^^^^^^


Other operating systems
^^^^^^^^^^^^^^^^^^^^^^^
Mac OSX

Installing 
