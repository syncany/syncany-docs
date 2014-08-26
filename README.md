Syncany User Guide [![Documentation Status](https://readthedocs.org/projects/syncany/badge/?version=latest)](https://readthedocs.org/projects/syncany/?badge=latest)
==================
The is the source project for the [Syncany User Guide](http://syncany-user-guide.readthedocs.org/). The documentation is built using the [Sphinx documentation generator](http://sphinx-doc.org/) on the [Read the Docs](https://readthedocs.org/) platform. It is automatically rebuilt with every commit to the `develop` branch.

Building
--------
To build the docs locally, run:

```
$ sudo pip install sphinx
$ make html
```

Theme
-----
The documentation uses the [Sphinx Read The Docs Theme](https://github.com/snide/sphinx_rtd_theme). To add/update it locally, do this:

```
$ git remote add readthedocs git@github.com:snide/sphinx_rtd_theme.git
$ git fetch readthedocs
$ git subtree add --prefix=source/_themes readthedocs/master
$ rm -rf (everything in source/_themes, but sphinx_rtd_theme)
```

The last `rm` is a workaround to prevent the inclusion of other rst files. 
