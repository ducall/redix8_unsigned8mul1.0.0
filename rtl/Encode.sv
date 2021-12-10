module Encode
#(
  ENCODE_DATA_WIDTH = 8,
  ENCODE_OBOOTHSEL_WIDTH = 7
)
(
  input        [ENCODE_DATA_WIDTH-1:0]           iDat,
  output logic [1:0][ENCODE_OBOOTHSEL_WIDTH-1:0] oBoothSel,
  output logic                                   oHighBit ,
  output logic                                   oNegative
);
  
  //oNegative_Generate
  assign  oNegative       =  iDat[$high(iDat)] ;
  //Take iDat[6:0] absolute value
  wire [6:0] iDatNegative = {$size(iDatNegative){oNegative}} ;
  wire [6:0] iDatRst      = (iDat[$high(iDatRst):$low(iDatRst)]^iDatNegative) + oNegative ;
  //oHighBit_Generate
  assign  oHighBit        =  iDatRst[$high(iDatRst)] ;
  //HighData_Booth_Encode_generate 
  always_comb begin : HighData_Booth_Encode_generate 
    unique case(iDatRst[2:0])
      3'b001   : oBoothSel[0] = 7'b000_0001;
      3'b010   : oBoothSel[0] = 7'b000_0010;
      3'b011   : oBoothSel[0] = 7'b000_0100;
      3'b100   : oBoothSel[0] = 7'b000_1000;
      3'b101   : oBoothSel[0] = 7'b001_0000;
      3'b110   : oBoothSel[0] = 7'b010_0000;
      3'b111   : oBoothSel[0] = 7'b100_0000; 
  default : oBoothSel[0] = 7'b000_0000;
  endcase 
  end
  //LowData_generate 
  always_comb begin : LowData_Booth_Encode_generate 
    unique case(iDatRst[5:3])
      3'b001   : oBoothSel[1] = 7'b000_0001;
      3'b010   : oBoothSel[1] = 7'b000_0010;
      3'b011   : oBoothSel[1] = 7'b000_0100;
      3'b100   : oBoothSel[1] = 7'b000_1000;
      3'b101   : oBoothSel[1] = 7'b001_0000;
      3'b110   : oBoothSel[1] = 7'b010_0000;
      3'b111   : oBoothSel[1] = 7'b100_0000; 
  default : oBoothSel[1] = 7'b000_0000;
  endcase 
  end
  
endmodule : Encode 