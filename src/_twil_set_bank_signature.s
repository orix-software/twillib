.export _twil_set_bank_signature

.import rom_signature

.export _twil_set_bank_signature

.importzp ptr1
;unsigned char twil_set_bank_signature(char *signature);

.proc _twil_set_bank_signature
	sta     ptr1
	stx		ptr1+1
    ldy     #$00
@L1:    
    lda     (ptr1),y
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