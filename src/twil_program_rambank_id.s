
.importzp ptr1,ptr2,ptr3
.import popax,popa

.include "include/twil.inc"
.include "telestrat.inc"
.include "fcntl.inc"              ; from cc65
.include "errno.inc"              ; from cc65

.include "../dependencies/orix-sdk/macros/SDK_file.mac"
.include "../dependencies/orix-sdk/macros/SDK_memory.mac"


.import _twil_get_registers_from_id_bank
.import twil_save_registers
.import twil_restore_registers

; Used in systemd : twiload/conf binary

; void _twil_program_rambank_id(char *file, unsigned char idbank);

.export _twil_program_rambank_id






.proc _twil_program_rambank_id
    ldy     #$00
    sty     no_start

    sta     start_vector+1
    stx     start_vector+2

    cmp     #$00
    bne     @continue

    cpx     #$00
    bne     @continue

    lda     #$01
    sta     no_start

@continue:
    jsr     popa
    sta		sector_to_update

    jsr 	popax ; Get file
    sta     ptr1
    stx		ptr1+1

    jsr     popa ; get bank
    sta     current_bank

    sei
	jsr     twil_save_registers

    fopen (ptr1), O_RDONLY
    cpx     #$FF
    bne     @read_file ; not null then  start because we did not found a conf
    cmp     #$FF
    bne     @read_file ; not null then  start because we did not found a conf

@exit_clean:
    lda     #$01 ; Error
    ldx     #$00
    cli

    rts

@read_file:
    sta     ptr2    ; FP
    sty     ptr2+1  ; FPs

    ;malloc 16384, ptr1
    ;cmp     #$00
    ;bne     @no_oom
    ;cpy     #$00
    ;bne     @no_oom
;
    ;fclose(ptr2)
    ;jmp     @exit_clean
;@no_oom:

    lda     #<buffer
    sta     ptr1
    lda     #>buffer
    sta     ptr1+1


    fread (ptr1),16384, 1, ptr2

    fclose(ptr2)

start:

	; on swappe pour que les banques 8,7,6,5 se retrouvent en bas en id : 1, 2, 3, 4
    lda     sector_to_update
    jsr     _twil_get_registers_from_id_bank

    stx  	TWILIGHTE_BANKING_REGISTER

    sta     sector_to_update


    lda     VIA2::PRA
    and     #%11111000
    ora     sector_to_update
    sta     VIA2::PRA

	lda		TWILIGHTE_REGISTER
	ora		#%00100000
	sta		TWILIGHTE_REGISTER


    lda     #<buffer
    sta     ptr1
    lda     #>buffer
    sta     ptr1+1

    lda     #$c0
    sta     ptr3+1
    lda     #$00
    sta     ptr3

    ldx     #$00
    ldy     #$00
@loop_copy:
    lda     (ptr1),y
    sta     (ptr3),y
    iny
    bne     @loop_copy

    inc     ptr1+1
    inc     ptr3+1
    inx
    cpx     #64
    bne     @loop_copy
   ; mfree(ptr1)

    lda     no_start
    bne     skip_start

start_vector:
    jsr     $dead

skip_start:
@finished:
	jsr		twil_restore_registers

	lda		#$00
	cli
	rts

.data
current_bank:
    .res	1
sector_to_update:
    .res    1
buffer:
    .res 16384
no_start:
    .res 0

.endproc


