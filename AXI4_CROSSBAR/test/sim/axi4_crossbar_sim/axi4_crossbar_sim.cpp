#include <cstdlib>
#include <ctime>
#include <iostream>
#include <memory>
#include <cmath>

#include <verilated.h>
#include <verilated_vcd_c.h>

#include "VTEST_TOP.h"

#include "axi4_interface.h"
#include "axi4_master_bram.h"
#include "axi4_slave_bram.h"
#include "axi4_transaction.h"

int main(int argc, char** argv) {
    Verilated::mkdir("logs");

    const auto contextp = std::make_unique<VerilatedContext>();

    // Set debug level, 0 is off, 9 is highest presently used
    // May be overridden by commandArgs argument parsing
    contextp->debug(0);

    // Verilator must compute traced signals
    contextp->traceEverOn(true);

    const auto top = std::make_unique<VTEST_TOP>(contextp.get());
    const auto tfp = std::make_unique<VerilatedVcdC>();

    top->trace(tfp.get(), 0);
    tfp->open("logs/axi4_crossbar_sim.vcd");

    vluint64_t timeStamp = 0;

    axi4_master_bram master_bram[4];
    axi4_slave_bram slave_bram[4];

    axi4_interface master_bram_interface[4];
    axi4_interface slave_bram_interface[4];

    axi4_read_transaction read_transaction;
    axi4_write_transaction write_transaction;

    srand(time(nullptr));
    while(timeStamp < 10000) {

        top->clk = timeStamp % 2;

        if (timeStamp < 10) {
            top->rstn = 0;
        }
        else {
            top->rstn = 1;
        }
        
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

            master_bram_interface[i].AWREADY  = top->m_AWREADY[i];

            // W
            top->m_WDATA[i]        = master_bram_interface[i].WDATA;
            top->m_WSTRB[i]        = master_bram_interface[i].WSTRB;
            top->m_WLAST[i]        = master_bram_interface[i].WLAST;
            top->m_WVALID[i]       = master_bram_interface[i].WVALID;

            master_bram_interface[i].WREADY  = top->m_WREADY[i];

            // B
            master_bram_interface[i].BID     = top->m_BID[i];
            master_bram_interface[i].BRESP   = top->m_BRESP[i];
            master_bram_interface[i].BVALID  = top->m_BVALID[i];

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

            master_bram_interface[i].ARREADY  = top->m_ARREADY[i];

            // R
            master_bram_interface[i].RID     = top->m_RID[i];
            master_bram_interface[i].RDATA   = top->m_RDATA[i];
            master_bram_interface[i].RSTRB   = top->m_RSTRB[i];
            master_bram_interface[i].RLAST   = top->m_RLAST[i];
            master_bram_interface[i].RVALID  = top->m_RVALID[i];

            top->m_RREADY[i]       = master_bram_interface[i].RREADY;

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

            top->s_AWREADY[i]      = slave_bram_interface[i].AWREADY;
            
            // W
            slave_bram_interface[i].WDATA    = top->s_WDATA[i];
            slave_bram_interface[i].WSTRB    = top->s_WSTRB[i];
            slave_bram_interface[i].WLAST    = top->s_WLAST[i];
            slave_bram_interface[i].WVALID   = top->s_WVALID[i];

            top->s_WREADY[i]       = slave_bram_interface[i].WREADY;

            // B
            top->s_BID[i]          = slave_bram_interface[i].BID;
            top->s_BRESP[i]        = slave_bram_interface[i].BRESP;
            top->s_BVALID[i]       = slave_bram_interface[i].BVALID;

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

            top->s_ARREADY[i]      = slave_bram_interface[i].ARREADY;

            // R
            top->s_RID[i]          = slave_bram_interface[i].RID;
            top->s_RDATA[i]        = slave_bram_interface[i].RDATA;
            top->s_RSTRB[i]        = slave_bram_interface[i].RSTRB;
            top->s_RLAST[i]        = slave_bram_interface[i].RLAST;
            top->s_RVALID[i]       = slave_bram_interface[i].RVALID;

            slave_bram_interface[i].RREADY   = top->s_RREADY[i];
        }

        for (int i = 0; i < 4; i ++) {
            master_bram[i].handle_interaction(master_bram_interface[i]);
            slave_bram[i].handle_interaction(slave_bram_interface[i]);
        }

        top->eval();
        tfp->dump(timeStamp);
        timeStamp ++;
    }

    // Final model cleanup
    top->final();
    tfp->close();
    // Return good completion status
    // Don't use exit() or destructor won't get called
    return 0;
}