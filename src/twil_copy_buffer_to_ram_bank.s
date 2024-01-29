.include "include/twil.inc"
.include "telestrat.inc"
.include "fcntl.inc"              ; from cc65


.include "../libs/usr/arch/include/ch376.inc"


.import _twil_get_registers_from_id_bank
; void twil_load_into_ram_bank(unsigned char bankid, char *buffer);

; X contains the bankid
; AY contains the the adress of the buffer
; RES contains the size in pages ; One byte
; RESB contains the ptr address to write

.export twil_copy_buffer_to_ram_bank

current_bank:=TR0
sector_to_update:=TR1
nb_bytes:=TR2
tmp1:=TR3
tmp3:=TR4
ptr1:=TR5 ; 2 bytes adress of the buffer
save_bank:= TR7

.proc twil_copy_buffer_to_ram_bank

    sta     ptr1
    sty     ptr1+1

    txa
    jsr     _twil_get_registers_from_id_bank
    stx     sector_to_update
    sta     current_bank
    ;

@start:
    sei
    jsr     twil_save_registers
    ; on swappe pour que les banques 8,7,6,5 se retrouvent en bas en id : 1, 2, 3, 4

    lda     VIA2::PRA
    and     #%11111000
    ora     current_bank
    sta     VIA2::PRA

    lda     sector_to_update ; pour debug FIXME, cela devrait être à 4
    sta  	TWILIGHTE_BANKING_REGISTER

	lda		TWILIGHTE_REGISTER
	ora		#%00100000
	sta		TWILIGHTE_REGISTER

    sei

    ldy    #$00
@loop:
    lda    (ptr1),y
    sta    (RESB),y
    iny
    bne    @loop
    inc    RESB+1
    inc    ptr1+1
    dec    RES
    bpl    @loop


	jsr		twil_restore_registers

	lda		#$00
	cli
	rts

.endproc

.proc	twil_restore_registers

    ldx     save_bank
    stx     VIA2::PRA

    lda     tmp1
    sta     TWILIGHTE_BANKING_REGISTER

    ldx     tmp3
    stx     TWILIGHTE_REGISTER

    rts

.endproc

.proc	twil_save_registers
    ldx     TWILIGHTE_BANKING_REGISTER
    stx     tmp1

    ldx     TWILIGHTE_REGISTER
    stx     tmp3

    ldx     VIA2::PRA
    stx     save_bank

    rts

.endproc
