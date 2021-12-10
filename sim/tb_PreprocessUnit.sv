module tb_PreprocessUnit ();
 logic clk ;
 logic rst ;
 logic iEn ;
 logic signed [7:0] iDat ;   
 logic [6 :0] oDat1X;
 logic [8 :0] oDat3X;
 logic [ 9:0] oDat5X;
 logic [ 9:0] oDat7X ;
 logic        oNegative;

  always_ff @(posedge clk, posedge rst) begin : EnGenerate
      iEn <= 1'b1;
  end
  
  always_ff @(posedge clk, negedge rst) begin : iDatGenerate
          if(!rst) begin
               iDat <= -128;
           end else if(iDat == 127) begin
               iDat <= -128;
           end else begin
               iDat <= iDat + 1;
           end
  end

 
PreprocessUnit 

u_PreprocessUnit(
    .clk       (clk       ),
    .rst       (rst       ),
    .iEn       (iEn       ),
    .iDat      (iDat      ),
    .oDat1X    (oDat1X    ),
    .oDat3X    (oDat3X    ),
    .oDat5X    (oDat5X    ),
    .oDat7X    (oDat7X    ),
    .oNegative (oNegative )
);


 logic [7:0] iDat_r1,iDat_r2;
 always_ff @(posedge clk, negedge rst) begin : blockName
     if(!rst) begin
         {iDat_r2,iDat_r1} <= 16'b0;
     end else begin    
         {iDat_r2,iDat_r1}  <= {iDat_r1,iDat} ;    
     end
 end

//TODO-2   clock and reset signal 
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