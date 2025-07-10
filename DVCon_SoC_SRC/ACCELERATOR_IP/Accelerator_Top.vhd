-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%                      Centre for Development of Advanced Computing                            %%
-- %%                          Vellayambalam, Thiruvananthapuram.                                  %%
-- %%==============================================================================================%%
-- %% This confidential and proprietary software may be used only as authorised by a licensing     %%
-- %% agreement from Centre for Development of Advanced Computing, India (C-DAC).In the event of   %%
-- %% publication, the following notice is applicable:                                             %%
-- %% Copyright (c) 2024 C-DAC                                                                     %%
-- %% ALL RIGHTS RESERVED                                                                          %%
-- %% The entire notice above must be reproduced on all authorised copies.                         %%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %% File Name        : Accelerator_Top.vhd                                                       %%
-- %% Title            : Accelerator Top File                                                      %%
-- %% Author           : HDG, CDAC Thiruvananthapuram                                              %%
-- %% Description      : Accelerator Top for DVCon System vivado Implementation                    %%
-- %% Version          : 00                                                                        %%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%% Modification / Updation  History %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%    Date                By              Version          Change Description                   %%
-- %%                                                                                              %%
-- %%                                                                                              %%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

library ieee;
  use ieee.std_logic_1164.all;

entity accelerator_top is
  port (
    s_axi_aclk    : in    std_logic;
    s_axi_aresetn : in    std_logic;

    ----- Master Write Address Channel ------
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

    ----- Master Write Data Channel ------
    m_axi_wvalid : out   std_logic;
    m_axi_wlast  : out   std_logic;
    m_axi_wdata  : out   std_logic_vector(127 downto 0);
    m_axi_wstrb  : out   std_logic_vector(15 downto 0);
    m_axi_wready : in    std_logic;

    ----- Master Write Response Channel ------
    m_axi_bready : out   std_logic;
    m_axi_bvalid : in    std_logic;
    m_axi_bid    : in    std_logic_vector(11 downto 0);
    m_axi_bresp  : in    std_logic_vector(1 downto 0);

    ----- Master Read Address Channel ------
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

    ----- Master Read Response Channel ------
    m_axi_rready : out   std_logic;
    m_axi_rvalid : in    std_logic;
    m_axi_rid    : in    std_logic_vector(11 downto 0);
    m_axi_rlast  : in    std_logic;
    m_axi_rresp  : in    std_logic_vector(1 downto 0);
    m_axi_rdata  : in    std_logic_vector(127 downto 0);

    ----- Slave Write Address Channel ------
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
    ----- Slave Write Data Channel ------
    s_axi_wdata  : in    std_logic_vector(127 downto 0);
    s_axi_wstrb  : in    std_logic_vector(15  downto 0);
    s_axi_wlast  : in    std_logic;
    s_axi_wvalid : in    std_logic;
    s_axi_wready : out   std_logic;
    ----- Slave Write Response Channel ------
    s_axi_bready : in    std_logic;
    s_axi_bid    : out   std_logic_vector(11  downto 0);
    s_axi_bresp  : out   std_logic_vector(1   downto 0);
    s_axi_bvalid : out   std_logic;
    ----- Slave Read Address Channel ------
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
    ----- Slave Read Data Channel ------
    s_axi_rready : in    std_logic;
    s_axi_rid    : out   std_logic_vector(11  downto 0);
    s_axi_rdata  : out   std_logic_vector(127 downto 0);
    s_axi_rresp  : out   std_logic_vector(1   downto 0);
    s_axi_rlast  : out   std_logic;
    s_axi_rvalid : out   std_logic
  );
end entity accelerator_top;

architecture accelerator_top_a of accelerator_top is

  component axi_acc_dwidth_converter_0 is
    port (
      s_axi_aclk    : in    std_logic;
      s_axi_aresetn : in    std_logic;

      s_axi_awregion : in    std_logic_vector( 3 downto 0);
      s_axi_arregion : in    std_logic_vector( 3 downto 0);
      s_axi_awvalid  : in    std_logic;
      s_axi_awid     : in    std_logic_vector( 0 downto 0);
      s_axi_awlen    : in    std_logic_vector( 7 downto 0);
      s_axi_awsize   : in    std_logic_vector( 2 downto 0);
      s_axi_awburst  : in    std_logic_vector( 1 downto 0);
      s_axi_awlock   : in    std_logic_vector( 0 downto 0);
      s_axi_awcache  : in    std_logic_vector( 3 downto 0);
      s_axi_awqos    : in    std_logic_vector( 3 downto 0);
      s_axi_awaddr   : in    std_logic_vector( 63 downto 0);
      s_axi_awprot   : in    std_logic_vector( 2 downto 0);
      s_axi_wvalid   : in    std_logic;
      s_axi_wlast    : in    std_logic;
      s_axi_wdata    : in    std_logic_vector( 31 downto 0);
      s_axi_wstrb    : in    std_logic_vector( 3 downto 0);
      s_axi_bready   : in    std_logic;
      s_axi_arvalid  : in    std_logic;
      s_axi_arid     : in    std_logic_vector( 0 downto 0);
      s_axi_arlen    : in    std_logic_vector( 7 downto 0);
      s_axi_arsize   : in    std_logic_vector( 2 downto 0);
      s_axi_arburst  : in    std_logic_vector( 1 downto 0);
      s_axi_arlock   : in    std_logic_vector( 0 downto 0);
      s_axi_arcache  : in    std_logic_vector( 3 downto 0);
      s_axi_arqos    : in    std_logic_vector( 3 downto 0);
      s_axi_araddr   : in    std_logic_vector( 63 downto 0);
      s_axi_arprot   : in    std_logic_vector( 2 downto 0);
      s_axi_rready   : in    std_logic;

      s_axi_awready : out   std_logic;
      s_axi_wready  : out   std_logic;
      s_axi_bvalid  : out   std_logic;
      s_axi_bid     : out   std_logic_vector( 0 downto 0);
      s_axi_bresp   : out   std_logic_vector( 1 downto 0);
      s_axi_arready : out   std_logic;
      s_axi_rvalid  : out   std_logic;
      s_axi_rid     : out   std_logic_vector( 0 downto 0);
      s_axi_rlast   : out   std_logic;
      s_axi_rresp   : out   std_logic_vector( 1 downto 0);
      s_axi_rdata   : out   std_logic_vector( 31 downto 0);

      m_axi_awregion : out   std_logic_vector( 3 downto 0);
      m_axi_arregion : out   std_logic_vector( 3 downto 0);
      m_axi_awvalid  : out   std_logic;
      m_axi_awlen    : out   std_logic_vector( 7 downto 0);
      m_axi_awsize   : out   std_logic_vector( 2 downto 0);
      m_axi_awburst  : out   std_logic_vector( 1 downto 0);
      m_axi_awlock   : out   std_logic_vector( 0 downto 0);
      m_axi_awcache  : out   std_logic_vector( 3 downto 0);
      m_axi_awqos    : out   std_logic_vector( 3 downto 0);
      m_axi_awaddr   : out   std_logic_vector( 63 downto 0);
      m_axi_awprot   : out   std_logic_vector( 2 downto 0);
      m_axi_wvalid   : out   std_logic;
      m_axi_wlast    : out   std_logic;
      m_axi_wdata    : out   std_logic_vector( 127 downto 0);
      m_axi_wstrb    : out   std_logic_vector( 15 downto 0);
      m_axi_bready   : out   std_logic;
      m_axi_arvalid  : out   std_logic;
      m_axi_arlen    : out   std_logic_vector( 7 downto 0);
      m_axi_arsize   : out   std_logic_vector( 2 downto 0);
      m_axi_arburst  : out   std_logic_vector( 1 downto 0);
      m_axi_arlock   : out   std_logic_vector( 0 downto 0);
      m_axi_arcache  : out   std_logic_vector( 3 downto 0);
      m_axi_arqos    : out   std_logic_vector( 3 downto 0);
      m_axi_araddr   : out   std_logic_vector( 63 downto 0);
      m_axi_arprot   : out   std_logic_vector( 2 downto 0);
      m_axi_rready   : out   std_logic;

      m_axi_awready : in    std_logic;
      m_axi_wready  : in    std_logic;
      m_axi_bvalid  : in    std_logic;
      m_axi_bresp   : in    std_logic_vector( 1 downto 0);
      m_axi_arready : in    std_logic;
      m_axi_rvalid  : in    std_logic;
      m_axi_rlast   : in    std_logic;
      m_axi_rresp   : in    std_logic_vector( 1 downto 0);
      m_axi_rdata   : in    std_logic_vector( 127 downto 0)
    );
  end component axi_acc_dwidth_converter_0;

  component matrix_multiply is
    port (
      ap_local_block        : out   std_logic;
      ap_clk                : in    std_logic;
      ap_rst_n              : in    std_logic;
      m_axi_gmem_awvalid    : out   std_logic;
      m_axi_gmem_awready    : in    std_logic;
      m_axi_gmem_awaddr     : out   std_logic_vector(63 downto 0);
      m_axi_gmem_awid       : out   std_logic_vector(0 downto 0);
      m_axi_gmem_awlen      : out   std_logic_vector(7 downto 0);
      m_axi_gmem_awsize     : out   std_logic_vector(2 downto 0);
      m_axi_gmem_awburst    : out   std_logic_vector(1 downto 0);
      m_axi_gmem_awlock     : out   std_logic_vector(1 downto 0);
      m_axi_gmem_awcache    : out   std_logic_vector(3 downto 0);
      m_axi_gmem_awprot     : out   std_logic_vector(2 downto 0);
      m_axi_gmem_awqos      : out   std_logic_vector(3 downto 0);
      m_axi_gmem_awregion   : out   std_logic_vector(3 downto 0);
      m_axi_gmem_awuser     : out   std_logic_vector(0 downto 0);
      m_axi_gmem_wvalid     : out   std_logic;
      m_axi_gmem_wready     : in    std_logic;
      m_axi_gmem_wdata      : out   std_logic_vector(31 downto 0);
      m_axi_gmem_wstrb      : out   std_logic_vector(3 downto 0);
      m_axi_gmem_wlast      : out   std_logic;
      m_axi_gmem_wid        : out   std_logic_vector(0 downto 0);
      m_axi_gmem_wuser      : out   std_logic_vector(0 downto 0);
      m_axi_gmem_arvalid    : out   std_logic;
      m_axi_gmem_arready    : in    std_logic;
      m_axi_gmem_araddr     : out   std_logic_vector(63 downto 0);
      m_axi_gmem_arid       : out   std_logic_vector(0 downto 0);
      m_axi_gmem_arlen      : out   std_logic_vector(7 downto 0);
      m_axi_gmem_arsize     : out   std_logic_vector(2 downto 0);
      m_axi_gmem_arburst    : out   std_logic_vector(1 downto 0);
      m_axi_gmem_arlock     : out   std_logic_vector(1 downto 0);
      m_axi_gmem_arcache    : out   std_logic_vector(3 downto 0);
      m_axi_gmem_arprot     : out   std_logic_vector(2 downto 0);
      m_axi_gmem_arqos      : out   std_logic_vector(3 downto 0);
      m_axi_gmem_arregion   : out   std_logic_vector(3 downto 0);
      m_axi_gmem_aruser     : out   std_logic_vector(0 downto 0);
      m_axi_gmem_rvalid     : in    std_logic;
      m_axi_gmem_rready     : out   std_logic;
      m_axi_gmem_rdata      : in    std_logic_vector(31 downto 0);
      m_axi_gmem_rlast      : in    std_logic;
      m_axi_gmem_rid        : in    std_logic_vector(0 downto 0);
      m_axi_gmem_ruser      : in    std_logic_vector(0 downto 0);
      m_axi_gmem_rresp      : in    std_logic_vector(1 downto 0);
      m_axi_gmem_bvalid     : in    std_logic;
      m_axi_gmem_bready     : out   std_logic;
      m_axi_gmem_bresp      : in    std_logic_vector(1 downto 0);
      m_axi_gmem_bid        : in    std_logic_vector(0 downto 0);
      m_axi_gmem_buser      : in    std_logic_vector(0 downto 0);
      s_axi_control_awvalid : in    std_logic;
      s_axi_control_awready : out   std_logic;
      s_axi_control_awaddr  : in    std_logic_vector(5 downto 0);
      s_axi_control_wvalid  : in    std_logic;
      s_axi_control_wready  : out   std_logic;
      s_axi_control_wdata   : in    std_logic_vector(31 downto 0);
      s_axi_control_wstrb   : in    std_logic_vector(3 downto 0);
      s_axi_control_arvalid : in    std_logic;
      s_axi_control_arready : out   std_logic;
      s_axi_control_araddr  : in    std_logic_vector(5 downto 0);
      s_axi_control_rvalid  : out   std_logic;
      s_axi_control_rready  : in    std_logic;
      s_axi_control_rdata   : out   std_logic_vector(31 downto 0);
      s_axi_control_rresp   : out   std_logic_vector(1 downto 0);
      s_axi_control_bvalid  : out   std_logic;
      s_axi_control_bready  : in    std_logic;
      s_axi_control_bresp   : out   std_logic_vector(1 downto 0);
      interrupt             : out   std_logic
    );
  end component matrix_multiply;

  signal s_acc_axi_awvalid  : std_logic;
  signal s_acc_axi_awlen    : std_logic_vector( 7 downto 0);
  signal s_acc_axi_awsize   : std_logic_vector( 2 downto 0);
  signal s_acc_axi_awburst  : std_logic_vector( 1 downto 0);
  signal s_acc_axi_awlock   : std_logic_vector( 1 downto 0);
  signal s_acc_axi_awcache  : std_logic_vector( 3 downto 0);
  signal s_acc_axi_awqos    : std_logic_vector( 3 downto 0);
  signal s_acc_axi_awaddr   : std_logic_vector( 63 downto 0);
  signal s_acc_axi_awprot   : std_logic_vector( 2 downto 0);
  signal s_acc_axi_wvalid   : std_logic;
  signal s_acc_axi_wid      : std_logic_vector( 7 downto 0);
  signal s_acc_axi_wlast    : std_logic;
  signal s_acc_axi_wdata    : std_logic_vector( 31 downto 0);
  signal s_acc_axi_wstrb    : std_logic_vector( 3 downto 0);
  signal s_acc_axi_bready   : std_logic;
  signal s_acc_axi_arvalid  : std_logic;
  signal s_acc_axi_arlen    : std_logic_vector( 7 downto 0);
  signal s_acc_axi_arsize   : std_logic_vector( 2 downto 0);
  signal s_acc_axi_arburst  : std_logic_vector( 1 downto 0);
  signal s_acc_axi_arlock   : std_logic_vector( 1 downto 0);
  signal s_acc_axi_arcache  : std_logic_vector( 3 downto 0);
  signal s_acc_axi_arqos    : std_logic_vector( 3 downto 0);
  signal s_acc_axi_araddr   : std_logic_vector( 63 downto 0);
  signal s_acc_axi_arprot   : std_logic_vector( 2 downto 0);
  signal s_acc_axi_rready   : std_logic;
  signal s_acc_axi_awready  : std_logic;
  signal s_acc_axi_wready   : std_logic;
  signal s_acc_axi_bvalid   : std_logic;
  signal s_acc_axi_bresp    : std_logic_vector( 1 downto 0);
  signal s_acc_axi_arready  : std_logic;
  signal s_acc_axi_rvalid   : std_logic;
  signal s_acc_axi_rlast    : std_logic;
  signal s_acc_axi_rresp    : std_logic_vector( 1 downto 0);
  signal s_acc_axi_rdata    : std_logic_vector( 31 downto 0);
  signal s_acc_axi_awid     : std_logic_vector( 0 downto 0);
  signal s_acc_axi_arid     : std_logic_vector( 0 downto 0);
  signal s_acc_axi_rid      : std_logic_vector( 0 downto 0);
  signal s_acc_axi_bid      : std_logic_vector( 0 downto 0);
  signal s_acc_axi_awregion : std_logic_vector( 3 downto 0);
  signal s_acc_axi_arregion : std_logic_vector( 3 downto 0);
  signal s_s_axi_rdata      : std_logic_vector(31 downto 0);
  signal s_s_axi_wdata      : std_logic_vector(31 downto 0);
  signal s_s_axi_wstrb      : std_logic_vector(3 downto 0);

begin

  s_axi_rid   <= s_axi_arid;
  s_axi_rlast <= '1';
  s_axi_rdata <= s_s_axi_rdata & s_s_axi_rdata & s_s_axi_rdata & s_s_axi_rdata;
  s_axi_bid   <= s_axi_awid;

  m_axi_arid <= "00100000000" & s_acc_axi_arid;
  m_axi_awid <= "00100000000" & s_acc_axi_awid;

  s_s_axi_wstrb <= s_axi_wstrb(3 downto 0) when s_axi_awaddr(3 downto 2) = "00" else
                   s_axi_wstrb(7 downto 4) when s_axi_awaddr(3 downto 2) = "01" else
                   s_axi_wstrb(11 downto 8) when s_axi_awaddr(3 downto 2) = "10" else
                   s_axi_wstrb(15 downto 12) when s_axi_awaddr(3 downto 2) = "11" else
                   x"0";
  s_s_axi_wdata <= s_axi_wdata(31 downto 0) when s_axi_awaddr(3 downto 2) = "00" else
                   s_axi_wdata(63 downto 32) when s_axi_awaddr(3 downto 2) = "01" else
                   s_axi_wdata(95 downto 64) when s_axi_awaddr(3 downto 2) = "10" else
                   s_axi_wdata(127 downto 96) when s_axi_awaddr(3 downto 2) = "11" else
                   x"00000000";

  u_example : component matrix_multiply
    port map (
      ap_local_block => open,
      ap_clk         => s_axi_aclk,
      ap_rst_n       => s_axi_aresetn,

      m_axi_gmem_awvalid  => s_acc_axi_awvalid,
      m_axi_gmem_awready  => s_acc_axi_awready,
      m_axi_gmem_awaddr   => s_acc_axi_awaddr,
      m_axi_gmem_awid     => s_acc_axi_awid,
      m_axi_gmem_awlen    => s_acc_axi_awlen,
      m_axi_gmem_awsize   => s_acc_axi_awsize,
      m_axi_gmem_awburst  => s_acc_axi_awburst,
      m_axi_gmem_awlock   => s_acc_axi_awlock,
      m_axi_gmem_awcache  => s_acc_axi_awcache,
      m_axi_gmem_awprot   => s_acc_axi_awprot,
      m_axi_gmem_awqos    => s_acc_axi_awqos,
      m_axi_gmem_awregion => s_acc_axi_awregion,
      m_axi_gmem_awuser   => open,

      m_axi_gmem_wvalid => s_acc_axi_wvalid,
      m_axi_gmem_wready => s_acc_axi_wready,
      m_axi_gmem_wdata  => s_acc_axi_wdata,
      m_axi_gmem_wstrb  => s_acc_axi_wstrb,
      m_axi_gmem_wlast  => s_acc_axi_wlast,
      m_axi_gmem_wid    => open,
      m_axi_gmem_wuser  => open,

      m_axi_gmem_arvalid  => s_acc_axi_arvalid,
      m_axi_gmem_arready  => s_acc_axi_arready,
      m_axi_gmem_araddr   => s_acc_axi_araddr,
      m_axi_gmem_arid     => s_acc_axi_arid,
      m_axi_gmem_arlen    => s_acc_axi_arlen,
      m_axi_gmem_arsize   => s_acc_axi_arsize,
      m_axi_gmem_arburst  => s_acc_axi_arburst,
      m_axi_gmem_arlock   => s_acc_axi_arlock,
      m_axi_gmem_arcache  => s_acc_axi_arcache,
      m_axi_gmem_arprot   => s_acc_axi_arprot,
      m_axi_gmem_arqos    => s_acc_axi_arqos,
      m_axi_gmem_arregion => s_acc_axi_arregion,
      m_axi_gmem_aruser   => open,

      m_axi_gmem_rvalid => s_acc_axi_rvalid,
      m_axi_gmem_rready => s_acc_axi_rready,
      m_axi_gmem_rdata  => s_acc_axi_rdata,
      m_axi_gmem_rlast  => s_acc_axi_rlast,
      m_axi_gmem_rid    => s_acc_axi_rid,
      m_axi_gmem_ruser  => "0",
      m_axi_gmem_rresp  => s_acc_axi_rresp,

      m_axi_gmem_bvalid => s_acc_axi_bvalid,
      m_axi_gmem_bready => s_acc_axi_bready,
      m_axi_gmem_bresp  => s_acc_axi_bresp,
      m_axi_gmem_bid    => s_acc_axi_bid,
      m_axi_gmem_buser  => "0",

      s_axi_control_awvalid => s_axi_awvalid,
      s_axi_control_awready => s_axi_awready,
      s_axi_control_awaddr  => s_axi_awaddr(5 downto 0),

      s_axi_control_wvalid => s_axi_wvalid,
      s_axi_control_wready => s_axi_wready,
      s_axi_control_wdata  => s_s_axi_wdata,
      s_axi_control_wstrb  => s_s_axi_wstrb,

      s_axi_control_arvalid => s_axi_arvalid,
      s_axi_control_arready => s_axi_arready,
      s_axi_control_araddr  => s_axi_araddr(5 downto 0),

      s_axi_control_rvalid => s_axi_rvalid,
      s_axi_control_rready => s_axi_rready,
      s_axi_control_rdata  => s_s_axi_rdata,
      s_axi_control_rresp  => s_axi_rresp,

      s_axi_control_bvalid => s_axi_bvalid,
      s_axi_control_bready => s_axi_bready,
      s_axi_control_bresp  => s_axi_bresp,

      interrupt => open
    );

  u_axi_acc_dwidth_converter_0 : component axi_acc_dwidth_converter_0
    port map (
      s_axi_aclk    => s_axi_aclk,
      s_axi_aresetn => s_axi_aresetn,

      s_axi_awregion => s_acc_axi_awregion,
      s_axi_arregion => s_acc_axi_arregion,
      s_axi_awvalid  => s_acc_axi_awvalid,
      s_axi_awid     => s_acc_axi_awid,
      s_axi_awlen    => s_acc_axi_awlen,
      s_axi_awsize   => s_acc_axi_awsize,
      s_axi_awburst  => s_acc_axi_awburst,
      s_axi_awlock   => s_acc_axi_awlock(0 downto 0),
      s_axi_awcache  => s_acc_axi_awcache,
      s_axi_awqos    => s_acc_axi_awqos,
      s_axi_awaddr   => s_acc_axi_awaddr,
      s_axi_awprot   => s_acc_axi_awprot,

      s_axi_wvalid  => s_acc_axi_wvalid,
      s_axi_wlast   => s_acc_axi_wlast,
      s_axi_wdata   => s_acc_axi_wdata,
      s_axi_wstrb   => s_acc_axi_wstrb,
      s_axi_bready  => s_acc_axi_bready,
      s_axi_arvalid => s_acc_axi_arvalid,
      s_axi_arid    => s_acc_axi_arid,
      s_axi_arlen   => s_acc_axi_arlen,
      s_axi_arsize  => s_acc_axi_arsize,
      s_axi_arburst => s_acc_axi_arburst,
      s_axi_arlock  => s_acc_axi_arlock(0 downto 0),
      s_axi_arcache => s_acc_axi_arcache,
      s_axi_arqos   => s_acc_axi_arqos,
      s_axi_araddr  => s_acc_axi_araddr,
      s_axi_arprot  => s_acc_axi_arprot,
      s_axi_rready  => s_acc_axi_rready,
      s_axi_awready => s_acc_axi_awready,
      s_axi_wready  => s_acc_axi_wready,
      s_axi_bvalid  => s_acc_axi_bvalid,
      s_axi_bid     => s_acc_axi_bid,
      s_axi_bresp   => s_acc_axi_bresp,
      s_axi_arready => s_acc_axi_arready,
      s_axi_rvalid  => s_acc_axi_rvalid,
      s_axi_rid     => s_acc_axi_rid,
      s_axi_rlast   => s_acc_axi_rlast,
      s_axi_rresp   => s_acc_axi_rresp,
      s_axi_rdata   => s_acc_axi_rdata,

      m_axi_awregion => open,
      m_axi_arregion => open,
      m_axi_awvalid  => m_axi_awvalid,
      m_axi_awlen    => m_axi_awlen,
      m_axi_awsize   => m_axi_awsize,
      m_axi_awburst  => m_axi_awburst,
      m_axi_awlock   => m_axi_awlock,
      m_axi_awcache  => m_axi_awcache,
      m_axi_awqos    => m_axi_awqos,
      m_axi_awaddr   => m_axi_awaddr,
      m_axi_awprot   => m_axi_awprot,
      m_axi_wvalid   => m_axi_wvalid,
      m_axi_wlast    => m_axi_wlast,
      m_axi_wdata    => m_axi_wdata,
      m_axi_wstrb    => m_axi_wstrb,
      m_axi_bready   => m_axi_bready,
      m_axi_arvalid  => m_axi_arvalid,
      m_axi_arlen    => m_axi_arlen,
      m_axi_arsize   => m_axi_arsize,
      m_axi_arburst  => m_axi_arburst,
      m_axi_arlock   => m_axi_arlock,
      m_axi_arcache  => m_axi_arcache,
      m_axi_arqos    => m_axi_arqos,
      m_axi_araddr   => m_axi_araddr,
      m_axi_arprot   => m_axi_arprot,
      m_axi_rready   => m_axi_rready,

      m_axi_awready => m_axi_awready,
      m_axi_wready  => m_axi_wready,
      m_axi_bvalid  => m_axi_bvalid,
      m_axi_bresp   => m_axi_bresp,
      m_axi_arready => m_axi_arready,
      m_axi_rvalid  => m_axi_rvalid,
      m_axi_rlast   => m_axi_rlast,
      m_axi_rresp   => m_axi_rresp,
      m_axi_rdata   => m_axi_rdata

    );

end architecture accelerator_top_a;
