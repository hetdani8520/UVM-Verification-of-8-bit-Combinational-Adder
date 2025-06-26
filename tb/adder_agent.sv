class adder_agent extends uvm_agent;
  `uvm_component_utils(adder_agent)
  
  agent_config agt_cfg;
  adder_driver drv;
  adder_monitor mon;
  uvm_sequencer #(comb_adder_item) sqr;
  
  uvm_analysis_port #(comb_adder_item) agt_port;
  
  function new(string name="adder_agent", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agt_port = new("agt_port", this);
    
    //create mon
    mon = adder_monitor::type_id::create("mon", this);
    
    //get agt_cfg from cfg_db
    if(!uvm_config_db#(agent_config)::get(this,"","agt_cfg",agt_cfg))
      `uvm_fatal(get_type_name(),"cfg_db type not found")
      
    if(agt_cfg.active == UVM_ACTIVE) begin
      drv=adder_driver::type_id::create("drv", this);
      sqr=new("sqr", this);
    end
    
    //copy sqr handle into agent_cfg
    agt_cfg.sqr = sqr;
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    //connect monitor with agt (hierarchical port connection)
    mon.mon_ap.connect(agt_port);
    
    //connect drv with sqr if agt active
    if(agt_cfg.active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end
   
  endfunction
  
  
  
endclass