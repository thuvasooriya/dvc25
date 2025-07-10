-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%                      Centre for Development of Advanced Computing                            %%
-- %%                          Vellayambalam, Thiruvananthapuram.                                  %%
-- %%==============================================================================================%%
-- %% This confidential and proprietary software may be used only as authorised by a licensing     %%
-- %% agreement from Centre for Development of Advanced Computing, India (C-DAC).In the event of   %%
-- %% publication, the following notice is applicable:                                             %%
-- %% Copyright (c) 2025 C-DAC                                                                     %%
-- %% ALL RIGHTS RESERVED                                                                          %%
-- %% The entire notice above must be reproduced on all authorised copies.                         %%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %% File Name        : Top.vhd                                                                   %%
-- %% Title            : Top File                                                                  %%
-- %% Author           : HDG, CDAC Thiruvananthapuram                                              %%
-- %% Description      : Top for DVCON System vivado Implementation                                %%
-- %% Version          : 00                                                                        %%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%% Modification / Updation  History %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%    Date                By              Version          Change Description                   %%
-- %%                                                                                              %%
-- %%                                                                                              %%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;

entity top is
  port (
    --------------- External reset from pin ---------------------
    rst          : in    std_logic;
    serial_rst_n : in    std_logic;
    gpio_rst_dip : in    std_logic;
    rst_led      : out   std_logic;
    locked_led   : out   std_logic;
    proc_beat    : out   std_logic;

    --------- differential clock for DDR controller -------------
    clk_in1_p : in    std_logic; -- 50MHz
    clk_in1_n : in    std_logic; -- 50MHz

    ------------------------ DDR Pins ---------------------------
    ddr3_addr           : out   std_logic_vector(14 downto 0);
    ddr3_ba             : out   std_logic_vector(2 downto 0);
    ddr3_ck_p           : out   std_logic_vector(0 to 0);
    ddr3_ck_n           : out   std_logic_vector(0 to 0);
    ddr3_cke            : out   std_logic_vector(0 downto 0);
    ddr3_cs_n           : out   std_logic_vector(0 downto 0);
    ddr3_ras_n          : out   std_logic;
    ddr3_cas_n          : out   std_logic;
    ddr3_we_n           : out   std_logic;
    ddr3_dq             : inout std_logic_vector(31 downto 0);
    ddr3_dqs_p          : inout std_logic_vector(3 downto 0);
    ddr3_dqs_n          : inout std_logic_vector(3 downto 0);
    ddr3_dm             : out   std_logic_vector(3 downto 0);
    ddr3_odt            : out   std_logic_vector(0 downto 0);
    ddr3_reset_n        : out   std_logic;
    init_calib_complete : out   std_logic;

    ------------------------ GMAC Pins --------------------------
    eth_rxck     : in    std_logic; -- 125
    eth_txck     : out   std_logic;
    eth_txd      : out   std_logic_vector(3 downto 0);
    eth_tx_en    : out   std_logic;
    eth_rxd      : in    std_logic_vector(3 downto 0);
    eth_rxctl    : in    std_logic;
    eth_mdio     : inout std_logic;
    eth_mdc      : out   std_logic;
    eth_phyrst_n : out   std_logic;
    eth_int_b    : in    std_logic;

    ------------------------ UART Pins ---------------------------
    sin0  : in    std_logic;
    sout0 : out   std_logic;

    ----------------------- SPI Pins ----------------------------
    mosi0 : out   std_logic;
    miso0 : in    std_logic;
    sclk0 : out   std_logic;
    cs_n0 : out   std_logic;

    wp   : out   std_logic;
    hold : out   std_logic;

    ----------------------- IIC Pins ----------------------------
    sda : inout std_logic;
    scl : inout std_logic;

    ----------------------- GPIO Pins ----------------------------
    gpio_port0 : inout std_logic_vector(15  downto 0);
    gpio_port1 : inout std_logic_vector(15  downto 0)
  );
end entity top;

architecture top_a of top is

  component at1051_system_top is
    port (
      --------------- External reset from pin ---------------------
      rst          : in    std_logic;
      rst_led      : out   std_logic;
      locked_led   : out   std_logic;
      serial_rst_n : in    std_logic;
      gpio_rst_dip : in    std_logic;

      --------- differential clock for DDR controller -------------
      clk_in1_p : in    std_logic;
      clk_in1_n : in    std_logic;

      ------------------------ DDR Pins ---------------------------
      ddr3_addr           : out   std_logic_vector(14 downto 0);
      ddr3_ba             : out   std_logic_vector(2 downto 0);
      ddr3_ck_p           : out   std_logic_vector(0 to 0);
      ddr3_ck_n           : out   std_logic_vector(0 to 0);
      ddr3_cke            : out   std_logic_vector(0 downto 0);
      ddr3_cs_n           : out   std_logic_vector(0 downto 0);
      ddr3_ras_n          : out   std_logic;
      ddr3_cas_n          : out   std_logic;
      ddr3_we_n           : out   std_logic;
      ddr3_dq             : inout std_logic_vector(31 downto 0);
      ddr3_dqs_p          : inout std_logic_vector(3 downto 0);
      ddr3_dqs_n          : inout std_logic_vector(3 downto 0);
      ddr3_dm             : out   std_logic_vector(3 downto 0);
      ddr3_odt            : out   std_logic_vector(0 downto 0);
      ddr3_reset_n        : out   std_logic;
      init_calib_complete : out   std_logic;

      ------------------------ GMAC Pins --------------------------
      eth_rxck     : in    std_logic;
      eth_txck     : out   std_logic;
      eth_txd      : out   std_logic_vector(3 downto 0);
      eth_tx_en    : out   std_logic;
      eth_rxd      : in    std_logic_vector(3 downto 0);
      eth_rxctl    : in    std_logic;
      eth_mdio     : inout std_logic;
      eth_mdc      : out   std_logic;
      eth_phyrst_n : out   std_logic;
      eth_int_b    : in    std_logic;

      ------------------------ UART Pins ---------------------------
      sin0  : in    std_logic;
      sout0 : out   std_logic;

      baudout_n : out   std_logic;

      ----------------------- SPI Pins ----------------------------
      mosi0 : out   std_logic;
      miso0 : in    std_logic;
      sclk0 : out   std_logic;
      cs_n0 : out   std_logic;

      wp   : out   std_logic;
      hold : out   std_logic;

      ----------------------- IIC Pins ----------------------------
      sda : inout std_logic;
      scl : inout std_logic;

      ----------------------- GPIO Pins ----------------------------
      gpio_port0 : inout std_logic_vector(15  downto 0);
      gpio_port1 : inout std_logic_vector(15  downto 0);

      proc_beat : out   std_logic;

      ----------------------- Accelerator  Pins -------------------------------
      s_axi_aclk    : out   std_logic;
      s_axi_aresetn : out   std_logic;
      ----- Master Write Address Channel ------
      m_axi_awvalid : in    std_logic;
      m_axi_awid    : in    std_logic_vector(11 downto 0);
      m_axi_awlen   : in    std_logic_vector(7 downto 0);
      m_axi_awsize  : in    std_logic_vector(2 downto 0);
      m_axi_awburst : in    std_logic_vector(1 downto 0);
      m_axi_awlock  : in    std_logic_vector(0 downto 0);
      m_axi_awcache : in    std_logic_vector(3 downto 0);
      m_axi_awqos   : in    std_logic_vector(3 downto 0);
      m_axi_awaddr  : in    std_logic_vector(63 downto 0);
      m_axi_awprot  : in    std_logic_vector(2 downto 0);
      m_axi_awready : out   std_logic;
      ----- Master Write Data Channel ------
      m_axi_wvalid : in    std_logic;
      m_axi_wlast  : in    std_logic;
      m_axi_wdata  : in    std_logic_vector(127 downto 0);
      m_axi_wstrb  : in    std_logic_vector(15 downto 0);
      m_axi_wready : out   std_logic;
      ----- Master Write Response Channel ------
      m_axi_bready : in    std_logic;
      m_axi_bvalid : out   std_logic;
      m_axi_bid    : out   std_logic_vector(11 downto 0);
      m_axi_bresp  : out   std_logic_vector(1 downto 0);
      ----- Master Read Address Channel ------
      m_axi_arvalid : in    std_logic;
      m_axi_arid    : in    std_logic_vector(11 downto 0);
      m_axi_arlen   : in    std_logic_vector(7 downto 0);
      m_axi_arsize  : in    std_logic_vector(2 downto 0);
      m_axi_arburst : in    std_logic_vector(1 downto 0);
      m_axi_arlock  : in    std_logic_vector(0 downto 0);
      m_axi_arcache : in    std_logic_vector(3 downto 0);
      m_axi_arqos   : in    std_logic_vector(3 downto 0);
      m_axi_araddr  : in    std_logic_vector(63 downto 0);
      m_axi_arprot  : in    std_logic_vector(2 downto 0);
      m_axi_arready : out   std_logic;
      ----- Master Read Response Channel ------
      m_axi_rready : in    std_logic;
      m_axi_rvalid : out   std_logic;
      m_axi_rid    : out   std_logic_vector(11 downto 0);
      m_axi_rlast  : out   std_logic;
      m_axi_rresp  : out   std_logic_vector(1 downto 0);
      m_axi_rdata  : out   std_logic_vector(127 downto 0);
      ----- Slave Write Address Channel ------
      s_axi_awid    : out   std_logic_vector(11  downto 0);
      s_axi_awaddr  : out   std_logic_vector(63  downto 0);
      s_axi_awlen   : out   std_logic_vector(7   downto 0);
      s_axi_awsize  : out   std_logic_vector(2   downto 0);
      s_axi_awburst : out   std_logic_vector(1   downto 0);
      s_axi_awlock  : out   std_logic;
      s_axi_awcache : out   std_logic_vector(3   downto 0);
      s_axi_awprot  : out   std_logic_vector(2   downto 0);
      s_axi_awqos   : out   std_logic_vector(3   downto 0);
      s_axi_awvalid : out   std_logic;
      s_axi_awready : in    std_logic;
      ----- Slave Write Data Channel ------
      s_axi_wdata  : out   std_logic_vector(127 downto 0);
      s_axi_wstrb  : out   std_logic_vector(15  downto 0);
      s_axi_wlast  : out   std_logic;
      s_axi_wvalid : out   std_logic;
      s_axi_wready : in    std_logic;
      ----- Slave Write Response Channel ------
      s_axi_bready : out   std_logic;
      s_axi_bid    : in    std_logic_vector(11  downto 0);
      s_axi_bresp  : in    std_logic_vector(1   downto 0);
      s_axi_bvalid : in    std_logic;
      ----- Slave Read Address Channel ------
      s_axi_arid    : out   std_logic_vector(11  downto 0);
      s_axi_araddr  : out   std_logic_vector(63  downto 0);
      s_axi_arlen   : out   std_logic_vector(7    downto 0);
      s_axi_arsize  : out   std_logic_vector(2    downto 0);
      s_axi_arburst : out   std_logic_vector(1    downto 0);
      s_axi_arlock  : out   std_logic;
      s_axi_arcache : out   std_logic_vector(3    downto 0);
      s_axi_arprot  : out   std_logic_vector(2    downto 0);
      s_axi_arqos   : out   std_logic_vector(3    downto 0);
      s_axi_arvalid : out   std_logic;
      s_axi_arready : in    std_logic;
      ----- Slave Read Data Channel ------
      s_axi_rready : out   std_logic;
      s_axi_rid    : in    std_logic_vector(11  downto 0);
      s_axi_rdata  : in    std_logic_vector(127 downto 0);
      s_axi_rresp  : in    std_logic_vector(1   downto 0);
      s_axi_rlast  : in    std_logic;
      s_axi_rvalid : in    std_logic;

      ----------------------- ROM  Pins -------------------------------

      rom_s_axi_awid    : out   std_logic_vector( 11 downto 0);
      rom_s_axi_awaddr  : out   std_logic_vector( 63 downto 0);
      rom_s_axi_awlen   : out   std_logic_vector( 7 downto 0);
      rom_s_axi_awsize  : out   std_logic_vector( 2 downto 0);
      rom_s_axi_awburst : out   std_logic_vector( 1 downto 0);
      rom_s_axi_awvalid : out   std_logic;
      rom_s_axi_awready : in    std_logic;
      rom_s_axi_wdata   : out   std_logic_vector( 127 downto 0);
      rom_s_axi_wstrb   : out   std_logic_vector( 15 downto 0);
      rom_s_axi_wlast   : out   std_logic;
      rom_s_axi_wvalid  : out   std_logic;
      rom_s_axi_wready  : in    std_logic;
      rom_s_axi_bid     : in    std_logic_vector( 11 downto 0);
      rom_s_axi_bresp   : in    std_logic_vector( 1 downto 0);
      rom_s_axi_bvalid  : in    std_logic;
      rom_s_axi_bready  : out   std_logic;
      rom_s_axi_arid    : out   std_logic_vector( 11 downto 0);
      rom_s_axi_araddr  : out   std_logic_vector( 63 downto 0);
      rom_s_axi_arlen   : out   std_logic_vector( 7 downto 0);
      rom_s_axi_arsize  : out   std_logic_vector( 2 downto 0);
      rom_s_axi_arburst : out   std_logic_vector( 1 downto 0);
      rom_s_axi_arvalid : out   std_logic;
      rom_s_axi_arready : in    std_logic;
      rom_s_axi_rid     : in    std_logic_vector( 11 downto 0);
      rom_s_axi_rdata   : in    std_logic_vector( 127 downto 0);
      rom_s_axi_rresp   : in    std_logic_vector( 1 downto 0);
      rom_s_axi_rlast   : in    std_logic;
      rom_s_axi_rvalid  : in    std_logic;
      rom_s_axi_rready  : out   std_logic
    );
  end component at1051_system_top;

  component accelerator_top is
    port (
      s_axi_aclk    : in    std_logic;
      s_axi_aresetn : in    std_logic;

      -- Master Write Address Channel ------
      m_axi_awvalid : out   std_logic;
      m_axi_awid    : out   std_logic_vector(11 downto 0);
      m_axi_awlen   : out   std_logic_vector(7 downto 0);
      m_axi_awsize  : out   std_logic_vector(2 downto 0);
      m_axi_awburst : out   std_logic_vector(1 downto 0);
      m_axi_awlock  : out   std_logic_vector(0 downto 0);
      m_axi_awcache : out   std_logic_vector(3 downto 0);
      m_axi_awqos   : out   std_logic_vector(3 downto 0);
      m_axi_awaddr  : out   std_logic_vector(63 downto 0);
      m_axi_awprot  : out   std_logic_vector(2 downto 0);
      m_axi_awready : in    std_logic;

      -- Master Write Data Channel ------
      m_axi_wvalid : out   std_logic;
      m_axi_wlast  : out   std_logic;
      m_axi_wdata  : out   std_logic_vector(127 downto 0);
      m_axi_wstrb  : out   std_logic_vector(15 downto 0);
      m_axi_wready : in    std_logic;

      -- Master Write Response Channel ------
      m_axi_bready : out   std_logic;
      m_axi_bvalid : in    std_logic;
      m_axi_bid    : in    std_logic_vector(11 downto 0);
      m_axi_bresp  : in    std_logic_vector(1 downto 0);

      -- Master Read Address Channel ------
      m_axi_arvalid : out   std_logic;
      m_axi_arid    : out   std_logic_vector(11 downto 0);
      m_axi_arlen   : out   std_logic_vector(7 downto 0);
      m_axi_arsize  : out   std_logic_vector(2 downto 0);
      m_axi_arburst : out   std_logic_vector(1 downto 0);
      m_axi_arlock  : out   std_logic_vector(0 downto 0);
      m_axi_arcache : out   std_logic_vector(3 downto 0);
      m_axi_arqos   : out   std_logic_vector(3 downto 0);
      m_axi_araddr  : out   std_logic_vector(63 downto 0);
      m_axi_arprot  : out   std_logic_vector(2 downto 0);
      m_axi_arready : in    std_logic;

      -- Master Read Response Channel ------
      m_axi_rready : out   std_logic;
      m_axi_rvalid : in    std_logic;
      m_axi_rid    : in    std_logic_vector(11 downto 0);
      m_axi_rlast  : in    std_logic;
      m_axi_rresp  : in    std_logic_vector(1 downto 0);
      m_axi_rdata  : in    std_logic_vector(127 downto 0);

      -- Slave Write Address Channel ------
      s_axi_awid    : in    std_logic_vector(11  downto 0);
      s_axi_awaddr  : in    std_logic_vector(63  downto 0);
      s_axi_awlen   : in    std_logic_vector(7   downto 0);
      s_axi_awsize  : in    std_logic_vector(2   downto 0);
      s_axi_awburst : in    std_logic_vector(1   downto 0);
      s_axi_awlock  : in    std_logic;
      s_axi_awcache : in    std_logic_vector(3   downto 0);
      s_axi_awprot  : in    std_logic_vector(2   downto 0);
      s_axi_awqos   : in    std_logic_vector(3   downto 0);
      s_axi_awvalid : in    std_logic;
      s_axi_awready : out   std_logic;
      -- Slave Write Data Channel ------
      s_axi_wdata  : in    std_logic_vector(127 downto 0);
      s_axi_wstrb  : in    std_logic_vector(15  downto 0);
      s_axi_wlast  : in    std_logic;
      s_axi_wvalid : in    std_logic;
      s_axi_wready : out   std_logic;
      -- Slave Write Response Channel ------
      s_axi_bready : in    std_logic;
      s_axi_bid    : out   std_logic_vector(11  downto 0);
      s_axi_bresp  : out   std_logic_vector(1   downto 0);
      s_axi_bvalid : out   std_logic;
      -- Slave Read Address Channel ------
      s_axi_arid    : in    std_logic_vector(11  downto 0);
      s_axi_araddr  : in    std_logic_vector(63  downto 0);
      s_axi_arlen   : in    std_logic_vector(7    downto 0);
      s_axi_arsize  : in    std_logic_vector(2    downto 0);
      s_axi_arburst : in    std_logic_vector(1    downto 0);
      s_axi_arlock  : in    std_logic;
      s_axi_arcache : in    std_logic_vector(3    downto 0);
      s_axi_arprot  : in    std_logic_vector(2    downto 0);
      s_axi_arqos   : in    std_logic_vector(3    downto 0);
      s_axi_arvalid : in    std_logic;
      s_axi_arready : out   std_logic;
      -- Slave Read Data Channel ------
      s_axi_rready : in    std_logic;
      s_axi_rid    : out   std_logic_vector(11  downto 0);
      s_axi_rdata  : out   std_logic_vector(127 downto 0);
      s_axi_rresp  : out   std_logic_vector(1   downto 0);
      s_axi_rlast  : out   std_logic;
      s_axi_rvalid : out   std_logic
    );
  end component accelerator_top;

  component rom_32kb_axi is
    port (
      rsta_busy     : out   std_logic;
      rstb_busy     : out   std_logic;
      s_aclk        : in    std_logic;
      s_aresetn     : in    std_logic;
      s_axi_awid    : in    std_logic_vector( 11 downto 0);
      s_axi_awaddr  : in    std_logic_vector( 31 downto 0);
      s_axi_awlen   : in    std_logic_vector( 7 downto 0);
      s_axi_awsize  : in    std_logic_vector( 2 downto 0);
      s_axi_awburst : in    std_logic_vector( 1 downto 0);
      s_axi_awvalid : in    std_logic;
      s_axi_awready : out   std_logic;
      s_axi_wdata   : in    std_logic_vector( 127 downto 0);
      s_axi_wstrb   : in    std_logic_vector( 15 downto 0);
      s_axi_wlast   : in    std_logic;
      s_axi_wvalid  : in    std_logic;
      s_axi_wready  : out   std_logic;
      s_axi_bid     : out   std_logic_vector( 11 downto 0);
      s_axi_bresp   : out   std_logic_vector( 1 downto 0);
      s_axi_bvalid  : out   std_logic;
      s_axi_bready  : in    std_logic;
      s_axi_arid    : in    std_logic_vector( 11 downto 0);
      s_axi_araddr  : in    std_logic_vector( 31 downto 0);
      s_axi_arlen   : in    std_logic_vector( 7 downto 0);
      s_axi_arsize  : in    std_logic_vector( 2 downto 0);
      s_axi_arburst : in    std_logic_vector( 1 downto 0);
      s_axi_arvalid : in    std_logic;
      s_axi_arready : out   std_logic;
      s_axi_rid     : out   std_logic_vector( 11 downto 0);
      s_axi_rdata   : out   std_logic_vector( 127 downto 0);
      s_axi_rresp   : out   std_logic_vector( 1 downto 0);
      s_axi_rlast   : out   std_logic;
      s_axi_rvalid  : out   std_logic;
      s_axi_rready  : in    std_logic
    );
  end component rom_32kb_axi;

  signal axi_clk : std_logic;
  signal reset_n : std_logic;
  ----- Master Write Address Channel ------
  signal acc_m_axi_awvalid : std_logic;
  signal acc_m_axi_awid    : std_logic_vector(11 downto 0);
  signal acc_m_axi_awlen   : std_logic_vector(7 downto 0);
  signal acc_m_axi_awsize  : std_logic_vector(2 downto 0);
  signal acc_m_axi_awburst : std_logic_vector(1 downto 0);
  signal acc_m_axi_awlock  : std_logic_vector(0 downto 0);
  signal acc_m_axi_awcache : std_logic_vector(3 downto 0);
  signal acc_m_axi_awqos   : std_logic_vector(3 downto 0);
  signal acc_m_axi_awaddr  : std_logic_vector(63 downto 0);
  signal acc_m_axi_awprot  : std_logic_vector(2 downto 0);
  signal acc_m_axi_awready : std_logic;
  ----- Master Write Data Channel ------
  signal acc_m_axi_wvalid : std_logic;
  signal acc_m_axi_wlast  : std_logic;
  signal acc_m_axi_wdata  : std_logic_vector(127 downto 0);
  signal acc_m_axi_wstrb  : std_logic_vector(15 downto 0);
  signal acc_m_axi_wready : std_logic;
  ----- Master Write Response Channel ------
  signal acc_m_axi_bready : std_logic;
  signal acc_m_axi_bvalid : std_logic;
  signal acc_m_axi_bid    : std_logic_vector(11 downto 0);
  signal acc_m_axi_bresp  : std_logic_vector(1 downto 0);
  ----- Master Read Address Channel ------
  signal acc_m_axi_arvalid : std_logic;
  signal acc_m_axi_arid    : std_logic_vector(11 downto 0);
  signal acc_m_axi_arlen   : std_logic_vector(7 downto 0);
  signal acc_m_axi_arsize  : std_logic_vector(2 downto 0);
  signal acc_m_axi_arburst : std_logic_vector(1 downto 0);
  signal acc_m_axi_arlock  : std_logic_vector(0 downto 0);
  signal acc_m_axi_arcache : std_logic_vector(3 downto 0);
  signal acc_m_axi_arqos   : std_logic_vector(3 downto 0);
  signal acc_m_axi_araddr  : std_logic_vector(63 downto 0);
  signal acc_m_axi_arprot  : std_logic_vector(2 downto 0);
  signal acc_m_axi_arready : std_logic;
  ----- Master Read Response Channel ------
  signal acc_m_axi_rready : std_logic;
  signal acc_m_axi_rvalid : std_logic;
  signal acc_m_axi_rid    : std_logic_vector(11 downto 0);
  signal acc_m_axi_rlast  : std_logic;
  signal acc_m_axi_rresp  : std_logic_vector(1 downto 0);
  signal acc_m_axi_rdata  : std_logic_vector(127 downto 0);
  ----- Slave Write Address Channel ------
  signal acc_s_axi_awid    : std_logic_vector(11  downto 0);
  signal acc_s_axi_awaddr  : std_logic_vector(63  downto 0);
  signal acc_s_axi_awlen   : std_logic_vector(7   downto 0);
  signal acc_s_axi_awsize  : std_logic_vector(2   downto 0);
  signal acc_s_axi_awburst : std_logic_vector(1   downto 0);
  signal acc_s_axi_awlock  : std_logic;
  signal acc_s_axi_awcache : std_logic_vector(3   downto 0);
  signal acc_s_axi_awprot  : std_logic_vector(2   downto 0);
  signal acc_s_axi_awqos   : std_logic_vector(3   downto 0);
  signal acc_s_axi_awvalid : std_logic;
  signal acc_s_axi_awready : std_logic;
  ----- Slave Write Data Channel ------
  signal acc_s_axi_wdata  : std_logic_vector(127 downto 0);
  signal acc_s_axi_wstrb  : std_logic_vector(15  downto 0);
  signal acc_s_axi_wlast  : std_logic;
  signal acc_s_axi_wvalid : std_logic;
  signal acc_s_axi_wready : std_logic;
  ----- Slave Write Response Channel ------
  signal acc_s_axi_bready : std_logic;
  signal acc_s_axi_bid    : std_logic_vector(11  downto 0);
  signal acc_s_axi_bresp  : std_logic_vector(1   downto 0);
  signal acc_s_axi_bvalid : std_logic;
  ----- Slave Read Address Channel ------
  signal acc_s_axi_arid    : std_logic_vector(11  downto 0);
  signal acc_s_axi_araddr  : std_logic_vector(63  downto 0);
  signal acc_s_axi_arlen   : std_logic_vector(7    downto 0);
  signal acc_s_axi_arsize  : std_logic_vector(2    downto 0);
  signal acc_s_axi_arburst : std_logic_vector(1    downto 0);
  signal acc_s_axi_arlock  : std_logic;
  signal acc_s_axi_arcache : std_logic_vector(3    downto 0);
  signal acc_s_axi_arprot  : std_logic_vector(2    downto 0);
  signal acc_s_axi_arqos   : std_logic_vector(3    downto 0);
  signal acc_s_axi_arvalid : std_logic;
  signal acc_s_axi_arready : std_logic;
  ----- Slave Read Data Channel ------
  signal acc_s_axi_rready : std_logic;
  signal acc_s_axi_rid    : std_logic_vector(11  downto 0);
  signal acc_s_axi_rdata  : std_logic_vector(127 downto 0);
  signal acc_s_axi_rresp  : std_logic_vector(1   downto 0);
  signal acc_s_axi_rlast  : std_logic;
  signal acc_s_axi_rvalid : std_logic;

  -----------------------------------------------------------
  ----- Boot ROM-AXI Interconnect connection signals
  -----------------------------------------------------------
  signal rom_axi_awid    : std_logic_vector(11 downto 0);
  signal rom_axi_awaddr  : std_logic_vector(63 downto 0);
  signal rom_axi_awlen   : std_logic_vector(7  downto 0);
  signal rom_axi_awsize  : std_logic_vector(2  downto 0);
  signal rom_axi_awburst : std_logic_vector(1  downto 0);
  signal rom_axi_awvalid : std_logic;
  signal rom_axi_awready : std_logic;

  signal rom_axi_wdata  : std_logic_vector(127 downto 0);
  signal rom_axi_wstrb  : std_logic_vector(15  downto 0);
  signal rom_axi_wlast  : std_logic;
  signal rom_axi_wvalid : std_logic;
  signal rom_axi_wready : std_logic;

  signal rom_axi_bid    : std_logic_vector(11 downto 0);
  signal rom_axi_bresp  : std_logic_vector(1  downto 0);
  signal rom_axi_bvalid : std_logic;
  signal rom_axi_bready : std_logic;

  signal rom_axi_arid    : std_logic_vector(11 downto 0);
  signal rom_axi_araddr  : std_logic_vector(63 downto 0);
  signal rom_axi_arlen   : std_logic_vector(7  downto 0);
  signal rom_axi_arsize  : std_logic_vector(2  downto 0);
  signal rom_axi_arburst : std_logic_vector(1  downto 0);
  signal rom_axi_arvalid : std_logic;
  signal rom_axi_arready : std_logic;

  signal rom_axi_rid    : std_logic_vector(11  downto 0);
  signal rom_axi_rdata  : std_logic_vector(127 downto 0);
  signal rom_axi_rresp  : std_logic_vector(1   downto 0);
  signal rom_axi_rlast  : std_logic;
  signal rom_axi_rvalid : std_logic;
  signal rom_axi_rready : std_logic;

begin

  u_at1051_system_top : component at1051_system_top
    port map (
      -------------- External reset from pin --------------------
      rst          => rst,
      rst_led      => rst_led,
      locked_led   => locked_led,
      serial_rst_n => serial_rst_n,
      gpio_rst_dip => gpio_rst_dip,

      -------- differential clock for DDR controller ------------
      clk_in1_p => clk_in1_p,
      clk_in1_n => clk_in1_n,

      ---------------------- DDR Pins ---------------------------
      ddr3_addr           => ddr3_addr,
      ddr3_ba             => ddr3_ba,
      ddr3_ck_p           => ddr3_ck_p,
      ddr3_ck_n           => ddr3_ck_n,
      ddr3_cke            => ddr3_cke,
      ddr3_cs_n           => ddr3_cs_n,
      ddr3_ras_n          => ddr3_ras_n,
      ddr3_cas_n          => ddr3_cas_n,
      ddr3_we_n           => ddr3_we_n,
      ddr3_dq             => ddr3_dq,
      ddr3_dqs_p          => ddr3_dqs_p,
      ddr3_dqs_n          => ddr3_dqs_n,
      ddr3_dm             => ddr3_dm,
      ddr3_odt            => ddr3_odt,
      ddr3_reset_n        => ddr3_reset_n,
      init_calib_complete => init_calib_complete,

      ------------------------ GMAC Pins --------------------------
      eth_rxck     => eth_rxck,
      eth_txck     => eth_txck,
      eth_txd      => eth_txd,
      eth_tx_en    => eth_tx_en,
      eth_rxd      => eth_rxd,
      eth_rxctl    => eth_rxctl,
      eth_mdio     => eth_mdio,
      eth_mdc      => eth_mdc,
      eth_phyrst_n => eth_phyrst_n,
      eth_int_b    => eth_int_b,
      ------------------------ UART Pins ---------------------------
      sin0  => sin0,
      sout0 => sout0,

      baudout_n => open,
      ----------------------- SPI Pins ----------------------------
      mosi0 => mosi0,
      miso0 => miso0,
      sclk0 => sclk0,
      cs_n0 => cs_n0,

      wp   => wp,
      hold => hold,
      ----------------------- IIC Pins ----------------------------
      sda => sda,
      scl => scl,

      ----------------------- GPIO Pins ----------------------------
      gpio_port0 => gpio_port0,
      gpio_port1 => gpio_port1,

      proc_beat => proc_beat,

      ---------------- Accelerator  Pins ---------------------------
      s_axi_aclk    => axi_clk,
      s_axi_aresetn => reset_n,
      m_axi_awvalid => acc_m_axi_awvalid,
      m_axi_awid    => acc_m_axi_awid,
      m_axi_awlen   => acc_m_axi_awlen,
      m_axi_awsize  => acc_m_axi_awsize,
      m_axi_awburst => acc_m_axi_awburst,
      m_axi_awlock  => acc_m_axi_awlock,
      m_axi_awcache => acc_m_axi_awcache,
      m_axi_awqos   => acc_m_axi_awqos,
      m_axi_awaddr  => acc_m_axi_awaddr,
      m_axi_awprot  => acc_m_axi_awprot,
      m_axi_awready => acc_m_axi_awready,
      m_axi_wvalid  => acc_m_axi_wvalid,
      m_axi_wlast   => acc_m_axi_wlast,
      m_axi_wdata   => acc_m_axi_wdata,
      m_axi_wstrb   => acc_m_axi_wstrb,
      m_axi_wready  => acc_m_axi_wready,
      m_axi_bready  => acc_m_axi_bready,
      m_axi_bvalid  => acc_m_axi_bvalid,
      m_axi_bid     => acc_m_axi_bid,
      m_axi_bresp   => acc_m_axi_bresp,
      m_axi_arvalid => acc_m_axi_arvalid,
      m_axi_arid    => acc_m_axi_arid,
      m_axi_arlen   => acc_m_axi_arlen,
      m_axi_arsize  => acc_m_axi_arsize,
      m_axi_arburst => acc_m_axi_arburst,
      m_axi_arlock  => acc_m_axi_arlock,
      m_axi_arcache => acc_m_axi_arcache,
      m_axi_arqos   => acc_m_axi_arqos,
      m_axi_araddr  => acc_m_axi_araddr,
      m_axi_arprot  => acc_m_axi_arprot,
      m_axi_arready => acc_m_axi_arready,
      m_axi_rready  => acc_m_axi_rready,
      m_axi_rvalid  => acc_m_axi_rvalid,
      m_axi_rid     => acc_m_axi_rid,
      m_axi_rlast   => acc_m_axi_rlast,
      m_axi_rresp   => acc_m_axi_rresp,
      m_axi_rdata   => acc_m_axi_rdata,
      ----- Slave Chann       el ------
      s_axi_awid    => acc_s_axi_awid,
      s_axi_awaddr  => acc_s_axi_awaddr,
      s_axi_awlen   => acc_s_axi_awlen,
      s_axi_awsize  => acc_s_axi_awsize,
      s_axi_awburst => acc_s_axi_awburst,
      s_axi_awlock  => acc_s_axi_awlock,
      s_axi_awcache => acc_s_axi_awcache,
      s_axi_awprot  => acc_s_axi_awprot,
      s_axi_awqos   => acc_s_axi_awqos,
      s_axi_awvalid => acc_s_axi_awvalid,
      s_axi_awready => acc_s_axi_awready,
      s_axi_wdata   => acc_s_axi_wdata,
      s_axi_wstrb   => acc_s_axi_wstrb,
      s_axi_wlast   => acc_s_axi_wlast,
      s_axi_wvalid  => acc_s_axi_wvalid,
      s_axi_wready  => acc_s_axi_wready,
      s_axi_bready  => acc_s_axi_bready,
      s_axi_bid     => acc_s_axi_bid,
      s_axi_bresp   => acc_s_axi_bresp,
      s_axi_bvalid  => acc_s_axi_bvalid,
      s_axi_arid    => acc_s_axi_arid,
      s_axi_araddr  => acc_s_axi_araddr,
      s_axi_arlen   => acc_s_axi_arlen,
      s_axi_arsize  => acc_s_axi_arsize,
      s_axi_arburst => acc_s_axi_arburst,
      s_axi_arlock  => acc_s_axi_arlock,
      s_axi_arcache => acc_s_axi_arcache,
      s_axi_arprot  => acc_s_axi_arprot,
      s_axi_arqos   => acc_s_axi_arqos,
      s_axi_arvalid => acc_s_axi_arvalid,
      s_axi_arready => acc_s_axi_arready,
      s_axi_rready  => acc_s_axi_rready,
      s_axi_rid     => acc_s_axi_rid,
      s_axi_rdata   => acc_s_axi_rdata,
      s_axi_rresp   => acc_s_axi_rresp,
      s_axi_rlast   => acc_s_axi_rlast,
      s_axi_rvalid  => acc_s_axi_rvalid,
      ---------------- ROM  Pins ------------------------
      rom_s_axi_awid    => rom_axi_awid,
      rom_s_axi_awaddr  => rom_axi_awaddr,
      rom_s_axi_awlen   => rom_axi_awlen,
      rom_s_axi_awsize  => rom_axi_awsize,
      rom_s_axi_awburst => rom_axi_awburst,
      rom_s_axi_awvalid => rom_axi_awvalid,
      rom_s_axi_awready => rom_axi_awready,
      rom_s_axi_wdata   => rom_axi_wdata,
      rom_s_axi_wstrb   => rom_axi_wstrb,
      rom_s_axi_wlast   => rom_axi_wlast,
      rom_s_axi_wvalid  => rom_axi_wvalid,
      rom_s_axi_wready  => rom_axi_wready,
      rom_s_axi_bid     => rom_axi_bid,
      rom_s_axi_bresp   => rom_axi_bresp,
      rom_s_axi_bvalid  => rom_axi_bvalid,
      rom_s_axi_bready  => rom_axi_bready,
      rom_s_axi_arid    => rom_axi_arid,
      rom_s_axi_araddr  => rom_axi_araddr,
      rom_s_axi_arlen   => rom_axi_arlen,
      rom_s_axi_arsize  => rom_axi_arsize,
      rom_s_axi_arburst => rom_axi_arburst,
      rom_s_axi_arvalid => rom_axi_arvalid,
      rom_s_axi_arready => rom_axi_arready,
      rom_s_axi_rid     => rom_axi_rid,
      rom_s_axi_rdata   => rom_axi_rdata,
      rom_s_axi_rresp   => rom_axi_rresp,
      rom_s_axi_rlast   => rom_axi_rlast,
      rom_s_axi_rvalid  => rom_axi_rvalid,
      rom_s_axi_rready  => rom_axi_rready
    );

  u_acc_example_top : component accelerator_top
    port map (
      s_axi_aclk    => axi_clk,
      s_axi_aresetn => reset_n,

      m_axi_awvalid => acc_m_axi_awvalid,
      m_axi_awid    => acc_m_axi_awid,
      m_axi_awlen   => acc_m_axi_awlen,
      m_axi_awsize  => acc_m_axi_awsize,
      m_axi_awburst => acc_m_axi_awburst,
      m_axi_awlock  => acc_m_axi_awlock,
      m_axi_awcache => acc_m_axi_awcache,
      m_axi_awqos   => acc_m_axi_awqos,
      m_axi_awaddr  => acc_m_axi_awaddr,
      m_axi_awprot  => acc_m_axi_awprot,
      m_axi_awready => acc_m_axi_awready,

      m_axi_wvalid => acc_m_axi_wvalid,
      m_axi_wlast  => acc_m_axi_wlast,
      m_axi_wdata  => acc_m_axi_wdata,
      m_axi_wstrb  => acc_m_axi_wstrb,
      m_axi_wready => acc_m_axi_wready,

      m_axi_bready => acc_m_axi_bready,
      m_axi_bvalid => acc_m_axi_bvalid,
      m_axi_bid    => acc_m_axi_bid,
      m_axi_bresp  => acc_m_axi_bresp,

      m_axi_arvalid => acc_m_axi_arvalid,
      m_axi_arid    => acc_m_axi_arid,
      m_axi_arlen   => acc_m_axi_arlen,
      m_axi_arsize  => acc_m_axi_arsize,
      m_axi_arburst => acc_m_axi_arburst,
      m_axi_arlock  => acc_m_axi_arlock,
      m_axi_arcache => acc_m_axi_arcache,
      m_axi_arqos   => acc_m_axi_arqos,
      m_axi_araddr  => acc_m_axi_araddr,
      m_axi_arprot  => acc_m_axi_arprot,
      m_axi_arready => acc_m_axi_arready,

      m_axi_rready => acc_m_axi_rready,
      m_axi_rvalid => acc_m_axi_rvalid,
      m_axi_rid    => acc_m_axi_rid,
      m_axi_rlast  => acc_m_axi_rlast,
      m_axi_rresp  => acc_m_axi_rresp,
      m_axi_rdata  => acc_m_axi_rdata,

      -- Slave Write Address Channel ------
      s_axi_awid    => acc_s_axi_awid,
      s_axi_awaddr  => acc_s_axi_awaddr,
      s_axi_awlen   => acc_s_axi_awlen,
      s_axi_awsize  => acc_s_axi_awsize,
      s_axi_awburst => acc_s_axi_awburst,
      s_axi_awlock  => acc_s_axi_awlock,
      s_axi_awcache => acc_s_axi_awcache,
      s_axi_awprot  => acc_s_axi_awprot,
      s_axi_awqos   => acc_s_axi_awqos,
      s_axi_awvalid => acc_s_axi_awvalid,
      s_axi_awready => acc_s_axi_awready,

      -- Slave Write Data Channel ------
      s_axi_wdata  => acc_s_axi_wdata,
      s_axi_wstrb  => acc_s_axi_wstrb,
      s_axi_wlast  => acc_s_axi_wlast,
      s_axi_wvalid => acc_s_axi_wvalid,
      s_axi_wready => acc_s_axi_wready,

      -- Slave Write Response Channel ------
      s_axi_bready => acc_s_axi_bready,
      s_axi_bid    => acc_s_axi_bid,
      s_axi_bresp  => acc_s_axi_bresp,
      s_axi_bvalid => acc_s_axi_bvalid,

      -- Slave Read Address Channel ------
      s_axi_arid    => acc_s_axi_arid,
      s_axi_araddr  => acc_s_axi_araddr,
      s_axi_arlen   => acc_s_axi_arlen,
      s_axi_arsize  => acc_s_axi_arsize,
      s_axi_arburst => acc_s_axi_arburst,
      s_axi_arlock  => acc_s_axi_arlock,
      s_axi_arcache => acc_s_axi_arcache,
      s_axi_arprot  => acc_s_axi_arprot,
      s_axi_arqos   => acc_s_axi_arqos,
      s_axi_arvalid => acc_s_axi_arvalid,
      s_axi_arready => acc_s_axi_arready,

      -- Slave Read Data Channel ------
      s_axi_rready => acc_s_axi_rready,
      s_axi_rid    => acc_s_axi_rid,
      s_axi_rdata  => acc_s_axi_rdata,
      s_axi_rresp  => acc_s_axi_rresp,
      s_axi_rlast  => acc_s_axi_rlast,
      s_axi_rvalid => acc_s_axi_rvalid
    );

  u_rom_32kb_axi : component rom_32kb_axi
    port map (
      rsta_busy => open,
      rstb_busy => open,

      s_aclk    => axi_clk,
      s_aresetn => reset_n,

      s_axi_awvalid => rom_axi_awvalid,
      s_axi_awid    => rom_axi_awid,
      s_axi_awlen   => rom_axi_awlen,
      s_axi_awsize  => rom_axi_awsize,
      s_axi_awburst => rom_axi_awburst,
      s_axi_awaddr  => rom_axi_awaddr(31 downto 0),
      s_axi_awready => rom_axi_awready,

      s_axi_wvalid => rom_axi_wvalid,
      s_axi_wlast  => rom_axi_wlast,
      s_axi_wdata  => rom_axi_wdata,
      s_axi_wstrb  => rom_axi_wstrb,
      s_axi_wready => rom_axi_wready,

      s_axi_bready => rom_axi_bready,
      s_axi_bvalid => rom_axi_bvalid,
      s_axi_bid    => rom_axi_bid,
      s_axi_bresp  => rom_axi_bresp,

      s_axi_arvalid => rom_axi_arvalid,
      s_axi_arid    => rom_axi_arid,
      s_axi_arlen   => rom_axi_arlen,
      s_axi_arsize  => rom_axi_arsize,
      s_axi_arburst => rom_axi_arburst,
      s_axi_araddr  => rom_axi_araddr(31 downto 0),
      s_axi_arready => rom_axi_arready,

      s_axi_rready => rom_axi_rready,
      s_axi_rvalid => rom_axi_rvalid,
      s_axi_rid    => rom_axi_rid,
      s_axi_rlast  => rom_axi_rlast,
      s_axi_rresp  => rom_axi_rresp,
      s_axi_rdata  => rom_axi_rdata

    );

end architecture top_a;
