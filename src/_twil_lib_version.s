.include "include/twil.inc"

.export _twil_lib_version

.proc _twil_lib_version
    lda 	#TWIL_LIB_VERSION_2022_4
    ldx     #$00
    rts
.endproc