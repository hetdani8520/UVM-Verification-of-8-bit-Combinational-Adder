class adder_driver extends uvm_driver #(comb_adder_item);
  `uvm_component_utils(adder_driver)
  
  virtual adder_if vif;
  agent_config agt_cfg;
  
  function new(string name="adder_driver", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(agent_config)::get(this,"","agt_cfg",agt_cfg))
      `uvm_fatal(get_type_name(),"cfg_db type not found")
      
    //copy vif from agt_cfg  
    vif = agt_cfg.vif;
    
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      //comb_adder_item req;
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(),$sformatf("a=%d,b=%d",req.a,req.b),UVM_LOW)
      drive(req);
      seq_item_port.item_done();
      #10; //random delay to wait 10ns before processing next txn from seq (not good methodology)
    end
  endtask
  
  virtual task drive(input comb_adder_item txn);
    //non-blocking assign
    vif.a <= txn.a;
    vif.b <= txn.b;
  endtask
  
endclass