module Unsigned8mul
#(
  B_NUM = 1
)(
  input                          clk, rst,
  input                          iAEn,
  input                   [ 7:0] iA,  
  input                   [ 7:0] iB,
  output logic [B_NUM-1:0][15:0] oRslt
);

  logic [B_NUM-1:0][6:0] dat1X;
  logic [B_NUM-1:0][8:0] dat3X;
  logic [B_NUM-1:0][9:0] dat5X;
  logic [B_NUM-1:0][9:0] dat7X;
  logic [B_NUM-1:0]       negative;

  PreprocessUnit #(B_NUM) 
    U_Preprose( clk, rst, iAEn, iA, dat1X, dat3X, dat5X, dat7X ,negative);

  for(genvar i=0; i<B_NUM; i=i+1) begin
    MulUnit U_MulUnit(clk, rst, iB, dat1X[i], dat3X[i], dat5X[i], dat7X[i], negative[i], oRslt[i]);
  end


endmodule : Unsigned8mul
