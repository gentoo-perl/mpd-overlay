# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="https://svn.musicpd.org/gmpc/trunk/"
inherit subversion eautogen-sh

DESCRIPTION="A Gnome client for the Music Player Daemon."
HOMEPAGE="http://sarine.nl/gmpc"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~ppc-macos ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
SLOT="0"
IUSE=""
LICENSE="GPL-2"

DEPEND=">=x11-libs/gtk+-2.4
	>=gnome-base/libglade-2.3
	dev-perl/XML-Parser
	media-libs/libmpd-live
	>dev-util/gob-2
	net-misc/curl"


## This is needed to extract the svn revision for the about window. The
## subversion.eclass doen't copy the .svn directories, so after the copy
## to the working directory, this information is unavilable.
pkg_setup() {
	local repo_uri=${ESVN_REPO_URI%/}
	local repo="${ESVN_STORE_DIR}/${ESVN_PROJECT}/${repo_uri##*/}/src"
	REV=`svn info ${repo} | grep "Last Changed Rev" | awk -F ': ' '{ print $2}'`
}

src_compile() {
       	sed -ie "s%REVISION=.*%REVISION=$REV%" ${WORKDIR}/${PF}/src/Makefile.am

	eautogen-sh || die "autogen.sh failed!"
	emake || die "Make failed!"
}
src_install() {
	make DESTDIR=${D} install || die "make install failed"
}

DOCS="AUTHORS ChangeLog NEWS README"
