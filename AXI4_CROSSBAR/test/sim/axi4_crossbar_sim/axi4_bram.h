#ifndef _AXI4_BRAM_H_
#define _AXI4_BRAM_H_

#include "axi4_interface.h"
#include "axi4_transaction.h"
#include <vector>

class axi4_master_bram {
    public:
        axi4_master_bram();

        // return axi4 signal in this cycle
        axi4_interface  get_interface_signal();

        // generate the signal in next cycle
        void  handle_interaction(axi4_interface interface);

        // new transaction
        void  new_write_transaction(axi4_write_transaction transaction);
        void  new_read_transaction(axi4_read_transaction transaction);

        // reset
        void  reset();

    private:
        axi4_interface                              _interface_signal;
        uint8_t                                     _bram_data[1024];
        std::vector<axi4_write_transaction>         _write_transaction_list;
        std::vector<axi4_read_transaction>          _read_transaction_list;
};

class axi4_slave_bram {
    public:
        axi4_slave_bram();

        // return axi4 signal in this cycle
        axi4_interface  get_interface_signal();

        // generate the signal in next cycle
        void  handle_interaction(axi4_interface interface);

        // reset
        void  reset();
        
    private:
        axi4_interface                              _interface_signal;
        uint8_t                                     _bram_data[1024];
        std::vector<axi4_write_transaction>         _write_transaction_list;
        std::vector<axi4_read_transaction>          _read_transaction_list;
};
#endif