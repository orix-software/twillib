.include "include/twil.inc"
.include "telestrat.inc"
.include "fcntl.inc"              ; from cc65
.include "errno.inc"              ; from cc65

.include "../dependencies/orix-sdk/macros/SDK_file.mac"
.include "../dependencies/orix-sdk/macros/SDK_memory.mac"


.import twil_get_registers_from_id_bank
.import twil_restore_registers
.import twil_save_registers

.proc twil_program_bank_code_inside_bank
    ;;@brief Program bank from a file. This routine can be used when the main program is inserted in a bank. This routine will copy a routine into main memory to copy the file
    ;;@inputA Low ptr pathfilename
    ;;@inputX High ptr pathfilename
    ;;@inputY Logical bank to program
    ;;@```ca65
    ;;@`  lda       #<memcache_rom
    ;;@`  ldx       #>memcache_rom
    ;;@`  ldy       #33
    ;;@`  jsr       twil_program_bank_code_inside_bank
    ;;@`  rts
    ;;@memcache_rom:
    ;;@   .asciiz "/usr/share/memcache/memcache.rom"
    ;;@```

    fp                      := libzp
    malloc_ptr              := libzp+1
    copy_routine            := libzp+3
    filename                := libzp+5
    logical_bank_to_update  := libzp+7
    dest_addr               := libzp+8
    bkpA                    := libzp+10
    bkpX                    := libzp+11
    bkpY                    := libzp+12
    physical_bank_to_update := libzp+13
    number_of_chunk_to_copy := libzp+14

    sta     filename
    stx     filename+1
    sty     logical_bank_to_update

    lda     #64
    sta     number_of_chunk_to_copy


    fopen (filename), O_RDONLY
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
    sta     fp    ; FP

    malloc 512
    cmp     #$00
    bne     @no_oom
    cpy     #$00
    bne     @no_oom
;
    fclose(fp)
    jmp     @exit_clean

@no_oom:
    sta     malloc_ptr
    sta     copy_routine

    sty     malloc_ptr+1
    sty     copy_routine+1

    inc     copy_routine+1
    jsr     fill_malloc_with_copy_routine

    lda     #$c0
    sta     dest_addr+1
    lda     #$00
    sta     dest_addr

@loop_read:
    fread (malloc_ptr), 256, 1, fp

    sei
    jsr     twil_save_registers
    sta     bkpA
    stx     bkpX
    sty     bkpY

	; on swappe pour que les banques 8,7,6,5 se retrouvent en bas en id : 1, 2, 3, 4
    lda     logical_bank_to_update
    jsr     twil_get_registers_from_id_bank

    sta     physical_bank_to_update
    stx  	TWILIGHTE_BANKING_REGISTER

    lda     VIA2::PRA
    and     #%11111000
    ora     physical_bank_to_update
    sta     VIA2::PRA

	lda		TWILIGHTE_REGISTER
	ora		#%00100000
	sta		TWILIGHTE_REGISTER

    jsr     copy_routine
    inc     dest_addr+1


    lda     bkpA
    ldx     bkpX
    ldy     bkpY
	jsr		twil_restore_registers
    cli
    dec     number_of_chunk_to_copy
    bne     @loop_read



exit_ok:
	lda		#$00
	cli
    fclose(fp)
    mfree(malloc_ptr)
	rts


fill_malloc_with_copy_routine:
    ldx     #$00

@L1:
    lda     @my_copy_routine,x
    sta     copy_routine,x
    inx
    cpx     #20
    rts

@my_copy_routine:

    ldy     #$00

@loop_copy:
    lda     (malloc_ptr),y
    sta     (dest_addr),y
    iny
    bne     @loop_copy
    rts



.endproc