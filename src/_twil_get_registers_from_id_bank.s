
; a contains the id of the command
; It returns : 
; 

.export _twil_get_registers_from_id_bank

.import popa

.importzp tmp1

;unsigned char twil_get_registers_from_id_bank(unsigned char bank);
.proc _twil_get_registers_from_id_bank
    cmp     #$00
    beq     @bank0
    tay
    lda     set,y
    tax
    lda     bank,y
    rts
@bank0:
    ; Impossible to have bank 0
    tax    
    rts

set:
    .byte 0,0,0,0,1,1,1,1
    .byte 1,1,1,1,1,1,1,1
    .byte 1,1,1,1,1,1,1,1
    .byte 1,1,1,1,1,1,1,1

    .byte 0,0,0,0,0,1,1,1
    .byte 1,2,2,2,2,3,3,3
    .byte 3,4,4,4,4,5,5,5
    .byte 5,6,6,6,6,7,7,7,7    

bank:
    .byte 1,2,3,4,1,1,1,1
    .byte 3,1,1,1,1,1,1,1
    .byte 3,1,1,1,1,1,1,1
    .byte 3,1,1,1,1,1,1,1

    .byte 0,1,2,3,4,1,2,3
    .byte 4,1,2,3,4,1,2,3
    .byte 4,1,2,3,4,1,2,3
    .byte 4,1,2,3,4,1,2,3
    .byte 4

.endproc

