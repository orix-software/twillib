#define TWIL_RAM_BANK_SEEMS_BUSY 2

unsigned char twil_program_rambank(unsigned char bank, char *file, unsigned char set);
unsigned char twil_clear_rambank(unsigned char bank, unsigned char set);