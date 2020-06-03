
.import current_bank

.importzp ptr3

.export write_byte_rom

.proc write_byte_rom

write_loop:
	pha
	
	lda		#$A0
	jsr		sequence

	lda  	sector_to_update ; pour debug FIXME, cela devrait être à 4
	sta  	TWILIGHTE_BANKING_REGISTER

	lda		current_bank ; Switch to bank
	jsr		select_bank
	
	;lda     #'#'
	;jsr     _cputc_custom

	;lda		ptr3
	;ldx		ptr3+1
	;jsr		_cputhex16_custom

	pla
	ldy		#$00
	sta		(ptr3),y
wait_write:
	cmp		(ptr3),y
	bne		wait_write
	inc		ptr3
	bne		@S1
	inc		ptr3+1
@S1:

	
	rts
.endproc