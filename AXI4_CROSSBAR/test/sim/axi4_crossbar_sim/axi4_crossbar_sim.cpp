#include <cstdlib>
#include <ctime>
#include <iostream>
#include <memory>
#include <cmath>

#include <verilated.h>
#include <verilated_vcd_c.h>

#include "VTEST_TOP.h"

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

    srand(time(nullptr));
    while(timeStamp < 10000) {

        top->clk = timeStamp % 2;

        if (timeStamp < 10) {
            top->rstn = 0;
        }
        else {
            top->rstn = 1;
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