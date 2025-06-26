class adder_monitor extends uvm_monitor;
  `uvm_component_utils(adder_monitor)
  
  uvm_analysis_port #(comb_adder_item) mon_ap;
  virtual adder_if vif;
  
  comb_adder_item mon_txn;
  agent_config agt_cfg;
  
  function new(string name="adder_monitor",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //ap creation
    mon_ap=new("mon_ap", this);
    
    //getting agt_cfg from cfg_db
    if(!uvm_config_db#(agent_config)::get(this,"","agt_cfg",agt_cfg))
      `uvm_fatal(get_type_name(), "cfg_db type not found")
      
      //get vif from agt_cfg
      vif = agt_cfg.vif;
    
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
      mon_txn = comb_adder_item::type_id::create("mon_txn", this);
      #10;
      sample(mon_txn);
      
      `uvm_info(get_type_name(), $sformatf("a=%d, b=%d, sum=%d",mon_txn.a,mon_txn.b,mon_txn.sum),UVM_LOW)
      
      //clone the mon_txn & send?
      //comb_adder_item recv_mon_txn;
      //$cast(recv_mon_txn,mon_txn.clone()); 
      mon_ap.write(mon_txn);
    end
  endtask
    
    virtual task sample(input comb_adder_item txn);
      txn.a = vif.a;
      txn.b = vif.b;
      txn.sum = vif.sum;
    endtask
  
endclass