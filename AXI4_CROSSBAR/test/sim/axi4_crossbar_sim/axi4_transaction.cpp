#include "axi4_transaction.h"

int list_search_with_id(const read_transaction_list& list, uint8_t id, axi4_write_transaction_state state) {
    for (int i = 0; i < list.size(); i++) {
        if (list[i].id == id && list[i].state == state) {
            return i;
        }
    }
    return -1;
}

int list_search_with_id(const write_transaction_list& list, uint8_t id, axi4_read_transaction_state state) {
    for (int i = 0; i < list.size(); i++) {
        if (list[i].id == id && list[i].state == state) {
            return i;
        }
    }
    return -1;
}