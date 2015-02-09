%%%This Script is currently written for Band 2
% The important quantities after adjustments are _M meaning meters or _R
% meaning real quantities

a = 81;
StaticForce = zeros(1,a);
ActuatorStrain = zeros(1,a);

for i=1:a
    StaticForce(i) = mean(StaticVoltage(:,i));
    ActuatorStrain(i) = mean(StrainVoltage(:,i));
end
set(0,'DefaultTextFontSize',20)
set(0,'DefaultAxesFontSize',20)
set(0,'DefaultTextFontName','times')
set(0,'DefaultAxesFontName','times')
set(0,'DefaultLineLineWidth',1.5)
set(0,'DefaultAxesLineWidth',1.5)
set(0,'DefaultLineMarkerSize',8)
set(0,'DefaultAxesBox','on')
set(0,'DefaultFigureColor','w');

%First find the point at which the actuator begins to compress the system 
figure
plot(log(OffsetVoltage),log(StaticForce));
%from the log log plot we can see that the actuator begins compression at
%1.6V or at 17 of 81 steps (i.e. the point when slope changes)
start = 18;
finish = 81;
%Now adjust the offsets
StaticForce_N = (StaticForce(start:finish)-StaticForce(start-1))*4.09;
OffsetVoltage_R = OffsetVoltage(start:finish)-OffsetVoltage(start-1);
ActuatorStrain_M = (ActuatorStrain(start:finish)-ActuatorStrain(start-1))*1.2564e-6;

%use the curve fitting toolbox to find the power law relation between
%actuator strain and the static load for F = A(delta)^n 
% Coefficients (with 95% confidence bounds):
%        A =   2.138e+09  (1.659e+09, 2.616e+09)
%        n =       1.522  (1.504, 1.539)


% The 2.604 scaling is to change units to mm/s and the sqrt(2) factor is to
% change to absolute amplitude instead of RMS. 
DynForceAmpNear_N = DynForceAmpNear(:,start:finish)*sqrt(2)/8.8;
DynForceAmpFar_N = DynForceAmpFar(:,start:finish)*sqrt(2)/9.9;
DynForceAmpNear_N = DynForceAmpNear_N*1000;
DynForceAmpFar_N = DynForceAmpFar_N*1000;

%Theoretical Band Edge
figure(2)
% FreqBandEdgeTheory_kHz = 4.96*StaticForce_N.^(1/6);
FreqBandEdgeTheory_kHz = 4.96*StaticForce_N.^(1/6);
plot(StaticForce_N,FreqBandEdgeTheory_kHz);
z = ones(1,length(StaticForce_N))*max(max(DynForceAmpNear_N*100));

li1 = 0:10;
li2 = ones(1,11);
z2 = ones(1,11)*max(max(DynForceAmpNear_N*100));
%We could choose either Compression or Strain for this axis. Here I have
%chose Precompression only for simplicity and consistency
az = 0;
el = 90;
figure(1)

% plot3(StaticForce_N,FreqBandEdgeTheory_kHz,z,'k');hold on;
% plot3(li2*.32,li1,z2,'r');hold on; plot3(li2*.86,li1,z2,'r');hold on; plot3(li2*4.8,li1,z2,'r');hold on;
% p1 = surf(StaticForce_N,FrequencyHz/1000,DynForceAmpNear_N);hold off;
% xlim([min(StaticForce_N),max(StaticForce_N)]);
% ylim([min(FrequencyHz),max(FrequencyHz)]/1000);
% xlabel('Static Compression [N]');
% ylabel('Frequency [kHz]');
% set(gca,'Ydir','normal');
% set(p1,'LineStyle','None');
% set(gca,'xtick',[1 3 5 7]);
% view(az,el);
% colorbar
% % set(h,'ytick',[1 5 10]);
% figure (2)
% plot3(StaticForce_N,FreqBandEdgeTheory_kHz,z,'k');hold on;
% plot3(li2*.32,li1,z2,'r');hold on; plot3(li2*.86,li1,z2,'r');hold on; plot3(li2*4.8,li1,z2,'r');hold on;
% p2 = surf(StaticForce_N,FrequencyHz/1000,DynForceAmpFar_N);hold off;
% xlim([min(StaticForce_N),max(StaticForce_N)]);
% ylim([min(FrequencyHz),max(FrequencyHz)]/1000);
% xlabel('Static Compression [N]');
% ylabel('Frequency [kHz]');
% set(gca,'Ydir','normal');
% set(p2,'LineStyle','None');
% set(gca,'xtick',[1 3 5 7]);
% h = colorbar
% % set(h,'ytick',[0 10 20 30]);
% view(az,el);
figure
p1 = uimagesc(StaticForce_N,FrequencyHz/1000,DynForceAmpNear_N);hold on;
vline([.32 .86 4.8])
plot(StaticForce_N,FreqBandEdgeTheory_kHz,'k');hold on;
xlim([min(StaticForce_N),max(StaticForce_N)]);
ylim([min(FrequencyHz),max(FrequencyHz)]/1000);
xlabel('Static Compression [N]');
ylabel('Frequency [kHz]');
set(gca,'Ydir','normal');
set(gca,'xtick',[1 3 5 7]);
colorbar


figure 
p = uimagesc(StaticForce_N,FrequencyHz/1000,DynForceAmpFar_N);hold on;
vline([.32 .86 4.8])
plot(StaticForce_N,FreqBandEdgeTheory_kHz,'k');hold on;
xlim([min(StaticForce_N),max(StaticForce_N)]);
ylim([min(FrequencyHz),max(FrequencyHz)]/1000);
xlabel('Static Compression [N]');
ylabel('Frequency [kHz]');
set(gca,'Ydir','normal');
set(gca,'xtick',[1 3 5 7]);
colorbar

