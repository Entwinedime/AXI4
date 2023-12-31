#ifndef _AXI4_MASTER_BRAM_H_
#define _AXI4_MASTER_BRAM_H_

#include "axi4_interface.h"
#include "axi4_transaction.h"

class axi4_master_bram {
    public:
        axi4_master_bram();

        std::vector<axi4_write_transaction>         write_transaction_completed_list;
        std::vector<axi4_read_transaction>          read_transaction_completed_list;

        // return axi4 signal in this cycle
        axi4_interface  get_interface_signal();

        // generate the signal in next cycle
        void  handle_interaction(const axi4_interface& interface);

        // new transaction
        void  new_write_transaction(const axi4_write_transaction& transaction);
        void  new_read_transaction(const axi4_read_transaction& transaction);

        // get ram data
        uint64_t get_bram_data(uint64_t addr, uint8_t size);

        // get ram data to vector
        std::vector<uint64_t> get_bram_data_to_vector(uint64_t addr, uint8_t size, uint8_t len);

        // reset
        void  reset();

    private:
        axi4_interface                              _interface;
        uint8_t                                     _bram_data[4096];
        std::vector<axi4_write_transaction>         _write_transaction_list;
        std::vector<axi4_read_transaction>          _read_transaction_list;
};

#endif