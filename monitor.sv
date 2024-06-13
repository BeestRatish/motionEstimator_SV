/* Generator */
class generator;
    virtual top_interface intf;

    function new(virtual top_interface intf);
        this.intf = intf;
    endfunction

    task generate_signals();
        intf.R = $random;
        intf.S1 = $random;
        intf.S2 = $random;
        #10 intf.start = 1;
    endtask
endclass
