# twillib

Some function to manage the board.

## Get the registers from the bank in arg

unsigned char twil_get_registers_from_id_bank(unsigned char bank);

Returns in A the bank register for $321, and in X the TWILIGHTE_BANKING_REGISTER

## get the twil lib version

unsigned char twil_lib_version();

Returns the lib version. Include "twil.inc" to have version mapping
