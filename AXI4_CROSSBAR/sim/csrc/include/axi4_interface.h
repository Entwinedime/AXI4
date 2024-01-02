#ifndef _AXI4_INTERFACE_H_
#define _AXI4_INTERFACE_H_

#include <cstdint>

typedef struct {
    // AW
    uint8_t                     AWID;
    uint64_t                    AWADDR;
    uint8_t                     AWLEN;
    uint8_t                     AWSIZE;
    uint8_t                     AWBURST;
    uint8_t                     AWLOCK;
    uint8_t                     AWCACHE;
    uint8_t                     AWPROT;
    uint8_t                     AWVALID;
    uint8_t                     AWREADY;

    // W
    uint64_t                    WDATA;
    uint8_t                     WSTRB;
    uint8_t                     WLAST;
    uint8_t                     WVALID;
    uint8_t                     WREADY;

    // B
    uint8_t                     BID;
    uint8_t                     BRESP;
    uint8_t                     BVALID;
    uint8_t                     BREADY;

    // AR
    uint8_t                     ARID;
    uint64_t                    ARADDR;
    uint8_t                     ARLEN;
    uint8_t                     ARSIZE;
    uint8_t                     ARBURST;
    uint8_t                     ARLOCK;
    uint8_t                     ARCACHE;
    uint8_t                     ARPROT;
    uint8_t                     ARVALID;
    uint8_t                     ARREADY;

    // R
    uint8_t                     RID;
    uint64_t                    RDATA;
    uint8_t                     RSTRB;
    uint8_t                     RLAST;
    uint8_t                     RVALID;
    uint8_t                     RREADY;
} axi4_interface;

#endif