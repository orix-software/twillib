 ;.if     .defined(TWIL_INC_LOADED)
.include "include/twil.inc"
;.endif
;.struct twil_bank_struct
    ;id_bank                   .res 1
    ;signature_str             .res 1
    ;pos_x                     .res 1
    ;pos_y                     .res 1
;.endstruct

 TWIL_READ_BYTE_FROM_OVERLAY_RAM := $04C7

; AY contains struct ptr
.proc twil_putScreenXY_bank_signature
    ; 
    sta     RES
    sty     RES+1

    sei
    
    lda     TWILIGHTE_BANKING_REGISTER
    sta     save_twilighte_banking_register
    
    ; switch to ram
    lda     TWILIGHTE_REGISTER
    sta     save_twilighte_register

    ldy     #twil_bank_struct::id_bank
    lda     (RES),y

    jsr     _twil_get_registers_from_id_bank
    ; X set
    ; A register bank
    sta     TWILIGHTE_REGISTER
    stx     TWILIGHTE_BANKING_REGISTER

    jsr     twil_get_bank_empty ; Is it an empty ROM ?
    cmp     #$00
    bne     @not_empty
    ; then displays empty


    jmp     @restore
@not_empty:

    ;ora     #%00100000
    ;sta     $342

    ;jsr     displays_banking

    ;lda     $342
    ;and     #%11011111
    ;sta     $342

    ;jsr     displays_banking


@restore:
    lda     save_twilighte_register
    sta     TWILIGHTE_REGISTER

    lda     save_twilighte_banking_register
    sta     TWILIGHTE_BANKING_REGISTER
    cli



    rts
save_twilighte_register:
    .res 1
save_twilighte_banking_register:    
    .res 1
.endproc

.proc twil_get_bank_empty
    lda     #<$FFF0
    sta     twil_get_bank_empty_ptr1
    lda     #>$FFF0
    sta     twil_get_bank_empty_ptr1+1
    ldy     #$00
    ldx     #$00 ; Read mode
    jsr     TWIL_READ_BYTE_FROM_OVERLAY_RAM ; get low
    rts
.endproc

.proc twil_get_bank_is_empty
    ; A id of the bank

    sei
    pha
    lda     TWILIGHTE_BANKING_REGISTER
    sta     save_twilighte_banking_register
    
    ; switch to ram
    lda     TWILIGHTE_REGISTER
    sta     save_twilighte_register

    pla

    jsr     _twil_get_registers_from_id_bank

    ; X set
    ; A register bank
    sta     TWILIGHTE_REGISTER
    stx     TWILIGHTE_BANKING_REGISTER



    lda     #<$FFF0
    sta     twil_get_bank_empty_ptr1
    lda     #>$FFF0
    sta     twil_get_bank_empty_ptr1+1
    ldy     #$00
    ldx     #$00 ; Read mode
    jsr     TWIL_READ_BYTE_FROM_OVERLAY_RAM ; get low
    pha
    lda     save_twilighte_register
    sta     TWILIGHTE_REGISTER

    lda     save_twilighte_banking_register
    sta     TWILIGHTE_BANKING_REGISTER
    pla

    cli
    rts
.endproc