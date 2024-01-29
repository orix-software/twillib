.define TWIL_LIB_VERSION_2021_2     $00
.define TWIL_LIB_VERSION_2021_3     $01
.define TWIL_LIB_VERSION_2021_4     $02
.define TWIL_LIB_VERSION_2022_1     $03
.define TWIL_LIB_VERSION_2022_4     $04
.define TWIL_LIB_VERSION_2023_2     $05
.define TWIL_LIB_VERSION_2024_1     $06

.define TWILIGHTE_REGISTER          $342
.define TWILIGHTE_BANKING_REGISTER  $343

libzp := $F0

.struct twil_bank_struct
    id_bank                   .res 1
    signature_str             .res 37
    pos_x                     .res 1
    pos_y                     .res 1
.endstruct
