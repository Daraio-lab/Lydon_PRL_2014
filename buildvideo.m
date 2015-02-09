close all
% figure
set(0,'DefaultTextFontSize',20)
set(0,'DefaultAxesFontSize',20)
set(0,'DefaultTextFontName','times')
set(0,'DefaultAxesFontName','times')
set(0,'DefaultLineLineWidth',1.5)
set(0,'DefaultAxesLineWidth',1.5)
set(0,'DefaultLineMarkerSize',8)
set(0,'DefaultLineColor','b');
set(0,'DefaultAxesBox','on')
set(0,'DefaultFigureColor','w');

a = 100;
b = 800;
figure('position',[a a 2*b b])
make_movie = 1;
if(exist('make_movie','var'));
    filename = 'hexmovie2.gif';
end

% xlin = linspace(-size/2,size/2,m);
xlin = linspace(min(Pointx),max(Pointx),m);
ylin = linspace(min(Pointy),max(Pointy),m);
[X,Y] = meshgrid(xlin,ylin);

% hold off
% figure(1);
mode1 = 1;
mode2 = 2;
min1 = min(min(mats{1}(1:m,mode1)));
max1 = max(max(mats{length(foo)}(1:m,mode1)));
lims = [-max1 -min1*1.5];

az = -55;
e = 16;
%%
V2 = mats{1};
idiotimes = diag(omegas{1});

if V2(1,mode1)<0
    V2(:,mode1) = V2(:,mode1)*-1;
end
if V2(1,mode2)<0
    V2(:,mode2) = V2(:,mode2)*-1;
end
scale = 1;
subplot(121);
qq = scatter(Pointx,Pointy,30,sqrt(V2(1:m,mode1).^2 + V2(1+m:2*m,mode1).^2),'o','MarkerFaceColor','flat'); hold on;axis square;
ww = quiver(Pointx,Pointy,V2(1:m,mode1)',V2(m+1:2*m,mode1)',scale,'k'); hold off;
% title('Defect Mode - Longitudinal')
clear title;
title(sprintf('Vectorized\nDisplacements'))


xlim([-size,size])
ylim([-size,size]);

subplot(122)
% Zmag = griddata(Pointx,Pointy,V2(1:m,mode).^2+V2(m+1:2*m,mode).^2,X,Y,'cubic');
Zmag = griddata(Pointx,Pointy,sqrt((V2(1:m,mode1).^2+V2(m+1:2*m,mode1).^2)).*sign(V2(1:m,mode1)),X,Y,'cubic');
ee = mesh(X,Y,Zmag); axis tight; box off; axis square;
% axis off;
zlim(lims*1.4)
caxis(lims)
view([az e]);
clear title;
title(sprintf('Corresponding\nAmplitudes'))


% subplot(223);
% rr = scatter(Pointx,Pointy,30,sqrt(V2(1:m,mode2).^2 + V2(1+m:2*m,mode2).^2),'o','MarkerFaceColor','flat'); hold on;axis square;
% tt = quiver(Pointx,Pointy,V2(1:m,mode2)',V2(m+1:2*m,mode2)','k');
% % title('Defect Mode - Transverse')
% xlim([-size,size])
% ylim([-size,size]);
% 
% subplot(224)
% Zmag2 = griddata(Pointx,Pointy,sqrt((V2(1:m,mode2).^2+V2(m+1:2*m,mode2).^2)).*sign(V2(1:m,mode2)),X,Y,'cubic');
% yy = mesh(X,Y,Zmag2); axis tight; box off;
% zlim(lims*.8)
% caxis(lims)
% view([az e]);

% h = figtitle(sprintf('Defect Mode Delocalization\n By Isotropic Compression'));


    
%%
start = 1;
step = 5;
finish = 300;
for i = start:step:finish;
V2 = mats{i};
% idiotimes = diag(omegas{i});
if V2(1,mode1)<0
    V2(:,mode1) = V2(:,mode1)*-1;
end
if V2(1,mode2)<0
    V2(:,mode2) = V2(:,mode2)*-1;
end
set(qq, 'CData',sqrt(V2(1:m,mode1).^2 + V2(1+m:2*m,mode1).^2));
set(ww, 'UData',V2(1:m,mode1)','VData',V2(m+1:2*m,mode1)');
Zmag = griddata(Pointx,Pointy,sqrt((V2(1:m,mode1).^2+V2(m+1:2*m,mode1).^2)).*sign(V2(1:m,mode1)),X,Y,'cubic');
set(ee, 'Zdata',Zmag);
% if(i<110)
% set(rr, 'CData',sqrt(V2(1:m,mode2).^2 + V2(1+m:2*m,mode2).^2));
% set(tt, 'UData',V2(1:m,mode2)','VData',V2(m+1:2*m,mode2)');
% Zmag2 = griddata(Pointx,Pointy,sqrt((V2(1:m,mode2).^2+V2(m+1:2*m,mode2).^2)).*sign(V2(1:m,mode2)),X,Y,'cubic');
% set(yy, 'Zdata',Zmag2);
% end
drawnow

    set(gcf, 'Renderer', 'zbuffer');
    set(gcf, 'Color', [1 1 1])
    pause(.1);
    if(exist('make_movie','var'));
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i ==start;
        imwrite(imind,cm,filename,'gif','Loopcount',inf,'WriteMode','overwrite');
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',.1');
    end
    
    end

% drawnow

% pause(.1)
end
