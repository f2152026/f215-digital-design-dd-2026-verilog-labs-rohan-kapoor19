// and_beh_intra.v
module and_beh_intra (
  input      a,
  input      b,
  output reg y
);

  always @(*) begin
    y = #1 a & b;   // use #2 for part (b), #3 for part (c)
  end

endmodule