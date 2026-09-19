// and_beh_before.v
module and_beh_before (
  input      a,
  input      b,
  output reg y
);

  always @(*) begin
    #1 y = a & b;   // use #2 for part (b), #3 for part (c)
  end

endmodule