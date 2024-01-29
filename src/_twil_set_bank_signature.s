.include "include/twil.inc"
.include "telestrat.inc"

.export _twil_set_bank_signature

.import rom_signature

.export _twil_set_bank_signature
.export twil_set_bank_signature


;unsigned char twil_set_bank_signature(char *signature);

.proc _twil_set_bank_signature

.endproc

.proc twil_set_bank_signature
    ;;@brief Set bank signature
    ;;@modifyA
    ;;@modifyY
    ;;@modifyMEM_RES For twil_set_bank_signature operation
    ;;@inputMEM_libzp Bank backup
    ;;@```ca65
    ;;@`  jsr       twil_set_bank_signature
    ;;@`  rts
    ;;@```
    sta     RES
    stx     RES+1
    ldy     #$00

@L1:
    lda     (RES),y
    beq     @out
    sta     rom_signature,y
    iny
    cpy     #37
    bne     @L1
    lda     #$00
@out:
    sta     rom_signature,y
    rts
.endproc
