import "DPI-C" pure function bit [8:0] add(input bit [7:0] a, input bit [7:0] b);

class adder_predictor extends uvm_subscriber #(comb_adder_item);
  `uvm_component_utils(adder_predictor)
  
  uvm_analysis_port #(comb_adder_item) pred2scb_ap;
  
  uvm_analysis_imp #(comb_adder_item, adder_predictor) mon2pred_imp;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon2pred_imp = new("mon2pred_imp", this);
    pred2scb_ap=new("pred2scb_ap", this);
  endfunction
  
  virtual function void write(comb_adder_item txn);
    comb_adder_item adder_pred_txn = new();
    //`uvm_info(get_type_name, $sformatf("a=%d, b=%d, sum=%d",txn.a,txn.b,txn.sum),UVM_LOW);
    adder_pred_txn.a = txn.a;
    adder_pred_txn.b = txn.b;
    adder_pred_txn.sum = add(adder_pred_txn.a, adder_pred_txn.b);
    
    `uvm_info("PRED2SCB", $sformatf("a=%d, b=%d, sum=%d",adder_pred_txn.a,adder_pred_txn.b,adder_pred_txn.sum),UVM_LOW);
    
    //write to pred2scb port
    pred2scb_ap.write(adder_pred_txn);
    
  endfunction
endclass