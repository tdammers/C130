var start_engine = func(num, cont) {
    var starter ="controls/engines/engine[" ~ num ~ "]/starting";
    var cutoff ="controls/engines/engine[" ~ num ~ "]/cutoff";
    var n1 = "fdm/jsbsim/propulsion/engine[" ~ num ~ "]/n1";
    setprop(starter, 1);
    setprop(cutoff, 1);
    setprop(n1, 20);
    setprop(cutoff, 0);
    var check_loop = func {
        if (getprop(n1) > 40) {
            setprop(starter, 0);
            if (cont != nil) {
                cont();
            }
        }
        else {
            settimer(check_loop, 1);
        }
    }
    check_loop();
};

var shutdown = func(num, cont) {
    var cutoff ="controls/engines/engine[" ~ num ~ "]/cutoff";
    var n1 = "fdm/jsbsim/propulsion/engine[" ~ num ~ "]/n1";
    setprop(cutoff, 1);
    var check_loop = func {
        if (getprop(n1) < 20) {
            if (cont != nil) {
                cont();
            }
        }
        else {
            settimer(check_loop, 1);
        }
    }
    check_loop();
};

setlistener("/sim/model/autostart", func(idle) {
    if (idle.getBoolValue()) {
        start_engine(2,
        func { start_engine(3,
        func { start_engine(1,
        func { start_engine(0,
            nil)})})});
    }
    else {
        shutdown(0,
        func { shutdown(1,
        func { shutdown(2,
        func { shutdown(3,
            nil)})})});
    }
}, 0, 0);
