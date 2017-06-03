function axialvariations=...
    isentrpy(geom,comb_chamb_st,comb_chamb_end,throat,exitplane)
%This function calculates the variation of gas parameters with axial 
%distance. Corrections are made in favor of CEA predictions 
xcc=linspace(geom.x(1),geom.x(2),10);%axial locations in combustion chamber
xnc=linspace(geom.x(2),geom.x(3),50);%axial locations in nozzle  convergent
xnd=linspace(geom.x(3),geom.x(4),50);%axial locations in nozzle  divergent
axialvariations.x=[xcc xnc xnd];
axialvariations.tins=interp1(geom.x,geom.tins,axialvariations.x);
dcc=2*geom.yi(1)*ones(size(xcc));
dnc=2*interp1([geom.x(2) geom.x(3)],[geom.yi(2) geom.yi(3)],xnc);%dia, Nozzle convergent section
dnd=2*interp1([geom.x(3) geom.x(4)],[geom.yi(3) geom.yi(4)],xnd);%dia, Nozzle divergent section
a_ratio.nc=(dnc/min(dnc)).^2;
a_ratio.nd=(dnd/min(dnd)).^2;
gam=interp1([geom.x(1) geom.x(2)],...
    [comb_chamb_st.gam comb_chamb_end.gam],xcc);%Cp/Cv in comb ch
gam=[gam interp1([geom.x(2) geom.x(3)],...
    [comb_chamb_st.gam throat.gam],xnc)];%Cp/Cv in con nozzle
gam=[gam interp1([geom.x(3) geom.x(4)],...
    [throat.gam exitplane.gam],xnd)];%Cp/Cv in divergent nozzle
%%
[~,Tr, Pr, rhor,~] = ...
      flowisentropic(throat.gam,1, 'sub');
correct.T.throat=throat.t-Tr*comb_chamb_st.t;
correct.P.throat=throat.p-Pr*comb_chamb_st.p;
correct.rho.throat=throat.rho-rhor*comb_chamb_st.rho;
[Mi,Tr, Pr, rhor,~] = ...
      flowisentropic(exitplane.gam,a_ratio.nd(end), 'sup');
correct.M.exit=exitplane.mach-Mi;
correct.T.exit=exitplane.t-Tr*comb_chamb_st.t;
correct.P.exit=exitplane.p-Pr*comb_chamb_st.p;
correct.rho.exit=exitplane.rho-rhor*comb_chamb_st.rho;
correction.T.nc=interp1([geom.x(2) geom.x(3)],[0 correct.T.throat],xnc);
correction.P.nc=interp1([geom.x(2) geom.x(3)],[0 correct.P.throat],xnc);
correction.rho.nc=interp1([geom.x(2) geom.x(3)],[0 correct.rho.throat],xnc);
correction.M.nd=interp1([geom.x(3) geom.x(4)],...
    [0 correct.M.exit],xnd);
correction.T.nd=interp1([geom.x(3) geom.x(4)],...
    [correct.T.throat correct.T.exit],xnd);
correction.P.nd=interp1([geom.x(3) geom.x(4)],...
    [correct.P.throat correct.P.exit],xnd);
correction.rho.nd=interp1([geom.x(3) geom.x(4)],...
    [correct.rho.throat correct.rho.exit],xnd);
%%
axialvariations.M=interp1([geom.x(1) geom.x(2)],...
    [comb_chamb_st.mach comb_chamb_end.mach],xcc);%Mach no in comb cham
axialvariations.T=interp1([geom.x(1) geom.x(2)],...
    [comb_chamb_st.t comb_chamb_end.t],xcc);%Temp(K) number in comb cham
axialvariations.P=interp1([geom.x(1) geom.x(2)],...
    [comb_chamb_st.p comb_chamb_end.p],xcc);%Pressure(Pa) in comb cham
axialvariations.rho=interp1([geom.x(1) geom.x(2)],...
    [comb_chamb_st.rho comb_chamb_end.rho],xcc);%Density(kg/m3) in comb cham
k1=length(xcc);
for k2=k1+1:k1+length(xnc)
  [axialvariations.M(k2), T_tt, P_pt, rho_rt,~] = ...
      flowisentropic(gam(k2), a_ratio.nc(k2-k1),'sub');
  axialvariations.T(k2)=T_tt*comb_chamb_st.t+0*correction.T.nc(k2-k1);
  axialvariations.P(k2)=P_pt*comb_chamb_st.p+correction.P.nc(k2-k1);
  axialvariations.rho(k2)=rho_rt*comb_chamb_st.rho+correction.rho.nc(k2-k1);
end
for k3=k2+1:k2+length(xnd)
  [axialvariations.M(k3), T_tt, P_pt, rho_rt,~] = ...
      flowisentropic(gam(k3), a_ratio.nd(k3-k2), 'sup');
  axialvariations.M(k3)=axialvariations.M(k3)+correction.M.nd(k3-k2);
  axialvariations.T(k3)=T_tt*comb_chamb_st.t+0*correction.T.nd(k3-k2);
  axialvariations.P(k3)=P_pt*comb_chamb_st.p+correction.P.nd(k3-k2);
  axialvariations.rho(k3)=rho_rt*comb_chamb_st.rho+correction.rho.nd(k3-k2);
end
%%
Pr=interp1([geom.x(1) geom.x(2)],...
    [comb_chamb_st.pran comb_chamb_end.pran],xcc);%Prandtl Number in comb ch
Pr=[Pr interp1([geom.x(2) geom.x(3)],...
    [comb_chamb_st.pran throat.pran],xnc)];%Prandtl Number in con nozzle
Pr=[Pr interp1([geom.x(3) geom.x(4)],...
    [throat.pran exitplane.pran],xnd)];%Prandtl Number in div nz
Cpg=interp1([geom.x(1) geom.x(2)],...
    [comb_chamb_st.cp comb_chamb_end.cp],xcc);%Cp in comb ch
Cpg=[Cpg interp1([geom.x(2) geom.x(3)],...
    [comb_chamb_st.cp throat.cp],xnc)];%Cp in con nozzle
Cpg=[Cpg interp1([geom.x(3) geom.x(4)],...
    [throat.cp exitplane.cp],xnd)];%Cp in div nz
vis=interp1([geom.x(1) geom.x(2)],...
    [comb_chamb_st.vis comb_chamb_end.vis],xcc);%Viscosity in comb ch
vis=[vis interp1([geom.x(2) geom.x(3)],...
    [comb_chamb_st.vis throat.vis],xnc)];%Viscosity in con nozzle
vis=[vis interp1([geom.x(3) geom.x(4)],...
    [throat.vis exitplane.vis],xnd)];%Viscosity in div nz
axialvariations.d=[dcc dnc dnd];
axialvariations.pran=Pr;axialvariations.Cpg=Cpg;axialvariations.vis=vis;
axialvariations.gam=gam;