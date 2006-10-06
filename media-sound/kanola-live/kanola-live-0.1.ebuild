# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils subversion

ESVN_REPO_URI="http://kanola.googlecode.com/svn/trunk/"

DESCRIPTION="A lightweight client for MPD, in PyQt 4"
HOMEPAGE="http://dadexter.googlepages.com/kanola"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"
PROVIDE="media-sound/kanola"

RDEPEND=">=virtual/python-2.4
	>=dev-python/PyQt4
	!media-sound/kanola
	kde-base/pykde"

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/lib/python${PYVER}/site-packages
}

pkg_postrm() {
	python_version
	python_mod_cleanup
}