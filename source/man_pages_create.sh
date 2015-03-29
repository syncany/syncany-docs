#!/bin/bash

set -e

echo -n "Reading version from conf.py ... "
version=$(grep -Po "(?<=^version)\s*=.*" conf.py | sed 's/[^0-9a-z.-]//g')
echo "$version"

echo -n "Writing man_pages.rst: "

cat << 'EOF' > man_pages.rst
Appendix A: Manual Pages
========================

This appendix lists all the manual/help pages available for the ``sy`` command, its sub-commands. These help pages are available by calling ``sy <action> --help`` or ``man sy-<action>`` (Linux only).

.. contents::

.. _man_sy:

sy / syncany
^^^^^^^^^^^^
::

EOF

echo -n "sy "

echo -n "	" >> man_pages.rst # First tab
curl -sS https://raw.githubusercontent.com/syncany/syncany/develop/syncany-cli/src/main/resources/org/syncany/cli/cmd/help.skel \
	| sed ':a;N;$!ba;s/\n/\n\t/g' \
	>> man_pages.rst
	
for cmd in cleanup connect daemon down genlink init log ls-remote ls plugin restore status up update watch; do
	echo -n "$cmd "
	
	cmd_label=$(echo "_man_$cmd" | tr '-' '_')
	
	title="sy $cmd"
	title_len=${#title}
	title_underline=$(printf %${title_len}s | tr " " "^")
	
	cat << EOF >> man_pages.rst

.. $cmd_label:

$title
$title_underline
::

EOF

	echo -n "	" >> man_pages.rst # First tab
	curl -sS https://raw.githubusercontent.com/syncany/syncany/develop/syncany-cli/src/main/resources/org/syncany/cli/cmd/help.$cmd.skel \
		| sed ':a;N;$!ba;s/\n/\n\t/g' \
		>> man_pages.rst
done

echo ""

echo -n "Replacing version to $version ... "
sed -i "s/%applicationVersionFull%/$version/" man_pages.rst
echo "OK"


