include_directories(../include)

add_library(AXI4_MASTER_BRAM axi4_master_bram.cpp)
add_library(AXI4_SLAVE_BRAM axi4_slave_bram.cpp)
add_library(AXI4_TRANSACTION axi4_transaction.cpp)