function plotresults(geom,axialvariations,optim)
%%
x=axialvariations.x*1000;yi=geom.yi*1000;yo=geom.yo*1000;
M=axialvariations.M;T=axialvariations.T;
Taw=axialvariations.Taw.unc2;
P=axialvariations.P/101325;
rho=axialvariations.rho;
Twg1=axialvariations.Twg.unc1;
Two1=axialvariations.Two.unc1;
q1=axialvariations.q.unc1/1000;
hg1=axialvariations.hg.unc1/1000;
% Tinsg2=axialvariations.Tinsg.unc2;
% Twi2=axialvariations.Twi.unc2;
% Two2=axialvariations.Two.unc2;
% q2=axialvariations.q.unc2/1000;
% hg2=axialvariations.hg.unc2/1000;
%%
figure;
plot(optim.ofr,optim.tf);xlabel('Oxidizer to Fuel ratio');
ylabel('Combustion Temperature, K');grid on;
figure;plot(optim.ofr,optim.isp);xlabel('Oxidizer to Fuel ratio');
ylabel('Specific Impulse, sec');grid on;
%%
figure;
subplot(5,1,1);
plot(geom.x*1000,yi,'k',geom.x*1000,yo,'k');grid on;
title('Nozzle Countour');
subplot(5,1,2);plot(x,M);grid on;ylabel('Mach No');
subplot(5,1,3);plot(x,T,x,Taw);grid on;axis tight;
ylabel('T (K)');legend('Static Temp, T_c_e_n_t_e_r',...
    'Near Wall Temp, T_w_a','location','best');
subplot(5,1,4);plot(x,P);grid on;
ylabel('P (bar)');
subplot(5,1,5);plot(x,rho);grid on;
ylabel('\rho (kg/m^3)');
%%
%%
figure;
subplot(4,1,1);
plot(geom.x*1000,yi,'k',geom.x*1000,yo,'k');grid on;
title('Nozzle Countour');axis tight;
subplot(4,1,2);plot(x,Taw,'r',x,Twg1,'g',x,Two1,'b');
grid on;axis tight;axis tight;
ylabel('T (K)');legend('Near Wall Gas, T_a_w',...
    'Inner Wall Temp, T_w_g','Outer Wall Temp, T_w_o','location','best');
subplot(4,1,3);plot(x,q1);grid on;axis tight;
ylabel('Flux (KW/m^2)');
subplot(4,1,4);plot(x,hg1);grid on;axis tight;
ylabel('h_g  (KW/m^2/K)');
%%
% figure;
% subplot(4,1,1);
% plot(geom.x*1000,yi,'k',geom.x*1000,yo,'k');grid on;
% title('Nozzle Countour');axis tight;
% subplot(4,1,2);plot(x,Taw,'r',x,Tinsg2,'g--',x,Twi2,'g',x,Two2,'b');
% grid on;axis tight;
% ylabel('T (K)');legend('Near Wall Gas, T_a_w','Insert, near gas, T_i_n_s_g',...
%     'Interface Temp, T_w_i','Outer Wall Temp, T_w_o','location','best');
% subplot(4,1,3);plot(x,q2);grid on;axis tight;
% ylabel('Flux (KW/m^2)');
% subplot(4,1,4);plot(x,hg2);grid on;axis tight;
% ylabel('h_g  (KW/m^2/K)');