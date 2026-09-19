// tb.v
// Self-checking testbench for comp2 (2-bit magnitude comparator).

module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  integer i;
  integer errors;
  integer total;

  reg exp_gt, exp_lt, exp_eq;

  // DUT
  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    total  = 0;

    for (i = 0; i < 16; i = i + 1) begin
      {t_a, t_b} = i[3:0];
      #5;

      // Compute expected result independently -- not by mirroring the DUT.
      exp_gt = (t_a >  t_b);
      exp_lt = (t_a <  t_b);
      exp_eq = (t_a == t_b);

      total = total + 1;

      if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
        $display("FAIL at time %0t: A=%b B=%b  got GT=%b LT=%b EQ=%b  expected GT=%b LT=%b EQ=%b",
                 $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
        errors = errors + 1;
      end
    end

    $write("SUMMARY: ");
    $write("%0d", total - errors);
    $write(" / %0d passed", total);
    $display("");

    $finish;
  end

endmodule