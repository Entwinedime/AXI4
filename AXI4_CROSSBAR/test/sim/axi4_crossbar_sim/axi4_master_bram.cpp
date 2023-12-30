#include "axi4_master_bram.h"
#include "axi4_transaction.h"

axi4_master_bram::axi4_master_bram() {
    std::memset(&_interface, 0, sizeof(_interface));
    _interface.BREADY = 1;
    _interface.RREADY = 1;

    for (int i = 0; i < 1024; i++) {
        _bram_data[i] = 0;
    }

    _write_transaction_list.clear();
    _read_transaction_list.clear();
}

axi4_interface axi4_master_bram::get_interface_signal() {
    return _interface;
}

void axi4_master_bram::handle_interaction(const axi4_interface& interface) {
    // update transaction list

    // AW
    if (_interface.AWVALID && interface.AWREADY) {
        int write_list_index = list_search_with_id(_write_transaction_list, _interface.AWID);
        _write_transaction_list[write_list_index].state = AXI4_W;
        _interface.AWVALID = 0;
    }

    // W
    if (_interface.WVALID && interface.WREADY) {
        int write_list_index = 0;
        _write_transaction_list[write_list_index].write_count++;
        if (_interface.WLAST) {
            _write_transaction_list[write_list_index].state = AXI4_B;
        }
        _interface.WVALID = 0;
    }

    // B
    if (_interface.BREADY && interface.BVALID) {
        int write_list_index = 0;
        _write_transaction_list.erase(_write_transaction_list.begin() + write_list_index);
    }

    // AR
    if (_interface.ARVALID && interface.ARREADY) {
        int read_list_index = list_search_with_id(_read_transaction_list, _interface.ARID);
        _read_transaction_list[read_list_index].state = AXI4_R;
        _interface.ARVALID = 0;
    }

    // R
    if (_interface.RREADY && interface.RVALID) {
        int read_list_index = list_search_with_id(_read_transaction_list, interface.RID);
        _read_transaction_list[read_list_index].read_count++;
        if (interface.RLAST) {
            _read_transaction_list.erase(_read_transaction_list.begin() + read_list_index);
        }
    }

    // generate signal with updated transaction list

    // AW
    if (!_interface.AWVALID && !_write_transaction_list.empty()) {
        int write_list_index = 0;
        for (write_list_index = 0; write_list_index < _write_transaction_list.size(); write_list_index ++) {
            if (_write_transaction_list[write_list_index].state == AXI4_AW) {
                break;
            }
        }
        if (write_list_index < _write_transaction_list.size()) {
            _interface.AWID     = _write_transaction_list[write_list_index].id;
            _interface.AWADDR   = _write_transaction_list[write_list_index].addr;
            _interface.AWLEN    = _write_transaction_list[write_list_index].len;
            _interface.AWSIZE   = _write_transaction_list[write_list_index].size;
            _interface.AWVALID  = 1;
        }
    }

    // W
    if (!_interface.WVALID && !_write_transaction_list.empty()) {
        int write_list_index = 0;
        if (_write_transaction_list[write_list_index].state == AXI4_W) {
            _interface.WDATA = axi4_master_bram::get_bram_data(_write_transaction_list[write_list_index].addr + _write_transaction_list[write_list_index].write_count * (1 << _write_transaction_list[write_list_index].size), _write_transaction_list[write_list_index].size);
            _interface.WLAST = (_write_transaction_list[write_list_index].len == _write_transaction_list[write_list_index].write_count);
            _interface.WVALID = 1;
        }
    }

    // B
    // nothing to do

    // AR
    if (!_interface.ARVALID && !_read_transaction_list.empty()) {
        srand((unsigned)time(NULL)); 
        int id = rand() % 16;
        int read_list_index = list_search_with_id(_read_transaction_list, id);
        while (read_list_index == -1) {
            id = rand() % 16;
            read_list_index = list_search_with_id(_read_transaction_list, id);
        }
        if (_read_transaction_list[read_list_index].state == AXI4_AR) {
            _interface.ARID = _read_transaction_list[read_list_index].id;
            _interface.ARADDR = _read_transaction_list[read_list_index].addr;
            _interface.ARLEN = _read_transaction_list[read_list_index].len;
            _interface.ARVALID = 1;
        }
    }

    // R
    // nothing to do
}

void axi4_master_bram::new_write_transaction(const axi4_write_transaction& transaction) {
    // check if the transaction is invalid

    // update transaction list
    _write_transaction_list.push_back(transaction);
}

void axi4_master_bram::new_read_transaction(const axi4_read_transaction& transaction) {
    // check if the transaction is invalid

    // update transaction list
    _read_transaction_list.push_back(transaction);
}

uint64_t axi4_master_bram::get_bram_data(uint64_t addr, uint8_t size) {
    uint64_t data = 0;
    for (size_t i = 0; i < size; ++i) {
        data |= static_cast<uint64_t>(_bram_data[addr % 4096 + i]) << (8 * i);
    }
    return data;
}

void axi4_master_bram::reset() {
    std::memset(&_interface, 0, sizeof(_interface));
    _interface.BREADY = 1;
    _interface.RREADY = 1;
    _interface.WSTRB = 0xff;

    for (int i = 0; i < 1024; i++) {
        _bram_data[i] = 0;
    }

    _write_transaction_list.clear();
    _read_transaction_list.clear();
}