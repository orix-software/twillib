.importzp ptr1,ptr2
.import popa
.import tmp1,tmp2

.include "twilighte.inc"
.include "telestrat.inc"



.export  _twil_display_signature_bank

.define MAX_SIGNATURE_LENGTH 40
; ROMRAM : 0 ROM, 1 RAM
; unsigned char * display_signature_bank(unsigned char ROMRAM, unsigned char sector,  unsigned char bank)

.proc _twil_display_signature_bank
    sei
    
        ; Save banking register
    ldx     TWILIGHTE_BANKING_REGISTER
    stx     tmp1

    ldx     TWILIGHTE_REGISTER
    stx     tmp2

    ldx     VIA2::PRA
    stx     save_bank
    
    ;  switch to right bank
    and     #%00000111
    stx     VIA2::PRA


    jsr     popa ; sector
    sta     TWILIGHTE_BANKING_REGISTER

    jsr     popa ; ROM RAM
    cmp     #$00 ; ? ROM
    bne     @RAM
    and     #%11011111
    sta     TWILIGHTE_REGISTER
    jmp     @go
@RAM:   
    ora     #%00111111
    sta     TWILIGHTE_REGISTER 
    ; 

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


    ldx     save_bank
    stx     VIA2::PRA

    lda     tmp1
    sta     TWILIGHTE_BANKING_REGISTER

    ldx     tmp2
    stx     TWILIGHTE_REGISTER
   

    cli 
    lda     #<bank_signature
    ldx     #>bank_signature
    rts
save_bank:
    .res 1    
bank_signature:    
    .res MAX_SIGNATURE_LENGTH  
.endproc
