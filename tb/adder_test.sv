`include "base_test.sv"
class adder_test extends base_test;
  `uvm_component_utils(adder_test)
  
  comb_adder_seq seq;
  
  function new(string name="adder_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    //brings all boiler plate code from base_test
    super.build_phase(phase);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    seq = comb_adder_seq::type_id::create("seq", this);
    super.run_phase(phase);
    phase.raise_objection(this,"start objection");
    seq.start(agt_cfg.sqr); //start a seq on sqr
    #10; //need_to get_rid_of_this_delay
    phase.drop_objection(this,"drop objection");
  endtask
endclass