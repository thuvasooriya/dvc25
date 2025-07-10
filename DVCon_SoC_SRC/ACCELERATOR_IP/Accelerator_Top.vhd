--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
--%%                      Centre for Development of Advanced Computing                            %%
--%%                          Vellayambalam, Thiruvananthapuram.                                  %%
--%%==============================================================================================%%
--%% This confidential and proprietary software may be used only as authorised by a licensing     %%
--%% agreement from Centre for Development of Advanced Computing, India (C-DAC).In the event of   %%
--%% publication, the following notice is applicable:                                             %%
--%% Copyright (c) 2024 C-DAC                                                                     %%
--%% ALL RIGHTS RESERVED                                                                          %%
--%% The entire notice above must be reproduced on all authorised copies.                         %%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%% File Name        : Accelerator_Top.vhd                                                       %%
--%% Title            : Accelerator Top File  						                              %%
--%% Author           : HDG, CDAC Thiruvananthapuram						                      %%
--%% Description      : Accelerator Top for DVCon System vivado Implementation  		          %%
--%% Version          : 00                                                                        %%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%% Modification / Updation  History %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%    Date                By              Version          Change Description                   %%
--%%                                                                                              %%
--%%                                                                                              %%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Accelerator_Top is
    Port (  s_axi_aclk 			: 	in 	  STD_LOGIC;                                    
			s_axi_aresetn 		: 	in 	  STD_LOGIC;                                                      
		      
			----- Master Write Address Channel ------  	                
    		m_axi_awvalid		: out std_logic;
    		m_axi_awid		    : out std_logic_vector(11 downto 0);
    		m_axi_awlen		    : out std_logic_vector(7 downto 0);
    		m_axi_awsize		: out std_logic_vector(2 downto 0);
    		m_axi_awburst		: out std_logic_vector(1 downto 0);
    		m_axi_awlock		: out std_logic_vector(0 downto 0);
    		m_axi_awcache		: out std_logic_vector(3 downto 0);
    		m_axi_awqos		    : out std_logic_vector(3 downto 0);
    		m_axi_awaddr		: out std_logic_vector(63 downto 0);
    		m_axi_awprot		: out std_logic_vector(2 downto 0);    		
    		m_axi_awready		: in  std_logic;
    		
			----- Master Write Data Channel ------  	
    		m_axi_wvalid		: out std_logic;
    		m_axi_wlast		    : out std_logic;
    		m_axi_wdata		    : out std_logic_vector(127 downto 0);
    		m_axi_wstrb		    : out std_logic_vector(15 downto 0);
    		m_axi_wready		: in  std_logic;
    	
			----- Master Write Response Channel ------  	
    		m_axi_bready		: out std_logic;
    		m_axi_bvalid		: in  std_logic;
    		m_axi_bid			: in  std_logic_vector(11 downto 0);
    		m_axi_bresp		    : in  std_logic_vector(1 downto 0);
    	
			----- Master Read Address Channel ------  	
    		m_axi_arvalid		: out std_logic;
    		m_axi_arid		    : out std_logic_vector(11 downto 0);
    		m_axi_arlen		    : out std_logic_vector(7 downto 0);
    		m_axi_arsize		: out std_logic_vector(2 downto 0);
    		m_axi_arburst		: out std_logic_vector(1 downto 0);
    		m_axi_arlock		: out std_logic_vector(0 downto 0);
    		m_axi_arcache		: out std_logic_vector(3 downto 0);
    		m_axi_arqos		    : out std_logic_vector(3 downto 0);
    		m_axi_araddr		: out std_logic_vector(63 downto 0);
    		m_axi_arprot		: out std_logic_vector(2 downto 0);
    		m_axi_arready		: in  std_logic;
    
			----- Master Read Response Channel ------  	
    		m_axi_rready		: out std_logic;
    		m_axi_rvalid		: in  std_logic;
    		m_axi_rid			: in  std_logic_vector(11 downto 0);
    		m_axi_rlast		    : in  std_logic;
    		m_axi_rresp		    : in  std_logic_vector(1 downto 0);
    		m_axi_rdata		    : in  std_logic_vector(127 downto 0);
    		                                                
			----- Slave Write Address Channel ------                        
			s_axi_awid  		:  	in    std_logic_vector	(11  downto 0); 
			s_axi_awaddr		:  	in    std_logic_vector	(63  downto 0); 
			s_axi_awlen 		:  	in    std_logic_vector	(7   downto 0); 
			s_axi_awsize		:  	in    std_logic_vector	(2   downto 0); 
			s_axi_awburst  		:  	in    std_logic_vector	(1   downto 0); 
			s_axi_awlock		:  	in    std_logic; 
			s_axi_awcache		:  	in    std_logic_vector	(3   downto 0); 
			s_axi_awprot		:  	in    std_logic_vector	(2   downto 0); 
			s_axi_awqos 		:  	in    std_logic_vector	(3   downto 0); 
			s_axi_awvalid  		:  	in    std_logic;                        
			s_axi_awready 		:  	out   std_logic;                        
			----- Slave Write Data Channel ------                          
			s_axi_wdata  		:  	in 	  std_logic_vector	(127 downto 0); 
			s_axi_wstrb  		:  	in 	  std_logic_vector	(15  downto 0); 
			s_axi_wlast  		:  	in 	  std_logic;                        
			s_axi_wvalid 		:  	in 	  std_logic;                        
			s_axi_wready 		:  	out	  std_logic;                        
			----- Slave Write Response Channel ------                       
			s_axi_bready 		: 	in    std_logic;                        
			s_axi_bid	 		: 	out   std_logic_vector	(11  downto 0); 
			s_axi_bresp  		: 	out   std_logic_vector	(1   downto 0); 
			s_axi_bvalid 		: 	out   std_logic;                        
			----- Slave Read Address Channel ------                         
			s_axi_arid   		:   in    std_logic_vector	(11  downto 0); 
			s_axi_araddr 		:	in    std_logic_vector	(63  downto 0); 
			s_axi_arlen  		:	in    std_logic_vector	(7 	 downto 0); 
			s_axi_arsize 		:	in    std_logic_vector	(2 	 downto 0); 
			s_axi_arburst		:	in    std_logic_vector	(1 	 downto 0); 
			s_axi_arlock 		:	in    std_logic; 
			s_axi_arcache		:	in    std_logic_vector	(3 	 downto 0); 
			s_axi_arprot 		:	in    std_logic_vector	(2 	 downto 0); 
			s_axi_arqos  		:	in    std_logic_vector	(3 	 downto 0); 
			s_axi_arvalid		:	in    std_logic;                        
			s_axi_arready		:	out   std_logic;                          
			----- Slave Read Data Channel ------                            
			s_axi_rready 		: 	in    std_logic;                        
			s_axi_rid    		: 	out   std_logic_vector	(11  downto 0); 
			s_axi_rdata  		: 	out   std_logic_vector	(127 downto 0); 
			s_axi_rresp  		: 	out   std_logic_vector	(1   downto 0); 
			s_axi_rlast  		: 	out   std_logic;                        
			s_axi_rvalid 		: 	out   std_logic 
           );
end Accelerator_Top;

architecture Accelerator_Top_a of Accelerator_Top is  	
   
	COMPONENT axi_acc_dwidth_converter_0
		port (
		
			s_axi_aclk             : in  std_logic; 
			s_axi_aresetn          : in  std_logic; 
			
			s_axi_awregion         : in std_logic_vector( 3 downto 0 );
			s_axi_arregion         : in std_logic_vector( 3 downto 0 );			
			s_axi_awvalid          : in std_logic; 
			s_axi_awid             : in std_logic_vector( 0 downto 0 );
			s_axi_awlen            : in std_logic_vector( 7 downto 0 );
			s_axi_awsize           : in std_logic_vector( 2 downto 0 );
			s_axi_awburst          : in std_logic_vector( 1 downto 0 );
			s_axi_awlock           : in std_logic_vector( 0 downto 0 );
			s_axi_awcache          : in std_logic_vector( 3 downto 0 );
			s_axi_awqos            : in std_logic_vector( 3 downto 0 );
			s_axi_awaddr           : in std_logic_vector( 63 downto 0 );
			s_axi_awprot           : in std_logic_vector( 2 downto 0 );			
			s_axi_wvalid           : in std_logic; 
			s_axi_wlast            : in std_logic; 
			s_axi_wdata            : in std_logic_vector( 31 downto 0 );
			s_axi_wstrb            : in std_logic_vector( 3 downto 0 );			
			s_axi_bready           : in std_logic; 
			s_axi_arvalid          : in std_logic; 			
			s_axi_arid             : in std_logic_vector( 0 downto 0 );
			s_axi_arlen            : in std_logic_vector( 7 downto 0 );
			s_axi_arsize           : in std_logic_vector( 2 downto 0 );
			s_axi_arburst          : in std_logic_vector( 1 downto 0 );
			s_axi_arlock           : in std_logic_vector( 0 downto 0 ); 
			s_axi_arcache          : in std_logic_vector( 3 downto 0 );
			s_axi_arqos            : in std_logic_vector( 3 downto 0 );
			s_axi_araddr           : in std_logic_vector( 63 downto 0 );
			s_axi_arprot           : in std_logic_vector( 2 downto 0 );			
			s_axi_rready           : in std_logic;  
			
			s_axi_awready          : out  std_logic; 			
			s_axi_wready           : out  std_logic; 			
			s_axi_bvalid           : out  std_logic; 
			s_axi_bid              : out  std_logic_vector( 0 downto 0 );
			s_axi_bresp            : out  std_logic_vector( 1 downto 0 );			
			s_axi_arready          : out  std_logic; 			
			s_axi_rvalid           : out  std_logic; 
			s_axi_rid              : out  std_logic_vector( 0 downto 0 );
			s_axi_rlast            : out  std_logic; 
			s_axi_rresp            : out  std_logic_vector( 1 downto 0 );
			s_axi_rdata            : out  std_logic_vector( 31 downto 0 );
			
			m_axi_awregion         : out std_logic_vector( 3 downto 0 );
			m_axi_arregion         : out std_logic_vector( 3 downto 0 );
			m_axi_awvalid          : out std_logic; 
			m_axi_awlen            : out std_logic_vector( 7 downto 0 );
			m_axi_awsize           : out std_logic_vector( 2 downto 0 );
			m_axi_awburst          : out std_logic_vector( 1 downto 0 );
			m_axi_awlock           : out std_logic_vector( 0 downto 0 );
			m_axi_awcache          : out std_logic_vector( 3 downto 0 );
			m_axi_awqos            : out std_logic_vector( 3 downto 0 );
			m_axi_awaddr           : out std_logic_vector( 63 downto 0 );
			m_axi_awprot           : out std_logic_vector( 2 downto 0 );
			m_axi_wvalid           : out std_logic; 
			m_axi_wlast            : out std_logic; 
			m_axi_wdata            : out std_logic_vector( 127 downto 0 );
			m_axi_wstrb            : out std_logic_vector( 15 downto 0 );
			m_axi_bready           : out std_logic; 
			m_axi_arvalid          : out std_logic; 
			m_axi_arlen            : out std_logic_vector( 7 downto 0 );
			m_axi_arsize           : out std_logic_vector( 2 downto 0 );
			m_axi_arburst          : out std_logic_vector( 1 downto 0 );
			m_axi_arlock           : out std_logic_vector( 0 downto 0 );
			m_axi_arcache          : out std_logic_vector( 3 downto 0 );
			m_axi_arqos            : out std_logic_vector( 3 downto 0 );
			m_axi_araddr           : out std_logic_vector( 63 downto 0 );
			m_axi_arprot           : out std_logic_vector( 2 downto 0 );
			m_axi_rready           : out std_logic;  
			
			m_axi_awready          : in  std_logic; 
			m_axi_wready           : in  std_logic; 
			m_axi_bvalid           : in  std_logic; 
			m_axi_bresp            : in  std_logic_vector( 1 downto 0 );
			m_axi_arready          : in  std_logic; 
			m_axi_rvalid           : in  std_logic; 
			m_axi_rlast            : in  std_logic; 
			m_axi_rresp            : in  std_logic_vector( 1 downto 0 );
			m_axi_rdata            : in  std_logic_vector( 127 downto 0 )		

		);
	end component;
	
component matrix_multiply 
port (
    ap_local_block : OUT STD_LOGIC;
    ap_clk : IN STD_LOGIC;
    ap_rst_n : IN STD_LOGIC;
    m_axi_gmem_AWVALID : OUT STD_LOGIC;
    m_axi_gmem_AWREADY : IN STD_LOGIC;
    m_axi_gmem_AWADDR : OUT STD_LOGIC_VECTOR (63 downto 0);
    m_axi_gmem_AWID : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_AWLEN : OUT STD_LOGIC_VECTOR (7 downto 0);
    m_axi_gmem_AWSIZE : OUT STD_LOGIC_VECTOR (2 downto 0);
    m_axi_gmem_AWBURST : OUT STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem_AWLOCK : OUT STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem_AWCACHE : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem_AWPROT : OUT STD_LOGIC_VECTOR (2 downto 0);
    m_axi_gmem_AWQOS : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem_AWREGION : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem_AWUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_WVALID : OUT STD_LOGIC;
    m_axi_gmem_WREADY : IN STD_LOGIC;
    m_axi_gmem_WDATA : OUT STD_LOGIC_VECTOR (31 downto 0);
    m_axi_gmem_WSTRB : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem_WLAST : OUT STD_LOGIC;
    m_axi_gmem_WID : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_WUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_ARVALID : OUT STD_LOGIC;
    m_axi_gmem_ARREADY : IN STD_LOGIC;
    m_axi_gmem_ARADDR : OUT STD_LOGIC_VECTOR (63 downto 0);
    m_axi_gmem_ARID : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_ARLEN : OUT STD_LOGIC_VECTOR (7 downto 0);
    m_axi_gmem_ARSIZE : OUT STD_LOGIC_VECTOR (2 downto 0);
    m_axi_gmem_ARBURST : OUT STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem_ARLOCK : OUT STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem_ARCACHE : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem_ARPROT : OUT STD_LOGIC_VECTOR (2 downto 0);
    m_axi_gmem_ARQOS : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem_ARREGION : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem_ARUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_RVALID : IN STD_LOGIC;
    m_axi_gmem_RREADY : OUT STD_LOGIC;
    m_axi_gmem_RDATA : IN STD_LOGIC_VECTOR (31 downto 0);
    m_axi_gmem_RLAST : IN STD_LOGIC;
    m_axi_gmem_RID : IN STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_RUSER : IN STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_RRESP : IN STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem_BVALID : IN STD_LOGIC;
    m_axi_gmem_BREADY : OUT STD_LOGIC;
    m_axi_gmem_BRESP : IN STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem_BID : IN STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_BUSER : IN STD_LOGIC_VECTOR (0 downto 0);
    s_axi_control_AWVALID : IN STD_LOGIC;
    s_axi_control_AWREADY : OUT STD_LOGIC;
    s_axi_control_AWADDR : IN STD_LOGIC_VECTOR (5 downto 0);
    s_axi_control_WVALID : IN STD_LOGIC;
    s_axi_control_WREADY : OUT STD_LOGIC;
    s_axi_control_WDATA : IN STD_LOGIC_VECTOR (31 downto 0);
    s_axi_control_WSTRB : IN STD_LOGIC_VECTOR (3 downto 0);
    s_axi_control_ARVALID : IN STD_LOGIC;
    s_axi_control_ARREADY : OUT STD_LOGIC;
    s_axi_control_ARADDR : IN STD_LOGIC_VECTOR (5 downto 0);
    s_axi_control_RVALID : OUT STD_LOGIC;
    s_axi_control_RREADY : IN STD_LOGIC;
    s_axi_control_RDATA : OUT STD_LOGIC_VECTOR (31 downto 0);
    s_axi_control_RRESP : OUT STD_LOGIC_VECTOR (1 downto 0);
    s_axi_control_BVALID : OUT STD_LOGIC;
    s_axi_control_BREADY : IN STD_LOGIC;
    s_axi_control_BRESP : OUT STD_LOGIC_VECTOR (1 downto 0);
    interrupt : OUT STD_LOGIC  );                
end component; 

	signal	s_acc_axi_awvalid          :  std_logic; 
	signal	s_acc_axi_awlen            :  std_logic_vector( 7 downto 0 );
	signal	s_acc_axi_awsize           :  std_logic_vector( 2 downto 0 );
	signal	s_acc_axi_awburst          :  std_logic_vector( 1 downto 0 );
	signal	s_acc_axi_awlock           :  std_logic_vector( 1 downto 0 );
	signal	s_acc_axi_awcache          :  std_logic_vector( 3 downto 0 );
	signal	s_acc_axi_awqos            :  std_logic_vector( 3 downto 0 );
	signal	s_acc_axi_awaddr           :  std_logic_vector( 63 downto 0 );
	signal	s_acc_axi_awprot           :  std_logic_vector( 2 downto 0 );
	signal	s_acc_axi_wvalid           :  std_logic; 
	signal	s_acc_axi_wid              :  std_logic_vector( 7 downto 0 );
	signal	s_acc_axi_wlast            :  std_logic; 
	signal	s_acc_axi_wdata            :  std_logic_vector( 31 downto 0 );
	signal	s_acc_axi_wstrb            :  std_logic_vector( 3 downto 0 );
	signal	s_acc_axi_bready           :  std_logic; 
	signal	s_acc_axi_arvalid          :  std_logic; 
	signal	s_acc_axi_arlen            :  std_logic_vector( 7 downto 0 );
	signal	s_acc_axi_arsize           :  std_logic_vector( 2 downto 0 );
	signal	s_acc_axi_arburst          :  std_logic_vector( 1 downto 0 );
	signal	s_acc_axi_arlock           :  std_logic_vector( 1 downto 0 ); 
	signal	s_acc_axi_arcache          :  std_logic_vector( 3 downto 0 );
	signal	s_acc_axi_arqos            :  std_logic_vector( 3 downto 0 );
	signal	s_acc_axi_araddr           :  std_logic_vector( 63 downto 0 );
	signal	s_acc_axi_arprot           :  std_logic_vector( 2 downto 0 );
	signal	s_acc_axi_rready           :  std_logic;  		    
	signal	s_acc_axi_awready          :  std_logic; 
	signal	s_acc_axi_wready           :  std_logic; 
	signal	s_acc_axi_bvalid           :  std_logic; 
	signal	s_acc_axi_bresp            :  std_logic_vector( 1 downto 0 );
	signal	s_acc_axi_arready          :  std_logic; 
	signal	s_acc_axi_rvalid           :  std_logic; 
	signal	s_acc_axi_rlast            :  std_logic; 
	signal	s_acc_axi_rresp            :  std_logic_vector( 1 downto 0 );
	signal	s_acc_axi_rdata            :  std_logic_vector( 31 downto 0 );			
	signal	s_acc_axi_awid             :  std_logic_vector( 0 downto 0 );
	signal	s_acc_axi_arid             :  std_logic_vector( 0 downto 0 );
	signal	s_acc_axi_rid              :  std_logic_vector( 0 downto 0 );
	signal	s_acc_axi_bid              :  std_logic_vector( 0 downto 0 );	
	signal	s_acc_axi_awregion         :  std_logic_vector( 3 downto 0 );
	signal	s_acc_axi_arregion         :  std_logic_vector( 3 downto 0 );	
    signal  s_s_axi_rdata              :  STD_LOGIC_VECTOR (31 downto 0);
    signal  s_s_axi_wdata              :  STD_LOGIC_VECTOR (31 downto 0);
    signal  s_s_axi_wstrb              :  STD_LOGIC_VECTOR (3 downto 0);
	
begin 

	s_axi_rid   <= s_axi_arid;
    s_axi_rlast <= '1';
	s_axi_rdata <= s_s_axi_rdata & s_s_axi_rdata & s_s_axi_rdata & s_s_axi_rdata;
	s_axi_bid   <= s_axi_awid;
	
	m_axi_arid  <= "00100000000"& s_acc_axi_arid;	
	m_axi_awid  <= "00100000000"& s_acc_axi_awid;	
	
	s_s_axi_wstrb <= s_axi_wstrb(3 downto 0)    when s_axi_awaddr(3 downto 2) = "00"  else	
	                 s_axi_wstrb(7 downto 4)    when s_axi_awaddr(3 downto 2) = "01"  else	
	                 s_axi_wstrb(11 downto 8)   when s_axi_awaddr(3 downto 2) = "10"  else	
	                 s_axi_wstrb(15 downto 12)  when s_axi_awaddr(3 downto 2) = "11"  else x"0";	
	s_s_axi_wdata <= s_axi_wdata(31 downto 0)   when s_axi_awaddr(3 downto 2) = "00"  else	
	                 s_axi_wdata(63 downto 32)  when s_axi_awaddr(3 downto 2) = "01"  else
	                 s_axi_wdata(95 downto 64)  when s_axi_awaddr(3 downto 2) = "10"  else
	                 s_axi_wdata(127 downto 96) when s_axi_awaddr(3 downto 2) = "11"  else x"00000000";
	
u_example  :   matrix_multiply
Port map ( 
            ap_local_block           => open                       ,
            ap_clk                   => s_axi_aclk                 ,
            ap_rst_n                 => s_axi_aresetn              ,
			                                                       
            m_axi_gmem_AWVALID       => s_acc_axi_awvalid          ,
            m_axi_gmem_AWREADY       => s_acc_axi_awready          ,
            m_axi_gmem_AWADDR        => s_acc_axi_awaddr           ,
            m_axi_gmem_AWID          => s_acc_axi_awid             ,
            m_axi_gmem_AWLEN         => s_acc_axi_awlen            ,
            m_axi_gmem_AWSIZE        => s_acc_axi_awsize           ,
            m_axi_gmem_AWBURST       => s_acc_axi_awburst          ,
            m_axi_gmem_AWLOCK        => s_acc_axi_awlock           ,
            m_axi_gmem_AWCACHE       => s_acc_axi_awcache          ,
            m_axi_gmem_AWPROT        => s_acc_axi_awprot           ,
            m_axi_gmem_AWQOS         => s_acc_axi_awqos            ,
            m_axi_gmem_AWREGION      => s_acc_axi_awregion         ,
            m_axi_gmem_AWUSER        => open                       ,
			                                                       
            m_axi_gmem_WVALID        => s_acc_axi_wvalid           ,
            m_axi_gmem_WREADY        => s_acc_axi_wready           ,
            m_axi_gmem_WDATA         => s_acc_axi_wdata            ,
            m_axi_gmem_WSTRB         => s_acc_axi_wstrb            ,
            m_axi_gmem_WLAST         => s_acc_axi_wlast            ,
            m_axi_gmem_WID           => open                       ,
            m_axi_gmem_WUSER         => open                       ,
			                                                       
            m_axi_gmem_ARVALID       => s_acc_axi_arvalid          ,
            m_axi_gmem_ARREADY       => s_acc_axi_arready          ,
            m_axi_gmem_ARADDR        => s_acc_axi_araddr           ,
            m_axi_gmem_ARID          => s_acc_axi_arid             ,
            m_axi_gmem_ARLEN         => s_acc_axi_arlen            ,
            m_axi_gmem_ARSIZE        => s_acc_axi_arsize           ,
            m_axi_gmem_ARBURST       => s_acc_axi_arburst          ,
            m_axi_gmem_ARLOCK        => s_acc_axi_arlock           ,
            m_axi_gmem_ARCACHE       => s_acc_axi_arcache          ,
            m_axi_gmem_ARPROT        => s_acc_axi_arprot           ,
            m_axi_gmem_ARQOS         => s_acc_axi_arqos            ,
            m_axi_gmem_ARREGION      => s_acc_axi_arregion         ,
            m_axi_gmem_ARUSER        => open                       ,
			                                                       
            m_axi_gmem_RVALID        => s_acc_axi_rvalid           ,
            m_axi_gmem_RREADY        => s_acc_axi_rready           ,
            m_axi_gmem_RDATA         => s_acc_axi_rdata            ,
            m_axi_gmem_RLAST         => s_acc_axi_rlast            ,
            m_axi_gmem_RID           => s_acc_axi_rid              ,
            m_axi_gmem_RUSER         => "0"                        ,
            m_axi_gmem_RRESP         => s_acc_axi_rresp            ,
			                                                      
            m_axi_gmem_BVALID        => s_acc_axi_bvalid           ,
            m_axi_gmem_BREADY        => s_acc_axi_bready           ,
            m_axi_gmem_BRESP         => s_acc_axi_bresp            ,
            m_axi_gmem_BID           => s_acc_axi_bid              ,
            m_axi_gmem_BUSER         => "0"                        ,
	                                                               
            s_axi_control_AWVALID    => s_axi_awvalid              ,
            s_axi_control_AWREADY    => s_axi_awready              ,
            s_axi_control_AWADDR     => s_axi_awaddr(5 downto 0)	,
			                                                       
            s_axi_control_WVALID     => s_axi_wvalid               ,
            s_axi_control_WREADY     => s_axi_wready               ,
            s_axi_control_WDATA      => s_s_axi_wdata              ,
            s_axi_control_WSTRB      => s_s_axi_wstrb              ,
			                                                       
            s_axi_control_ARVALID    => s_axi_arvalid              ,
            s_axi_control_ARREADY    => s_axi_arready              ,
            s_axi_control_ARADDR     => s_axi_araddr(5 downto 0)   ,
			                                                       
            s_axi_control_RVALID     => s_axi_rvalid               ,
            s_axi_control_RREADY     => s_axi_rready               ,
            s_axi_control_RDATA      => s_s_axi_rdata              ,
            s_axi_control_RRESP      => s_axi_rresp                ,
			                                                       
            s_axi_control_BVALID     => s_axi_bvalid	           ,
            s_axi_control_BREADY     => s_axi_bready	           ,
            s_axi_control_BRESP      => s_axi_bresp 	           ,
	                                 
            interrupt                => open
       );  
        
u_axi_acc_dwidth_converter_0	: axi_acc_dwidth_converter_0
        port map (
        	
			s_axi_aclk             => s_axi_aclk 	, 
			s_axi_aresetn          => s_axi_aresetn , 
			
			s_axi_awregion         => s_acc_axi_awregion,
			s_axi_arregion         => s_acc_axi_arregion,
			s_axi_awvalid          => s_acc_axi_awvalid,
			s_axi_awid             => s_acc_axi_awid,
			s_axi_awlen            => s_acc_axi_awlen  ,
			s_axi_awsize           => s_acc_axi_awsize ,
			s_axi_awburst          => s_acc_axi_awburst,
			s_axi_awlock           => s_acc_axi_awlock(0 downto 0) ,
			s_axi_awcache          => s_acc_axi_awcache,
			s_axi_awqos            => s_acc_axi_awqos  ,
			s_axi_awaddr           => s_acc_axi_awaddr ,
			s_axi_awprot           => s_acc_axi_awprot ,
			
			s_axi_wvalid           => s_acc_axi_wvalid ,
			s_axi_wlast            => s_acc_axi_wlast  ,
			s_axi_wdata            => s_acc_axi_wdata  ,
			s_axi_wstrb            => s_acc_axi_wstrb  ,			
			s_axi_bready           => s_acc_axi_bready ,			
			s_axi_arvalid          => s_acc_axi_arvalid,
			s_axi_arid             => s_acc_axi_arid,
			s_axi_arlen            => s_acc_axi_arlen  ,
			s_axi_arsize           => s_acc_axi_arsize ,
			s_axi_arburst          => s_acc_axi_arburst,
			s_axi_arlock           => s_acc_axi_arlock(0 downto 0) ,
			s_axi_arcache          => s_acc_axi_arcache,
			s_axi_arqos            => s_acc_axi_arqos  ,
			s_axi_araddr           => s_acc_axi_araddr ,
			s_axi_arprot           => s_acc_axi_arprot ,			
			s_axi_rready           => s_acc_axi_rready ,			
			s_axi_awready          => s_acc_axi_awready,
			s_axi_wready           => s_acc_axi_wready ,
			s_axi_bvalid           => s_acc_axi_bvalid ,
			s_axi_bid              => s_acc_axi_bid,
			s_axi_bresp            => s_acc_axi_bresp  ,
			s_axi_arready          => s_acc_axi_arready,
			s_axi_rvalid           => s_acc_axi_rvalid ,
			s_axi_rid              => s_acc_axi_rid,
			s_axi_rlast            => s_acc_axi_rlast,
			s_axi_rresp            => s_acc_axi_rresp,
			s_axi_rdata            => s_acc_axi_rdata,
			
			m_axi_awregion         => open,
			m_axi_arregion         => open,
			m_axi_awvalid          => m_axi_awvalid ,
			m_axi_awlen            => m_axi_awlen   ,
			m_axi_awsize           => m_axi_awsize  ,
			m_axi_awburst          => m_axi_awburst ,
			m_axi_awlock           => m_axi_awlock  ,
			m_axi_awcache          => m_axi_awcache ,
			m_axi_awqos            => m_axi_awqos   ,
			m_axi_awaddr           => m_axi_awaddr  ,
			m_axi_awprot           => m_axi_awprot  ,
			m_axi_wvalid           => m_axi_wvalid  ,
			m_axi_wlast            => m_axi_wlast   ,
			m_axi_wdata            => m_axi_wdata   ,
			m_axi_wstrb            => m_axi_wstrb   ,
			m_axi_bready           => m_axi_bready  ,
			m_axi_arvalid          => m_axi_arvalid ,
			m_axi_arlen            => m_axi_arlen   ,
			m_axi_arsize           => m_axi_arsize  ,
			m_axi_arburst          => m_axi_arburst ,
			m_axi_arlock           => m_axi_arlock  ,
			m_axi_arcache          => m_axi_arcache ,
			m_axi_arqos            => m_axi_arqos   ,
			m_axi_araddr           => m_axi_araddr  ,
			m_axi_arprot           => m_axi_arprot  ,
			m_axi_rready           => m_axi_rready  ,
			                          
			m_axi_awready          => m_axi_awready ,
			m_axi_wready           => m_axi_wready  ,
			m_axi_bvalid           => m_axi_bvalid  ,
			m_axi_bresp            => m_axi_bresp   ,
			m_axi_arready          => m_axi_arready ,
			m_axi_rvalid           => m_axi_rvalid  ,
			m_axi_rlast            => m_axi_rlast   ,
			m_axi_rresp            => m_axi_rresp   ,
			m_axi_rdata            => m_axi_rdata   
			
		);
	
           
end Accelerator_Top_a;
