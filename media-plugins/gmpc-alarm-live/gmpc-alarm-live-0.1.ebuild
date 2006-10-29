# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="http://svn.brokentrain.net/gmpc-alarm/trunk/"
GMPC_DOCS="AUTHORS TODO README"
inherit subversion eautogen-sh

DESCRIPTION="A GMPC plugin to generate playlists based on rules"
HOMEPAGE="http://cms.qballcow.nl/"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"
SLOT="0"
LICENSE="GPL-2"

src_install() {
	insinto "/usr/share/gmpc/plugins"
	doins "src/.libs/alarmplugin.so"

	if [[ -n ${GMPC_DOCS} ]]; then
		dodoc ${GMPC_DOCS}
	fi
}
