module BoothEncode
#(
  ENCODE_DATA_WIDTH = 7,
  ENCODE_OBOOTHSEL_WIDTH = 7
)
(
  input        [ENCODE_DATA_WIDTH-1:0] iDat,
  output logic [1:0][ENCODE_OBOOTHSEL_WIDTH-1:0] oBoothSel
);
 // assign oBoothSel[0] = ( iDat[0]) & (~iDat[1]) & (~iDat[2]) ;
 // assign oBoothSel[1] = (~iDat[0]) & ( iDat[1]) & (~iDat[2]) ;
 // assign oBoothSel[2] = ( iDat[0]) & ( iDat[1]) & (~iDat[2]) ;  
 // assign oBoothSel[3] = (~iDat[0]) & (~iDat[1]) & ( iDat[2]) ;
 // assign oBoothSel[4] = ( iDat[0]) & (~iDat[1]) & ( iDat[2]) ;
 // assign oBoothSel[5] = (~iDat[0]) & ( iDat[1]) & ( iDat[2]) ;
 // assign oBoothSel[6] = ( iDat[0]) & ( iDat[1]) & ( iDat[2]) ; 
    always_comb begin 
      unique case(iDat)
        3'b001   : oBoothSel = 7'b000_0001;
        3'b010   : oBoothSel = 7'b000_0010;
        3'b011   : oBoothSel = 7'b000_0100;
        3'b100   : oBoothSel = 7'b000_1000;
        3'b101   : oBoothSel = 7'b001_0000;
        3'b110   : oBoothSel = 7'b010_0000;
        3'b111   : oBoothSel = 7'b100_0000; 

      default : oBoothSel = 7'b000_0000;
    endcase 
    end

endmodule : BoothEncode
