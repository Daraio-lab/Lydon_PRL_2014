% build paper figures 
set(0,'DefaultTextFontSize',20)
set(0,'DefaultAxesFontSize',20)
set(0,'DefaultTextFontName','times')
set(0,'DefaultAxesFontName','times')
set(0,'DefaultLineLineWidth',1.5)
set(0,'DefaultAxesLineWidth',1.5)
set(0,'DefaultLineMarkerSize',8)
set(0,'DefaultAxesBox','on')
set(0,'DefaultFigureColor','w');
%modevideos

% figure(1);
% plot(ActuatorStrain,(StaticForce-StaticForce(1))*4.09)
% ylabel('Static Compression [N]');
% xlabel('Actuator Strain [V]');
% ylim([-.2 max((StaticForce-StaticForce(1))*4.09)*1.1]);
% plot((OffsetVoltage),(StaticForce))

start = 1;
finish = 240;
StaticForce_N = (StaticForce(start:finish)-StaticForce(start))*4.09;
OffsetVoltage_R = OffsetVoltage(start:finish)-OffsetVoltage(start);
ActuatorStrain_M = (ActuatorStrain(start:finish)-ActuatorStrain(start))*1.2564e-6;
Amplitude_Vel = Amplitude*sqrt(2)*2.604;
% Amplitude_Vel = Amplitude_Vel*1000;

%First Adjust Phase and scale amplitude for calibration factor (2mm/s/V) and RMS
Phase_adj = zeros(16,240);
for i=1:240
    Phase_adj(:,i) = Phase(:,i)-Phase(16,i);
end

figure(1);
maximum = max(max(Amplitude_Vel));
mode = Amplitude_Vel(:,1).*cos(Phase_adj(:,1)); sym_mode = [mode ; mode(15:-1:1)];
h = plot(sym_mode,'-o');
xlim([1 31]);
ylim(maximum*[-.8 1.1]);
xlabel('Bead #');
ylabel('Velocity \mu/s');
%Loop through Precompressions


make_movie = 1;
if(exist('make_movie','var'));
    filename = 'movie4.gif';
end

for i = 20:150
    mode = Amplitude_Vel(:,i).*cos(Phase_adj(:,i)); 
    sym_mode = [mode ; mode(15:-1:1)];
    set(h,'ydata',sym_mode);
    title(strcat(['Static Compression = ' num2str(StaticForce_N(i),'%02.2f'), 'N']));
    pause(.1);
    
    
    if(exist('make_movie','var'));
    drawnow
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i ==20;
        imwrite(imind,cm,filename,'gif','Loopcount',inf,'WriteMode','overwrite');
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',.1');
    end
    end
end


% % 
% % make_movie = 1;
% % if(exist('make_movie','var'));
% %     filename = 'movie.gif';
% % end
% % 
% % for t = 0:.2:4*pi; 
% %     for i = 1:7;
% %     mode(:,i) = (Bead_Velocities(:,i)/max(Bead_Velocities(:,i))).*cos(t+Bead_Phases(:,i)*pi/180); 
% %     subplot(row,col,i+1)
% %     plot([0:8],[0 mode(:,i)' 0],'-o');
% %     set(gca,'Xtick',[],'Ytick',[]);
% %     xlim([0 8])
% %     ylim(1.2*[-1,1]);
% %     title(strcat(num2str(Mode_Frequencies(i)),'Hz'));
% %     end
% % %     
% %     if(exist('make_movie','var'));
% %     drawnow
% %     frame = getframe(1);
% %     im = frame2im(frame);
% %     [imind,cm] = rgb2ind(im,256);
% %     if t ==0;
% %         imwrite(imind,cm,filename,'gif','Loopcount',inf,'WriteMode','overwrite');
% %     else
% %         imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',.1');
% %     end
% %     end
% %     
% % %     pause(.02);
% % end

