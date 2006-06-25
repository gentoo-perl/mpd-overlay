# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="http://svn.brokentrain.net/gmpc-alarm/trunk/"
ESVN_BOOTSTRAP="autogen.sh"
GMPC_DOCS="AUTHORS TODO README"
inherit gmpc-plugin

DESCRIPTION="A GMPC plugin to generate playlists based on rules"
HOMEPAGE="http://etomite.qballcow.nl/qgmpc-0.12.html"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="net-misc/curl"