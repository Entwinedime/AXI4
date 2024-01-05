#include "axi4_transaction.h"

int list_search_with_id(const read_transaction_list& list, uint8_t id, axi4_read_transaction_state state) { 
    if (state == AXI4_AR) {
        for (int i = 0; i < list.size(); i++) {
            if (list[i].id == id) {
                if (list[i].state == AXI4_AR) {
                    return i;
                }
                else {
                    return -1;
                }
            }
        }
    }  
    else {
        for (int i = 0; i < list.size(); i++) {
            if (list[i].id == id && list[i].state == state) {
                return i;
            }
        }
    }
    return -1;
}

int list_search_with_id(const write_transaction_list& list, uint8_t id, axi4_write_transaction_state state) {
    for (int i = 0; i < list.size(); i++) {
        if (list[i].id == id && list[i].state == state) {
            return i;
        }
    }
    return -1;
}

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