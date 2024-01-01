#include "axi4_slave_bram.h"
#include "axi4_transaction.h"

#include <iostream>

axi4_slave_bram::axi4_slave_bram() {
    write_transaction_completed_list.clear();
    read_transaction_completed_list.clear();

    std::memset(&_interface, 0, sizeof(_interface));
    _interface.AWREADY = 1;
    _interface.ARREADY = 1;
    _interface.WREADY = 1;
    _interface.RSTRB = 0xff;

    for (int i = 0; i < 4096; i++) {
        _bram_data[i] = (uint8_t)rand();
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

        transaction.state   = AXI4_W;
        transaction.write_count = 0;
        transaction.write_buffer.clear();

        _write_transaction_list.push_back(transaction);
        _interface.AWREADY = 0;
    }

    // W
    if (_interface.WREADY && interface.WVALID) {
        int write_list_index = 0;
        _write_transaction_list[write_list_index].write_count++;
        _write_transaction_list[write_list_index].write_buffer.push_back(interface.WDATA);
        if (interface.WLAST) {
            _write_transaction_list[write_list_index].state = AXI4_B;
        }
    }

    // B
    if (_interface.BVALID && interface.BREADY) {
        int write_list_index = 0;
        write_transaction_completed_list.push_back(_write_transaction_list[write_list_index]);
        _write_transaction_list.erase(_write_transaction_list.begin() + write_list_index);
        _interface.BVALID = 0;
    }

    // AR
    if (_interface.ARREADY && interface.ARVALID) {
        axi4_read_transaction transaction;
        transaction.id      = interface.ARID;
        transaction.addr    = interface.ARADDR;
        transaction.len     = interface.ARLEN;
        transaction.size    = interface.ARSIZE;

        transaction.state   = AXI4_R;
        transaction.read_count = 0;
        transaction.read_buffer.clear();

        _read_transaction_list.push_back(transaction);
    }

    // R
    if (_interface.RVALID && interface.RREADY) {
        int read_list_index = list_search_with_id(_read_transaction_list, _interface.RID, AXI4_R);
        _read_transaction_list[read_list_index].read_count++;
        if (_interface.RLAST) {
            read_transaction_completed_list.push_back(_read_transaction_list[read_list_index]);
            _read_transaction_list.erase(_read_transaction_list.begin() + read_list_index);
            _interface.RLAST = 0;
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
    if (!_read_transaction_list.empty()) { 
        int id = rand() % 64;
        int try_count = 0;
        int read_list_index = list_search_with_id(_read_transaction_list, id, AXI4_R);
        while (read_list_index == -1) {
            id = rand() % 64;
            try_count ++;
            read_list_index = list_search_with_id(_read_transaction_list, id, AXI4_R);
            if (try_count > 32) {
                break;
            }
        }

        if (read_list_index != -1) {
            _interface.RID = _read_transaction_list[read_list_index].id;
            _interface.RDATA = axi4_slave_bram::get_bram_data(_read_transaction_list[read_list_index].addr + _read_transaction_list[read_list_index].read_count * (1 << _read_transaction_list[read_list_index].size), _read_transaction_list[read_list_index].size);
            // std::cout << "RDATA: " << std::hex << _interface.RDATA << std::endl;
            _interface.RLAST = (_read_transaction_list[read_list_index].len == _read_transaction_list[read_list_index].read_count);
            _interface.RVALID = 1;
        }
    }
}

uint64_t axi4_slave_bram::get_bram_data(uint64_t addr, uint8_t size) {
    uint64_t data = 0;
    for (size_t i = 0; i < (1 << size); ++i) {
        data |= static_cast<uint64_t>(_bram_data[(addr  + i) % 4096]) << (8 * i);
    }
    return data;
}

std::vector<uint64_t> axi4_slave_bram::get_bram_data_to_vector(uint64_t addr, uint8_t size, uint8_t len) {
    std::vector<uint64_t> data;
    for (size_t i = 0; i < len + 1; ++i) {
        data.push_back(axi4_slave_bram::get_bram_data(addr + i * (1 << size), size));
    }
    return data;
}

void axi4_slave_bram::reset() {
    write_transaction_completed_list.clear();
    read_transaction_completed_list.clear();

    std::memset(&_interface, 0, sizeof(_interface));
    _interface.AWREADY = 1;
    _interface.ARREADY = 1;
    _interface.WREADY = 1;
    _interface.RSTRB = 0xff;

    for (int i = 0; i < 4096; i++) {
        _bram_data[i] = (uint8_t)rand();
    }

    _write_transaction_list.clear();
    _read_transaction_list.clear();
}