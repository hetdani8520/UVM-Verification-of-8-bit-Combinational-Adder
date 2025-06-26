`uvm_analysis_imp_decl(_expected)
`uvm_analysis_imp_decl(_actual)

class adder_scb extends uvm_scoreboard;
  `uvm_component_utils(adder_scb)
  
  uvm_analysis_imp_expected #(comb_adder_item, adder_scb) exp_imp;
  uvm_analysis_imp_actual #(comb_adder_item, adder_scb) actual_imp;
  
  env_config env_cfg;
  
  //queue of expected comb_adder_item txns. cache it due to DUT latency
  comb_adder_item expected_q[$];
  
  //params
  int match;
  int mismatch;
  int nothing_to_compare_against;
  int total_exp_txn_cnt;
  
  //incase exp_q is not empty (max txn to print for debug)
  int max_txn_to_print=2;

  
  function new(string name="adder_scb", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    //imp ports creation
    exp_imp = new("exp_imp", this);
    actual_imp = new("actual_imp", this);
    
    //get env_cfg
    if(!uvm_config_db#(env_config)::get(this,"","env_cfg",env_cfg))
      `uvm_fatal(get_type_name(),"cfg_db type not found")
  endfunction
      
   virtual function void write_expected(comb_adder_item t);
    if(env_cfg.enable_scoreboard == 1) begin
      //need a counter here to count number of predicted txns?
      total_exp_txn_cnt++;
      expected_q.push_back(t);
    end
   endfunction
  
  virtual function void write_actual(comb_adder_item t);
    uvm_comparer cmp; //why do we need this?
    if(env_cfg.enable_scoreboard == 1) begin:scb_enabled
      if(expected_q.size() == 0) begin:nothing_to_compare_against_logic
        nothing_to_compare_against++;
        `uvm_error(get_type_name,$sformatf("Nothing to compare against"));
      end:nothing_to_compare_against_logic
      else begin:exp_txn_exists
        comb_adder_item exp_txn;
        exp_txn = expected_q.pop_front();
        cmp = new(); //why do we need this?
        if(t.compare(exp_txn,cmp)) begin:match_logic
          match++;
          `uvm_info(get_type_name,$sformatf("MATCH: exp_sum=%d, actual_sum=%d",exp_txn.sum,t.sum),UVM_LOW)
        end:match_logic
        else begin: mismatch_logic
          mismatch++;
          `uvm_info(get_type_name,$sformatf("MATCH: exp_sum=%d, actual_sum=%d",exp_txn.sum,t.sum),UVM_LOW)
        end:mismatch_logic
        end:exp_txn_exists
    end:scb_enabled
      
   endfunction
  
  //This function can be used to extract scb reporting var status like pred_txns, matches count, mismatches cnt etc
  virtual function void extract_phase(uvm_phase phase);
  endfunction
  
  //check if scb exp_q empty at the end of test? if not, report scb not empty
  virtual function void check_phase(uvm_phase phase);
    int fifo_entry=0;
    comb_adder_item expected_txn;
    if(expected_q.size() != 0) begin:check_end_of_test
    while(expected_q.size != 0 && fifo_entry < max_txn_to_print) begin:entries_remain
      expected_txn = expected_q.pop_front();
      `uvm_info(get_type_name,$sformatf("Entry=%p",expected_txn),UVM_LOW)
      fifo_entry++;
    end:entries_remain
    `uvm_error("SCBD","scoreboard not empty")
    end:check_end_of_test
  endfunction
  
  //This function will print scb status at the end of test (matches, mismatches, pred_txns, etc)
  virtual function void report_phase(uvm_phase phase); `uvm_info(get_type_name,$sformatf("PREDICTED_TRANSACTIONS=%d,MATCHES=%d,MISMATCHES=%d, NOTHING_TO_COMPARE_AGAINST=%d",total_exp_txn_cnt,match,mismatch,nothing_to_compare_against),UVM_LOW)
  endfunction
  
  task wait_for_scb_to_drain(uvm_phase phase);
    wait(expected_q.size() == 0);
    phase.drop_objection(this,"phase_ready_to_end");
  endtask
               
  //This function gets invoked at the end of run_phase after all objections are dropped (to delay end of run_phase) - make sure this should not cause sim hangs (it is prone to that)
  virtual function void phase_ready_to_end(uvm_phase phase);
    if(phase.get_name() == "run") begin
      if(expected_q.size() == 0) return;
      phase.raise_objection(this,"phase_ready_to_end");
      fork
        wait_for_scb_to_drain(phase);
      join_none
    end
  endfunction
  
endclass