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

Encryption Schema
^^^^^^^^^^^^^^^^^
For users to share a repository with Syncany, they must trust each other completely: They share the pre-shared **repository password** to access the Syncany repository and use the same credentials to the offsite storage. 

Repository Initialization
"""""""""""""""""""""""""
When a user creates a new repository using ``sy init``, Syncany asks the user for the repository password. This password is used to derive a 64-bit **master key** using PBKDF2 with 1 million rounds and a 64-bit random **master salt** (1-4). The master key is stored locally in the ``config.xml`` file (see :ref:`configuration_config_xml`) -- since the local machine is trusted, it is not encrypted. The master salt is stored in plaintext locally (although it is not needed) and on the offsite storage in the ``master`` file.  Since the master salt must be public for when other clients connect to the repository, the ``master`` file is not encrypted. 

Encrypting new Files
""""""""""""""""""""
Whenever new files have to be uploaded, Syncany encrypts these files with **128-bit AES/GCM and Twofish/GCM** using the crypto scheme and file format described below (8-21). File encryption happens with every file that is uploaded (except the ``master`` file): For instance, during the file index process in ``sy up``, Syncany packages new/unknown chunks into multichunks (= ZIP files containing many chunks) and creates a new database file (= metadata). These files are encrypted using the the following scheme:

In the default configuration, Syncany uses two nested ciphers: It uses AES in GCM mode to encrypt the actual plaintext, and then encrypts the AES ciphertext with Twofish in GCM mode. As of today, Syncany can theoretically nest any authenticated cipher that is supported by the Bouncy Castle Cryptography Provider, but only Twofish/GCM and AES/GCM (both 128-bit or 256-bit) are enabled by Syncany. 

.. image:: _static/security_crypto_example.png
   :align: center
   :scale: 80%

|

The diagram shows an example for the default configuration: For each file to be encrypted, Syncany uses **HKDF with SHA-256** and a **random 96-bit salt** to derive a **128-bit file key** to use for the Twofish cipher (8-10), and another **128-bit file key** using the same scheme for the AES cipher (12-14). In addition to that, two **128-bit random IVs** are created and used as input for the two ciphers (11/15). Using the 128-bit key and the 128-bit IV, Syncany then encrypts plaintext (= multichunk file, database file, etc.) using the AES cipher in GCM mode, and then takes the output to do the same with Twofish in GCM mode.

The salts and IVs as well as the cipher configuration itself (here: AES/GCM+Twofish/GCM) is stored in the file header of the crypto file format. Since this information is required to decrypt the files, they are unencrypted. However, to avoid an attack on the clients through header tampering, the header is authenticated using an **HMAC with SHA-256**, using **a 128-bit header key** derived from the master key and a random **96-bit header salt**.

The resulting **crypto file format** is structured as follows:

.. image:: _static/security_crypto_format.png
   :align: center
   
* **Magic identifier**: Used to identify Syncany-encrypted files (static ``0x53790205``) 
* **Crypto format version:** Used to identify the crypto format version (static ``0x01``)
* **Header HMAC salt:** Used to derive the HMAC header key with HKDF (to verify the header)
* **Cipher Count:** Defines the number of nested ciphers (default: 2)
* **Cipher Spec:**: For each of the nested ciphers, the following information is repeated.
  * **Cipher Spec ID:** Identifies the algorithm and key size used for the first/second/.. cipher
  * **Cipher Salt:** Random salt used to derive the cipher-specific file key
  * **Cipher IV:** Random IV used as input for the given cipher (size depends on cipher spec ID)
* **Header HMAC:** HMAC calculated over the cipher count and cipher specs.

Connecting new Clients
""""""""""""""""""""""
When a user connects to an existing repository using ``sy connect``, Syncany first downloads the ``master`` file. This master file contains the unencrypted  **master salt** which (in combination with the **repository password**) can be used to derive the **master key**. Using this master key and the salts and IVs contained in the encrypted database and multichunk files, Syncany can create the file keys and thereby decrypt any file.

``syncany://`` Links
""""""""""""""""""""
After the actual initialization, the ``sy init`` command creates a so-called ``syncany://``-link which can be used by other users to connect to a repository. This link contains the plugin credentials needed to access the repository (e.g. FTP host/user/pass). The link is encrypted using the same crypto format as described above, except that the master salt is included and the link is base64 encoded.

Syncany supports two types of links:

1. **Encrypted links (normal)**: Links prefixed ``syncany://storage/1/`` are encrypted and can be safely shared via unsecure channels.
2. **Plaintext links (not recommended!):** Links prefixed ``syncany://storage/1/not-encrypted/`` are not encrypted and should **never be shared via unsecure channels**.

Encrypted links are structured like this: ``syncany://storage/1/<master-salt>-<encrypted-config>``. Both ``<master-salt>`` and ``<encrypted-config>`` are base64 encoded. The master salt is stored in plaintext and unauthenticated. The encrypted config is stored in the same file format as described above, i.e. using a nested cipher combination of AES and Twofish. When a client attempts to connect to a repository using ``sy connect syncany://storage/1/...``, Syncany decrypts uses the master salt and the prompted password to derive a master key, and then uses the master key and the IVs and salts in the encrypted config to derive the actual cipher keys. These keys can then be used to decrypt the storage/connection config.

Plaintext links naturally do not contain a master salt. They are structured like this: ``syncany://storage/1/not-encrypted/<plaintext-config>``. The ``<plaintext-config>`` is simply a base64-encoded representation of the storage/connection config. 

.. warning::
	
	Never share an unencrypted/plaintext link over unsecure channels, such as instant messengers or e-mail! If the link contains ``not-encrypted``, it is trivial to retrieve the storage credentials from it. 
	
Crypto Algorithms and Parameters
""""""""""""""""""""""""""""""""
- Users of a shared folder (= repository) share a password
- Random values are created using Java's default SecureRandom implementation (``/dev/urandom`` on Linux, CryptGenRandom on Windows)
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
   

metadata protection




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
