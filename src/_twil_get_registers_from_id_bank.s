; a contains the id of the command
; It returns :
;

.export _twil_get_registers_from_id_bank
.export twil_get_registers_from_id_bank

;unsigned char twil_get_registers_from_id_bank(unsigned char bank);
.proc _twil_get_registers_from_id_bank
    ; Follow
.endproc

.proc twil_get_registers_from_id_bank
    ;;@brief Convert logical bank number into set and bank id
    ;;@inputA Logical bank number to convert
    ;;@inputY Bank
    ;;@modifyA
    ;;@modifyX
    ;;@modifyY
    ;;@returnsA Bank
    ;;@returnsX Set (banking register)
    ;;@```ca65
    ;;@`  lda       #$03 ;  set 3
    ;;@`  ldy       #$03 ;  bank3
    ;;@`  jsr       twil_get_id_bank
    ;;@`  ; A contains the logical bank
    ;;@`  rts
    ;;@```
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
    ; Rom
    .byt 0
    .byte    0,0,0,0
    .byte    4,4,4,4
    .byte    1,1,1,1
    .byte    5,5,5,5
    .byte    2,2,2,2
    .byte    6,6,6,6
    .byte    3,3,3,3
    .byte    7,7,7,7

    ; Ram
    .byte    0,0,0,0
    .byte    1,1,1,1
    .byte    2,2,2,2
    .byte    3,3,3,3
    .byte    4,4,4,4
    .byte    5,5,5,5
    .byte    6,6,6,6
    .byte    7,7,7,7

bank:
    .byt 0
    ; Rom
    .byte    1,2,3,4
    .byte    1,2,3,4
    .byte    1,2,3,4
    .byte    1,2,3,4
    .byte    1,2,3,4
    .byte    1,2,3,4
    .byte    1,2,3,4
    .byte    1,2,3,4

    ; Ram
    .byte    1,2,3,4
    .byte    1,2,3,4
    .byte    1,2,3,4
    .byte    1,2,3,4
    .byte    1,2,3,4
    .byte    1,2,3,4
    .byte    1,2,3,4
    .byte    1,2,3,4

.endproc

