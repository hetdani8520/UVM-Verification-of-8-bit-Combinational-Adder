class env_config extends uvm_object;
  `uvm_object_utils(env_config)
  
  //agent_conifg agt_cfg; //handle to agt_cfg
  bit enable_coverage;
  bit enable_scoreboard;
  
  function new(string name="env_config");
    super.new(name);
  endfunction
endclass