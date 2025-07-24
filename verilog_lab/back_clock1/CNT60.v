module CNT60(CLK, RST, CLR, EN, INC, QH, QL, CA);
input CLK, RST, CLR, EN, INC;

output reg [3:0] QH;  
output reg [3:0] QL;  
output CA; 

always @(posedge CLK) begin
    if(RST || CLR) begin
        QH <= 0;
    end else if(EN || INC) begin
        if(QL == 9) begin
            if(QH == 5) begin
                QH <= 0;
            end else
                QH <= QH + 1;
        end 
    end
end

always @(posedge CLK) begin
    if(RST || CLR) begin
        QL <= 0;
    end else if(EN || INC) begin
        if(QL == 9) begin
            QL <= 0;
        end else
            QL <= QL + 1;
    end
end


/*
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        QH <= 0;
        QL <= 0;
      
    end else if (EN && INC) begin
        if (CLR) begin
            QH <= 0;
            QL <= 0;
         
        end else begin
            if (QL == 9) begin
                QL <= 0;
                if (QH == 5) begin
                    QH <= 0;
                    //CA <= 1;  // 60 -> 00 
                end else begin
                    QH <= QH + 1;
                   
            end else begin
                QL <= QL + 1;
                
        end
    end else begin
    
end
*/

assign CA = (QL == 4'd9) && (QH == 3'd5) && (EN || INC);

endmodule
