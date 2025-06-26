class adder_env extends uvm_env;
  `uvm_component_utils(adder_env)
  
  env_config env_cfg;
  adder_agent agt;
  adder_scb scb;
  adder_predictor pred;
  
  function new(string name="adder_env", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //get env_cfg if req
    if(!uvm_config_db#(env_config)::get(this,"","env_cfg",env_cfg))
      `uvm_fatal(get_type_name(), "cfg_db type not found")
      
      //adder_scb
      if(env_cfg.enable_scoreboard == 1) begin
        scb=adder_scb::type_id::create("scb", this);
      end
    
      //adder_pred creation
    pred=adder_predictor::type_id::create("pred", this);
    
    //agent creation
    agt=adder_agent::type_id::create("agt", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //connect agt_port to pred imp port
    agt.agt_port.connect(pred.mon2pred_imp);
    
    //connnect agt_port(mon) to scb actual imp_port;
    agt.agt_port.connect(scb.actual_imp);
    
    //connect pred2scb port to scb expected imp port
    pred.pred2scb_ap.connect(scb.exp_imp);
  endfunction
  
endclass