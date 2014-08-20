What is Syncany?
================

Syncany is an open source Dropbox-like file sync tool. It synchronizes files and folders between computers either manually or automatically. Users can define certain folders on their machine and keep them in sync with friends or colleagues. 

So what makes Syncany **awesome**?

* Automatic/continuous file synchronization
* Use-your-own storage (FTP, S3, WebDAV, NFS, Samba/Windows file share, ...)
* Files are encrypted before upload (don't trust anybody but yourself)
* Files are `deduplicated <http://en.wikipedia.org/wiki/Data_deduplication>`_ locally (massive space savings on remote storage)
* Files are intelligently versioned (restoring old versions or deleted files is easy)

**Excited yet? Ready to learn more?**

Syncany takes the idea of a Dropbox-like continuous file synchronization and applies it to the real world: It makes use of the storage that is *available* rather than being bound to a certain protocol or backend a certain provider is offering. **With a simple plugin-based storage system, Syncany can turn almost anything into a usable backend storage**. Right now, it can use folders on an FTP or SFTP storage, WebDAV or Samba shares and Amazon S3 buckets, but that's just the beginning. Because it's so easy to implement plugins, more are definitely coming. Even things like using IMAP folders or Flickr's free 1 TB of image data could be used to store your data.

Besides its incredible flexibilty in terms of storage, Syncany is also a very privacy-aware software: **User data never leaves the local machine without being encrypted**. Data confidentiality and user privacy are the taken very seriously -- 128-bit AES+Twofish/GCM encryption is built-in by default.

Combining these two features makes Syncany really awesome: You can use all of the free storage that the Internet gives you (Google Drive, OneDrive, etc.) to share your files, but you don't have to worry about your privacy. Syncany takes care of encryption before files are uploaded.

Let's look at a simple example:

.. image:: _static/introduction_example.png
   :align: center



xxxxxxxxxxxxxx


a world in which people do not want to send their data to a central provider, and they do not trust the provider to 

Syncany is is for those out there that don't trust the providers of online storage with their data. For people that are afraid of what sysadmins and other interested parties might do with their data. And it's for people who would love to use all the free storage that the Internet provides without having to give up to any privacy. 

The idea behind Syncany is pretty simple: 


make a `file sync <http://en.wikipedia.org/wiki/File_synchronization>`_ software that allows you to easily exchange files with friends or colleagues -- but avoid being bound to a central provider, or any kind of active central system for that matter. Syncany is supposed to be as easy to use as software like Dropbox, but have the advantage of using any kind of storage you can imagine. So, instead of having an active central component with its own proprietary protocol, Syncany is built to work with regular "dumb" storage like FTP, Samba, SFTP, Amazon S3, and so on. 

That makes it incredibly flexible: You can use all of the free storage that the Internet gives you (Google Drive, OneDrive, etc.) to share your files, but you don't have to worry about your privacy. Syncany takes care of encryption before files are uploaded.



Target audience: Who needs it?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The target audience for Syncany is not the usual *cloud user*, but rather at the more privacy-aware user. xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Syncany is is for those out there that don't trust the providers of online storage with their data. For people that are afraid of what sysadmins and other interested parties might do with their data. And it's for people who would love to use all the free storage that the Internet provides without having to give up to any privacy. 


What Syncany is **not**
^^^^^^^^^^^^^^^^^^^^^^^
* A service. You don't pay for it. You don't get storage from us. 
* Usable for critical files yet. It's alpha software. Don't do it!
* A large network of interconnected machines. You can't share folders with strangers. You must trust the persons you share files with.
* A fully fledged version control system. 


Requirements: What do I need?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Do you have some spare storage you 
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


Use Case 1: Friends sharing files 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Pim, Philipp and Steffen want to share a folder. Pim has an FTP account at a random hosting company and can spare some storage space. Since they do not want the hosting company (or any other third parties) to have access to their files, they can use Syncany to turn that FTP folder without having to worry about manually encrypting or versioning their files.

((( some sort of diagram )))


Use Case 2: Sharing in a company
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

With server + web interface
