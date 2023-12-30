#ifndef _AXI4_TRANSACTION_H_
#define _AXI4_TRANSACTION_H_

#include <cstdint>
#include <vector>

    typedef enum {
        AXI4_AW,
        AXI4_W,
        AXI4_B
    } axi4_write_transaction_state ;

    typedef enum {
        AXI4_AR,
        AXI4_R
    } axi4_read_transaction_state ;

    typedef struct{
        uint8_t                         id;
        uint32_t                        addr;
        uint8_t                         len;
        uint8_t                         size;

        axi4_write_transaction_state    state;
        uint8_t                         write_count;
    } axi4_write_transaction;

    typedef struct{
        uint8_t                         id;
        uint32_t                        addr;
        uint8_t                         len;
        uint8_t                         size;

        axi4_read_transaction_state     state;
        uint8_t                         read_count;
    } axi4_read_transaction;

    typedef std::vector<axi4_write_transaction> read_transaction_list;
    typedef std::vector<axi4_read_transaction> write_transaction_list;

    int list_search_with_id(const read_transaction_list& list, uint8_t id);
    int list_search_with_id(const write_transaction_list& list, uint8_t id);

#endif