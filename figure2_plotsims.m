clear all; close all; clc
%code to plot results

load fig_results.mat

afsize = 9;  % axes numbering fontsize
lfsize = 9;  % x/y label fontsize
tfsize = 9;  % title fontsize
lw_lines = 1.5; % line linewidth line
lw_edge = 1; % fig edge linewidth
mksize = 15;  % markersize
g1 = [0.8 0.8 0.8]; % grey color for baseline

figure(1); clf
hh = gcf;
set(hh,'PaperUnits','centimeters');
set(hh,'Units','centimeters');
width = 15; height = 12;
xpos = 4;
ypos = 4;
set(gcf,'Position',[xpos ypos width height])

w = 0.35;
h = 0.28;
dx = 0.14;
dy = 0.22;
sx = 0.1;
sy = 0.09;

axes('position',[sx sy+h+dy w h])
    line([-0.2 1.5],[speed_basic_s speed_basic_s],'color',g1,'LineWidth',lw_lines)
    hold on
    plot(mu_s_vec,(speed_inst_s_all_1(:,end)),'k.','MarkerSize',mksize)
    box on
    axis([0 1.02 -0.02 0.8])
    xlabel('Herbivore Pressure (\mu_s)','FontSize',lfsize)
    ylabel('Spread speed','FontSize',lfsize)
    title('Syndrome [1]','FontSize',tfsize)
    set(gca,'FontSize',afsize,'LineWidth',lw_edge);
    
axes('position',[sx+w+dx sy+h+dy w h])
    line([-0.2 1.5],[speed_basic_s speed_basic_s],'color',g1,'LineWidth',lw_lines)
    hold on
    plot(mu_a_vec,speed_inst_s_all_2(:,end),'k.','MarkerSize',mksize)
    box on
    axis([0 1.02 -0.02 0.8])
    xlabel('Herbivore Pressure (\mu_a)','FontSize',lfsize)
    ylabel('Spread speed','FontSize',lfsize)
    title('Syndrome [2]','FontSize',tfsize)
    set(gca,'FontSize',afsize,'LineWidth',lw_edge);

axes('position',[sx sy w h])
    line([-0.6 0.2],[speed_basic_s speed_basic_s],'color',g1,'LineWidth',lw_lines)
    hold on
    plot(delta_vec_neg,speed_inst_s_all_3(:,end),'k.','MarkerSize',mksize)
    box on
    set(gca,'XTick',[-0.5 -0.25 0])
    set(gca, 'XDir','reverse')
    axis([-0.52 0.02 -0.02 0.8])
    xlabel('Herbivore Pressure (\delta)','FontSize',lfsize)
    ylabel('Spread speed','FontSize',lfsize)
    title('Syndrome [3]','FontSize',tfsize)
    set(gca,'FontSize',afsize,'LineWidth',lw_edge);

% label subpanels
axes('position',[0 0 1 1],'visible','off')
    hold on
     text(0.04,     0.06+sy+2*h+dy,'a)','horizontalalignment','center')
     text(0.04+dx+w,0.06+sy+2*h+dy,'b)','horizontalalignment','center')
     text(0.04,     0.06+sy+h,'c)','horizontalalignment','center')
axis([0 1 0 1])

%Backup previous settings
prePaperType = get(hh,'PaperType');
prePaperPosition = get(hh,'PaperPosition');
prePaperSize = get(hh,'PaperSize');

%Make changing paper type possible
set(hh,'PaperType','<custom>');
%Set the page size and position to match the figure's dimensions
position = get(hh,'Position');
set(hh,'PaperPosition',[0,0,position(3:4)]);
set(hh,'PaperSize',position(3:4));

%print -dtiff -r600 Fig1.tiff % save as 600dpi tiff
saveas(1,'fig2_results.jpg')

%Restore the previous settings
set(hh,'PaperType',prePaperType);
set(hh,'PaperPosition',prePaperPosition);
set(hh,'PaperSize',prePaperSize);

