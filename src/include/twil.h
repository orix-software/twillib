#define TWIL_BANK_TYPE_ROM 0
#define TWIL_BANK_TYPE_RAM 1

#define TWIL_LIB_VERSION_2021_2 0

#define TWILIGHTE_REGISTER          0x342
#define TWILIGHTE_BANKING_REGISTER  0x343

unsigned char twil_program_rambank(unsigned char bank, char *file, unsigned char set); 
//unsigned char twil_program_rambank_id(char *file, unsigned char rambankid); 
unsigned char twil_clear_rambank(unsigned char bank, unsigned char set);
unsigned char * twil_display_signature_bank(unsigned char sector,  unsigned char bank);
unsigned char twil_lib_version(void);

