.importzp ptr1,ptr2

.include "include/twil.inc"
.include "telestrat.inc"

.import twil_save_registers
.import twil_restore_registers

.export  _twil_display_signature_bank

.define MAX_SIGNATURE_LENGTH 40
; ROMRAM : 0 ROM, 1 RAM
; unsigned char * display_signature_bank( unsigned char sector,  unsigned char bank)

.proc _twil_display_signature_bank
    sta     current_bank

    stx     TWILIGHTE_BANKING_REGISTER
    sei
    jsr     twil_save_registers
    ; Save banking register
    ; Switch to right bank
    lda     VIA2::PRA
    and     #%11111000
    ora     current_bank
    sta     VIA2::PRA

@go:
    lda     #<$FFF8
    sta     ptr1
    lda     #>$FFF8
    sta     ptr1+1

    ldy     #$00

    lda     (ptr1),y
    sta     ptr2
    iny
    lda     (ptr1),y
    sta     ptr2+1


    ldy     #$00

@L1:
    lda     (ptr2),y
    beq     @out
    cmp     #$0A ; skip return line
    beq     @out
    cmp     #$0D
    beq     @out
    sta     bank_signature,y

    iny
    cpy     #MAX_SIGNATURE_LENGTH
    bne     @L1

@out:
    lda     #$00
    sta     bank_signature,y

    jsr     twil_restore_registers

    cli
    lda     #<bank_signature
    ldx     #>bank_signature
    rts
current_bank:
    .res 1
save_bank:
    .res 1
bank_signature:
    .res MAX_SIGNATURE_LENGTH
.endproc
