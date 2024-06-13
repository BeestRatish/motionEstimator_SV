/* Driver */
class driver;
    virtual top_interface intf;

    function new(virtual top_interface intf);
        this.intf = intf;
    endfunction

    task drive_signals();
        intf.clock = 0;
        intf.start = 0;
        #10 intf.clock = 1;
    endtask
endclass
