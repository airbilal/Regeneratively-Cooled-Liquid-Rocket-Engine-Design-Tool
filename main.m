clc;close all;clear;fclose('all');
%%
% A code developed for 
% Regeneratively cooled Liquid Rocket Engine Design 
% by Dr. Bilal A. Siddiqui,
% Mechanical Engineering Department,
% DHA Suffa University
% Copyrights, Bilal Siddiqui @ 2017 under MIT Liscence
%%
addpath('./fcea2');
requirements.F=convforce(250,'lbf','N');%newtons, required thrust
requirements.tb=10;%seconds, required burn time
requirements.pinj=20.4;%injection pressure (into combustor) in bars
requirements.pexit=1;%nozzle exit pressure (design point) in bars
requirements.Lstar=60*25.4/1000;%characteristic length of combustion chamer
requirements.acat=9;%contraction ratio, Ac/At
requirements.halfangle_con=45;%half angle of convergent side
requirements.halfangle_div=15;%half angle of divergent side
requirements.throatcurv=1;%ratio of curvature at throat to throat radius [0.5-1.5]

materials.wall.grade='SS 316-L';%%SS 316-L
materials.wall.servtemp=1100;%1100 K for 316L%service temp, K, i.e. around 525C
materials.wall.strength=120E6;%120E6 for 316L%yield strength, Pascals, at 525C
materials.wall.fos=4.5;%factor of safety
materials.wall.cond=20;%20 for 316L%Thermal Conductivity, W/m2/K

oxidizer.name='O2';
oxidizer.carbon=0;
oxidizer.oxygen=2;
oxidizer.nitrogen=0;
oxidizer.hydrogen=0;
oxidizer.formula='O2';
oxidizer.composition=[oxidizer.carbon oxidizer.oxygen oxidizer.nitrogen oxidizer.hydrogen]';
oxidizer.molecularmass=oxidizer.carbon*12+oxidizer.oxygen*16+oxidizer.nitrogen*12+...
    oxidizer.hydrogen*1;
oxidizer.gamma=1.4;% ratio of specific heats
oxidizer.hf=0;% ratio of specific heats
fuel(1).name='n-octane';
fuel(1).carbon=8;
fuel(1).oxygen=0;
fuel(1).nitrogen=0;
fuel(1).hydrogen=2+2*fuel(1).carbon;
fuel(1).formula=['C' num2str(fuel(1).carbon) 'H' num2str(fuel(1).hydrogen)];
fuel(1).composition=[fuel(1).carbon fuel(1).oxygen fuel(1).nitrogen fuel(1).hydrogen]';
fuel(1).fraction=1;
fuel(1).molecularmass=fuel(1).carbon*12+fuel(1).oxygen*16+fuel(1).nitrogen*12+...
    fuel(1).hydrogen*1;
fuel(1).hf=-250.5;%heat of formation, kJ/mol
fuel(1).rho=720;%fuel density, kg/m3
combustionproduct(1).carbon=1;
combustionproduct(1).oxygen=2;
combustionproduct(1).nitrogen=0;
combustionproduct(1).hydrogen=0;
combustionproduct(1).formula='CO2';
combustionproduct(2).carbon=0;
combustionproduct(2).oxygen=1;
combustionproduct(2).nitrogen=0;
combustionproduct(2).hydrogen=2;
combustionproduct(2).formula='H20';

engine.outside.h=100;%convection heat transfer from rocket outer surface; 100 for natural
engine.outside.Ta=300;%ambient temperature, K
%%
%Perform stoichiometric calculations for ideal oxidizer/fuel ratio
stoich=stoichometry(fuel,oxidizer,combustionproduct);
%%
%Optimize the fuel air ratio for the best specific impulse at given Pc
[engine.OF,nozzle.aeat,comb_chamb_st,comb_chamb_end,...
    throat,exitplane,optim]=ofr_optim(stoich,requirements,fuel,oxidizer);
%%
%Sizing the engine
[engine.cf,engine.cstar,engine.isp,propellants,tanks,geom]=...
    sizing_LRE(engine,nozzle,materials,requirements,...
    comb_chamb_st,exitplane,fuel);
%%
% Axial variation of parameters
axialvariations=...
    isentrpy(geom,comb_chamb_st,comb_chamb_end,throat,exitplane);
%%
%Heat Transfer Calculations
[axialvariations.Taw.unc1,axialvariations.Twg.unc1,axialvariations.Two.unc1,...
    axialvariations.q.unc1,axialvariations.hg.unc1]=heat_transfer_unc1(materials,...
    geom,engine,comb_chamb_st,axialvariations);
%%
%Plot results
plotresults(geom,axialvariations,optim);
%%
save regenLREdata;