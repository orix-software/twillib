.importzp ptr1,ptr2,ptr3
.import popax,popa

.include "include/twil.inc"
.include "telestrat.inc"
.include "fcntl.inc"              ; from cc65


.include "../libs/usr/arch/include/ch376.inc"

.import _ch376_wait_response
.import _ch376_set_bytes_read
.import _ch376_file_open

.import twil_save_registers
.import twil_restore_registers

; void _twil_program_rambank(unsigned char bank, char *file, unsigned char set);

.export _twil_program_rambank

.proc _twil_program_rambank

	sta     sector_to_update

	jsr     popax ; Get file
	sta     ptr1
	stx		ptr1+1

    jsr     popa ; get bank
    sta     current_bank


    ldy     #O_RDONLY

	lda     ptr1
	ldx	    ptr1+1
	.byte   $00,XOPEN
	
	cmp		#$FF
	bne		@start
	cpx		#$FF
	bne		@start		
    lda     #$12
    sta     $bb80
   
	jsr		twil_restore_registers
	lda		#$01
	cli
	rts

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
  ;  lda     #$11
   ; sta     $bb80


	lda		#$00
	sta		ptr3

	lda		#$C0
	sta		ptr3+1	

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
	sta		(ptr3),y
    iny

@skip_change_bank:

    dec		nb_bytes
    bne		@read_byte
    
    tya     
    clc
    adc     ptr3
    bcc     @skip_inc
    inc     ptr3+1
@skip_inc:
    sta     ptr3    

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
