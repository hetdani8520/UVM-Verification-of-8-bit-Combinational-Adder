`include "package.sv"
class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  
  adder_env env;
  agent_config agt_cfg;
  env_config env_cfg;
  
  function new(string name="base_test", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    //all factory overrides first
    
    super.build_phase(phase);
    
    //create env_cfg
    env_cfg=env_config::type_id::create("env_cfg", this);
    
    //configure env_cfg obj
    env_cfg.enable_scoreboard = 1;
    
    //set the env_cfg into cfg_db with env & sub-components visibility
    uvm_config_db#(env_config)::set(this, "env*", "env_cfg", env_cfg);
    
    //create agt_config
    agt_cfg = agent_config::type_id::create("agt_cfg", this);
    
    //get vif from top_tb() into agt_cfg config obj from cfg_db
    if(!uvm_config_db#(virtual adder_if)::get(this,"","vif",agt_cfg.vif))
      `uvm_fatal(get_type_name(),"cfg_db type not found")
      
    agt_cfg.active = UVM_ACTIVE;
    
    //set the agt_cfg into cfg_db for ideally agt & subcomponent visibility
    uvm_config_db#(agent_config)::set(this,"env*","agt_cfg",agt_cfg);
    
    //instantiate adder_env
    env = adder_env::type_id::create("env", this);
    
  endfunction
  
  //end_of_elab debug phase
    virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
    uvm_factory::get.print();
  endfunction
  
endclass