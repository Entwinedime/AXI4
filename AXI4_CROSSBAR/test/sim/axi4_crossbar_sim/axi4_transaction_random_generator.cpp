#include <cstddef>
#include <cstdlib>
#include <random>

#include "axi4_transaction_random_generator.h"
#include "axi4_transaction.h"

void axi4_transaction_random_generator(axi4_write_transaction& transaction) {
    srand((unsigned)time(NULL)); 
    transaction.id = rand() % 16;
    transaction.addr = rand() % 16384;
    transaction.size = rand() % 7;
    transaction.len = rand() % 256;

    transaction.write_count = 0;
    transaction.write_buffer.clear();
}

void axi4_transaction_random_generator(axi4_read_transaction& transaction) {
    srand((unsigned)time(NULL)); 
    transaction.id = rand() % 16;
    transaction.addr = rand() % 16384;
    transaction.size = rand() % 7;
    transaction.len = rand() % 256;

    transaction.read_count = 0;
    transaction.read_buffer.clear();
}