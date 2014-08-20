What is Syncany?
================

Syncany is not a *file sync* tool. Not really anyway. It's not a *versioning* tool either. Well, at least not entirely. And it's also not a *backup* tool. It's sort of *all of them combined*. With *encryption*. Confused yet? Let me explain. Syncany solves a very particular need: It offers users a way to share files in a Dropbox-like continuous-sync type of way, use any type of storage for it and at the same time don't have to trust the provider offering that storage. 

* **Storage freedom**: So instead of signing up for a service and hoping that it'll still be there in a year or two, you choose where you want to store your data. You don't just choose the server, you choose the type of storage you want to use -- be it FTP, Samba, SFTP, Amazon S3, or others.
* **Respect your privacy**: And instead of hoping that the provider's admin or other parties don't take a peak at your data, you make sure that your data stays confidential -- by encrypting it locally before it's uploaded.

XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX WORK IN PROGRESS

With normal syncing tools, you are either bound to a provider, bound to a certain type of storage/protocol or you have to trust the underlying storage provider. Syncany is different. Syncany lets you choose where you want to store your data, and it 

The original idea behind Syncany is pretty simple: make a `file sync <http://en.wikipedia.org/wiki/File_synchronization>`_ software that allows you to easily exchange files with friends or colleagues -- but avoid being bound to a central provider, or any kind of active central system for that matter, and make sure that your privacy is protected. Syncany's goal is to be as easy to use as Dropbox, but have the advantage of using any kind of storage you can imagine. So, instead of having an active central component with its own proprietary protocol, Syncany is built to work with regular `"dumb" storage <http://en.wikipedia.org/wiki/Storage_as_a_service>`_ like FTP, Samba, SFTP, Amazon S3, and so on.

Up to this point, the feature set sounds really nice, but it still didn't quite cut it for me: instead of just synchronizing the current state of a folder, I wanted to add <a href="http://en.wikipedia.org/wiki/Revision_control">versioning</a> capabilities, so that one could restore older versions of a file or use Syncany as backup tool with incremental backups. If you're familiar with version control systems like SVN or Git, that's pretty much what I wanted for Syncany. So in the end, one could either use Syncany to share a common folder with a friend and occasionally restore a file, or one could use it to backup his or her files to "the cloud" (<i>I still don't like saying "the cloud", still sounds like a buzz word to me</i>). To realize the versioning capabilities and save remote disk space at the same time, I decided to use a technique called <a href="http://en.wikipedia.org/wiki/Data_deduplication">data deduplication</a>. Deduplication is widely used in enterprise-size backup solutions to save disk space, but it is quite uncommon for desktop applications. In a nutshell, deduplication breaks files into many data chunks (each about 8-32 KB in size) and keeps track of which chunks make up the contents of a file. Each chunk is only stored once on the remote storage, even if it appears hundreds of times on the local disk -- thus saving ridiculous amounts of megabytes or even gigabytes. And remember, if you're using Amazon S3 or any other paid storage, gigabytes equal monthly payments.

The problem with having so many storage options is that when you use a commercial storage provider like Amazon S3 or Google Storage, you never know who's going to look at your data, or if your data is going to end up on a flash drive of an overly interested employee. Having these concerns about the long-term confidentiality of cloud storage and the providers' trustworthiness, it was pretty obvious that files needed to be <a href="http://en.wikipedia.org/wiki/Encryption">encrypted</a> <i>before</i> they were uploaded. This, of course, did not make things any easier!

When you add all these features to the "pretty simple" idea from above, you suddenly get something that sounds a little less simple: Syncany became a <b>client-side encrypted, deduplicated, storage-abstracted, multi-client file synchronization software with versioning capabilities</b>. Pretty long and fancy-sounding phrase -- now just imagine what it means to actually combine these technologies into one piece of working software?

Recaping the list of requirements so far, Syncany would have the following features:

- Continuous file synchronzation between multiple clients
- Use your own and any type of storage (no installation on the server needed)
- Client-side encryption of data
- Minimal remote storage usage through deduplication
- File versioning on chunk-level

XXXXXXXXXXXXXXXXXXX WORK IN PROGRESS









Syncany is not a file sync tool. Not really anyway. It's not a versioning tool either. Not a real one anyway. And it's also not a backup tool. It's sort of all of them combined. With encryption. Confused yet? Let me explain. Syncany solves a very particular need: A group of users want to share files in a Dropbox-like continuous-sync fashion. They have some storage lying around -- say an FTP folder or a Samba share -- but they don't trust the storage provider with their data. 

This is where Syncany comes in: With normal syncing tools, you are either bound to a provider, bound to a certain type of storage/protocol or you have to trust the underlying storage provider. Syncany is incredibly flexible in terms of storage and provides client-side encryption out-of-the-box and enabled by default. And to top it all of, it offers smart file versioning and storage space reduction techniques through data deduplication. To sum this all up: **Syncany is a client-side encrypted, deduplicated, storage-abstracted, multi-client file synchronization software with versioning capabilities**. 

That means it offers:

- Continuous file synchronzation between multiple clients
- Use your own and any type of storage (no installation on the server needed)
- Client-side encryption of data
- Minimal remote storage usage through deduplication
- File versioning on chunk-level


The original idea behind Syncany is pretty simple: make a `file sync <http://en.wikipedia.org/wiki/File_synchronization>`_ software that allows you to easily exchange files with friends or colleagues -- but avoid being bound to a central provider, or any kind of active central system for that matter. Syncany is supposed to be as easy to use as software like Dropbox, but have the advantage of using any kind of storage you can imagine. So, instead of having an active central component with its own proprietary protocol, Syncany is built to work with regular `"dumb" storage <http://en.wikipedia.org/wiki/Storage_as_a_service>`_ like FTP, Samba, SFTP, Amazon S3, and so on.

Up to this point, the feature set sounds really nice, but it still didn't quite cut it for me: instead of just synchronizing the current state of a folder, I wanted to add <a href="http://en.wikipedia.org/wiki/Revision_control">versioning</a> capabilities, so that one could restore older versions of a file or use Syncany as backup tool with incremental backups. If you're familiar with version control systems like SVN or Git, that's pretty much what I wanted for Syncany. So in the end, one could either use Syncany to share a common folder with a friend and occasionally restore a file, or one could use it to backup his or her files to "the cloud" (<i>I still don't like saying "the cloud", still sounds like a buzz word to me</i>). To realize the versioning capabilities and save remote disk space at the same time, I decided to use a technique called <a href="http://en.wikipedia.org/wiki/Data_deduplication">data deduplication</a>. Deduplication is widely used in enterprise-size backup solutions to save disk space, but it is quite uncommon for desktop applications. In a nutshell, deduplication breaks files into many data chunks (each about 8-32 KB in size) and keeps track of which chunks make up the contents of a file. Each chunk is only stored once on the remote storage, even if it appears hundreds of times on the local disk -- thus saving ridiculous amounts of megabytes or even gigabytes. And remember, if you're using Amazon S3 or any other paid storage, gigabytes equal monthly payments.

The problem with having so many storage options is that when you use a commercial storage provider like Amazon S3 or Google Storage, you never know who's going to look at your data, or if your data is going to end up on a flash drive of an overly interested employee. Having these concerns about the long-term confidentiality of cloud storage and the providers' trustworthiness, it was pretty obvious that files needed to be <a href="http://en.wikipedia.org/wiki/Encryption">encrypted</a> <i>before</i> they were uploaded. This, of course, did not make things any easier!

When you add all these features to the "pretty simple" idea from above, you suddenly get something that sounds a little less simple: Syncany became a <b>client-side encrypted, deduplicated, storage-abstracted, multi-client file synchronization software with versioning capabilities</b>. Pretty long and fancy-sounding phrase -- now just imagine what it means to actually combine these technologies into one piece of working software?

Recaping the list of requirements so far, Syncany would have the following features:

- Continuous file synchronzation between multiple clients
- Use your own and any type of storage (no installation on the server needed)
- Client-side encryption of data
- Minimal remote storage usage through deduplication
- File versioning on chunk-level

Even though this already sounds pretty great, my list of requirements for the initial version of Syncany didn't stop here. I really wanted to make it easy-to-use for everybody -- which meant that a simple command line tool wasn't enough! To make it usable by the average user, a little bit of <a href="http://en.wiktionary.org/wiki/Klickibunti">Klickibunti</a> was necessary -- so basically a graphical user interface. 

In my mind, a user interface for Syncany must consist of two things: First, a user must be able to set up a repository using an easy-to-use wizard. Ideally, he or she does not have to manually edit configuration files or do other complicated things to create a new repository or connect to an existing one. Instead, I believe that a guided step-by-step is the way to go. 

Second, the user must be informed about the current state of the file synchronization -- meaning that there must be an integration in the file manager, e.g. using green/blue/red indicator icons next to the files and a tray icon showing the overall progress. I already developed something like this <b>back in May 2011</b>. There are a few screenshots here to illustrate what I just described:

<div class="imageset"><a href="http://blog.philippheckel.com/wp-content/uploads/2013/10/nautilus_plugin.png" data-lightbox="syncany2011"><img height="207" src="http://blog.philippheckel.com/wp-content/uploads/2013/10/nautilus_plugin-300x231.png" /></a> <a href="http://blog.philippheckel.com/wp-content/uploads/2013/10/nautilus_restore.png" data-lightbox="syncany2011"><img src="http://blog.philippheckel.com/wp-content/uploads/2013/10/nautilus_restore-300x207.png" /></a></div>

Adding up these features, I ended up with an additional three major things to do:

<ul>
 <li>Step-by-step repository setup wizard</li>
 <li>Platform-specific file manager integration (for Windows/Mac/Linux)</li>
 <li>File system watching to react on changes</li>
</ul>

Even in the first iteration of Syncany, I wanted to fit all these features into the software. And let's be honest: You don't have to be a genius to see that these are a lot of big time requirements. Putting all that together meant combining many more or less complex ideas. 

As you might have guessed, I think that's where it all went a little wrong.




Target audience: Who needs it?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The target audience for Syncany is not the usual *cloud user*, but rather at the more privacy-aware user. xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


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
