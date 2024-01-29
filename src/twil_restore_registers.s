.include "include/twil.inc"
.include "telestrat.inc"

.importzp tmp1
.importzp tmp3

.import save_bank

.export twil_restore_registers

; not available from c

.proc	twil_restore_registers
    ;;@brief Restore essentials Twilighte board register : Can be used in eeprom or EEPROM
    ;;@inputA TWILIGHTE_BANKING_REGISTER backup
    ;;@inputX TWILIGHTE_REGISTER backup
    ;;@inputY Bank backup
    ;;@```ca65
    ;;@`  lda       #$01 ; TWILIGHTE_BANKING_REGISTER
    ;;@`  ldx       #$01 ; TWILIGHTE_REGISTER
    ;;@`  ldy       #$01 ; bank
    ;;@`  jsr       twil_restore_registers
    ;;@`  rts
    ;;@```

    sta     TWILIGHTE_BANKING_REGISTER
    stx     TWILIGHTE_REGISTER

    tya
    and     #%11111000
    ora     VIA2::PRA
    sta     VIA2::PRA
    rts

.endproc
