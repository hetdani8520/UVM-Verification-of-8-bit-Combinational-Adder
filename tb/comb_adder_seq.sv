class comb_adder_seq extends uvm_sequence #(comb_adder_item);
  `uvm_object_utils(comb_adder_seq)
  
  comb_adder_item req;
  
  function new(string name="comb_adder_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    //generating 2 txns
    repeat(2) begin
    req = comb_adder_item::type_id::create("req", null);
    start_item(req);
    assert(req.randomize()) else
      `uvm_fatal(get_type_name,"randomization error")
    finish_item(req);
    end
  endtask
endclass