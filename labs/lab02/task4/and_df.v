// and_df.v
module and_df (
  input  a,
  input  b,
  output y
);

  assign #1 y = a & b;   // use #2 for part (b), #3 for part (c)

endmodule