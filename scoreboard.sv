// scoreboard.sv
class scoreboard;
    virtual top_interface intf;
    int expected_BestDist;
    int expected_motionX;
    int expected_motionY;

    // Constructor
    function new(virtual top_interface intf);
        this.intf = intf;
    endfunction

    // Compare the expected results with the DUT output
    task compare();
        forever begin
            @ (monitor.data_collected);
            if (intf.cb.BestDist !== expected_BestDist || 
                intf.cb.motionX !== expected_motionX || 
                intf.cb.motionY !== expected_motionY) begin
                $error("Mismatch: Expected BestDist = %h, motionX = %h, motionY = %h; Got BestDist = %h, motionX = %h, motionY = %h",
                       expected_BestDist, expected_motionX, expected_motionY,
                       intf.cb.BestDist, intf.cb.motionX, intf.cb.motionY);
            end else begin
                $display("Match: BestDist = %h, motionX = %h, motionY = %h",
                         intf.cb.BestDist, intf.cb.motionX, intf.cb.motionY);
            end
        end
    endtask
endclass
