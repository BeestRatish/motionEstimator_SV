// generator.sv
class generator;
    virtual top_interface intf;
    
    // Constructor
    function new(virtual top_interface intf);
        this.intf = intf;
    endfunction

    // Generate stimulus for the DUT
    task generate_signals();
        // Add your stimulus generation logic here
        intf.cb.start <= 1;
        intf.cb.R <= 8'hA5;
        intf.cb.S1 <= 8'h3C;
        intf.cb.S2 <= 8'h7F;
        #10;
        intf.cb.start <= 0;
    endtask
endclass
