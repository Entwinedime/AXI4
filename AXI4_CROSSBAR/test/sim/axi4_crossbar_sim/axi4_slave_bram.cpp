#include "axi4_bram.h"
#include "axi4_transaction.h"

axi4_slave_bram::axi4_slave_bram() {
    std::memset(&_interface, 0, sizeof(_interface));
    _interface.AWREADY = 1;
    _interface.ARREADY = 1;
    _interface.WREADY = 1;
    _interface.RSTRB = 0xff;

    for (int i = 0; i < 1024; i++) {
        _bram_data[i] = 0;
    }

    _write_transaction_list.clear();
    _read_transaction_list.clear();
}

axi4_interface axi4_slave_bram::get_interface_signal() {
    return _interface;
}

void axi4_slave_bram::handle_interaction(const axi4_interface& interface) {
    // update transaction list

    // AW
    if (_interface.AWREADY && interface.AWVALID) {
        axi4_write_transaction transaction;
        transaction.id      = interface.AWID;
        transaction.addr    = interface.AWADDR;
        transaction.len     = interface.AWLEN;
        transaction.size    = interface.AWSIZE;
        transaction.state   = AXI4_W;;
        _write_transaction_list.push_back(transaction);
        _interface.AWREADY = 0;
    }

    // W
    if (_interface.WREADY && interface.WVALID) {
        int write_list_index = 0;
        _write_transaction_list[write_list_index].write_count++;
        if (interface.WLAST) {
            _write_transaction_list[write_list_index].state = AXI4_B;
        }
    }

    // B
    if (_interface.BVALID && interface.BREADY) {
        int write_list_index = 0;
        _write_transaction_list.erase(_write_transaction_list.begin() + write_list_index);
        _interface.BVALID = 0;
    }

    // AR
    if (_interface.ARVALID && interface.ARREADY) {
        axi4_read_transaction transaction;
        transaction.id      = interface.ARID;
        transaction.addr    = interface.ARADDR;
        transaction.len     = interface.ARLEN;
        transaction.size    = interface.ARSIZE;
        transaction.state   = AXI4_R;
        _read_transaction_list.push_back(transaction);
    }

    // R
    if (_interface.RVALID && interface.RREADY) {
        int read_list_index = list_search_with_id(_read_transaction_list, interface.RID);
        _read_transaction_list[read_list_index].read_count++;
        if (interface.RLAST) {
            _read_transaction_list.erase(_read_transaction_list.begin() + read_list_index);
        }
        _interface.RVALID = 0;
    }

    // generate signal with updated transaction list

    // AW
    if (_write_transaction_list.empty()) {
        _interface.AWREADY = 1;
    }
    else {
        _interface.AWREADY = 0;
    }

    // W
    // nothing to do

    // B
    if (!_write_transaction_list.empty()) {
        int write_list_index = 0;
        if (_write_transaction_list[write_list_index].state == AXI4_B) {
            _interface.BID = _write_transaction_list[write_list_index].id;
            _interface.BVALID = 1;
        }
    }

    // AR
    // nothing to do

    // R
    if (!_interface.RVALID && !_read_transaction_list.empty()) {
        srand((unsigned)time(NULL)); 
        int id = rand() % 16;
        int read_list_index = list_search_with_id(_read_transaction_list, id);
        while (read_list_index == -1) {
            id = rand() % 16;
            read_list_index = list_search_with_id(_read_transaction_list, id);
        }
        if (_read_transaction_list[read_list_index].state == AXI4_R) {
            _interface.RID = _read_transaction_list[read_list_index].id;
            _interface.RDATA = axi4_slave_bram::get_bram_data(_read_transaction_list[read_list_index].addr + _read_transaction_list[read_list_index].read_count * (1 << _read_transaction_list[read_list_index].size), _read_transaction_list[read_list_index].size);
            _interface.RVALID = 1;
        }
    }
}

uint64_t axi4_slave_bram::get_bram_data(uint64_t addr, uint8_t size) {
    uint64_t data = 0;
    for (size_t i = 0; i < size; ++i) {
        data |= static_cast<uint64_t>(_bram_data[addr % 4096 + i]) << (8 * i);
    }
    return data;
}

void axi4_slave_bram::reset() {
    std::memset(&_interface, 0, sizeof(_interface));
    _interface.AWREADY = 1;
    _interface.ARREADY = 1;
    _interface.WREADY = 1;
    _interface.RSTRB = 0xff;

    for (int i = 0; i < 1024; i++) {
        _bram_data[i] = 0;
    }

    _write_transaction_list.clear();
    _read_transaction_list.clear();
}