
include(type_nfl_util4.x)
%

include(type_nfsv4_1_file_layouthint4.x)
%

include(type_nfsv4_1_file_layout_ds_addr4.x)
%

include(type_nfsv4_1_file_layout4.x)
%

%/*
% * Encoded in the lou_body field of data type layoutupdate4:
% *	 Nothing. lou_body is a zero length array of bytes.
% */
%

%/*
% * Encoded in the lrf_body field of
% * data type layoutreturn_file4:
% */
include(type_layoutreturn_errs.x)
%

