Concepts
========

**WORK IN PROGRESS: This is a work in progress. We are currently just copying relevant content in the corresponding chapters, and sorting stuff out. Feel free to contribute!**

This chapter explains the basic concepts of Syncany to the interested user in a hopefully understandable way. If you just want to use Syncany and don't care how it ticks inside, **you can safely skip this chapter**. 

Our Philosophy
--------------
TODO

The Magic behind it
-------------------          
Syncany breaks files into chunks, then packages those chunks into multichunks, compresses and encrypts those multichunks, and then uploads these multichunks. Metadata such as filenames and permissions is written to XML-based database files, and then compressed/encrypted with the same scheme.

.. image:: _static/overview_chunking.png
   :align: center
   
Comparing it to others
---------------------- 

Differences and similarities to other tools
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
As stated in other posts, the fundamental idea of the Syncany software architecture is a mixture between a version control system like `Git <http://git-scm.com/>`_, `SVN <http://subversion.apache.org/>`_ or `Bazaar <http://bazaar.canonical.com/en/>`_, a file synchronization software like `rsync <http://rsync.samba.org/>`_ or `Unison <http://www.cis.upenn.edu/~bcpierce/unison/>`_, and crypto software such as `GPG <http://www.gnupg.org/>`_. 

Like in a **version control system** (VCS), Syncany keeps track of the files in a certain folder using metadata about these files (size, last modified date, checksum, etc.). It manages different versions of a file, detects if a file has been moved or changed and adds a new file version if it has. Like version control systems, Syncany knows a concept similar to a "commit", i.e. a collection of changes the local files that are uploaded to the central repository. In other ways, however, it is also very different: In contrast to Git and its friends, Syncany does not support the full range of commands that regular VCS do. For instance, there is no explicit branching or merging, no tagging and diffing. Instead, Syncany has only one trunk/master and auto-resolves conflicts when they occur (much like `Dropbox <http://www.dropbox.com/>`_ does). Unlike most VCS, Syncany does not focus on text-based files, but treats all files the same (large/small, binary/text). In addition, Syncany is not limited to one or two transport protocols, but can be easily extended to many more. 

The similarities to **file sync software** are quite obvious: Syncany must tackle the `file synchronization problem <http://blog.philippheckel.com/2013/05/20/minimizing-remote-storage-usage-and-synchronization-time-using-deduplication-and-multichunking-syncany-as-an-example/2/#Synchronization-Software>`_, i.e. the problem of keeping multiple replicas of a file set in sync. Much like the widely popular rsync, Syncany compares the local files to the remote copy (or at least its metadata) using date/time/size and checksums of both whole files and parts of files, and then transfers only the changed parts to the remote location. Like rsync, Syncany tries to minimize the individual upload/download requests (and the corresponding network latency) by grouping these changes into bigger blocks. However, while rsync does that by actively gathering the file stats on the remote system, Syncany only uses the downloaded metadata, i.e. using dumb storage is possible. 

Unlike any of the above mentioned tools, Syncany is **built with and around cryptography** and takes confidentiality and data integrity very seriously: Syncany generally assumes that everything but your local machine can be monitored/eavesdropped by others which is why it encrypts all data locally before uploading. As of now, Syncany only supports password-based symmetric key encryption based on configurable ciphers. By default, it uses 128 bit AES and Twofish, both in the authenticated GCM mode, but basically can support anything that Java and the Bouncy Castle crypto provider have to offer.

Comparison Matrix
^^^^^^^^^^^^^^^^^
We don't pretend that we're the only ones doing this. Nowadays, there are so many sync tools that it's hard to keep track of what differentiates them. This is an attempt to compare the sync tool *as objectively as possible*. Given that we wrote Syncany, our views are certainly a bit subjective, but we try to keep that at a minimum.

+----------------------+------------+------------+----------+-----------+--------------+--------------------------+------+
| Software             | File Mgr.  | Version.   | Encr.    | Any Prov. | Clients      | Backend                  | Lic. |
+======================+============+============+==========+===========+==============+==========================+======+
| Dropbox              | yes        | part. [1]_ | \-       | \-        | D/M/W/C      | prov.-owned              | P    |
+----------------------+------------+------------+----------+-----------+--------------+--------------------------+------+
| Seafile              | ?          | ?          | yes [2]_ | ?         | ?            | Seafile server           | O    |
+----------------------+------------+------------+----------+-----------+--------------+--------------------------+------+
| SparkleShare         | yes        | yes        | \-       | ?         | D/M/-/C      | Git server               | O    |
+----------------------+------------+------------+----------+-----------+--------------+--------------------------+------+
| SpiderOak            | \-         | part.      | yes      | ?         | ?            | prov.-owned              | P    |
+----------------------+------------+------------+----------+-----------+--------------+--------------------------+------+
| Syncany              | \-         | yes        | yes      | yes       | -/-/-/C      | S3, (S)FTP, [3]_         | P    |
+----------------------+------------+------------+----------+-----------+--------------+--------------------------+------+
| git-annex            | \-         | yes        | yes      | yes       | ?/?/?/C      | Git server               | O    |
+----------------------+------------+------------+----------+-----------+--------------+--------------------------+------+

**D** = Desktop client, **M** = Mobile client, **W** = Web client, **C** = Command line client   
**O** = Open source license, **P** = Proprietary

.. [1] Basic filename-based versioning, i.e. new filename means new file history. If files are moved or renamed, the history is lost   
.. [2] Security of Seafile is not great as *many* security issues prove (see below).
.. [3] Syncany storage backends are extensible   

|

Dropbox
"""""""
Dropbox is mother of them all. Dropbox is a file sync tool with a proprietary server component. It provides various clients on different platforms (mobile, web, desktop) as well as an API. Backend and clients are proprietary (exception: The Dropbox Nautilus extension is open source). Users can share links and folders among each other. User data is not encrypted before the upload.

**Syncany is superior because ...**

- Syncany is open source
- Syncany encrypts data before upload (strong crypto focus!)
- Syncany doesn't need an intelligent server instance, dumb storage is sufficient
- Syncany doesn't rely on a single provider and storage backend (any storage backend possible)

**Dropbox is superior because ...**

- Syncany does not allow sharing links with friends (as of now, in development)
- Syncany has no web/desktop/mobile clients yet

Seafile
"""""""

**Difference to Syncany**

- Syncany doesn't rely on a single provider and storage backend (any storage backend possible)
- Syncany doesn't need an intelligent server instance, dumb storage is sufficient
- Syncany does not allow sharing links with friends (as of now, in development)
- Syncany has no web/desktop/mobile clients yet
- Seafile has a `rather <https://github.com/haiwen/seafile/issues/714>`_ `bad <https://github.com/haiwen/ccnet/issues/35>`_, `security <https://github.com/haiwen/seafile/issues/587>`_, `record <https://github.com/haiwen/seafile/issues/350>`_

    

SparkleShare
""""""""""""
TODO


Others
""""""
Of course the comparison is not complete. From the top of my head, the following other solutions come to mind. If you know things about them, please feel free to edit this page

* Tahoe-LAFS 
* rsync
* Unison


   
