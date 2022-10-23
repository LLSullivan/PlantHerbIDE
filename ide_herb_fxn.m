function [speed_inst_s,speed_inst_a,xleft_s,xleft_a,xright_s,xright_a] = ide_herb_fxn(var_0,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta,gflag)
%
%
% inputs: 
%   var_0 = dispersal kernel variance
%   sigma_s = annual seed survival
%   sigma_a = annual adult survival
%   gamma = annual germination
%   phi = annual fecundity (seeds produced)
%   mu_g = seedling consumption during germination (after dispersal)
%   mu_a = adult consumption
%   mu_s = seed consumption pre-dispersal
%   delta = change to dispersal kernel variance by herbivores
%   gflag = whether (1) or not (0) to show graphics
%
%
%
% last updated: 18 May 2022 (by Allison K Shaw)
% July 2015 (by Lauren L Sullivan)
% modified from basic IDE model by Michael Neubert (2/8/2022) to include a
% stage-structured model with plant herbivory
%
% x = vector of node locations
% x2 = vector of node locations for extended domain
% dx = internode distance
% n = matrix of population densities
% k = dispersal kernel
% f = growth function


%-----PARAMETERS----------------------------------------------------------%
    diameter = 1200;   % length of the domain
    nodes = (2^15)+1;  % number of nodes in domain (should be 2^m + 1)
    lowval = 1e-15;    % truncation threshold for too small population values
    ncrit = 0.05;      % critical threshold for edge of wave
    %
    irad = 5; % radius of initial condition
    idens = 0.8; % initial density
    iterations = 250; % number of iterations to perform
%-----PARAMETERS----------------------------------------------------------%
  
  radius = diameter/2;
  x = linspace(-radius,radius,nodes);
  x2 = linspace(-diameter,diameter,2*nodes-1);
  dx = diameter/(nodes-1);
  ns = zeros(1,length(x));
  na = zeros(1,length(x));
  
  %seeds
  xright_s = zeros(1,iterations+1); % left wave location
  xleft_s = zeros(1,iterations+1); % right wave location
  [speed_av_s,speed_inst_s] = deal(zeros(1,iterations)); % wave speed
  
  %adults
  xright_a = zeros(1,iterations+1); % left wave location
  xleft_a = zeros(1,iterations+1); % right wave location
  [speed_av_a,speed_inst_a] = deal(zeros(1,iterations)); % wave speed

  %Dispersal kernel
  k = normpdf(x2,0,sqrt(var_0 + delta)); % gaussian kernel
  
  
%SET THE INITIAL CONDITIONS
  ns = zeros(size(ns)); %seeds
  na = zeros(size(na)); %adults
  
  temp = find(abs(x) <= irad);
  
  ns(temp) = idens*normpdf(x(temp),0,1);
  na(temp) = idens*normpdf(x(temp),0,1);
  
%PLOT INITIAL CONDITIONS AND WAIT FOR KEYSTRIKE

if gflag==1
    figure(1); clf
    plot(x,ns,'--');
    hold on 
    plot(x,na,'r');
    xlabel('location (x)'); ylabel('population density [ n_{t} (x) ]');
    title('t = 0');
    %axis([xmin xmax ymin ymax]);
    drawnow;
    disp('Strike any key when ready...');
end

%DO THE SIMULATION ITERATIONS  
n1 = zeros(1,length(x2)+length(x)-1);

for j = 1:iterations
    
    n1 = zeros(size(n1));

    %%GROWTH

    %Some seeds remain in the seedbank
    ns_bank = ns.*(sigma_s*(1-gamma)); %will become ns next time step

    %Seeds germinate to adults and are consumed by seed predators
    nj_mature = ns.*((sigma_s*gamma)*(1-mu_g)); %will become na next time step
    
    %Adults maintain, are consumed, and reproduce
    na_mature = na.*(sigma_a*(1-mu_a)); %will become able to reproduce but stay as na next time step
    
    %Adults reproduce
    na_off = na_mature.*(phi*(1-mu_s)*exp(-(na_mature))); %will become dispersing seeds
    
    %New seeds disperse
    n1 = fft_conv(k,na_off);   % dispersing individuals - will become seeds next time step
    n = dx*n1(nodes:length(x2)); %vector is too big w. convolution so this cuts out the middle? and shrinks it back down
    n(1) = n(1)/2; n(nodes) = n(nodes)/2;     
    
    %Finalize
    na = nj_mature + na_mature; %adults plus germinated seeds
    ns = ns_bank + n; %seeds from seed bank that didn't germinate, and dispersed seeds.
    
    %Clean up weird numeric stuff
    temp = find(na < lowval); %gets rid of tiny values at the end so you don't have strange numerical problems
    na(temp) = zeros(size(na(temp)));
    %clear temp
    temp = find(ns < lowval); %gets rid of tiny values at the end so you don't have strange numerical problems
    ns(temp) = zeros(size(ns(temp)));
    clear temp
    
    % Graphics
    if gflag==1
        figure(1); clf
        plot(x,ns,'--b');
        hold on 
        plot(x,na,'r');
        xlabel('location (x)'); ylabel('population density [ n_{t} (x) ]');
        title(['t = ',num2str(j)]);
        %axis([xmin xmax ymin ymax]);
        drawnow;
    end

    
    % Find the front for seeds
    jj_j = find(ns >= ncrit,1,'last');
    if jj_j
        xright_s(j+1) = interp1(ns(jj_j:jj_j+1),x(jj_j:jj_j+1),ncrit); 
    end
    speed_av_s(j) = (xright_s(j+1)-xright_s(1))/j; 
    speed_inst_s(j) = xright_s(j+1)-xright_s(j); 
    clear jj_j
    jj_j = find(ns >= ncrit,1,'first');
    if jj_j
        xleft_s(j+1) = interp1(ns(jj_j-1:jj_j),x(jj_j-1:jj_j),ncrit);
    end
    clear jj_j
    
    
    % Find the front for adults
    jj_a = find(na >= ncrit,1,'last');
    if jj_a
        xright_a(j+1) = interp1(na(jj_a:jj_a+1),x(jj_a:jj_a+1),ncrit); 
    end
    speed_av_a(j) = (xright_a(j+1)-xright_a(1))/j; 
    speed_inst_a(j) = xright_a(j+1)-xright_a(j); 
    clear jj_a
    jj_a = find(na >= ncrit,1,'first');
    if jj_a
        xleft_a(j+1) = interp1(na(jj_a-1:jj_a),x(jj_a-1:jj_a),ncrit);
    end
    clear jj_a
    
end


if gflag==1
    figure(2);clf
    subplot(2,1,1)
    plot(speed_inst_s)
    xlabel('t')
    ylabel('seed speed')     

    subplot(2,1,2)
    plot(speed_inst_a)
    xlabel('t')
    ylabel('adult speed')  
end

if radius-xright_s < 10; error('too close to boundary');end
if radius-xright_a < 10; error('too close to boundary');end


figure(100);clf
plot(speed_inst_s)
hold on
plot(speed_inst_a)
xlabel('t')
ylabel('wave speed')
legend('seed','adult')
saveas(100,strcat(['speed_var0=' num2str(var_0) '_sigmas=' num2str(sigma_s) '_sigmaa=' num2str(sigma_a) '_gamma=' num2str(gamma) '_phi=' num2str(phi) '_mug=' num2str(mu_g) '_mua=' num2str(mu_a) '_mus=' num2str(mu_s) '_delta=' num2str(delta) '.jpg']))


figure(101), clf;
plot(x,ns);
hold on;
plot(x,na);
xlabel('location (x)'); ylabel('population density');
title(['t = ',num2str(j)]);
legend('seed','adult')
saveas(101,strcat(['distrbution_var0=' num2str(var_0) '_sigmas=' num2str(sigma_s) '_sigmaa=' num2str(sigma_a) '_gamma=' num2str(gamma) '_phi=' num2str(phi) '_mug=' num2str(mu_g) '_mua=' num2str(mu_a) '_mus=' num2str(mu_s) '_delta=' num2str(delta) '.jpg']))

