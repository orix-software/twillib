.include "twilighte.inc"
.include "telestrat.inc"

.import tmp1,tmp2

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
