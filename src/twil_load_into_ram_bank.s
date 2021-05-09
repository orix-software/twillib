.include "include/twil.inc"
.include "telestrat.inc"
.include "fcntl.inc"              ; from cc65


.include "../libs/usr/arch/include/ch376.inc"

.import _ch376_wait_response
.import _ch376_set_bytes_read
.import _ch376_file_open


.import _twil_get_registers_from_id_bank
; void twil_load_into_ram_bank(unsigned char bankid, char *buffer);

; Y contains the bankid
; A contains the FD

.export twil_load_into_ram_bank

.proc twil_load_into_ram_bank
	sta     RES ; Save FD

    tya
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


	lda		#$00
	sta		RESB

	lda		#$C0
	sta		RESB+1	

    lda		#$00
    ldy     #$40
    jsr		_ch376_set_bytes_read

@loop:
    cmp		#CH376_USB_INT_DISK_READ
    bne		@finished

    lda		#CH376_RD_USB_DATA0
    sta		CH376_COMMAND
    lda		CH376_DATA
	sta		nb_bytes
    ; Tester si userzp == 0?

    ldy    #$00

@read_byte:
	
    lda		CH376_DATA
	sta		(RESB),y
    iny

@skip_change_bank:

    dec		nb_bytes
    bne		@read_byte
    
    tya     
    clc
    adc     RESB
    bcc     @skip_inc
    inc     RESB+1
@skip_inc:
    sta     RESB    

    lda		#CH376_BYTE_RD_GO
    sta		CH376_COMMAND
    jsr		_ch376_wait_response

    ; _ch376_wait_response renvoie 1 en cas d'erreur et le CH376 ne renvoie pas de valeur 0
    ; donc le bne devient un saut inconditionnel!
    bne		@loop
 @finished:

	jsr		twil_restore_registers

	lda		#$00
	cli
	rts

.endproc

current_bank:
    .res	1
sector_to_update:
    .res    1
nb_bytes:
    .res    1
tmp1:
    .res    1
tmp3: 
    .res    1    
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
.bss
save_bank:    
    .res      1    
