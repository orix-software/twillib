
; a contains the id of the command
; It returns : 
; 

.export _twil_get_id_bank

.import popa

.importzp tmp1

;unsigned char _twil_get_id_bank(unsigned char bank, unsigned char set)
.proc _twil_get_id_bank
    
    tax             ; Save

    pha
    lda     #$00    ; init tmp1
    sta     tmp1
    pla

    cmp     #$00    ; is it set 0 ?
    beq     @out

    
    lda     #$00
@L1:    
    clc
    adc     #$04
    dex
    bne     @L1
    sta     tmp1

@out:      
    jsr     popa
    
    clc
    adc     tmp1
    
    tax


  
    lda     table,x
    ldy     #$00
    rts
table:    
.byt  0,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,1,2,3,4,5,59,38,8,38,62,63,64,53,64,11,12,13,55,15,16,17,18,19,20,21



.endproc