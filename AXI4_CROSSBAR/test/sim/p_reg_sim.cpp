#include <cstdlib>
#include <ctime>
#include <iostream>
#include <memory>
#include <cmath>

#include <verilated.h>
#include <verilated_vcd_c.h>

#include "VPRIORITY_REG.h"

int main(int argc, char** argv) {
    Verilated::mkdir("logs");

    const auto contextp = std::make_unique<VerilatedContext>();

    // Set debug level, 0 is off, 9 is highest presently used
    // May be overridden by commandArgs argument parsing
    contextp->debug(0);

    // Verilator must compute traced signals
    contextp->traceEverOn(true);

    const auto PRIORITY_REG = std::make_unique<VPRIORITY_REG>(contextp.get());
    const auto tfp = std::make_unique<VerilatedVcdC>();

    PRIORITY_REG->trace(tfp.get(), 0);
    tfp->open("logs/p_reg_sim.vcd");

    const int sender_num = 8;

    int i;
    int j;

    vluint64_t timeStamp = 0;
    int index[sender_num];
    int rank_prev[sender_num];
    int rank_cur[sender_num];
    int error_count = 0;

    for (i = 0; i < sender_num; i ++) {
        index[i] = 0;
        rank_prev[i] = i;
        rank_cur[i] = i;
    }

    srand(time(nullptr));
    while(timeStamp < 100) {
        PRIORITY_REG->clk = timeStamp % 2;
        PRIORITY_REG->rst = 0;

        for (i = 0; i < sender_num; i ++) {
            if (timeStamp%2 == 0) {
                index[i] = rand() % 2;
                if (index[i]) {
                    PRIORITY_REG->valid[i] = 1;
                    PRIORITY_REG->ready[i] = 1;
                }
                else {
                    PRIORITY_REG->valid[i] = 0;
                    PRIORITY_REG->ready[i] = 0;
                }
            }
        }

        // Evaluate model
        // (If you have multiple models being simulated in the same
        // timestep then instead of eval(), call eval_step() on each, then
        // eval_end_step() on each. See the manual.)
        PRIORITY_REG->eval();
        tfp->dump(timeStamp);
        timeStamp ++;

        if (timeStamp % 2 == 0) {

            std::cout << "NO." << timeStamp/2 <<" test:" << std::endl;

            for (i = 0; i < sender_num; i ++) {
                rank_cur[i] = int(log2(PRIORITY_REG->prio[i]));
                std::cout << "prio_cur[" << i << "]:" << rank_cur[i] << " ";
            }
            std::cout << std::endl;
            int max_rank = -1;
            int index_chosen = -1;
            for (i = 0; i < sender_num; i ++) {
                std::cout << "prio_pre[" << i << "]:" << rank_prev[i] << " ";
                if (index[i] && (rank_prev[i] >= max_rank)) {
                    max_rank = rank_prev[i];
                    index_chosen = i;
                }
            }
            std::cout << std::endl;
            for (i = 0; i < sender_num; i ++) {
                std::cout << "valid   [" << i << "]:" << index[i] << " ";
            }
            
            std::cout << std::endl << "max_rank:" << max_rank << std::endl;
            std::cout << "index_chosen:" << index_chosen << std::endl;

            for (i = 0; i < sender_num; i ++) {
                if (i == index_chosen) {
                    if (rank_cur[i] != 0) {
                        std::cout << "error: not set to the lowest" << std::endl;
                        error_count ++;
                        break;
                    }
                }
                else if (rank_prev[i] < max_rank) {
                    if (rank_cur[i] != rank_prev[i] + 1) {
                        std::cout << "error: other bits are not shifted" << std::endl;
                        error_count ++;
                        break;
                    }
                }
            }
            if (i >= sender_num) {
                std::cout << "success" << std::endl << std::endl;
            }
            for (i = 0; i < sender_num; i ++) {
                rank_prev[i] = rank_cur[i];
            }
        }
    }

    // Final model cleanup
    PRIORITY_REG->final();
    tfp->close();
    std::cout << std::endl << "total error count:" << error_count << std::endl;
    // Return good completion status
    // Don't use exit() or destructor won't get called
    return 0;
}
