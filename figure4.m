clear all
% code to do analytics


nu = 0.5;     % dispersal variance
sigma_s = 0.9;   % annual seed survival
gamma = 0.9;     % annual germination
sigma_a = 0.5;   % annual adult survival
phi = 5;         % annual adult fecundity (seed production)

kflag = 1; % which dispersal kernel to use: 1=gaussian; 2=laplace

    %herbivore inputs
    mu_g_vec_ana = linspace(0,1,101);
    mu_a_vec_ana = linspace(0,1,101);
    mu_s_vec_ana = linspace(0,1,101);
    delta_vec_pos_ana = linspace(0,2,101);
    
    
    %%%%%%%%%%%%%  BASIC VALUE [baseline]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
    cstar = analytic_speed_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta);
    cstar_basic = cstar; % find the minimum value

    %%%%%%%%%%%%%  PRE-DISPERSAL SEED CONSUMPTION + SEED DISPERSAL [scenario 4]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(mu_s_vec_ana)
            for ii = 1:length(delta_vec_pos_ana)
                mu_s = mu_s_vec_ana(i);
                delta = delta_vec_pos_ana(ii);
                cstar = analytic_speed_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta);
                cstar_all_double_4(i,ii) = cstar; % find the minimum value
            end
        end

    %%%%%%%%%%%%%  ADULT CONSUMPTION + SEED DISPERSAL [scenario 5]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(mu_a_vec_ana)
            for ii = 1:length(delta_vec_pos_ana)
                mu_a = mu_a_vec_ana(i);
                delta = delta_vec_pos_ana(ii);
                cstar = analytic_speed_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta);
                cstar_all_double_5(i,ii) = cstar; % find the minimum value
            end
        end


    %%%%%%%%%%%%%  SEEDLING CONSUMPTION + SEED DISPERSAL [scenario 6]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(mu_g_vec_ana)
            for ii = 1:length(delta_vec_pos_ana)
                mu_g = mu_g_vec_ana(i);
                delta = delta_vec_pos_ana(ii);
                cstar = analytic_speed_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta);
                cstar_all_double_6(i,ii) = cstar; % find the minimum value
            end
        end

%set zeros to NaN
cstar_all_double_4(cstar_all_double_4==0)=NaN;
cstar_all_double_5(cstar_all_double_5==0)=NaN;
cstar_all_double_6(cstar_all_double_6==0)=NaN;

%%


afsize = 9;  % axes numbering fontsize
lfsize = 9;  % x/y label fontsize
tfsize = 9;  % title fontsize
lw_lines = 1.5; % line linewidth line
lw_edge = 1; % fig edge linewidth
mksize = 15;  % markersize

mymap = cool;
mymap = [1 1 1; mymap]; % add white for lowest values
%%
figure(1); clf
colormap(mymap)
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

xx = 20;
yy = 20;
mu_s_vec_ana2 = fliplr(mu_s_vec_ana);
mu_a_vec_ana2 = fliplr(mu_a_vec_ana);
mu_g_vec_ana2 = fliplr(mu_g_vec_ana);

axes('position',[sx sy+h+dy w h])
    imagesc(flipud(cstar_all_double_4-cstar_basic),[-0.4 0.4])
    colorbar
    set(gca,'XTick',1:xx:length(delta_vec_pos_ana))
    set(gca,'XTickLabel',delta_vec_pos_ana(1:xx:end))
    set(gca,'YTick',1:yy:length(mu_s_vec_ana2))
    set(gca,'YTickLabel',mu_s_vec_ana2(1:yy:end))
    xlabel('Herbivore Pressure (\delta)','FontSize',lfsize)
    ylabel('Herbivore Pressure (\mu_s)','FontSize',lfsize)
    title('Syndrome [4]','FontSize',tfsize)
    set(gca,'FontSize',afsize,'LineWidth',lw_edge);

axes('position',[sx+w+dx sy+h+dy w h])
    imagesc(flipud(cstar_all_double_5-cstar_basic),[-0.4 0.4])
    colorbar
    set(gca,'XTick',1:xx:length(delta_vec_pos_ana))
    set(gca,'XTickLabel',delta_vec_pos_ana(1:xx:end))
    set(gca,'YTick',1:yy:length(mu_a_vec_ana2))
    set(gca,'YTickLabel',mu_a_vec_ana2(1:yy:end))
    xlabel('Herbivore Pressure (\delta)','FontSize',lfsize)
    ylabel('Herbivore Pressure (\mu_a)','FontSize',lfsize)
    title('Syndrome [5]','FontSize',tfsize)
    set(gca,'FontSize',afsize,'LineWidth',lw_edge);

axes('position',[sx sy w h])
    imagesc(flipud(cstar_all_double_6-cstar_basic),[-0.4 0.4])
    set(gca,'XTick',1:xx:length(delta_vec_pos_ana))
    set(gca,'XTickLabel',delta_vec_pos_ana(1:xx:end))
    set(gca,'YTick',1:yy:length(mu_g_vec_ana2))
    set(gca,'YTickLabel',mu_g_vec_ana2(1:yy:end))
    colorbar
    xlabel('Herbivore Pressure (\delta)','FontSize',lfsize)
    ylabel('Herbivore Pressure (\mu_g)','FontSize',lfsize)
    title('Syndrome [6]','FontSize',tfsize)
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
saveas(1,'fig4.jpg')

%Restore the previous settings
set(hh,'PaperType',prePaperType);
set(hh,'PaperPosition',prePaperPosition);
set(hh,'PaperSize',prePaperSize);


