module MulUnit
(
  input               clk, rst,
  input        [ 7:0] iMulDat, 
  input        [ 6:0] iDat1X,
  input        [ 8:0] iDat3X,
  input        [ 9:0] iDat5X,
  input        [ 9:0] iDat7X,
  input               iNegative,
  output logic [15:0] oDat
);

  logic [7:0] dat;
  EnReg #(8) U_DatInput(clk,rst,1'b1,iMulDat,dat);
  
  logic [1:0][ 6:0] boothSel, boothSel_r;
  logic             HighBit , HighBit_r ;
  logic             negative, negative_r;

  Encode U_Encode(dat, boothSel, HighBit , negative);

  EnReg #(14) U_BoothSel(clk,rst,1'b1,boothSel,boothSel_r);
  EnReg #( 1) U_HighBit (clk,rst,1'b1,HighBit,HighBit_r); 
  EnReg #( 1) U_Negative(clk,rst,1'b1,negative,negative_r);

  logic [15:0] outputDat;  
  
  ComputeUnit U_ComputeUnit(iDat1X, iDat3X, iDat5X, iDat7X, iNegative,
                               negative_r, boothSel_r, HighBit_r, outputDat);
  
  EnReg #(16) U_DatOutput(clk,rst,1'b1,outputDat,oDat);                             

endmodule : MulUnit
