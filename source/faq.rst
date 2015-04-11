FAQ
===
We generally talk a lot about Syncany, and whenever we explain the idea, people tend to ask the same questions. Here are a few of them -- hopefully with satisfying answers.

.. contents::

What is Syncany?
----------------
Syncany is open source Dropbox-like file sync tool. It syncs files between computers either manually or automatically. Users can define certain folders of their computers and keep this folder in sync with friends. 

So what make Syncany **awesome**?

- Use-your-own storage (FTP, S3, WebDAV, NFS, Samba/Windows file share, ...)
- Files are encrypted before upload (don't trust anybody but yourself)
- Files are `deduplicated <http://en.wikipedia.org/wiki/Data_deduplication>`_ locally (massive space savings on remote storage)

What Syncany is **not**:

- A service. You don't pay for it. You don't get storage from us. 
- Usable for critical files. It's alpha software. Don't do it!
- A large network of interconnected machines. You can't share folders with strangers. You must trust the persons you share files with.
- A fully fledged version control system. 

Why make something new? Why not use Dropbox/rsync/etc.? How is it different from X?
-----------------------------------------------------------------------------------
If there were something like Syncany, we wouldn't be developing it. There are a few alternatives, but they all have a different focus, are not open source, have no versioning, cannot use arbitrary storage or don't encrypt locally. As far as we know, no tool has this exact feature set.

Let's pick the normal contenders: Dropbox, Wuala, SparkleShare, BitTorrent Sync, ownCloud, rsync, SyncThing.

And here's how to filter them out: Dropbox, Wuala, and BitTorrent Sync are not open source, ownCloud, rsync and Ubuntu One don't support encryption. SyncThing is bound to the peer2peer concept.

Is there an App/Web-App/GUI for it?
-----------------------------------
Yes! You can install it using ``sy plugin install gui``.

There is an outdated (and currently broken) `proof of concept web interface <https://github.com/syncany/syncany-plugin-simpleweb>`_.

When will it be available? When is the release date?
----------------------------------------------------
We don't promise anything, because this is a spare time project. We are slowly moving towards beta and after that it will be a lot of testing before we can remove the beta label. 

How can I help?
---------------
If you're a developer, try out the code, review it and contact us on GitHub if you want to help. Check out the `issues <https://github.com/syncany/syncany/issues?state=open>`_ to find out more. Check out `the wiki page <https://github.com/syncany/syncany/wiki>`_ for more ways to help.

Does it support multiple users?
-------------------------------
You can connect to a single repo from many different machines, but there is no role concept or access control for users. All users have the same rights, meaning there is no administrator and once a user is connected he or she can easily delete all repo data if they want to.

Does it work on Windows/Linux/Mac?
----------------------------------
The majority of Syncany developers work on Linux, but we are also testing it on Windows. We've done short cross-platform tests and it seems to work okay. We'll test that even more in the future.

Why is it written in Java?
--------------------------
That's easy: Because we speak Java!

Can you write a plugin for X?
-----------------------------
People often ask about plugins for other storage backend -- examples include Hazelcast, OpenStack Swift, Box.net, Amazon Cloud Drive, etc. 

We're currently concentrating on the core functionality -- so plugins are not very high on the list. However, plugins are very easy to develop; just 200 lines of code or so... :-)﻿ If you want, you can of course develop the plugin yourself. 

Plugins can be independently developed and deployed in other repos.

What shouldn't I use Syncany for?
---------------------------------
Here are some things Syncany isn't good at, and things you shouldn't use Syncany for:

- **Critical files**: At the moment, **do not use Syncany for critical files**. The software is still alpha software! 
- **Low CPU environments**: Syncany uses up quite a bit of CPU power when it is indexing files. So in general, any situation where the client has little computation power.

Can I use Syncany to sync two unencrypted folders? Can I mirror two folders?
----------------------------------------------------------------------------
No this is not possible. Syncany stores data in a packed repository form. While this might seem as a disadvantage at first, it makes great things possible:

- Save space: Using the deduplication mechanisms in Syncany, you can save a lot of remote storage space (>90% space savings)
- File versioning: Syncany versions files, so if you overwrite or lose a file, you can restore it very easily
- Huge files: Syncany splits files into chunks, so it doesn't matter how large the original file is.

To sync two folders directly, you can use rsync or Unison.
