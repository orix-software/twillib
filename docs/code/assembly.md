# Assembly

const char str_slash[2] = "/";
const char rom_signature[18] = "Empty ram v2024.2";
## twil_clear_rambank

***Description***

Clear bank for Orix bank pattern. Can work in ram bank or rom bank

***Input***

* Accumulator : bank register to clear
* Y Register : banking register to clear

***Modify***

* X Register 
* Y Register 

***Returns***

* Accumulator : TWILIGHTE_BANKING_REGISTER value

* X Register : TWILIGHTE_REGISTER value

* Y Register : current bank value


***Example***

```ca65
 jsr twil_save_registers
 rts
```



## twil_copy_buffer_to_ram_bank



## twil_restore_registers



## twil_save_registers



## twil_get_bank_signature



## twil_get_id_bank

***Description***

Convert set and bank to logical bank id

***Input***

* Accumulator : Set 
* Y Register : Bank 

***Modify***

* Accumulator 
* X Register 
* Y Register 

***Returns***

* Accumulator : The logical bank id


***Example***

```ca65
 lda #$03 ; set 3
 ldy #$03 ; bank3
 jsr twil_get_id_bank
 ; A contains the logical bank
 rts
```



## twil_get_registers_from_id_bank

***Description***

Convert logical bank number into set and bank id

***Input***

* Accumulator : Logical bank number to convert
* Y Register : Bank 

***Modify***

* Accumulator 
* X Register 
* Y Register 

***Returns***

* Accumulator : Bank 

* X Register : Set (banking register)


***Example***

```ca65
 lda #$03 ; set 3
 ldy #$03 ; bank3
 jsr twil_get_id_bank
 ; A contains the logical bank
 rts
```



## twil_lib_version

***Description***

Return twil lib version


***Modify***

* Accumulator 

***Returns***

* Accumulator : twillib version


***Example***

```ca65
 jsr twil_lib_version
 cmp #TWIL_LIB_VERSION_2024_1
 beq @is_twillib2024.1
 rts
 @is_twillib2024.1
```



## twil_load_into_ram_bank



## twil_restore_registers



## twil_save_registers



## twil_program_bank_code_inside_bank

***Description***

Program bank from a file. This routine can be used when the main program is inserted in a bank. This routine will copy a routine into main memory to copy the file

***Input***

* Accumulator : Low ptr pathfilename
* X Register : High ptr pathfilename
* Y Register : Logical bank to program

***Example***

```ca65
 lda #<memcache_rom
 ldx #>memcache_rom
 ldy #33
 jsr twil_program_bank_code_inside_bank
 rts
```



## twil_restore_registers

***Description***

Restore essentials Twilighte board register : Can be used in eeprom or EEPROM

***Input***

* Accumulator : TWILIGHTE_BANKING_REGISTER backup
* X Register : TWILIGHTE_REGISTER backup
* Y Register : Bank backup

***Example***

```ca65
 lda #$01 ; TWILIGHTE_BANKING_REGISTER
 ldx #$01 ; TWILIGHTE_REGISTER
 ldy #$01 ; bank
 jsr twil_restore_registers
 rts
```



## twil_save_registers

***Description***

Save essentials Twilighte board register. Can be used in eeprom bank or ram bank


***Modify***

* Accumulator 
* X Register 
* Y Register 

***Returns***

* Accumulator : TWILIGHTE_BANKING_REGISTER value

* X Register : TWILIGHTE_REGISTER value

* Y Register : current bank value


***Example***

```ca65
 jsr twil_save_registers
 rts
```



## twil_set_bank_signature

***Description***

Set bank signature


***Modify***

* Accumulator 
* Y Register 
* RESFor twil_set_bank_signature operation
***Input***

* libzp : Bank backup

***Example***

```ca65
 jsr twil_set_bank_signature
 rts
```



