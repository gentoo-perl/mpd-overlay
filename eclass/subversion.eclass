# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/subversion.eclass,v 1.33 2006/07/22 13:52:38 hattya Exp $

## --------------------------------------------------------------------------- #
# Author: Akinori Hattori <hattya@gentoo.org>
#
# The subversion eclass is written to fetch the software sources from
# subversion repositories like the cvs eclass.
#
#
# Description:
#   If you use this eclass, the ${S} is ${WORKDIR}/${P}.
#   It is necessary to define the ESVN_REPO_URI variable at least.
#
## --------------------------------------------------------------------------- #

inherit eutils

ESVN="subversion.eclass"

EXPORT_FUNCTIONS src_unpack

HOMEPAGE="http://subversion.tigris.org/"
DESCRIPTION="Based on the ${ECLASS} eclass"


## -- add subversion in DEPEND
#
DEPEND="dev-util/subversion"


## -- ESVN_STORE_DIR:  subversion sources store directory
#
ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src"


## -- ESVN_FETCH_CMD:  subversion fetch command
#
ESVN_FETCH_CMD="svn checkout"

## -- ESVN_UPDATE_CMD:  subversion update command
#
ESVN_UPDATE_CMD="svn update"


## -- ESVN_OPTIONS:
#
# the options passed to checkout or update.
#
: ESVN_OPTIONS=${ESVN_OPTIONS:=}


## -- ESVN_REPO_URI:  repository uri
#
# e.g. http://foo/trunk, svn://bar/trunk
#
# supported protocols:
#   http://
#   https://
#   svn://
#   svn+ssh://
#
: ESVN_REPO_URI=${ESVN_REPO_URI:=}


## -- ESVN_PROJECT:  project name of your ebuild (= name space)
#
# subversion eclass will check out the subversion repository like:
#
#   ${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/}
#
# so if you define ESVN_REPO_URI as http://svn.collab.net/repo/svn/trunk or
# http://svn.collab.net/repo/svn/trunk/. and PN is subversion-svn.
# it will check out like:
#
#   ${ESVN_STORE_DIR}/subversion/trunk
#
# this is not used in order to declare the name of the upstream project.
# so that you can declare this like:
#
#   # jakarta commons-loggin
#   ESVN_PROJECT=commons/logging
#
# default: ${PN/-svn}.
#
: ESVN_PROJECT=${ESVN_PROJECT:=${PN/-svn}}


## -- ESVN_BOOTSTRAP:
#
# bootstrap script or command like autogen.sh or etc..
#
: ESVN_BOOTSTRAP=${ESVN_BOOTSTRAP:=}


## -- ESVN_PATCHES:
#
# subversion eclass can apply pathces in subversion_bootstrap().
# you can use regexp in this valiable like *.diff or *.patch or etc.
# NOTE: this patches will apply before eval ESVN_BOOTSTRAP.
#
# the process of applying the patch is:
#   1. just epatch it, if the patch exists in the path.
#   2. scan it under FILESDIR and epatch it, if the patch exists in FILESDIR.
#   3. die.
#
: ESVN_PATCHES=${ESVN_PATCHES:=}


## -- ESVN_RESTRICT:
#
# this should be a space delimited list of subversion eclass features to restrict.
#   export)
#     don't export the working copy to S.
#
: ESVN_RESTRICT=${ESVN_RESTRICT:=}


## -- subversion_fetch() ----------------------------------------------------- #

function subversion_fetch() {

	local repo_uri=${1:-${ESVN_REPO_URI}}

	if [[ -z "${repo_uri}" ]]; then
		die "${ESVN}: ESVN_REPO_URI is empty."
	fi

	# delete trailing slash
	if [[ -z "${repo_uri##*/}" ]]; then
		repo_uri=${repo_uri%/}
	fi

	# check for the protocol
	local protocol=${repo_uri%%:*}

	case "${protocol}" in
		http|https)
			if built_with_use dev-util/subversion nowebdav; then
				eerror "In order to emerge this package, you need to"
				eerror "re-emerge subversion with USE=-nowebdav"
				die "Please run 'USE=-nowebdav emerge subversion'"
			fi
			;;
		svn|svn+ssh)
			;;
		*)
			die "${ESVN}: fetch from "${protocol}" is not yet implemented."
			;;
	esac

	if [[ ! -d "${ESVN_STORE_DIR}" ]]; then
		debug-print "${FUNCNAME}: initial checkout. creating subversion directory"

		addwrite /
		mkdir -p "${ESVN_STORE_DIR}" || die "${ESVN}: can't mkdir ${ESVN_STORE_DIR}."
		export SANDBOX_WRITE=${SANDBOX_WRITE%%:/}
	fi

	cd "${ESVN_STORE_DIR}" || die "${ESVN}: can't chdir to ${ESVN_STORE_DIR}"

	# every time
	addwrite "/etc/subversion"
	addwrite "${ESVN_STORE_DIR}"

	local wc_path=${ESVN_PROJECT}/${repo_uri##*/}
	ESVN_OPTIONS="${ESVN_OPTIONS} --config-dir ${ESVN_STORE_DIR}/.subversion"
	addwrite "${ESVN_STORE_DIR}/.subversion"

	debug-print "${FUNCNAME}: ESVN_OPTIONS = \"${ESVN_OPTIONS}\""

	if [[ ! -d "${wc_path}/.svn" ]]; then
		# first check out
		einfo "subversion check out start -->"
		einfo "     repository: ${repo_uri}"

		mkdir -p "${ESVN_PROJECT}"      || die "${ESVN}: can't mkdir ${ESVN_PROJECT}."
		cd "${ESVN_PROJECT}"
		${ESVN_FETCH_CMD} ${ESVN_OPTIONS} "${repo_uri}" || die "${ESVN}: can't fetch from ${repo_uri}."

	else
		# update working copy
		einfo "subversion update start -->"
		einfo "     repository: ${repo_uri}"

		cd "${wc_path}"
		${ESVN_UPDATE_CMD} ${ESVN_OPTIONS} || die "${ESVN}: can't update from ${repo_uri}."

	fi

	einfo "   working copy: ${ESVN_STORE_DIR}/${wc_path}"

	if ! has "export" ${ESVN_RESTRICT}; then
		cd "${ESVN_STORE_DIR}/${wc_path}"

		# export to the ${WORKDIR}
		#*  "svn export" has a bug.  see http://bugs.gentoo.org/119236
		#* svn export . "${S}" || die "${ESVN}: can't export to ${S}."
		rsync -rlpgo --exclude=".svn/" . "${S}" || die "${ESVN}: can't export to ${S}."
	fi

	echo

}


## -- subversion_bootstrap() ------------------------------------------------ #

function subversion_bootstrap() {

	if has "export" ${ESVN_RESTRICT}; then
		return
	fi

	cd "${S}"

	if [[ -n "${ESVN_PATCHES}" ]]; then
		einfo "apply patches -->"

		local p=

		for p in ${ESVN_PATCHES}; do
			if [[ -f "${p}" ]]; then
				epatch "${p}"

			else
				local q=

				for q in ${FILESDIR}/${p}; do
					if [[ -f "${q}" ]]; then
						epatch "${q}"

					else
						die "${ESVN}; ${p} is not found"

					fi
				done
			fi
		done

		echo

	fi

	if [[ -n "${ESVN_BOOTSTRAP}" ]]; then
		einfo "begin bootstrap -->"

		if [[ -f "${ESVN_BOOTSTRAP}" && -x "${ESVN_BOOTSTRAP}" ]]; then
			einfo "   bootstrap with a file: ${ESVN_BOOTSTRAP}"
			eval "./${ESVN_BOOTSTRAP}" || die "${ESVN}: can't execute ESVN_BOOTSTRAP."

		else
			einfo "   bootstrap with commands: ${ESVN_BOOTSTRAP}"
			eval "${ESVN_BOOTSTRAP}" || die "${ESVN}: can't eval ESVN_BOOTSTRAP."

		fi
	fi

}


## -- subversion_src_unpack() ------------------------------------------------ #

function subversion_src_unpack() {

	subversion_fetch     || die "${ESVN}: unknown problem in subversion_fetch()."
	subversion_bootstrap || die "${ESVN}: unknown problem in subversion_bootstrap()."

}


## -- subversion_wc_info() --------------------------------------------------- #

function subversion_wc_info() {

	local repo_uri=${ESVN_REPO_URI}

	# delete trailing slash
	if [[ -z "${repo_uri##*/}" ]]; then
		repo_uri="${repo_uri%/}"
	fi

	local wc_path=${ESVN_STORE_DIR}/${ESVN_PROJECT}/${repo_uri##*/}

	if [[ ! -e "${wc_path}" ]]; then
		return 1
	fi

	local k=

	for k in url revision; do
		export ESVN_WC_$(echo "${k}" | tr [a-z] [A-Z])=$(env LANG=C svn info "${wc_path}" | grep -i "^${k}" | cut -d" " -f2)
	done

}