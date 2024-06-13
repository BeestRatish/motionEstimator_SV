class environment;
    driver drv;
    monitor mon;
    scoreboard sb;
    generator gen;

    virtual top_interface.test topif;

    // Constructor
    function new(top_interface.test topif);
        this.topif = topif;
        drv = new(topif);
        mon = new(topif;
        sb = new(topif);
        gen = new(topif);
    endfunction

    // Run the environment
    task run();
        fork
            drv.drive();
            mon.collect();
            sb.compare();
            gen.generate_signals();
        join
    endtask
endclass
