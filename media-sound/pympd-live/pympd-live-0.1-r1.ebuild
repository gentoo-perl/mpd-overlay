# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/pympd/trunk/pympd/"
inherit subversion toolchain-funcs python

DESCRIPTION="a Rhythmbox-like PyGTK+ client for Music Player Daemon"
HOMEPAGE="http://sourceforge.net/projects/pympd"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~ppc-macos ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
SLOT="0"
IUSE=""

DEPEND=">=virtual/python-2.4
	>=dev-python/pygtk-2.6
	!media-sound/pympd"

pkg_setup() {
	if ! built_with_use =gtk+-2* jpeg; then
		eerror "You must build gtk+-2.x with jpeg USE flag."
		die "Please re-emerge gtk+-2.x with jpeg USE flag."
	fi
}

src_compile() {
	# Honor CFLAGS in make.conf
	export BUILDFLAGS="${CFLAGS}"
	sed -i -e 's:CFLAGS =:CFLAGS = ${BUILDFLAGS}:' src/modules/tray/Makefile
	emake CC="$(tc-getCC)" PREFIX="/usr" DESTDIR="${D}" || die "emake failed."
}

src_install() {
        # Fix for 'src//glade/../pympd.svg': No such file or directory
        sed -i -e 's:\..\/py:/usr/share/pympd/py:g' src/glade/pympd.glade

	emake PREFIX="/usr" DESTDIR="${D}" install || die "emake install failed."
	dodoc README
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/lib/python${PYVER}/site-packages/pympd
}

pkg_postrm() {
	python_version
	python_mod_cleanup
}