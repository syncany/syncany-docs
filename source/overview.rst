General Overview
================

How does it work?
-----------------            
Syncany breaks files into chunks, then packages those chunks into multichunks, compresses and encrypts those multichunks, and then uploads these multichunks. Metadata such as filenames and permissions is written to XML-based database files, and then compressed/encrypted with the same scheme.

Manual syncing: CLI mode
------------------------

.. _overview_daemon:

Automatic syncing: Daemon mode
------------------------------

