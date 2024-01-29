.include "include/twil.inc"
.include "telestrat.inc"

.importzp tmp1
.importzp tmp3

.export save_bank

.export twil_save_registers

; not available from c

.proc	twil_save_registers
    ;;@brief Save essentials Twilighte board register. Can be used in eeprom bank or ram bank
    ;;@modifyA
    ;;@modifyX
    ;;@modifyY
    ;;@returnsA TWILIGHTE_BANKING_REGISTER value
    ;;@returnsX TWILIGHTE_REGISTER value
    ;;@returnsY current bank value
    ;;@```ca65
    ;;@`  jsr       twil_save_registers
    ;;@`  rts
    ;;@```

    lda     TWILIGHTE_BANKING_REGISTER
    ldx     TWILIGHTE_REGISTER
    ldy     VIA2::PRA
    rts

.endproc
.bss
save_bank:
    .res      1
