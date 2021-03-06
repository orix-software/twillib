.include "include/twil.inc"
.include "telestrat.inc"

.importzp tmp1
.importzp tmp3

.export save_bank

.export twil_save_registers

; not available from c

.proc	twil_save_registers
    ldx     TWILIGHTE_BANKING_REGISTER
    stx     tmp1

    ldx     TWILIGHTE_REGISTER
    stx     tmp3

    ldx     VIA2::PRA
    stx     save_bank

    rts

.endproc	
.bss
save_bank:    
    .res      1    
