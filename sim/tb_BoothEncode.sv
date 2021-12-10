module tb_BoothEncode ();
  logic clk,rst;
  logic  [2:0]     iDat ;

  logic  [6:0] oBoothSel;

 always_ff @(posedge clk, negedge rst) begin : iDat_Encode 
          if(!rst) begin
               iDat <= 3'd0;
          end else if(iDat == 3'b111) begin
               iDat <= 3'd0;
           end else begin
               iDat <= iDat + 3'd1;
          end
  end

//////instance 
BoothEncode 
#(
    .ENCODE_DATA_WIDTH      (3),
    .ENCODE_OBOOTHSEL_WIDTH (7)
)
u_BoothEncode(
    .iDat      (iDat      ),
    .oBoothSel (oBoothSel )
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

//  wire error0 = (S[0] == (A+B))? '0 : 'x;
//  wire error1 = (S[1] == (A+B))? '0 : 'x;
//  wire error2 = (S[2] == (A+B))? '0 : 'x;

endmodule