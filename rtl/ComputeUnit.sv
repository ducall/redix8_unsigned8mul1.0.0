module ComputeUnit(
  input         [ 6:0] iDat1X,
  input         [ 8:0] iDat3X,
  input         [ 9:0] iDat5X,
  input         [ 9:0] iDat7X,
  input                iNegativeA,
  input                iNegativeB,
  input    [1:0][ 6:0] iBoothSel,
  input                iHgihBit,
 
  output        [15:0] oDat
);

  logic [1:0][6:0] dat1XMask;
  logic [1:0][8:0] dat3XMask;
  logic [1:0][9:0] dat5XMask;
  logic [1:0][9:0] dat7XMask;

  logic [1:0][7:0] dat2XMask;
  logic [1:0][8:0] dat4XMask;

  logic [1:0][9:0] dat6XMask;
  
  //************LowBoothbit_Generate***********************
  Mask #(  7) U_LowDat1XMask(iBoothSel[0][0], iDat1X  , dat1XMask[0]);
  Mask #(  7) U_LowDat2XMask(iBoothSel[0][1], iDat1X  , dat2XMask[0][$high(dat2XMask[0])-:$size(dat1XMask[0])]);
  Mask #(  9) U_LowDat3XMask(iBoothSel[0][2], iDat3X  , dat3XMask[0]);
  Mask #(  7) U_LowDat4XMask(iBoothSel[0][3], iDat1X  , dat4XMask[0][$high(dat4XMask[0])-:$size(dat1XMask[0])]);
  Mask #( 10) U_LowDat5XMask(iBoothSel[0][4], iDat5X  , dat5XMask[0]);
  Mask #(  9) U_LowDat6XMask(iBoothSel[0][5], iDat3X  , dat6XMask[0][$high(dat6XMask[0])-:$size(dat3XMask[0])]);
  Mask #( 10) U_LowDat7XMask(iBoothSel[0][6], iDat7X  , dat7XMask[0]);

  always_comb begin : Lowdat1X2X4X6X
     dat2XMask[0][  $low(dat2XMask[0])]  = 1'b0   ;
     dat4XMask[0][1:$low(dat4XMask[0])]  = 2'b00  ;
     dat6XMask[0][  $low(dat3XMask[0])]  = 1'b0   ;
  end

  wire [ 7:0] LowDat1X2X        = {1'b0,dat1XMask[0]} | dat2XMask[0]; 
  wire [ 8:0] LowDat3X4X        =  dat3XMask[0] | dat4XMask[0] ;
  wire [ 8:0] LowDat1X2X3X4X    = {1'b0,LowDat1X2X} |  LowDat3X4X ;
  wire [ 9:0] LowDat5X6X7X      = dat5XMask[0] | dat6XMask[0] | dat7XMask[0] ;
  wire [ 9:0] LowBoothDat       = {1'b0,LowDat1X2X3X4X} | LowDat5X6X7X;
  
  //**************HighBoothBitGenerate**********************
  Mask #(  7) U_HighDat1XMask(iBoothSel[1][0], iDat1X  , dat1XMask[1]);
  Mask #(  7) U_HighDat2XMask(iBoothSel[1][1], iDat1X  , dat2XMask[1][$high(dat2XMask[1])-:$size(dat1XMask[1])]);
  Mask #(  9) U_HighDat3XMask(iBoothSel[1][2], iDat3X  , dat3XMask[1]);
  Mask #(  7) U_HighDat4XMask(iBoothSel[1][3], iDat1X  , dat4XMask[1][$high(dat4XMask[1])-:$size(dat1XMask[1])]);
  Mask #( 10) U_HighDat5XMask(iBoothSel[1][4], iDat5X  , dat5XMask[1]);
  Mask #(  9) U_HighDat6XMask(iBoothSel[1][5], iDat3X  , dat6XMask[1][$high(dat6XMask[1])-:$size(dat3XMask[1])]);
  Mask #( 10) U_HighDat7XMask(iBoothSel[1][6], iDat7X  , dat7XMask[1]);
 
  always_comb begin : Highdat1X2X4X6X8X
     dat2XMask[1][  $low(dat2XMask[1])]  = 1'b0   ;
     dat4XMask[1][1:$low(dat4XMask[1])]  = 2'b00  ;
     dat6XMask[1][  $low(dat6XMask[1])]  = 1'b0   ;
  end

  wire [ 7:0] highDat1X2X     = {1'b0,dat1XMask[1]} | dat2XMask[1];
  wire [ 8:0] highDat3X4X     =  dat3XMask[1] | dat4XMask[1] ;
  wire [ 8:0] highDat1X2X3X4X = {1'b0,highDat1X2X} | highDat3X4X ;
  wire [ 9:0] highDat5X6X7X   =  dat5XMask[1] | dat6XMask[1] | dat7XMask[1] ;
  wire [ 9:0] highBoothDat    = {1'b0,highDat1X2X3X4X} | highDat5X6X7X;  
  
  //********************HighBitGenerate**********************
  logic [ 6:0] HighBitGenerate;
  Mask #(  7) U_HighBitGenerateMask(iHgihBit, iDat1X , HighBitGenerate);

  ////**********************Adder_HighBit_HighBooth**********************
  wire    [ 7:0]  Adder_HighBit_HighBooth_Part  =  {1'b0,HighBitGenerate} + {1'b0,highBoothDat[9:3]} ;
  wire    [10:0]  Adder_HighBit_HighBooth       =  {Adder_HighBit_HighBooth_Part,highBoothDat[2:0]} ;
  ////**********************Adder_HighBit_HighBooth_LowBooth*************
  wire    [10:0]  Adder_HighBit_HighBooth_LowBooth_Part =  Adder_HighBit_HighBooth + {4'b0000,LowBoothDat[9:3]} ;
  wire    [13:0]  Adder_HighBit_HighBooth_LowBooth      =  {Adder_HighBit_HighBooth_LowBooth_Part,LowBoothDat[2:0]};

  NegativeGenerate u_NegativeGenerate(
  	.iNegativeA                       (iNegativeA                       ),
    .iNegativeB                       (iNegativeB                       ),
    .Adder_HighBit_HighBooth_LowBooth (Adder_HighBit_HighBooth_LowBooth ),
    .oDat                             (oDat                             )
  );
  

endmodule : ComputeUnit 


