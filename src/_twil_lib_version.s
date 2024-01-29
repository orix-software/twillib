.include "include/twil.inc"

.export _twil_lib_version
.export twil_lib_version

.proc _twil_lib_version
    ldx     #$00
.endproc

.proc twil_lib_version
    ;;@brief Return twil lib version
    ;;@modifyA
    ;;@returnsA twillib version
    ;;@```ca65
    ;;@`  jsr       twil_lib_version
    ;;@`  cmp       #TWIL_LIB_VERSION_2024_1
    ;;@`  beq       @is_twillib2024.1
    ;;@`  rts
    ;;@`  @is_twillib2024.1
    ;;@```
    lda     #TWIL_LIB_VERSION_2024_1
    rts
.endproc
