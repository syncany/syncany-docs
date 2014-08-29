Security
========
Syncany takes security very seriously. Our goal is to protect the confidentiality of user data stored on remote servers -- meaning that whatever leaves the local computer is encrypted. This chapter explains the **security concepts** of Syncany to the interested user in a hopefully understandable way. Due to the complexity of the subject, however, this is a rather technical chapter. If you just want to use Syncany, **you can safely skip this chapter**. 

.. contents::
   :depth: 3
   
Prologue
--------
Although we take special care designing and implementing the security-related parts of Syncany, we are not cryptographers. We have have asked multiple parties to peer review our concept and implementation, and we hereby do that again: **Please review our security concepts and implementation!** If you believe that any of the concepts and/or the implementation is incorrect, insecure or can be attacked, please let us know `by creating a new issue <https://github.com/syncany/syncany/issues>`_ or `by contacting us directly for major issues <mailto:philipp.heckel@gmail.com>`_.

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

Encryption Scheme
^^^^^^^^^^^^^^^^^
For users to share a repository with Syncany, they must trust each other completely: They share the pre-shared **repository password** to access the Syncany repository and use the same credentials to the offsite storage. 

Repository Initialization
"""""""""""""""""""""""""
When a user creates a new repository using ``sy init``, Syncany asks the user for the repository password. This password is used to derive a 64-bit **master key** using PBKDF2 with 1 million rounds and a 64-bit random **master salt** (1-4). The master key is stored locally in the ``config.xml`` file (see :ref:`configuration_config_xml`) -- since the local machine is trusted, it is not encrypted. The master salt is stored in plaintext locally (although it is not needed) and on the offsite storage in the ``master`` file.  Since the master salt must be public for when other clients connect to the repository, the ``master`` file is not encrypted. 

Encrypting new Files
""""""""""""""""""""
Whenever new files have to be uploaded, Syncany encrypts these files with **128-bit AES/GCM and Twofish/GCM** using the crypto scheme and file format described below (8-21). File encryption happens with every file that is uploaded (except the ``master`` file): For instance, during the file index process in ``sy up``, Syncany packages new/unknown chunks into multichunks (= ZIP files containing many chunks) and creates a new database file (= metadata). These files are encrypted using the the following scheme:

In the default configuration, Syncany uses two nested ciphers: It uses AES in GCM mode to encrypt the actual plaintext, and then encrypts the AES ciphertext with Twofish in GCM mode. As of today, Syncany can theoretically nest any authenticated cipher that is supported by the Bouncy Castle Cryptography Provider, but only Twofish/GCM and AES/GCM (both 128-bit or 256-bit) are allowed by Syncany. 

.. image:: _static/security_crypto_example.png
   :align: center
   :scale: 80%

|

The diagram shows an example for the default configuration: For each file to be encrypted, Syncany uses **HKDF with SHA-256** and a **random 96-bit salt** to derive a **128-bit file key** to use for the Twofish cipher (8-10), and another **128-bit file key** using the same scheme for the AES cipher (12-14). In addition to that, two **128-bit random IVs** are created and used as input for the two ciphers (11/15). Using the 128-bit key and the 128-bit IV, Syncany then encrypts plaintext (= multichunk file, database file, etc.) using the AES cipher in GCM mode, and then takes the output to do the same with Twofish in GCM mode.

To reduce improve encryption/decryption performance, Syncany **re-uses file keys up to 100 times** -- meaning that up to 100 multichunks or database files are encrypted with the same key. Given that the maximum file size for multichunks is about 4 MB, max. 400 MB might be encrypted with the same key -- although typically it's much less. **IVs are never re-used!**

The salts and IVs as well as the cipher configuration itself (here: AES/GCM+Twofish/GCM) is stored in the file header of the crypto file format. Since this information is required to decrypt the files, they are unencrypted. However, to avoid an attack on the clients through header tampering, the header is authenticated using an **HMAC with SHA-256**, using **a 128-bit header key** derived from the master key and a random **96-bit header salt**.

.. image:: _static/security_crypto_format.png
   :align: center
   
The resulting **crypto file format** is structured as follows:

* **Magic identifier**: Used to identify Syncany-encrypted files (static ``0x53790205``) 
* **Crypto format version:** Used to identify the crypto format version (static ``0x01``)
* **Header HMAC salt:** Used to derive the HMAC header key with HKDF (to verify the header)
* **Cipher Count:** Defines the number of nested ciphers (default: 2)
* **Cipher Spec ID** Identifies the algorithm and key size used for the first/second/.. cipher
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
This chapter sumarizes the algorithms and parameters used by Syncany. This is probably a bit repetetive, but maybe useful for people who don't want to read the entire text:

- Users of a shared folder/repository share a repository password
- Random values are generated using Java's default ``SecureRandom`` implementation (``/dev/urandom`` on Linux, CryptGenRandom on Windows)
- The repository password is used to derive one symmetric key per cipher using PBKDF2 (12 byte salt, 1 million rounds)
- The derived symmetric key(s) are used to encrypt files; each key is reused in max. 100 files (~ 400 MB)
- Cipher algorithms are configurable, but not every cipher is allowed: only AES and Twofish (128/256 bit), only authenticated modes (as of now only GCM; no ECB, CBC, etc.)
- Ciphers are initialized with a random initialization vector (IV), IVs are never reused
- Multiple cipher algorithms can be nested/chained (1-n ciphers), e.g. AES-128 and Twofish-256
- Cipher configurations, IVs and salts are authenticated with an HMAC-SHA256

.. _security_daemon:

HTTPS-only Daemon
^^^^^^^^^^^^^^^^^
The Syncany daemon provides an API and a web interface that can be access over HTTPS (not HTTP!). The API is also available via secure WebSockets. 

Keys and Certificates
"""""""""""""""""""""
The keypair and certificate used for the HTTPS server is generated by Syncany upon the first startup of the daemon. Syncany generates a **2048-bit RSA keypair** and then uses this keypair to **generate a self-signed X.509v3 certificate** with a validity of 5 years. The certificates common name is set to the local hostname, and the organization and org-unit to 'Syncany'. The certificate's **SHA-256 hash** is signed using the RSA private key (signature algorithm):

::

	Certificate:
	    Data:
		Version: 3 (0x2)
		Serial Number: 1409206372293 (0x1481b3ec7c5)
	    Signature Algorithm: sha256WithRSAEncryption
		Issuer: CN=localhost, O=Syncany, OU=Syncany
		Validity
		    Not Before: Aug 27 06:12:52 2014 GMT
		    Not After : Aug 27 06:12:52 2019 GMT
		Subject: CN=localhost, O=Syncany, OU=Syncany
		Subject Public Key Info:
		    Public Key Algorithm: rsaEncryption
		        Public-Key: (2048 bit)
		        Modulus:
		            00:a0:43:ca:d6:e6:e9:70:2d:ca:d5:77:ad:e9:3a:
		            1a:50:fe: ...
		        Exponent: 65537 (0x10001)
	    Signature Algorithm: sha256WithRSAEncryption
		 74:7b:a9:22:e3:fb:21:cf:15:3c:ba:11:46:c4:7a:6c:8e:2c:
		 f4:aa:cc:27:98:e7: ...

The private key and the certificate are stored in a key/trust store. Using your own keypair and certificate is also possible. See :ref:`configuration_keys_certificates` for details.

Authentication and Authorization
""""""""""""""""""""""""""""""""
The user authentication and authorization capabilities of Syncany to the web server and REST/WS API are very limited. Syncany provides a simple **HTTP Basic-based user authentication** (but only over HTTPS!). All authenticated users have complete access to the REST/WS API. The user configuration is done via the ``daemon.xml`` file. See :ref:`configuration_daemon_users`.

Attack Scenarios
----------------
Syncany tries to prevent against a certain threat scenarios. This chapter briefly shows how an adversary might try to attack Syncany. In general, we differentiate between **attacks on the data in transit** and **attacks on the storage provider's side**. Since the local machine is assumed to be secure and data we're trying to protect is not encrypted on the local machine, attacks on the local machine are disregarded.

Attacking Data Transmissions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
An adversary with access to the network infrastructure, e.g. through network monitoring or a man-in-the-middle attack, can either passively monitor the network traffic or actively modify the data being transmitted. 

Since Syncany can be used with a many different plugins, **the overall security of the solution strongly depends on the storage plugin**. If, for instance, the FTP plugin is used, the transmitted data can be observed (or even modified) by the adversary, because the FTP protocol does not provide communication security. Similarly, if the WebDAV plugin is used with a HTTP target, the same attack scenario is possible.

However, because Syncany encrypts files before upload, the data being transmitted is of little to no value to the adversary. Even if the data is changed by the adversary, Syncany will detect these changes, because only authenticated ciphers are used -- meaning that data confidentiality and integrity is still ensured. When using a plugin without communication security and the adversary can modify the network, **data availibility might be compromised**. An attacker might simply read the storage access credentials and delete the entire repository.

If, however, a plugin is used that provides communication security, an attacker cannot modify network transmissions and **data availibility is ensured**. Examples for such plugins include the WebDAV plugin with a HTTPS target, the Amazon S3 plugin, or the SFTP plugin. In summation: 

* Syncany provides data confidentiality, integrity and availability against attacks on the network if the used plugin provides communication security
* Syncany provides data confidentiality, integrity, **but not availability** against attacks on the network if the used plugin **does not provide communication security**

Provider-originated Attacks
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Syncany stores its data at a central storage. By definition, the provider of that storage has complete access to the data that resides on that storage. If an evil provider takes interest in that data, it is very easy to gain access to it. If, for instance, the owner on an FTP server decides to modify or delete your repository, it is very easy for them to do so. In fact, **Syncany can never provide any protection against a provider-originated attack on data availibility**. 

However, similarly to the above mentioned no-communication-security scenario, Syncany still provides data confidentiality and integrity, because files are encrypted in an authenticated mode before upload. A provider might be able to retrieve the encrypted files (or even delete them), but it won't be able to decrypt them.

Theft of Credentials
^^^^^^^^^^^^^^^^^^^^
One of Syncany's assumptions is that users sharing a repository must trust each other completely. The reason for that is that to access a repository, credentials to the storage are shared. If one of the trusted users were to be tricked into giving up the password, or her laptop were to be compromised, the repository password, the master key or the offsite storage credentials might be in the hand of an attacker.

If the repository password or the master key is retrieved, data confidentiality is completely breached -- without other users having a chance of detecting it and without a chance of changing the password. **Syncany can not prevent or detect if the master key or password has been stolen or was used by an adversary.**

If only the storage credentials are retrieved by an adversary, only the availability of data is at risk (same scenario as above).

Source Code
-----------
All the cryptography related code is implemented in the ``org.syncany.crypto`` package. Feel free to `inspect the code <https://github.com/syncany/syncany/tree/da6e4f5dd91a9c42f375a55bd764e61488a8950f/syncany-lib/src/main/java/org/syncany/crypto>`_ and `create a new issue <https://github.com/syncany/syncany/issues>`_ if something doesn't feel right.

Known Issues and Limitations
----------------------------   
- In multiple peer reviews, it has been suggested to drop the cipher nesting in favor of a single cipher. While there is no evidence that a nested cipher is or might be weaker than a single cipher, there is very little literature about it -- so it is probably not a good idea. See `issue 59 <https://github.com/syncany/syncany/issues/59>`_.
- As of today, neither the master key nor the password can be changed. See `issue 150 <https://github.com/syncany/syncany/issues/150>`_.
