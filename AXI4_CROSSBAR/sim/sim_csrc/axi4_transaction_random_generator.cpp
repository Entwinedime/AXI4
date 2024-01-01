#include "axi4_transaction_random_generator.h"
#include "axi4_transaction.h"

#include <ctime>
#include <cstdlib>


void axi4_transaction_random_generator(axi4_write_transaction& transaction) {
    transaction.id = rand() % 16;
    transaction.addr = rand() % 16384;
    transaction.size = rand() % 4;
    transaction.len = rand() % 256;

    transaction.state = AXI4_AW;
    transaction.write_count = 0;
    transaction.write_buffer.clear();
}

void axi4_transaction_random_generator(axi4_read_transaction& transaction) {
    transaction.id = rand() % 16;
    transaction.addr = rand() % 16384;
    transaction.size = rand() % 4;
    transaction.len = rand() % 256;

    transaction.state = AXI4_AR;
    transaction.read_count = 0;
    transaction.read_buffer.clear();
}