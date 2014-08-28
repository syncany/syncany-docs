Security
========
**WORK IN PROGRESS: This is a work in progress. We are currently just copying relevant content in the corresponding chapters, and sorting stuff out. Feel free to contribute!**

Syncany takes security very seriously. Our goal is to protect the confidentiality of user data stored on remote servers -- meaning that whatever leaves the local computer is encrypted. This chapter explains the **security concepts** of Syncany to the interested user in a hopefully understandable way. Due to the complexity of the subject, however, this is a rather technical chapter. If you just want to use Syncany, **you can safely skip this chapter**. 

.. contents::
   :depth: 3
   
Prologue
--------
Although we take special care designing and implementing the security-related parts of Syncany, we are not cryptographers. We have have asked multiple parties to peer review our concept and implementation, and we hereby do that again: **Please review our security concepts and implementation!** If you believe that any of the concepts and/or the implementation is incorrect, insecure or can be attacked, please let us know `by creating a new issue <https://github.com/syncany/syncany/issues>`_.

Security Assumptions
--------------------
Syncany's central security goal is to protect the user's data against attacks on **confidentiality** and **integrity**. Syncany provides data confidentiality and detects attacks on the integrity of data, but does not provide mechanisms to protect against attacks on the availability of data. 

1. Syncany assumes the **storage provider and network infrastructure cannot be trusted**. 
2. In contrast to that, Syncany assumes that the **local machine is secure**.
3. Users sharing a repository **trust each other completely**.

Security Concepts
-----------------
There are two security/cryptography-related topics in Syncany:

1. **Pre-upload encryption**: Before uploading anything to the offsite storage, Syncany encrypts files locally. This is done for metadata (database files) and for the actual data (multichunk files). The ciphers and modes as well as the resulting crypto file format is described in :ref:`security_encryption`.
2. **Auth-only and HTTPS-only daemon/server**: Accessing the daemon API or web interface is HTTPS-only using either self-signed or your own certificates; and allows only authenticated users. Details are described in :ref:`security_daemon`.

.. _security_encryption:

File Encryption
^^^^^^^^^^^^^^^   
For users to share a repository with Syncany, they must trust each other completely: They share the pre-shared **repository password** to access the Syncany repository and use the same credentials to the offsite storage. 

When a user creates a new repository using ``sy init``, Syncany asks the user for the repository password. This password is used to derive a 64-bit **master key** using PBKDF2 with 1 million rounds and a 64-bit random **master salt**. The master key is stored locally in the ``config.xml`` file (see :ref:`configuration_config_xml`) -- since the local machine is trusted, it is not encrypted. The master salt is stored in plaintext locally and on the offsite storage in the ``master`` file.

The master key is not used to encrypt anything itself. Instead, 

.. image:: _static/security_crypto_example.png
   :align: center
   :scale: 80%


As of today, Syncany's encryption scheme is entirely base don symmetric cryptography. 

Syncany uses symm
files:
- encrypt all files
- no directory structure exposed



Crypto File Format
""""""""""""""""""

.. image:: _static/security_crypto_format.png
   :align: center

metadata protection

Crypto Algorithms and Parameters
""""""""""""""""""""""""""""""""
- Users of a shared folder (= repository) share a password
- Input parameters: Password string, list of cipher specs (e.g. AES/GCM/NoPadding, 128 bit)
- The user password is used to derive one symmetric key per cipher using PBKDF2 (12 byte salt, 1 million rounds)
- The derived symmetric key(s) are used to encrypt files; each key is reused in max. 100 files (~ 200 MB)
- Cipher algorithms are configurable, but not every cipher is allowed:
  only AES and Twofish (128/256 bit), only authenticated modes (as of now only GCM; no ECB, CBC, etc.)
- Ciphers are initialized with a random initialization vector (IV), IVs are never re-used
- Multiple cipher algorithms can be nested/chained (1-n ciphers), e.g. AES-128 and Twofish-256
- Cipher configurations, IVs and salts are authenticated with an HMAC-SHA256

- Master key: PBKDF2 with 1MM round, random 512 bit salt
- HKDF: Derive key from master key ...
- AES/GCM + Twofish/GCM for multichunk/chunk
- RSA 2048-bit keypair for self-signed certificates (web frontend and REST/WS interface)

IVs are definitely never reused. Syncany only compares chunk checksums with one another, and it only does that on the clients. No calculation is or can be done on the server, since the server is just a dumb storage (FTP, etc.). A new file is broken into chunks and these chunks are then compared to the local database (chunk exists -> store reference, chunk does not exist -> store chunk data in new multichunk). 
   





.. _security_daemon:

HTTPS-only Daemon
^^^^^^^^^^^^^^^^^

daemon API




Threat Models
-------------

Eavesdropping the data transfer 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- Syncany cannot prevent the leakage of information about the frequency of downloads/uploads and the amount of data transferred by clients (e.g. through FTP logs). 


Provider-originated attacks
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Attacks on data confidentiality
"""""""""""""""""""""""""""""""

Attacks on data integrity
"""""""""""""""""""""""""

Attacks on data availability
""""""""""""""""""""""""""""
Syncany provides no measures to ensure data availability: (a) both provider and other trusted users (with storage credentials) may detectably alter or even delete encrypted files on the remote storage. (b) Also, an attacker with storage access may alter the master salt (stored in the clear, obviously) to prevent new clients from connecting to the repository.

Social engineering
^^^^^^^^^^^^^^^^^^
Syncany can furthermore not prevent or detect if the master key or password has been stolen or was used by an adversary. 

Known Issues and Limitations
----------------------------   
- As of today, neither the master key nor the password can be changed. See `issue 150 <https://github.com/syncany/syncany/issues/150>`_.
