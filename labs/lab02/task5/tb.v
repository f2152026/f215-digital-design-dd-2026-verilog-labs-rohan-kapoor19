// tb.v
// Self-checking testbench for alu (1-bit-opcode, 4-bit operand ALU).

module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  reg [3:0] exp_result;
  integer errors;
  integer total;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  task check;
    begin
      #1; // let combinational logic settle
      exp_result = (t_op == 1'b0) ? (t_a + t_b) : (t_a - t_b);
      total = total + 1;
      if (t_result !== exp_result) begin
        $display("FAIL at time %0t: a=%d b=%d op=%b  got result=%d  expected=%d",
                 $time, t_a, t_b, t_op, t_result, exp_result);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;
    total  = 0;

    // 1) Same operand pair, switch op -- exposes sensitivity-list bug.
    t_a = 4'd9; t_b = 4'd3;
    t_op = 1'b0; check;   // add
    t_op = 1'b1; check;   // sub, same operands, no change to a/b

    t_a = 4'd5; t_b = 4'd5;
    t_op = 1'b0; check;
    t_op = 1'b1; check;

    // 2) Add with changing operands.
    t_op = 1'b0;
    t_a = 4'd1;  t_b = 4'd1;  check;
    t_a = 4'd7;  t_b = 4'd2;  check;
    t_a = 4'd15; t_b = 4'd15; check;
    t_a = 4'd0;  t_b = 4'd0;  check;

    // 3) Sub with changing operands -- exposes blocking/non-blocking bug.
    t_op = 1'b1;
    t_a = 4'd9;  t_b = 4'd3;  check;
    t_a = 4'd5;  t_b = 4'd5;  check;
    t_a = 4'd2;  t_b = 4'd7;  check;
    t_a = 4'd15; t_b = 4'd1;  check;
    t_a = 4'd0;  t_b = 4'd0;  check;

    // 4) Interleave op with same/changing operands together.
    t_a = 4'd8; t_b = 4'd6;
    t_op = 1'b0; check;
    t_op = 1'b1; check;
    t_a = 4'd3; t_b = 4'd10;
    t_op = 1'b1; check;
    t_op = 1'b0; check;

    $write("SUMMARY: ");
    $write("%0d", total - errors);
    $write(" / %0d passed", total);
    $display("");

    $finish;
  end

endmodule