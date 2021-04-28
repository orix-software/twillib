.include "include/twil.inc"

.export _twil_lib_version

.proc _twil_lib_version
    lda 	#TWIL_LIB_VERSION_2021_3
    ldx     #$00
    rts
.endproc