.include "include/twil.inc"
.include "telestrat.inc"

.export tmp1
.export tmp2

.import save_bank

.export twil_restore_registers

; not available from c

.proc	twil_restore_registers
    
    ldx     save_bank
    stx     VIA2::PRA

    lda     tmp1
    sta     TWILIGHTE_BANKING_REGISTER

    ldx     tmp2
    stx     TWILIGHTE_REGISTER
 
    rts

.endproc	
.bss
tmp1:
    .res 1
tmp2:
    .res 1