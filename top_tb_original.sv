module top_testbench();

    // Test bench gets wires for all device under test (DUT) outputs:
    wire [7:0] BestDist;
    wire [3:0] motionX, motionY;

    // Regs for all DUT inputs:
    reg clock;
    reg start;
  
    reg [7:0] Rmem[0:255]; 
    reg [7:0] Smem[0:1023];
    integer Expected_motionX, Expected_motionY;
    integer i;
    integer signed x, y;
    wire [7:0] R, S1, S2;
    wire [7:0] AddressR;
    wire [9:0] AddressS1, AddressS2;
    wire completed;

    // Instantiate the DUT
    top dut (
        .BestDist(BestDist[7:0]),
        .motionX(motionX[3:0]),
        .motionY(motionY[3:0]),
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

    // Setup clock to automatically strobe with a period of 20.
    always #10 clock = ~clock;

    initial begin
        $vcdpluson;

        // Randomize Smem
        foreach (Smem[i]) begin
            Smem[i] = $urandom_range(0, 255);
        end

        // Randomize expected motionX and motionY
        Expected_motionX = $urandom_range(0, 15) - 8;   
        Expected_motionY = $urandom_range(0, 15) - 8;
        
        // Extract Rmem from Smem for Expected_motionX and Expected_motionY
        foreach (Rmem[i]) begin
            Rmem[i] = Smem[32 * 8 + 8 + (((i / 16) + Expected_motionY) * 32) + ((i % 16) + Expected_motionX)];
        end

        // Initialize memories
        foreach (Rmem[i]) begin
            memR_u.Rmem[i] = Rmem[i];
        end
        foreach (Smem[i]) begin
            memS_u.Smem[i] = Smem[i];
        end

        // Initialize clock and start signals
        clock = 1'b0;
        start = 1'b0;

        @(posedge clock); #10;
        start = 1'b1;

        for (i = 0; i < 4112; i = i + 1) begin
            if (dut.comp_u.newBest == 1'b1) begin
                $display("New Result Coming!");
            end
            @(posedge clock); #10;
        end

        start = 1'b0;

        @(posedge clock); #10;

        if (motionX >= 8)
            x = motionX - 16;
        else
            x = motionX;

        if (motionY >= 8)
            y = motionY - 16;
        else
            y = motionY;
        
        // Print memory content
        $display("Reference Memory content:");
        foreach (Rmem[i]) begin
            if (i % 16 == 0)
                $display("  ");
            $write("%h  ", Rmem[i]);
            if (i == 255)
                $display("  ");
        }

        $display("Search Memory content:");
        foreach (Smem[i]) begin
            if (i % 32 == 0)
                $display("  ");
            $write("%h  ", Smem[i]);
            if (i == 1023)
                $display("  ");
        }

        // Print test results
        if (BestDist == 8'b11111111)
            $display("Reference Memory Not Found in the Search Window!");
        else begin
            if (BestDist == 8'b00000000)
                $display("Perfect Match Found for Reference Memory in the Search Window: BestDist = %d, motionX = %d, motionY = %d, Expected motionX = %d, Expected motionY = %d", BestDist, x, y, Expected_motionX, Expected_motionY);
            else
                $display("Non-perfect Match Found for the Reference Memory in the Search Window: BestDist = %d, motionX = %d, motionY = %d, Expected motionX = %d, Expected motionY = %d", BestDist, x, y, Expected_motionX, Expected_motionY);
        }

        if (x == Expected_motionX && y == Expected_motionY)
            $display("DUT motion outputs match expected motions: DUT motionX = %d, DUT motionY = %d, Expected motionX = %d, Expected motionY = %d", x, y, Expected_motionX, Expected_motionY);
        else
            $display("DUT motion outputs do not match expected motions: DUT motionX = %d, DUT motionY = %d, Expected motionX = %d, Expected motionY = %d", x, y, Expected_motionX, Expected_motionY);

        $display("All tests completed\n\n");

        $finish;
    end

    // This is to create a dump file for offline viewing.
    initial begin
        $dumpfile("top.dump");
        $dumpvars(0, top_testbench);
    end

endmodule // top_testbench
