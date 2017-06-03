function [OFbest,aeatOFbest,comb_chamb_st,comb_chamb_end,...
    throat,exitplane,optim]=ofr_optim(stoich,requirements,fuel,oxidizer)
%This function searches for the o/f ratio which gives the best 
%specific impulse. It is not equal to stoichiometric o/f, in general
% (c) Dr. Bilal Siddiqui 2017
optimflag=1;%doing optimization....need to find nozzle area ratio
optim.ofr=1:0.1:stoich.OF*2;
for ind=1:length(optim.ofr)
    [comb_chamb,~,~,exitplane]=...
        RunCEA2(optim.ofr(ind),[],requirements,fuel,oxidizer,optimflag);
    optim.tf(ind)=comb_chamb.t;%Kelvin, adiabatic flame temperature
    optim.isp(ind)=exitplane.isp/9.81;
    Mexit(ind)=exitplane.mach;
    aeat(ind)=exitplane.ae;
end
%%
OFbest=2;%optim.ofr(optim.isp==max(optim.isp));
aeatOFbest=aeat(optim.ofr==2);%aeat(optim.isp==max(optim.isp));
optimflag=0;%Done with optimization, want final value
[comb_chamb_st,comb_chamb_end,throat,exitplane]=...
        RunCEA2(OFbest,aeatOFbest,requirements,fuel,oxidizer,optimflag);