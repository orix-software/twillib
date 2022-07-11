
.importzp ptr1,ptr2,ptr3,tmp1


.include "include/twil.inc"
.include "telestrat.inc"

;.include "../libs/usr/arch/include/ch376.inc"

;.import _ch376_wait_response
;.import _ch376_set_bytes_read
;.import _ch376_file_open

.import twil_save_registers
.import twil_restore_registers

.import popa

.export  rom_signature

.export _twil_clear_rambank



;unsigned char twil_clear_rambank(unsigned char bank, unsigned char set);
.proc _twil_clear_rambank
	sei
	sta		sector_to_update

	jsr     twil_save_registers
	; on swappe pour que les banques 8,7,6,5 se retrouvent en bas en id : 1, 2, 3, 4

    jsr     popa ; get bank
    sta     current_bank

    lda     VIA2::PRA
    and     #%11111000
    ora     current_bank
    sta     VIA2::PRA
	
    lda     sector_to_update ; pour debug FIXME, cela devrait être à 4
    sta  	TWILIGHTE_BANKING_REGISTER

	lda		TWILIGHTE_REGISTER
	ora		#%00100000
	sta		TWILIGHTE_REGISTER

    lda     #<IRQVECTOR
    ;cmp     $FFFE
    sta     $FFFE

    lda     #>IRQVECTOR
    sta     $FFFF

    lda     #$00   ; Set empty bank
    sta     $fff0 

    lda     #<$c000
    sta     $fff8

    lda     #>$c000
    sta     $fff9

    lda     #$00
    sta     $fff7

    ; Clear ID bank
    sta     $FFED
    sta     $FFEE
    sta     $FFEF

    ldx     #$00
@L1:
    lda     rom_signature,x
    beq     @out
    sta     $c000,x
    inx 
    bne     @L1

@out:
    sta     $c000,x


	jsr		twil_restore_registers

	lda		#$00
	cli
	rts


str_slash:
	.asciiz "/"


.endproc

rom_signature:
	.ASCIIZ   "Empty ram v2021.2"

current_bank:
    .res	1
sector_to_update:
    .res    1
nb_bytes:
    .res    1
