# Copyright (C) The IETF Trust (2011-2014)
#
# Manage the .xml for the NFSv4 minorversion 2 document.
#

YEAR=`date +%Y`
MONTH=`date +%B`
DAY=`date +%d`
PREVVERS=40
VERS=41
VPATH=dotx.d

XML2RFC=xml2rfc

DRAFT_BASE=draft-ietf-nfsv4-minorversion2
DOC_PREFIX=nfsv42

autogen/%.xml : %.x
	@mkdir -p autogen
	@rm -f $@.tmp $@
	@( cd dotx.d ; m4 `basename $<` > ../$@.tmp )
	@cat $@.tmp | sed 's/^\%//' | sed 's/</\&lt;/g'| \
	awk ' \
		BEGIN	{ print "<figure>"; print" <artwork>"; } \
			{ print $0 ; } \
		END	{ print " </artwork>"; print"</figure>" ; } ' \
	| expand > $@
	@rm -f $@.tmp

all: html txt dotx dotx-txt

#
# Build the stuff needed to ensure integrity of document.
common: testx dotx html dotx-txt

txt: ${DRAFT_BASE}-$(VERS).txt

html: ${DRAFT_BASE}-$(VERS).html

nr: ${DRAFT_BASE}-$(VERS).nr

dotx:
	cd dotx.d ; VERS=$(VERS) $(MAKE) all

#
# Builds the I-D that has just the .x file
#
dotx-txt:
	cd dotx-id.d ; SPECVERS=$(VERS) $(MAKE) all

xml: ${DRAFT_BASE}-$(VERS).xml

clobber:
	$(RM) ${DRAFT_BASE}-$(VERS).txt \
		${DRAFT_BASE}-$(VERS).html \
		${DRAFT_BASE}-$(VERS).nr
	export SPECVERS=$(VERS)
	export VERS=$(VERS)
	cd dotx-id.d ; SPECVERS=$(VERS) $(MAKE) clobber
	cd dotx.d ; VERS=$(VERS) $(MAKE) clobber

clean:
	rm -f $(AUTOGEN)
	rm -rf autogen
	rm -f ${DRAFT_BASE}-$(VERS).xml
	rm -rf draft-$(VERS)
	rm -f draft-$(VERS).tar.gz
	rm -rf testx.d
	rm -rf draft-tmp.xml
	cd dotx.d ; VERS=$(VERS) $(MAKE) clean
	cd dotx-id.d ; SPECVERS=$(VERS) $(MAKE) clean
	git clean -f -x -d

# Parallel All
pall:
	$(MAKE) xml
	( $(MAKE) txt ; echo .txt done ) & \
	( $(MAKE) html ; echo .html done ) & \
	wait

${DRAFT_BASE}-$(VERS).txt: ${DRAFT_BASE}-$(VERS).xml
	$(XML2RFC) --text ${DRAFT_BASE}-$(VERS).xml -o $@

${DRAFT_BASE}-$(VERS).html: ${DRAFT_BASE}-$(VERS).xml
	$(XML2RFC) --html ${DRAFT_BASE}-$(VERS).xml -o $@

${DRAFT_BASE}-$(VERS).nr: ${DRAFT_BASE}-$(VERS).xml
	$(XML2RFC) --nroff ${DRAFT_BASE}-$(VERS).xml -o $@

${DOC_PREFIX}_middle_errortoop_autogen.xml: ${DOC_PREFIX}_middle_errors.xml
	./errortbl < ${DOC_PREFIX}_middle_errors.xml > ${DOC_PREFIX}_middle_errortoop_autogen.xml

${DOC_PREFIX}_front_autogen.xml: ${DOC_PREFIX}_front.xml Makefile
	sed -e s/DAYVAR/${DAY}/g -e s/MONTHVAR/${MONTH}/g -e s/YEARVAR/${YEAR}/g < ${DOC_PREFIX}_front.xml > ${DOC_PREFIX}_front_autogen.xml

${DOC_PREFIX}_rfc_start_autogen.xml: ${DOC_PREFIX}_rfc_start.xml Makefile
	sed -e s/DRAFTVERSION/${DRAFT_BASE}-${VERS}/g < ${DOC_PREFIX}_rfc_start.xml > ${DOC_PREFIX}_rfc_start_autogen.xml

autogen/basic_types.xml: dotx.d/spit_types.sh
	sh dotx.d/spit_types.sh $@

SPITGEN =	dotx.d/type_nfstime4.x \
		dotx.d/type_time_how4.x \
		dotx.d/type_nfsacl41.x \
		dotx.d/type_settime4.x \
		dotx.d/type_fsid4.x \
		dotx.d/type_specdata4.x \
		dotx.d/type_fs_location4.x \
		dotx.d/type_fs_locations4.x \
		dotx.d/type_fattr4.x \
		dotx.d/type_change_info4.x \
		dotx.d/type_chg_policy4.x \
		dotx.d/type_netaddr4.x \
		dotx.d/type_state_owner4.x \
		dotx.d/type_open_to_lock_owner4.x \
		dotx.d/type_stateid4.x \
		dotx.d/type_layouttype4.x \
		dotx.d/type_deviceid4.x \
		dotx.d/type_nfl_util4.x \
		dotx.d/type_nfsv4_1_file_layouthint4.x \
		dotx.d/type_nfsv4_1_file_layout_ds_addr4.x \
		dotx.d/type_nfsv4_1_file_layout4.x \
		dotx.d/type_ssv_subkey4.x \
		dotx.d/type_ssv_mic_plain_tkn4.x \
		dotx.d/type_ssv_mic_tkn4.x \
		dotx.d/type_ssv_seal_plain_tkn4.x \
		dotx.d/type_ssv_seal_cipher_tkn4.x \
		dotx.d/type_layoutreturn4.x \
		dotx.d/type_client_owner4.x \
		dotx.d/type_server_owner4.x \
		dotx.d/type_device_addr4.x \
		dotx.d/type_layout_content4.x \
		dotx.d/type_layout4.x \
		dotx.d/type_layoutupdate4.x \
		dotx.d/type_layouthint4.x \
		dotx.d/type_layoutiomode4.x \
		dotx.d/type_nfs_impl_id4.x \
		dotx.d/type_threshold_item4.x \
		dotx.d/type_mdsthreshold4.x \
		dotx.d/type_retention_get4.x \
		dotx.d/type_retention_set4.x \
		dotx.d/type_acetype4.x \
		dotx.d/type_aceflag4.x \
		dotx.d/type_acemask4.x \
		dotx.d/type_nfsace4.x \
		dotx.d/type_fs4_status.x \
		dotx.d/type_fs_charset_cap4.x \
		dotx.d/const_acetype4.x \
		dotx.d/const_aceflag4.x \
		dotx.d/const_aclsupport4.x \
		dotx.d/const_acemask4.x \
		dotx.d/const_mode4.x \
		dotx.d/const_aclflag4.x \
		dotx.d/const_access_deny.x \
		dotx.d/const_sizes.x \
		dotx.d/type_nfs_cb_opnum4.x \
		dotx.d/type_nfs_cb_argop4.x \
		dotx.d/type_CB_COMPOUND4args.x \
		dotx.d/type_nfs_cb_resop4.x \
		dotx.d/type_CB_COMPOUND4res.x \
		dotx.d/type_nfs_opnum4.x \
		dotx.d/type_nfs_argop4.x \
		dotx.d/type_nfs_resop4.x \
		dotx.d/type_COMPOUND4args.x \
		dotx.d/type_COMPOUND4res.x \
		dotx.d/type_netloc_type4.x \
		dotx.d/type_chattr_type.x \
		dotx.d/type_label_format.x \
		dotx.d/copy_confirm_auth.x \
		dotx.d/copy_from_auth.x \
		dotx.d/copy_to_auth.x \
		dotx.d/app_data_block4.x \
		dotx.d/data_info4.x \
		dotx.d/data4.x \
		dotx.d/data_content4.x \
		dotx.d/stable_how4.x \
		dotx.d/write_response4.x

SPITGENXML =	autogen/type_nfstime4.xml \
		autogen/type_time_how4.xml \
		autogen/type_nfsacl41.xml \
		autogen/type_settime4.xml \
		autogen/type_fsid4.xml \
		autogen/type_specdata4.xml \
		autogen/type_fs_location4.xml \
		autogen/type_fs_locations4.xml \
		autogen/type_fattr4.xml \
		autogen/type_change_info4.xml \
		autogen/type_chg_policy4.xml \
		autogen/type_netaddr4.xml \
		autogen/type_state_owner4.xml \
		autogen/type_open_to_lock_owner4.xml \
		autogen/type_stateid4.xml \
		autogen/type_layouttype4.xml \
		autogen/type_deviceid4.xml \
		autogen/type_nfl_util4.xml \
		autogen/type_nfsv4_1_file_layouthint4.xml \
		autogen/type_nfsv4_1_file_layout_ds_addr4.xml \
		autogen/type_nfsv4_1_file_layout4.xml \
		autogen/type_ssv_subkey4.xml \
		autogen/type_ssv_mic_plain_tkn4.xml \
		autogen/type_ssv_mic_tkn4.xml \
		autogen/type_ssv_seal_plain_tkn4.xml \
		autogen/type_ssv_seal_cipher_tkn4.xml \
		autogen/type_layoutreturn4.xml \
		autogen/type_client_owner4.xml \
		autogen/type_server_owner4.xml \
		autogen/type_device_addr4.xml \
		autogen/type_layout_content4.xml \
		autogen/type_layout4.xml \
		autogen/type_layoutupdate4.xml \
		autogen/type_layouthint4.xml \
		autogen/type_layoutiomode4.xml \
		autogen/type_nfs_impl_id4.xml \
		autogen/type_threshold_item4.xml \
		autogen/type_mdsthreshold4.xml \
		autogen/type_retention_get4.xml \
		autogen/type_retention_set4.xml \
		autogen/type_acetype4.xml \
		autogen/type_aceflag4.xml \
		autogen/type_acemask4.xml \
		autogen/type_nfsace4.xml \
		autogen/type_fs4_status.xml \
		autogen/type_fs_charset_cap4.xml \
		autogen/const_acetype4.xml \
		autogen/const_aceflag4.xml \
		autogen/const_aclsupport4.xml \
		autogen/const_acemask4.xml \
		autogen/const_mode4.xml \
		autogen/const_aclflag4.xml \
		autogen/const_access_deny.xml \
		autogen/const_sizes.xml \
		autogen/type_nfs_cb_opnum4.xml \
		autogen/type_nfs_cb_argop4.xml \
		autogen/type_CB_COMPOUND4args.xml \
		autogen/type_nfs_cb_resop4.xml \
		autogen/type_CB_COMPOUND4res.xml \
		autogen/type_nfs_opnum4.xml \
		autogen/type_nfs_argop4.xml \
		autogen/type_nfs_resop4.xml \
		autogen/type_COMPOUND4args.xml \
		autogen/type_COMPOUND4res.xml \
		autogen/type_netloc_type4.xml \
		autogen/type_chattr_type.xml \
		autogen/type_label_format.xml \
		autogen/copy_confirm_auth.xml \
		autogen/copy_from_auth.xml \
		autogen/copy_to_auth.xml \
		autogen/app_data_block4.xml \
		autogen/data_info4.xml \
		autogen/data4.xml \
		autogen/data_content4.xml \
		autogen/stable_how4.xml \
		autogen/write_response4.xml

$(SPITGEN): dotx.d/spit_types.sh
	cd dotx.d ; sh spit_types.sh `basename $@`


dotx.d/open_args_gen.x: dotx.d/open_args.x dotx.d/const_access_deny.x
	cd dotx.d ; VERS=$(VERS) $(MAKE) `basename $@`

AUTOGEN =	\
		${DOC_PREFIX}_front_autogen.xml \
		${DOC_PREFIX}_rfc_start_autogen.xml \
		${DOC_PREFIX}_middle_errortoop_autogen.xml \
		autogen/basic_types.xml \
		$(SPITGEN) \
		$(SPITGENXML) \
		autogen/access_args.xml \
		autogen/access_res.xml \
		autogen/allocate_args.xml \
		autogen/allocate_res.xml \
		autogen/backchannel_ctl_args.xml \
		autogen/backchannel_ctl_res.xml \
		autogen/bind_conn_to_session_args.xml \
		autogen/bind_conn_to_session_res.xml \
		autogen/offload_info4.xml \
		autogen/cb_offload_args.xml \
		autogen/cb_offload_res.xml \
		autogen/cb_getattr_args.xml \
		autogen/cb_getattr_res.xml \
		autogen/cb_illegal_res.xml \
		autogen/cb_layoutrecall_args.xml \
		autogen/cb_layoutrecall_res.xml \
		autogen/cb_notify_args.xml \
		autogen/cb_notify_res.xml \
		autogen/cb_notify_lock_args.xml \
		autogen/cb_notify_lock_res.xml \
		autogen/cb_notify_deviceid_args.xml \
		autogen/cb_notify_deviceid_res.xml \
		autogen/cb_push_deleg_args.xml \
		autogen/cb_push_deleg_res.xml \
		autogen/cb_recall_any_args.xml \
		autogen/cb_recall_any_res.xml \
		autogen/cb_recall_args.xml \
		autogen/cb_recall_res.xml \
		autogen/cb_recall_slot_args.xml \
		autogen/cb_recall_slot_res.xml \
		autogen/cb_recallable_obj_avail_args.xml \
		autogen/cb_recallable_obj_avail_res.xml \
		autogen/cb_sequence_args.xml \
		autogen/cb_sequence_res.xml \
		autogen/cb_wants_cancelled_args.xml \
		autogen/cb_wants_cancelled_res.xml \
		autogen/clone_args.xml \
		autogen/clone_res.xml \
		autogen/close_args.xml \
		autogen/close_res.xml \
		autogen/commit_args.xml \
		autogen/commit_res.xml \
		autogen/copy_notify_args.xml \
		autogen/copy_notify_res.xml \
		autogen/offload_cancel_args.xml \
		autogen/offload_cancel_res.xml \
		autogen/copy_args.xml \
		autogen/copy_res.xml \
		autogen/offload_status_args.xml \
		autogen/offload_status_res.xml \
		autogen/create_args.xml \
		autogen/exchange_id_args.xml \
		autogen/exchange_id_res.xml \
		autogen/fs_locations_info.xml \
		autogen/create_res.xml \
		autogen/create_session_args.xml \
		autogen/create_session_res.xml \
		autogen/delegpurge_args.xml \
		autogen/delegpurge_res.xml \
		autogen/delegreturn_args.xml \
		autogen/delegreturn_res.xml \
		autogen/destroy_clientid_args.xml \
		autogen/destroy_clientid_res.xml \
		autogen/destroy_session_args.xml \
		autogen/destroy_session_res.xml \
		autogen/free_stateid_args.xml \
		autogen/free_stateid_res.xml \
		autogen/get_dir_delegation_args.xml \
		autogen/get_dir_delegation_res.xml \
		autogen/getattr_args.xml \
		autogen/getattr_res.xml \
		autogen/getdeviceinfo_args.xml \
		autogen/getdeviceinfo_res.xml \
		autogen/getdevicelist_args.xml \
		autogen/getdevicelist_res.xml \
		autogen/getfh_res.xml \
		autogen/illegal_res.xml \
		autogen/deallocate_args.xml \
		autogen/deallocate_res.xml \
		autogen/write_same_args.xml \
		autogen/write_same_res.xml \
		autogen/type_io_advise.xml \
		autogen/io_advise_args.xml \
		autogen/io_advise_res.xml \
		autogen/layoutcommit_args.xml \
		autogen/layoutcommit_res.xml \
		autogen/type_device_error.xml \
		autogen/layouterror_args.xml \
		autogen/layouterror_res.xml \
		autogen/layoutget_args.xml \
		autogen/layoutget_res.xml \
		autogen/layoutreturn_args.xml \
		autogen/layoutreturn_res.xml \
		autogen/type_io_info.xml \
		autogen/layoutstats_args.xml \
		autogen/layoutstats_res.xml \
		autogen/link_args.xml \
		autogen/link_res.xml \
		autogen/lock_args.xml \
		autogen/lock_res.xml \
		autogen/lockt_args.xml \
		autogen/lockt_res.xml \
		autogen/locku_args.xml \
		autogen/locku_res.xml \
		autogen/lookup_args.xml \
		autogen/lookup_res.xml \
		autogen/lookupp_res.xml \
		autogen/nverify_args.xml \
		autogen/nverify_res.xml \
		autogen/open_args_gen.xml \
		autogen/open_downgrade_args.xml \
		autogen/open_downgrade_res.xml \
		autogen/open_res.xml \
		autogen/openattr_args.xml \
		autogen/openattr_res.xml \
		autogen/putfh_args.xml \
		autogen/putfh_res.xml \
		autogen/putpubfh_res.xml \
		autogen/putrootfh_res.xml \
		autogen/read_args.xml \
		autogen/read_res.xml \
		autogen/read_plus_args.xml \
		autogen/read_plus_content.xml \
		autogen/read_plus_res_pre.xml \
		autogen/read_plus_res.xml \
		autogen/readdir_args.xml \
		autogen/readdir_res.xml \
		autogen/readlink_res.xml \
		autogen/reclaim_complete_args.xml \
		autogen/reclaim_complete_res.xml \
		autogen/remove_args.xml \
		autogen/remove_res.xml \
		autogen/rename_args.xml \
		autogen/rename_res.xml \
		autogen/restorefh_res.xml \
		autogen/savefh_res.xml \
		autogen/secinfo_args.xml \
		autogen/secinfo_no_name_args.xml \
		autogen/secinfo_no_name_res.xml \
		autogen/secinfo_res.xml \
		autogen/seek_args.xml \
		autogen/seek_res_pre.xml \
		autogen/seek_res.xml \
		autogen/sequence_args.xml \
		autogen/sequence_res.xml \
		autogen/set_ssv_args.xml \
		autogen/set_ssv_res.xml \
		autogen/setattr_args.xml \
		autogen/setattr_res.xml \
		autogen/test_stateid_args.xml \
		autogen/test_stateid_res.xml \
		autogen/verify_args.xml \
		autogen/verify_res.xml \
		autogen/want_delegation_args.xml \
		autogen/want_delegation_res.xml \
		autogen/write_args.xml \
		autogen/stable_how4.xml \
		autogen/write_res.xml

START_PREGEN = ${DOC_PREFIX}_rfc_start.xml
START=	${DOC_PREFIX}_rfc_start_autogen.xml
END=	${DOC_PREFIX}_rfc_end.xml

FRONT_PREGEN = ${DOC_PREFIX}_front.xml

IDXMLSRC_BASE = \
	${DOC_PREFIX}_middle_start.xml \
	${DOC_PREFIX}_middle_introduction.xml \
	${DOC_PREFIX}_middle_minorv.xml \
	${DOC_PREFIX}_middle_pnfs.xml \
	${DOC_PREFIX}_middle_copy.xml \
	${DOC_PREFIX}_middle_advise.xml \
	${DOC_PREFIX}_middle_sparse.xml \
	${DOC_PREFIX}_middle_space.xml \
	${DOC_PREFIX}_middle_application.xml \
	${DOC_PREFIX}_middle_lnfs.xml \
	${DOC_PREFIX}_middle_chattr.xml \
	${DOC_PREFIX}_middle_new_errors.xml \
	${DOC_PREFIX}_middle_fileattributes.xml \
	${DOC_PREFIX}_middle_op_mandlist.xml \
	${DOC_PREFIX}_middle_mod_op_start.xml \
	${DOC_PREFIX}_middle_mod_op_exchange_id.xml \
	${DOC_PREFIX}_middle_mod_op_getdevicelist.xml \
	${DOC_PREFIX}_middle_mod_op_end.xml \
	${DOC_PREFIX}_middle_op_start.xml \
	${DOC_PREFIX}_middle_op_allocate.xml \
	${DOC_PREFIX}_middle_op_copy.xml \
	${DOC_PREFIX}_middle_op_copy_notify.xml \
	${DOC_PREFIX}_middle_op_deallocate.xml \
	${DOC_PREFIX}_middle_op_io_advise.xml \
	${DOC_PREFIX}_middle_op_layouterror.xml \
	${DOC_PREFIX}_middle_op_layoutstats.xml \
	${DOC_PREFIX}_middle_op_offload_cancel.xml \
	${DOC_PREFIX}_middle_op_offload_status.xml \
	${DOC_PREFIX}_middle_op_read_plus.xml \
	${DOC_PREFIX}_middle_op_seek.xml \
	${DOC_PREFIX}_middle_op_write_same.xml \
	${DOC_PREFIX}_middle_op_clone.xml \
	${DOC_PREFIX}_middle_op_end.xml \
	${DOC_PREFIX}_middle_op_cb_start.xml \
	${DOC_PREFIX}_middle_op_cb_offload.xml \
	${DOC_PREFIX}_middle_op_cb_end.xml \
	${DOC_PREFIX}_middle_security.xml \
	${DOC_PREFIX}_middle_iana.xml \
	${DOC_PREFIX}_middle_end.xml \
	${DOC_PREFIX}_back_front.xml \
	${DOC_PREFIX}_back_references.xml \
	${DOC_PREFIX}_back_acks.xml \
	${DOC_PREFIX}_back_back.xml

IDCONTENTS = ${DOC_PREFIX}_front_autogen.xml $(IDXMLSRC_BASE)

IDXMLSRC = ${DOC_PREFIX}_front.xml $(IDXMLSRC_BASE)

draft-tmp.xml: $(START) ${DOC_PREFIX}_front_autogen.xml Makefile $(END) $(IDCONTENTS) $(AUTOGEN)
		rm -f $@ $@.tmp
		cp $(START) $@.tmp
		chmod +w $@.tmp
		for i in $(IDCONTENTS) ; do cat $$i >> $@.tmp ; done
		cat $(END) >> $@.tmp
		mv $@.tmp $@

${DRAFT_BASE}-$(VERS).xml: draft-tmp.xml $(IDCONTENTS) $(AUTOGEN)
		rm -f $@
		./rfcincfill.pl draft-tmp.xml $@

genhtml: Makefile gendraft html txt dotx dotx-txt draft-$(VERS).tar
	./gendraft draft-$(PREVVERS) \
		${DRAFT_BASE}-$(PREVVERS).txt \
		draft-$(VERS) \
		${DRAFT_BASE}-$(VERS).txt \
		${DRAFT_BASE}-$(VERS).html \
		dotx.d/nfsv42.x \
		draft-$(VERS).tar.gz

testx:
	rm -rf testx.d
	mkdir testx.d
	$(MAKE) dotx
	# In Linux, authunix is still used.
	# In Linux, the RPCSEC_GSS library/API has
	# a conflicting data type.
	# In Linux, the gssapi and RPCSEC_GSS headers
	# are placed in bizarre places.
	# In Linux, rpcgen produces a makefile name that
	# just *has* to be different from Solaris.
	( \
		if [ -f /usr/include/rpc/auth_sys.h ]; then \
			cp dotx.d/nfsv42.x testx.d ; \
		else \
			sed s/authsys/authunix/g < dotx.d/nfsv42.x | \
			sed s/auth_sys/auth_unix/g | \
			sed s/AUTH_SYS/AUTH_UNIX/g | \
			sed s/gss_svc/Gss_Svc/g > testx.d/nfsv42.x ; \
		fi ; \
	)
	( cd testx.d ; \
		rpcgen -a nfsv42.x ; )
	( cd testx.d ; \
		rpcgen -a nfsv42.x ; \
		if [ ! -f /usr/include/rpc/auth_sys.h ]; then \
			ln Make* make ; \
			CFLAGS="-I /usr/include/gssglue -I /usr/include/tirpc" ; export CFLAGS ; \
		fi ; \
		$(MAKE) -f make* )

spellcheck: $(IDXMLSRC)
	for f in $(IDXMLSRC); do echo "Spell Check of $$f"; aspell check -p dictionary.pws $$f; done
	cd dotx-id.d ; SPECVERS=$(VERS) $(MAKE) spellcheck

AUXFILES = \
	dictionary.txt \
	gendraft \
	Makefile \
	errortbl \
	rfcdiff \
	xml2rfc_wrapper.sh \
	xml2rfc

DRAFTFILES = \
	${DRAFT_BASE}-$(VERS).txt \
	${DRAFT_BASE}-$(VERS).html \
	${DRAFT_BASE}-$(VERS).xml

draft-$(VERS).tar: $(IDCONTENTS) $(START_PREGEN) $(FRONT_PREGEN) $(AUXFILES) $(DRAFTFILES) dotx.d/nfsv4.x
	rm -f draft-$(VERS).tar.gz
	tar -cvf draft-$(VERS).tar \
		$(START_PREGEN) \
		$(END) \
		$(FRONT_PREGEN) \
		$(IDCONTENTS) \
		$(AUXFILES) \
		$(DRAFTFILES) \
		`cat dotx.d/tmp.filelist` \
		`cat dotx-id.d/tmp.filelist`; \
		gzip draft-$(VERS).tar
