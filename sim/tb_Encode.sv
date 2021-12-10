module tb_Encode ();
  logic clk,rst;
  logic        [7:0]     iDat;
  logic   [1:0][6:0]     oBoothSel;
  logic                  oHighBit ;
  logic                  oNegative;


 always_ff @(posedge clk, negedge rst) begin : iDat_Encode 
          if(!rst) begin
               iDat <= 8'd0;
          end else if(iDat == 8'b1111_1111) begin
               iDat <= 3'd0;
           end else begin
               iDat <= iDat + 3'd1;
          end
  end


////instance
   Encode 
   #(
       .ENCODE_DATA_WIDTH      (8   ),
       .ENCODE_OBOOTHSEL_WIDTH (7)
   )
   u_Encode(
   	 .iDat      (iDat      ),
       .oBoothSel (oBoothSel ),
       .oHighBit  (oHighBit  ),
       .oNegative (oNegative )
   );
 



///clock
  initial begin
    clk = 1'b0;
    forever begin
        #50 clk = ~clk;
    end
  end
  initial begin
    rst = 1'b1;
    #30 rst = 1'b0;
    #200 rst = 1'b1;
  end

endmodule