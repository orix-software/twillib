.include "include/twil.inc"
.include "telestrat.inc"

.importzp tmp1
.importzp tmp3

.import save_bank

.export twil_restore_registers

; not available from c

.proc	twil_restore_registers
    

    lda     VIA2::PRA
    and     #%11111000
    ora     save_bank
    sta     VIA2::PRA

    lda     tmp1
    sta     TWILIGHTE_BANKING_REGISTER

    ldx     tmp3
    stx     TWILIGHTE_REGISTER
 
    rts

.endproc	


