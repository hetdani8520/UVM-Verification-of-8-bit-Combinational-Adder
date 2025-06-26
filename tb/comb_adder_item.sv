class comb_adder_item extends uvm_sequence_item;
  `uvm_object_utils(comb_adder_item)
  
  rand bit [7:0] a; //dut input a driven by TB
  rand bit [7:0] b; //dut input b driven by TB
  
  bit [8:0] sum; //dut output sum sampled by TB
  
  function new(string name="comb_adder_item");
    super.new(name);
  endfunction
  
  virtual function bit compare(uvm_object rhs, uvm_comparer comparer);
    comb_adder_item tx_rhs;
    if(!$cast(tx_rhs,rhs))
      `uvm_fatal(get_type_name(),"cast failed")
      
      return (((super.do_compare(rhs,comparer)) &&
               (this.a === tx_rhs.a) &&
               (this.b === tx_rhs.b) &&
               (this.sum === tx_rhs.sum)));
  endfunction
  
endclass