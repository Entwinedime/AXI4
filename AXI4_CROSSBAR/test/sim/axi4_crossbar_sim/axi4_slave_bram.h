#ifndef _AXI4_SLAVE_BRAM_H_
#define _AXI4_SLAVE_BRAM_H_

#include "axi4_interface.h"
#include "axi4_transaction.h"
#include <vector>

class axi4_slave_bram {
    public:
        axi4_slave_bram();

        // return axi4 signal in this cycle
        axi4_interface  get_interface_signal();

        // generate the signal in next cycle
        void  handle_interaction(const axi4_interface& interface);

        // get ram data
        uint64_t  get_bram_data(uint64_t addr, uint8_t size);

        // reset
        void  reset();

    private:
        axi4_interface                              _interface;
        uint8_t                                     _bram_data[4096];
        std::vector<axi4_write_transaction>         _write_transaction_list;
        std::vector<axi4_read_transaction>          _read_transaction_list;
};

#endif