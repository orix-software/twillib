#define TWIL_BANK_TYPE_ROM 0
#define TWIL_BANK_TYPE_RAM 1

#define TWIL_LIB_VERSION_2021_2 0
#define TWIL_LIB_VERSION_2021_3 1
#define TWIL_LIB_VERSION_2021_4 2
#define TWIL_LIB_VERSION_2022_1 3
#define TWIL_LIB_VERSION_2022_4 4

#define TWILIGHTE_REGISTER          0x342
#define TWILIGHTE_BANKING_REGISTER  0x343

unsigned char twil_lib_version(void);

unsigned char twil_program_rambank(unsigned char bank, char *file, unsigned char set);
/*Clear a ram bank*/
unsigned char twil_clear_rambank(unsigned char bank, unsigned char set);


unsigned char twil_get_id_bank(unsigned char bank, unsigned char set);
/*Set default bank signature*/
void twil_set_bank_signature(char *signature);

unsigned char twil_get_registers_from_id_bank(unsigned char bank);

void twil_program_rambank_id(char *file, unsigned char idbank, unsigned int startaddress);

