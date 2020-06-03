
.importzp ptr1,ptr2,ptr3
.import popax
.include "twilighte.inc"
.include "telestrat.inc"

.include "../dependencies/ch376-lib/src/include/ch376.inc"
.include "../dependencies/ch376-lib/src/_ch376_wait_response.s"
.include "../dependencies/ch376-lib/src/_ch376_set_bytes_read.s"
.include "../dependencies/ch376-lib/src/_ch376_file_open.s"

.export current_bank

; void _twil_program_sector(unsigned char sector);

.export _twil_program_sector

.proc _twil_program_sector
	sei
	sta		sector_to_update

	;lda		#$00
	;sta	    pos_cputc

	jsr 	popax ; Get file
	sta     ptr1
	stx		ptr1+1

	;lda     #$00
	;sta     posx
	jsr     save_twil_registers
	; on swappe pour que les banques 8,7,6,5 se retrouvent en bas en id : 1, 2, 3, 4
	
	
    lda     sector_to_update ; pour debug FIXME, cela devrait être à 4
    sta  	TWILIGHTE_BANKING_REGISTER

	lda		TWILIGHTE_REGISTER
	and		#%11011111
	sta		TWILIGHTE_REGISTER

	lda		#$01
	sta		current_bank

    lda     #CH376_SET_FILE_NAME        ;$2f
    sta     CH376_COMMAND
    lda     #'/'

    sta     CH376_DATA
	lda		#$00
    sta     CH376_DATA
	jsr		_ch376_file_open


reset_label:

    lda     #CH376_SET_FILE_NAME        ;$2f
    sta     CH376_COMMAND

	ldy		#$00
@L1:	
	lda     (ptr1),y
    beq 	@S1
  	
  	cmp     #'a'                        ; 'a'
  	bcc     @do_not_uppercase
  	cmp     #'z'+1                        ; 'z'
  	bcs     @do_not_uppercase
  	sbc     #$1F
@do_not_uppercase:
	sta		CH376_DATA
	iny
	bne		@L1
	lda		#$00
@S1:
	sta		CH376_DATA
	
	jsr		_ch376_file_open

    cmp		#CH376_ERR_MISS_FILE
    bne 	start
	jsr		restore_twil_registers
	lda		#$01
	cli
	rts


start:

	; Erase 
	lda		sector_to_update
	sta  	TWILIGHTE_BANKING_REGISTER

	jsr	    _erase_sector

;	lda		#'1'
;	sta     value_to_display

	lda		#$00
	sta		ptr3

	lda		#$C0
	sta		ptr3+1	

    lda		#$FF
    tay
    jsr		_ch376_set_bytes_read

@loop:
    cmp		#CH376_USB_INT_DISK_READ
    bne		@finished

    lda		#CH376_RD_USB_DATA0
    sta		CH376_COMMAND
    lda		CH376_DATA
	sta		nb_bytes
    ; Tester si userzp == 0?

;	lda		current_bank
;	clc
 ;   adc		#$30
;	sta     $bb80+21


  @read_byte:
	
    lda		CH376_DATA
	pha
	jsr		write_kernel
	pla



;	lda     value_to_display
@display:
;	ldx		posx
 ; 	sta		$bb80+40,x
;	inx
;	stx		posx

	lda		ptr3+1
	bne     @skip_change_bank

	lda		ptr3
	bne     @skip_change_bank	

	;inc		value_to_display

	lda		#$00
	sta		ptr3

	lda		#$C0
	sta		ptr3+1	


	ldx     current_bank
	inx
	stx	    current_bank
	cpx     #$05
	bne     @skip_change_bank
	; end we stop


	lda     #$00
	cli
	rts


@skip_change_bank:

    dec		nb_bytes
    bne		@read_byte

    lda		#CH376_BYTE_RD_GO
    sta		CH376_COMMAND
    jsr		_ch376_wait_response

    ; _ch376_wait_response renvoie 1 en cas d'erreur et le CH376 ne renvoie pas de valeur 0
    ; donc le bne devient un saut inconditionnel!
    bne		@loop
 @finished:

	jsr		restore_twil_registers

	lda		#$00
	cli
	rts


str_slash:
	.asciiz "/"
posx:
	.res 1	
.endproc

current_bank:
    .res	1
sector_to_update:
    .res    1
nb_bytes:
    .res    1
