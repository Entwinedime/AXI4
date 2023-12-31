#include "axi4_master_bram.h"
#include "axi4_transaction.h"

axi4_master_bram::axi4_master_bram() {
    write_transaction_completed_list.clear();
    read_transaction_completed_list.clear();

    _interface.BREADY = 1;
    _interface.RREADY = 1;
    _interface.WSTRB = 0xff;

    srand((unsigned)time(NULL)); 
    for (int i = 0; i < 1024; i++) {
        _bram_data[i] = (uint8_t)rand();
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
        int write_list_index = list_search_with_id(_write_transaction_list, _interface.AWID, AXI4_AW);
        _write_transaction_list[write_list_index].state = AXI4_W;
        _interface.AWVALID = 0;
    }

    // W
    if (_interface.WVALID && interface.WREADY) {
        int write_list_index = 0;
        _write_transaction_list[write_list_index].write_count++;
        if (_interface.WLAST) {
            _write_transaction_list[write_list_index].state = AXI4_B;
            _interface.WLAST = 0;
        }
        _interface.WVALID = 0;
    }

    // B
    if (_interface.BREADY && interface.BVALID) {
        int write_list_index = 0;
        write_transaction_completed_list.push_back(_write_transaction_list[write_list_index]);
        _write_transaction_list.erase(_write_transaction_list.begin() + write_list_index);
    }

    // AR
    if (_interface.ARVALID && interface.ARREADY) {
        int read_list_index = list_search_with_id(_read_transaction_list, _interface.ARID, AXI4_AR);
        _read_transaction_list[read_list_index].state = AXI4_R;
        _interface.ARVALID = 0;
    }

    // R
    if (_interface.RREADY && interface.RVALID) {
        int read_list_index = list_search_with_id(_read_transaction_list, interface.RID, AXI4_R);
        _read_transaction_list[read_list_index].read_buffer.push_back(interface.RDATA);
        _read_transaction_list[read_list_index].read_count++;
        if (interface.RLAST) {
            read_transaction_completed_list.push_back(_read_transaction_list[read_list_index]);
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

        if (-1 < write_list_index < _write_transaction_list.size()) {
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
        int try_count = 0;
        int read_list_index = list_search_with_id(_read_transaction_list, id, AXI4_AR);
        while (read_list_index == -1) {
            id = rand() % 16;
            try_count ++;
            read_list_index = list_search_with_id(_read_transaction_list, id, AXI4_AR);
            if (try_count > 16) {
                break;
            }
        }
        if (read_list_index != -1) {
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
    for (size_t i = 0; i < (1 << size); ++i) {
        data |= static_cast<uint64_t>(_bram_data[(addr + i) % 4096]) << (8 * i);
    }
    return data;
}

std::vector<uint64_t> axi4_master_bram::get_bram_data_to_vector(uint64_t addr, uint8_t size, uint8_t len) {
    std::vector<uint64_t> data;
    for (size_t i = 0; i < len; ++i) {
        data.push_back(axi4_master_bram::get_bram_data(addr + i * (1 << size), (1 << size)));
    }
    return data;
}

void axi4_master_bram::reset() {
    write_transaction_completed_list.clear();
    read_transaction_completed_list.clear();

    _interface.BREADY = 1;
    _interface.RREADY = 1;
    _interface.WSTRB = 0xff;

    srand((unsigned)time(NULL)); 
    for (int i = 0; i < 1024; i++) {
        _bram_data[i] = (uint8_t)rand();
    }

    _write_transaction_list.clear();
    _read_transaction_list.clear();
}