
#include "axi4_bram.h"

axi4_master_bram::axi4_master_bram() {
    _interface_signal.AWID      = 0;
    _interface_signal.AWADDR    = 0;
    _interface_signal.AWLEN     = 0;
    _interface_signal.AWSIZE    = 0;
    _interface_signal.AWBURST   = 0;
    _interface_signal.AWLOCK    = 0;
    _interface_signal.AWCACHE   = 0;
    _interface_signal.AWPROT    = 0;
    _interface_signal.AWVALID   = 0;
    _interface_signal.AWREADY   = 0;

    _interface_signal.WDATA     = 0;
    _interface_signal.WSTRB     = 0;
    _interface_signal.WLAST     = 0;
    _interface_signal.WVALID    = 0;
    _interface_signal.WREADY    = 0;

    _interface_signal.BID       = 0;
    _interface_signal.BRESP     = 0;
    _interface_signal.BVALID    = 0;
    _interface_signal.BREADY    = 0;

    _interface_signal.ARID      = 0;
    _interface_signal.ARADDR    = 0;
    _interface_signal.ARLEN     = 0;
    _interface_signal.ARSIZE    = 0;
    _interface_signal.ARBURST   = 0;
    _interface_signal.ARLOCK    = 0;
    _interface_signal.ARCACHE   = 0;
    _interface_signal.ARPROT    = 0;
    _interface_signal.ARVALID   = 0;

    _interface_signal.RID       = 0;
    _interface_signal.RDATA     = 0;
    _interface_signal.RSTRB     = 0;
    _interface_signal.RLAST     = 0;
    _interface_signal.RVALID    = 0;
    _interface_signal.RREADY    = 0;

    for (int i = 0; i < 1024; i++) {
        _bram_data[i] = 0;
    }

    _write_transaction_list.clear();
    _read_transaction_list.clear();
}

axi4_interface axi4_master_bram::get_interface_signal() {
    return _interface_signal;
}

void axi4_master_bram::handle_interaction(axi4_interface interface) {
    // update transaction list

    // generate signal with updated transaction list
}

void axi4_master_bram::new_write_transaction(axi4_write_transaction transaction) {
    // check if the transaction is invalid

    // update transaction list
    _write_transaction_list.push_back(transaction);
}

void axi4_master_bram::new_read_transaction(axi4_read_transaction transaction) {
    // check if the transaction is invalid

    // update transaction list
    _read_transaction_list.push_back(transaction);
}

void axi4_master_bram::reset() {
    _interface_signal.AWID      = 0;
    _interface_signal.AWADDR    = 0;
    _interface_signal.AWLEN     = 0;
    _interface_signal.AWSIZE    = 0;
    _interface_signal.AWBURST   = 0;
    _interface_signal.AWLOCK    = 0;
    _interface_signal.AWCACHE   = 0;
    _interface_signal.AWPROT    = 0;
    _interface_signal.AWVALID   = 0;
    _interface_signal.AWREADY   = 0;

    _interface_signal.WDATA     = 0;
    _interface_signal.WSTRB     = 0;
    _interface_signal.WLAST     = 0;
    _interface_signal.WVALID    = 0;
    _interface_signal.WREADY    = 0;

    _interface_signal.BID       = 0;
    _interface_signal.BRESP     = 0;
    _interface_signal.BVALID    = 0;
    _interface_signal.BREADY    = 0;

    _interface_signal.ARID      = 0;
    _interface_signal.ARADDR    = 0;
    _interface_signal.ARLEN     = 0;
    _interface_signal.ARSIZE    = 0;
    _interface_signal.ARBURST   = 0;
    _interface_signal.ARLOCK    = 0;
    _interface_signal.ARCACHE   = 0;
    _interface_signal.ARPROT    = 0;
    _interface_signal.ARVALID   = 0;

    _interface_signal.RID       = 0;
    _interface_signal.RDATA     = 0;
    _interface_signal.RSTRB     = 0;
    _interface_signal.RLAST     = 0;
    _interface_signal.RVALID    = 0;
    _interface_signal.RREADY    = 0;

    for (int i = 0; i < 1024; i++) {
        _bram_data[i] = 0;
    }

    _write_transaction_list.clear();
    _read_transaction_list.clear();
}