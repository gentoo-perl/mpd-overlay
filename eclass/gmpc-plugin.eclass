EAPI=2

[ -z "${SRC_URI}" ] || inherit git autotools

DEPEND="${DEPEND}
	=media-sound/gmpc-9999
	dev-libs/libxml2"
RDEPEND="${DEPEND}"

if [ -z ${EGIT_REPO_URI} ] || [ -z "${SRC_URI}" ]; then
	DEPEND="${DEPEND}"
	if [ -z ${GMPC_PLUGIN} ]; then
		GMPC_PLUGIN="${PN}"
		GMPC_PLUGIN="${GMPC_PLUGIN#gmpc-}"
	fi
	EGIT_REPO_URI="git://repo.or.cz/gmpc-${GMPC_PLUGIN}.git"
fi

if [ -z "${SRC_URI}" ]; then
	gmpc-plugin_src_prepare() {
		eautoreconf
	}
fi

gmpc-plugin_src_install() {
	cd "${S}"
	emake DESTDIR="${D}" install || die "Install failed"
}

## A few sane defaults
HOMEPAGE="http://gmpcwiki.sarine.nl/index.php/${PN/gmpc-}"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

EXPORT_FUNCTIONS src_install src_prepare
