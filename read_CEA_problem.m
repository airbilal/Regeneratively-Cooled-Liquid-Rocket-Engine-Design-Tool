function [comb_chamb_st,comb_chamb_end,throat,exitplane]=...
    read_CEA_problem(optimflag)
%function for reading output of NASA's Chemical Equilibrium and
%Applications (CEA) program
n=~(optimflag)*7;
FID = fopen(fullfile('fcea2','regenLRE1.plt'),'r');
while FID<0
    FID = fopen(fullfile('fcea2','regenLRE1.plt'),'r');
end
C=fscanf(FID,'%e');
    % fprintf(FID,'p t rho mw cp gam sonic\n');
    comb_chamb_st.p=C(1)*101325;comb_chamb_st.t=C(2);comb_chamb_st.rho=C(3);
    comb_chamb_st.mw=C(4);comb_chamb_st.cp=C(5)*1000;comb_chamb_st.gam=C(6);
    comb_chamb_st.sonic=C(7);
    comb_chamb_end.exist=0;
    if optimflag==0
        comb_chamb_end.exist=1;
        comb_chamb_end.p=C(n+1)*101325;comb_chamb_end.t=C(n+2);
        comb_chamb_end.rho=C(n+3);comb_chamb_end.mw=C(n+4);
        comb_chamb_end.cp=C(n+5)*1000;comb_chamb_end.gam=C(n+6);
        comb_chamb_end.sonic=C(n+7);
    end
    throat.p=C(n+8)*101325;throat.t=C(n+9);throat.rho=C(n+10);
    throat.mw=C(n+11);throat.cp=C(n+12)*1000;throat.gam=C(n+13);
    throat.sonic=C(n+14);

    exitplane.p=C(n+15)*101325;exitplane.t=C(n+16);exitplane.rho=C(n+17);
    exitplane.mw=C(n+18);exitplane.cp=C(n+19)*1000;exitplane.gam=C(n+20);
    exitplane.sonic=C(n+21);
fclose(FID);

FID = fopen(fullfile('fcea2','regenLRE2.plt'),'r');
while FID<0
    FID = fopen(fullfile('fcea2','regenLRE2.plt'),'r');
end
C=fscanf(FID,'%e');%   fprintf(FID,'vis cond pran mach ae cf isp\n');
    comb_chamb_st.vis=C(1)*1E-4;comb_chamb_st.cond=C(2)/10;comb_chamb_st.pran=C(3);
    comb_chamb_st.mach=C(4);comb_chamb_st.ae=C(5);comb_chamb_st.cf=C(6);
    comb_chamb_st.isp=C(7);
    if optimflag==0
        comb_chamb_end.vis=C(n+1)*1E-4;comb_chamb_end.cond=C(n+2)/10;
        comb_chamb_end.pran=C(n+3);comb_chamb_end.mach=C(n+4);
        comb_chamb_end.ae=C(n+5);comb_chamb_end.cf=C(n+6);
        comb_chamb_end.isp=C(n+7);
    end
    throat.vis=C(n+8)*1E-4;throat.cond=C(n+9)/10;throat.pran=C(n+10);
    throat.mach=C(n+11);throat.ae=C(n+12);throat.cf=C(n+13);
    throat.isp=C(n+14);

    exitplane.vis=C(n+15)*1E-4;exitplane.cond=C(n+16)/10;
    exitplane.pran=C(n+17);exitplane.mach=C(n+18);
    exitplane.ae=C(n+19);exitplane.cf=C(n+20);
    exitplane.isp=C(n+21);
fclose(FID);