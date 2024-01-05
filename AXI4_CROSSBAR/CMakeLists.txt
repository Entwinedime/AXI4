cmake_minimum_required(VERSION 3.26)
project(AXI4_CROSSBAR_SIM)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(verilator)
if(NOT verilator_FOUND)
    message(FATAL_ERROR "Verilator was not found. Either install it, or set the VERILATOR_ROOT environment variable")
endif()

add_executable(SIM_TOP ./sim/axi4_crossbar_sim.cpp)

set(VSRC_DIR vsrc)
file(GLOB_RECURSE VSRC_FILES ${VSRC_DIR}/*.sv)

verilate(   SIM_TOP 
            TRACE
            PREFIX VSIM_TOP
            INCLUDE_DIRS ${VSRC_DIR}/include
            TOP_MODULE SIM_TOP
            SOURCES ${VSRC_FILES}
            VERILATOR_ARGS 
            +define+_AXI4_CROSSBAR_SIM_
            +define+MASTER_NUM=4
            +define+SLAVE_NUM=4
            +define+W_ID_LEN=4
            +define+R_ID_LEN=4
            +define+ADDR_WIDTH=32
            +define+DATA_WIDTH=64 
)

add_subdirectory(./sim/sources)
include_directories(./sim/include)

set_target_properties(SIM_TOP PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
)

target_link_libraries(SIM_TOP PUBLIC AXI4_MASTER_BRAM)
target_link_libraries(SIM_TOP PUBLIC AXI4_SLAVE_BRAM)
target_link_libraries(SIM_TOP PUBLIC AXI4_TRANSACTION)



