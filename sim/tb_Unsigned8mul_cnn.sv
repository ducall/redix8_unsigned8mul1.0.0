//`define SDF_FILE  "../setuptime_output/ChipTop_cmax.sdf"
module tb_Unsigned8mul_cnn ();
//initial $sdf_annotate(`SDF_FILE, tb_Unsigned8mul_cnn.u_Unsigned8mul, ,"sdf.log");
  logic clk,rst;
  logic signed [7:0]  A;
  logic signed [7:0]  B;
  logic [15:0] P;
  logic [15:0] test;
  logic EnA;  

//TODO-1 creat enable and A_mul and B_mul signal

  logic [7:0]count;
  logic [7:0]MemA[100000:0];
  logic [7:0]MemB[100000:0];
  logic [100000:0] A_adder;
  logic [100000:0] B_adder;
  
  initial begin   
      $readmemb("D:/mul_code/redix8_unsigned8mul/redix8_unsigned8mul0.0.1/sim/data/dat_actv_dat0.frpt", MemA);
    //$readmemb("/home/train/2019chengqiao/mul8_new/sim/dat_actv_dat0.frpt", MemA);
  end
  initial begin   
      $readmemb("D:/mul_code/redix8_unsigned8mul/redix8_unsigned8mul0.0.1/sim/data/wt_actv_data02.frpt", MemB);
    //$readmemb("/home/train/2019chengqiao/mul8_new/sim/wt_actv_data02.frpt", MemB);  
  end
  always_ff @(posedge clk, negedge rst) begin
    if(!rst) begin
        count <= 8'b0000_0000;
    end else if(count == 127) begin
        count <= 'b0;
    end else begin
        count <= count+1;
    end
  end
  always_ff @(posedge clk, negedge rst) begin
      if(!rst) begin
          A_adder <= 'b0;
      end else begin
          A_adder <= A_adder+1;
      end
  end
  
  always_ff @(posedge clk, negedge rst) begin
      if(!rst) begin
          B_adder <= 'b0;
      end else if(count == 127) begin
          B_adder <= B_adder+1;
      end else begin
          B_adder <= B_adder;
      end
  end
  assign A = MemA[A_adder];
  assign B = MemB[B_adder];
  
  
  always_ff @(posedge clk, negedge rst) begin : enable_signalA
      EnA <= 1'b1;
  end
  
  assign test = $signed(A) * $signed(B);
  logic [15:0] test_r1,test_r2,test_r3;
  logic [ 7:0] A_r1,A_r2,A_r3 ;
  logic [ 7:0] B_r1,B_r2,B_r3;
  always_ff @(posedge clk or negedge rst) begin
      if(!rst) begin
          {test_r3,test_r2,test_r1} <= 16'b0;
          {A_r1,A_r2,A_r3 } <= 8'b0;
          {B_r1,B_r2,B_r3 } <= 8'b0;
      end else begin
          {test_r3,test_r2,test_r1}  <= {test_r2,test_r1,test};    
          {A_r3,A_r2,A_r1}                 <= {A_r2,A_r1,A} ;
          {B_r3,B_r2,B_r1}                 <= {B_r2,B_r1,B} ;
     
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

//TODO-3 instance
Unsigned8mul 
#(
    .B_NUM (1)
)
u_Unsigned8mul(
    .clk   (clk   ),
    .rst   (rst   ),
    .iAEn  (EnA  ),
    .iA    (A    ),
    .iB    (B    ),
    .oRslt (P)
);

//TODO-4 checker

logic error;
always_comb begin
   if ((P == test_r3))
       error = 0;
   else
       error = 1;
end

//TODO-5 dump
/*
   initial begin
     forever @ (posedge clk) begin
       if(B_adder == 100) begin
         $finish;  
       end
     end
   end

 
  initial begin
  $fsdbDumpfile("tb_Unsigned8mul.fsdb");
  $fsdbDumpvars();
  end
  
  
  
  initial begin
  $dumpfile("tb_Unsigned8mul.vcd");
  $dumpvars();
  end
*/
endmodule
