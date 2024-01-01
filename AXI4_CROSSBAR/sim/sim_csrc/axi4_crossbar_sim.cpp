#include <cstdlib>
#include <ctime>
#include <iostream>
#include <memory>
#include <cmath>

#include <vector>
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "VSIM_TOP.h"

#include "axi4_interface.h"
#include "axi4_master_bram.h"
#include "axi4_slave_bram.h"
#include "axi4_transaction.h"
#include "axi4_transaction_random_generator.h"

int main(int argc, char** argv) {
    Verilated::mkdir("logs");

    const auto contextp = std::make_unique<VerilatedContext>();

    // Set debug level, 0 is off, 9 is highest presently used
    // May be overridden by commandArgs argument parsing
    contextp->debug(0);

    // Verilator must compute traced signals
    contextp->traceEverOn(true);

    const auto top = std::make_unique<VSIM_TOP>(contextp.get());
    const auto tfp = std::make_unique<VerilatedVcdC>();

    top->trace(tfp.get(), 0);
    tfp->open("logs/axi4_crossbar_sim.vcd");

    vluint64_t timeStamp = 0;

    axi4_master_bram master_bram[4];
    axi4_slave_bram slave_bram[4];

    axi4_interface master_bram_interface[4];
    axi4_interface slave_bram_interface[4];

    int read_transaction_num[4];
    int write_transaction_num[4];

    axi4_read_transaction read_transaction;
    axi4_write_transaction write_transaction;

    srand((unsigned)time(NULL));

    for (int i = 0; i < 4; i ++) {
        write_transaction_num[i] = rand() % 8 + 1;
        for (int j = 0; j < write_transaction_num[i]; j ++) {
            axi4_transaction_random_generator(write_transaction);
            master_bram[i].new_write_transaction(write_transaction);
        }
        read_transaction_num[i] = rand() % 8 + 1;
        for (int j = 0; j < read_transaction_num[i]; j ++) {
            axi4_transaction_random_generator(read_transaction);
            master_bram[i].new_read_transaction(read_transaction);
        }
    }
    
    while(true) {
        top->clk = timeStamp % 2;
        top->rstn = 1;
        
        for (int i = 0; i < 4; i ++) {
            master_bram_interface[i] = master_bram[i].get_interface_signal();
            slave_bram_interface[i] = slave_bram[i].get_interface_signal();

            // AW
            top->m_AWID[i]         = master_bram_interface[i].AWID;
            top->m_AWADDR[i]       = master_bram_interface[i].AWADDR;
            top->m_AWLEN[i]        = master_bram_interface[i].AWLEN;
            top->m_AWSIZE[i]       = master_bram_interface[i].AWSIZE;
            top->m_AWBURST[i]      = master_bram_interface[i].AWBURST;
            top->m_AWLOCK[i]       = master_bram_interface[i].AWLOCK;
            top->m_AWCACHE[i]      = master_bram_interface[i].AWCACHE;
            top->m_AWPROT[i]       = master_bram_interface[i].AWPROT;
            top->m_AWVALID[i]      = master_bram_interface[i].AWVALID;

            // W
            top->m_WDATA[i]        = master_bram_interface[i].WDATA;
            top->m_WSTRB[i]        = master_bram_interface[i].WSTRB;
            top->m_WLAST[i]        = master_bram_interface[i].WLAST;
            top->m_WVALID[i]       = master_bram_interface[i].WVALID;

            // B
            top->m_BREADY[i]       = master_bram_interface[i].BREADY;

            // AR
            top->m_ARID[i]         = master_bram_interface[i].ARID;
            top->m_ARADDR[i]       = master_bram_interface[i].ARADDR;
            top->m_ARLEN[i]        = master_bram_interface[i].ARLEN;
            top->m_ARSIZE[i]       = master_bram_interface[i].ARSIZE;
            top->m_ARBURST[i]      = master_bram_interface[i].ARBURST;
            top->m_ARLOCK[i]       = master_bram_interface[i].ARLOCK;
            top->m_ARCACHE[i]      = master_bram_interface[i].ARCACHE;
            top->m_ARPROT[i]       = master_bram_interface[i].ARPROT;
            top->m_ARVALID[i]      = master_bram_interface[i].ARVALID;

            // R
            top->m_RREADY[i]       = master_bram_interface[i].RREADY;

            // AW
            top->s_AWREADY[i]      = slave_bram_interface[i].AWREADY;
            
            // W
            top->s_WREADY[i]       = slave_bram_interface[i].WREADY;

            // B
            top->s_BID[i]          = slave_bram_interface[i].BID;
            top->s_BRESP[i]        = slave_bram_interface[i].BRESP;
            top->s_BVALID[i]       = slave_bram_interface[i].BVALID;

            // AR
            top->s_ARREADY[i]      = slave_bram_interface[i].ARREADY;

            // R
            top->s_RID[i]          = slave_bram_interface[i].RID;
            top->s_RDATA[i]        = slave_bram_interface[i].RDATA;
            top->s_RSTRB[i]        = slave_bram_interface[i].RSTRB;
            top->s_RLAST[i]        = slave_bram_interface[i].RLAST;
            top->s_RVALID[i]       = slave_bram_interface[i].RVALID;
        }

        for (int i = 0; i < 4; i ++) {
            // AW
            master_bram_interface[i].AWREADY  = top->m_AWREADY[i];

            // W
            master_bram_interface[i].WREADY  = top->m_WREADY[i];

            // B
            master_bram_interface[i].BID     = top->m_BID[i];
            master_bram_interface[i].BRESP   = top->m_BRESP[i];
            master_bram_interface[i].BVALID  = top->m_BVALID[i];

            // AR
            master_bram_interface[i].ARREADY  = top->m_ARREADY[i];

            // R
            master_bram_interface[i].RID     = top->m_RID[i];
            master_bram_interface[i].RDATA   = top->m_RDATA[i];
            master_bram_interface[i].RSTRB   = top->m_RSTRB[i];
            master_bram_interface[i].RLAST   = top->m_RLAST[i];
            master_bram_interface[i].RVALID  = top->m_RVALID[i];

            // AW
            slave_bram_interface[i].AWID     = top->s_AWID[i];
            slave_bram_interface[i].AWADDR   = top->s_AWADDR[i];
            slave_bram_interface[i].AWLEN    = top->s_AWLEN[i];
            slave_bram_interface[i].AWSIZE   = top->s_AWSIZE[i];
            slave_bram_interface[i].AWBURST  = top->s_AWBURST[i];
            slave_bram_interface[i].AWLOCK   = top->s_AWLOCK[i];
            slave_bram_interface[i].AWCACHE  = top->s_AWCACHE[i];
            slave_bram_interface[i].AWPROT   = top->s_AWPROT[i];
            slave_bram_interface[i].AWVALID  = top->s_AWVALID[i];

            // W
            slave_bram_interface[i].WDATA    = top->s_WDATA[i];
            slave_bram_interface[i].WSTRB    = top->s_WSTRB[i];
            slave_bram_interface[i].WLAST    = top->s_WLAST[i];
            slave_bram_interface[i].WVALID   = top->s_WVALID[i];

            // B
            slave_bram_interface[i].BREADY   = top->s_BREADY[i];

            // AR
            slave_bram_interface[i].ARID     = top->s_ARID[i];
            slave_bram_interface[i].ARADDR   = top->s_ARADDR[i];
            slave_bram_interface[i].ARLEN    = top->s_ARLEN[i];
            slave_bram_interface[i].ARSIZE   = top->s_ARSIZE[i];
            slave_bram_interface[i].ARBURST  = top->s_ARBURST[i];
            slave_bram_interface[i].ARLOCK   = top->s_ARLOCK[i];
            slave_bram_interface[i].ARCACHE  = top->s_ARCACHE[i];
            slave_bram_interface[i].ARPROT   = top->s_ARPROT[i];
            slave_bram_interface[i].ARVALID  = top->s_ARVALID[i];

            // R
            slave_bram_interface[i].RREADY   = top->s_RREADY[i];
        }

        if (top->clk == 1) {
            for (int i = 0; i < 4; i ++) {
                master_bram[i].handle_interaction(master_bram_interface[i]);
                slave_bram[i].handle_interaction(slave_bram_interface[i]);
            }
        }

        top->eval();
        tfp->dump(timeStamp);
        timeStamp ++;

        bool is_finish = true;
        for (int i = 0; i < 4; i ++) {
            if (master_bram[i].write_transaction_completed_list.size() != write_transaction_num[i]) {
                is_finish = false;
            }
            if (master_bram[i].read_transaction_completed_list.size() != read_transaction_num[i]) {
                is_finish = false;
            }
        }

        if (is_finish) {
            break;
        }

        if (timeStamp > 1000000) {
            std::cout << "Simulation timeout!" << std::endl;
            for (int i = 0; i < 4; i ++) {
                std::cout << "master index: " << i << std::endl;
                std::cout << "    write transaction completed list size: " << master_bram[i].write_transaction_completed_list.size() << std::endl;
                std::cout << "    read transaction completed list size: " << master_bram[i].read_transaction_completed_list.size() << std::endl;
                std::cout << "    write transaction num: " << write_transaction_num[i] << std::endl;
                std::cout << "    read transaction num: " << read_transaction_num[i] << std::endl;
            }
            break;
        }
    }

    int error_count = 0;

    std::cout << std::hex;

    for (int i = 0; i < 4; i ++) {
        for (int j = 0; j < master_bram[i].read_transaction_completed_list.size(); j ++) {
            std::vector<uint64_t>   read_data;
            int slave_index =   (master_bram[i].read_transaction_completed_list[j].addr < 0x1000) ? 0 : 
                                (master_bram[i].read_transaction_completed_list[j].addr < 0x2000) ? 1 :
                                (master_bram[i].read_transaction_completed_list[j].addr < 0x3000) ? 2 :
                                (master_bram[i].read_transaction_completed_list[j].addr < 0x4000) ? 3 : 0;
            read_data = slave_bram[slave_index].get_bram_data_to_vector(master_bram[i].read_transaction_completed_list[j].addr, master_bram[i].read_transaction_completed_list[j].size, master_bram[i].read_transaction_completed_list[j].len);
            if (read_data != master_bram[i].read_transaction_completed_list[j].read_buffer) {
                error_count ++;
                std::cout << "Read Error: " << std::endl;
                std::cout << "    master index: " << i << std::endl;
                std::cout << "    slave index: " << slave_index << std::endl;
                std::cout << "    id: " << (int)master_bram[i].read_transaction_completed_list[j].id << std::endl;
                std::cout << "    addr: " << (int)master_bram[i].read_transaction_completed_list[j].addr << std::endl;
                std::cout << "    size: " << (int)master_bram[i].read_transaction_completed_list[j].size << std::endl;
                std::cout << "    len: " << (int)master_bram[i].read_transaction_completed_list[j].len << std::endl << std::endl;
            }
        }

        for (int j = 0; j < slave_bram[i].write_transaction_completed_list.size(); j ++) {
            std::vector<uint64_t>   write_data;
            int master_index = slave_bram[i].write_transaction_completed_list[j].id / 16;
            write_data = master_bram[master_index].get_bram_data_to_vector(slave_bram[i].write_transaction_completed_list[j].addr, slave_bram[i].write_transaction_completed_list[j].size, slave_bram[i].write_transaction_completed_list[j].len);
            if (write_data != slave_bram[i].write_transaction_completed_list[j].write_buffer) {
                error_count ++;
                std::cout << "Write Error: " << std::endl;
                std::cout << "    master index: " << master_index << std::endl;
                std::cout << "    slave index: " << i << std::endl;
                std::cout << "    id: " << (int)slave_bram[i].write_transaction_completed_list[j].id << std::endl;
                std::cout << "    addr: " << (int)slave_bram[i].write_transaction_completed_list[j].addr << std::endl;
                std::cout << "    size: " << (int)slave_bram[i].write_transaction_completed_list[j].size << std::endl;
                std::cout << "    len: " << (int)slave_bram[i].write_transaction_completed_list[j].len << std::endl << std::endl;
            }
        }
    }

    std::cout << std::dec;

    std::cout << "Simulation finished!" << std::endl;
    std::cout << "Error count: " << error_count << std::endl;

    for (int i = 0; i < 4; i ++) {
        master_bram[i].reset();
        slave_bram[i].reset();
    }

    // Final model cleanup
    top->final();
    tfp->close();
    // Return good completion status
    // Don't use exit() or destructor won't get called
    return 0;
}