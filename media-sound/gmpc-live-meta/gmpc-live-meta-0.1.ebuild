# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="gmpc - a meta ebuild to pull in gmpc and all plugins"
HOMEPAGE="http://sarine.nl/gmpc"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~ppc-macos ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND="media-sound/gmpc-live \
	media-plugins/gmpc-alarm-live \
	media-plugins/gmpc-amazon-coverart-live \
	media-plugins/gmpc-autoplaylist-live \
	media-plugins/gmpc-lastfm-live \
	media-plugins/gmpc-lyrics-live \
	media-plugins/gmpc-magnatune-live \
	media-plugins/gmpc-mdcover-live \
	media-plugins/gmpc-osd-live \
	media-plugins/gmpc-playlistsort-live \
	media-plugins/gmpc-qosd-live \
	media-plugins/gmpc-random-playlist-live \
	media-plugins/gmpc-serverstats-live \
	media-plugins/gmpc-stopbutton-live \
	media-plugins/gmpc-wikipedia-live"
RDEPEND="${DEPEND}"