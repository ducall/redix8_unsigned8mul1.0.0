 module PreprocessUnit
 #(OUTPUT_PORT_NUM = 1
 )(
   input              clk, rst,
   input              iEn,
   input        [7:0] iDat,
   output logic [OUTPUT_PORT_NUM-1:0][6:0] oDat1X,
   output logic [OUTPUT_PORT_NUM-1:0][8:0] oDat3X,
   output logic [OUTPUT_PORT_NUM-1:0][9:0] oDat5X,
   output logic [OUTPUT_PORT_NUM-1:0][9:0] oDat7X,
   output logic [OUTPUT_PORT_NUM-1:0]      oNegative
 );
  
  logic       enable;
  logic [7:0] iDatRst ; 
  EnReg #(1) U_EnInput(clk,rst,(iEn|enable),iEn,enable) ;
  EnReg #(8) U_DatInput(clk,rst,iEn,iDat,iDatRst) ;

  wire       iNegative    = iDatRst[$high(iDatRst)] ;
  wire [6:0] iDatNegative = {$size(iDatNegative){iNegative}} ;
  wire [6:0] dat1X        = (iDatRst[$high(dat1X):$low(dat1X)]^iDatNegative) + iNegative ;

  wire [7:0] dat2X = {dat1X, 1'b0  } ;
  wire [8:0] dat4X = {dat1X, 2'b00 } ;
  wire [9:0] dat8X = {dat1X, 3'b000} ;
  
  wire [8:0] dat3X = {2'b00 ,dat1X} + {1'b0,dat2X} ;
  wire [9:0] dat5X = {3'b000,dat1X} + {1'b0,dat4X} ;
  wire [9:0] dat7X = dat8X - {3'b000,dat1X};

  for(genvar i=0; i<OUTPUT_PORT_NUM; i=i+1) begin : Gen_Output 
    EnReg #( 7) U_Dat1X(clk,rst,enable,dat1X,oDat1X[i]); //
    EnReg #( 9) U_Dat3X(clk,rst,enable,dat3X,oDat3X[i]);
    EnReg #(10) U_Dat5X(clk,rst,enable,dat5X,oDat5X[i]);
    EnReg #(10) U_Dat7X(clk,rst,enable,dat7X,oDat7X[i]);
    EnReg #( 1) U_NativeFlag(clk,rst,enable,iNegative,oNegative[i]);
  end


endmodule : PreprocessUnit