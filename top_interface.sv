// Interface for the top module
interface top_interface (
    input wire clock,
    input wire start,
    output reg [7:0] BestDist,
    output reg [3:0] motionX,
    output reg [3:0] motionY,
    output reg completed,
    input wire [7:0] R,
    input wire [7:0] S1,
    input wire [7:0] S2,
    output reg [7:0] AddressR,
    output reg [9:0] AddressS1,
    output reg [9:0] AddressS2
);

    // Instantiate the top module with the interface ports
    top dut (
        .BestDist(BestDist),
        .motionX(motionX),
        .motionY(motionY),
        .clock(clock),
        .start(start),
        .AddressR(AddressR),
        .AddressS1(AddressS1),
        .AddressS2(AddressS2),
        .R(R),
        .S1(S1),
        .S2(S2),
        .completed(completed)
    );

endinterface // top_interface
