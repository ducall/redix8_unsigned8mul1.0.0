module NegativeGenerate (
    input            iNegativeA,
    input            iNegativeB,
    input   [13:0]   Adder_HighBit_HighBooth_LowBooth,

    output  [15:0]   oDat
);

  wire        oNegativeFlag  =  iNegativeA ^ iNegativeB ;
  wire [15:0] oDatFlag       =  {$size(oDatFlag){oNegativeFlag}} ;
  assign      oDat           = ( oDatFlag[15:0]^({2'b00,Adder_HighBit_HighBooth_LowBooth})) + oNegativeFlag;  
    
endmodule