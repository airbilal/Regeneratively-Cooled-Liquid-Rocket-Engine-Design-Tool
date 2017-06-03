function [cf,cstar,isp,propellants,tanks,geom]=...
    sizing_LRE(engine,nozzle,materials,requirements,comb_chamb_st,exitplane,fuel)
%This function sizes the Liquid rocket engine and nozzle
cf=exitplane.cf;%Thrust coefficient
cstar=exitplane.isp/cf;%characteristic velocity (m/s)
isp=exitplane.isp/9.81;%seconds (ideal)
propellants.Tf=comb_chamb_st.t;%Kelvin, adiabatic flame temperature
propellants.Ve=exitplane.mach*exitplane.sonic;
propellants.massflow=requirements.F/propellants.Ve;
tanks.oxidizer.massflow=propellants.massflow*engine.OF/(1+engine.OF);
tanks.oxidizer.mass=tanks.oxidizer.massflow*requirements.tb;
tanks.fuel(1).massflow=propellants.massflow/(1+engine.OF);
tanks.fuel(1).mass=tanks.fuel(1).massflow*requirements.tb;
tanks.fuel(1).volflow=tanks.fuel(1).massflow/fuel(1).rho;%volume flow rate of fuel
tanks.fuel(1).volume=tanks.fuel(1).mass/fuel(1).rho;%volume of fuel tank

at=requirements.F/exitplane.cf/comb_chamb_st.p;%area of throat
geom.nozzle.throat.dia=sqrt(at*4/pi);
volc=at*requirements.Lstar;
ac=at*requirements.acat;%area of combustion chamber
geom.comb_chamb.dia=sqrt(ac*4/pi);
geom.comb_chamb.length=(volc/at-sqrt(at/pi)*(requirements.acat^0.33-1)*...
    cotd(requirements.halfangle_con)/3)/requirements.acat;
ae=nozzle.aeat*at;
geom.nozzle.exit.dia=sqrt(ae*4/pi);
geom.tw=materials.wall.fos*comb_chamb_st.p*geom.comb_chamb.dia...
    /2/materials.wall.strength;%wall thickness
%Note: Stainless steel 316L can be exposed to 850C easily, with 42%
%strength remaining. http://www.ssina.com/composition/temperature.html
geom.x(1)=0;geom.x(2)=geom.x(1)+geom.comb_chamb.length;
geom.x(3)=geom.x(2)+cotd(requirements.halfangle_con)*...
    (geom.comb_chamb.dia-geom.nozzle.throat.dia)/2;
geom.x(4)=geom.x(3)+cotd(requirements.halfangle_div)*...
    (geom.nozzle.exit.dia-geom.nozzle.throat.dia)/2;
geom.yi(1)=geom.comb_chamb.dia/2;geom.yi(2)=geom.yi(1);
geom.yi(3)=geom.nozzle.throat.dia/2;geom.yi(4)=geom.nozzle.exit.dia/2;
geom.yo=geom.yi+geom.tw;
geom.throatcurv.radius=requirements.throatcurv*geom.nozzle.throat.dia/2;
geom.tins=geom.yi(1)-geom.yi;%if there is an insert in the nozzzle
% 
% %%
% %Injector design
%  injector.Cd=0.6;%discharge coefficient of injector
% % injector.area_total=oxidizer.massflow/injector.Cd/...
% %     sqrt(2*oxidizer.rho);
% 
