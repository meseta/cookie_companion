if(debug_mode) return true; // if debug_mode, we’re definitely in IDE
if(code_is_compiled()) return false; // if compiled, we’re definitely not
if(parameter_count() == 3 and parameter_string(1) == "-game") return true; // this tests for the IDE’s runner
return false; // I guess not