#ifndef _AXI4_TRANSACTION_RANDOM_GENERATOR_H_
#define _AXI4_TRANSACTION_RANDOM_GENERATOR_H_

    #include "axi4_transaction.h"

    void axi4_transaction_random_generator(axi4_write_transaction& transaction);
    void axi4_transaction_random_generator(axi4_read_transaction &transaction);
    
#endif