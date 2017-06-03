function [Taw,Twg,Two,q,hg]=heat_transfer(materials,...
    geom,engine,comb_chamb_st,axialvariations)
%%
% This function calculates heat transfer coefficients 
%and temperatures
%%
x=axialvariations.x;
d=axialvariations.d;%diameters of engine
Mx=axialvariations.M;
P=axialvariations.P;%Pressure
gam=axialvariations.gam;
vis=axialvariations.vis;
Pr=axialvariations.pran;%Prandtl number
Cpg=axialvariations.Cpg;
cs=engine.cstar;
Tc=comb_chamb_st.t;%stagnation temperature in chamber, K
dt=geom.nozzle.throat.dia;
rtc=geom.throatcurv.radius;%radius of curvature at throat;
%%
%Calculate Adiabatic Temperature of the gas, near the wall
recov=Pr.^0.33;%recovery factor for turbulent flow, p 85 of Huzel 1992
k=(gam-1)/2;
Taw=Tc*(1+k.*recov.*Mx.^2)./(1+k.*Mx.^2);
%Calculate forced convection heat transfer from gas to wall
C=0.0417/dt^0.2*(vis(1)^0.2*Cpg(1)/Pr(1)^0.6)*(P(1)/cs)^0.8...
    *(dt/rtc)^0.1*(dt./d).^1.8;
param.ha=engine.outside.h;%heat transfer coefficient of free convection from nozzle outer boundary
param.cond=materials.wall.cond;
param.t=geom.tw;
param.Ta=engine.outside.Ta;%ambient temperature, K
param.Tc=Tc;
for ind=1:length(x)
    param.C=C(ind);
    param.Taw=Taw(ind);
    param.k=k(ind);
    param.Mx=Mx(ind);
    Tfun = @(Twg,param) param.C*(Twg/param.Tc*...
        (1+param.k*param.Mx^2)+1)^(-0.68)*(param.Taw-Twg)-...
        param.ha*(param.ha*param.Ta*param.t+param.cond*Twg)/...
        (param.ha*param.t+param.cond)+param.ha*param.Ta;
    fun = @(Twg) Tfun(Twg,param);    % function of T alone
    Twg(ind) = fzero(fun,Taw(ind));
    hg(ind)=param.C*(Twg(ind)/param.Tc*...
        (1+param.k*param.Mx^2)+1)^(-0.68);
    q(ind)=hg(ind)*(param.Taw-Twg(ind));
    Two(ind)=Twg(ind)-q(ind)*param.t/param.cond;
end