/* Accumulator */
module accumulator (clock, R, S1, S2, S1S2mux, newDist, Accumulate);
    input clock;
    input [7:0] R, S1, S2;
    input S1S2mux, newDist;
    output [7:0] Accumulate;
    reg [7:0] Accumulate, AccumulateIn, difference, difference_temp;
    reg Carry;

    always @(posedge clock) Accumulate <= AccumulateIn;

    always @(R or S1 or S2 or S1S2mux or newDist or Accumulate)
    begin
        difference = R -(S1S2mux? S1:S2);
        difference_temp = - difference;
        if (difference<0)
        begin
            difference = difference_temp;
        end
        {Carry,AccumulateIn} = Accumulate + difference;
        if (Carry == 1) AccumulateIn = 8'hFF; // saturated
        if (newDist == 1) AccumulateIn = difference;
    end
endmodule
