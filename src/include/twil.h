#define TWIL_RAM_BANK_SEEMS_BUSY 2

#define TWIL_BANK_TYPE_ROM 0
#define TWIL_BANK_TYPE_RAM 1

#define TWIL_LIB_VERSION_2021_2 0

unsigned char twil_program_rambank(unsigned char bank, char *file, unsigned char set);
unsigned char twil_clear_rambank(unsigned char bank, unsigned char set);
unsigned char * twil_display_signature_bank(unsigned char ROMRAM, unsigned char sector,  unsigned char bank);
unsigned char twil_lib_version(void);

