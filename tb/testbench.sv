`include "uvm_macros.svh"
import uvm_pkg::*;
`include "interface.sv"
`include "adder_test.sv"
module top_tb;
  
  //instantiate interface
  adder_if vif ();
  
  //instantiate DUT
  comb_adder dut (.a(vif.a),.b(vif.b),.sum(vif.sum));
  
  initial begin
    uvm_config_db#(virtual adder_if)::set(null,"uvm_test_top","vif",vif);
  end
  
  initial begin
    run_test("adder_test");
  end
endmodule