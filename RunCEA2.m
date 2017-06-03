function [comb_chamb_st,comb_chamb_end,throat,exitplane]=...
    RunCEA2(OF,aeatOFbest,requirements,fuel,oxidizer,optimflag)
for run=1:2
    write_CEA_problem(OF,aeatOFbest,requirements,fuel,oxidizer,run,optimflag);
    cd('fcea2');system('cea300.exe < fname.txt');cd('..');
end
[comb_chamb_st,comb_chamb_end,throat,exitplane]=...
    read_CEA_problem(optimflag);