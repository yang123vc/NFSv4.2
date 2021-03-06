const RCA4_TYPE_MASK_RDATA_DLG		= 0;
const RCA4_TYPE_MASK_WDATA_DLG		= 1;
const RCA4_TYPE_MASK_DIR_DLG		= 2;
const RCA4_TYPE_MASK_FILE_LAYOUT	= 3;
const RCA4_TYPE_MASK_BLK_LAYOUT		= 4;
const RCA4_TYPE_MASK_OBJ_LAYOUT_MIN	= 8;
const RCA4_TYPE_MASK_OBJ_LAYOUT_MAX	= 9;
const RCA4_TYPE_MASK_OTHER_LAYOUT_MIN	= 12;
const RCA4_TYPE_MASK_OTHER_LAYOUT_MAX	= 15;

struct	CB_RECALL_ANY4args	{
	uint32_t	craa_objects_to_keep;
	bitmap4		craa_type_mask;
};

