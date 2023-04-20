clear all; close all; clc
%code to run simulations
    
%This part takes 10 minutes to run
tic

gflag = 0; % don't show or output graphics

%Inputs for ide_herb_fxm
%plant inputs
nu = 0.5;     % dispersal variance
sigma_s = 0.9;   % annual seed survival
gamma = 0.9;     % annual germination
sigma_a = 0.5;   % annual adult survival
phi = 5;         % annual adult fecundity (seed production)

for kflag = [1 2] % which dispersal kernel to use: 1=gaussian; 2=laplace

    %herbivore inputs
    mu_g_vec = linspace(0,1,11);
    mu_a_vec = linspace(0,1,11);
    mu_s_vec = linspace(0,1,11);
    delta_vec_pos = linspace(0,2,11);
    delta_vec_neg = linspace(0,-nu,11);


    % get baseline speed for comparison
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
    [speed_inst_s,~,~,~,~,~] = ide_herb_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta,gflag);
    speed_basic_s = speed_inst_s(end);


    %%%%%%%%%%%%%  PRE-DISPERSAL SEED CONSUMPTION [scenario 1]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(mu_s_vec)
            mu_s = mu_s_vec(i);
            [speed_inst_s,~,~,~,~,~] = ide_herb_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta,gflag);
            speed_inst_s_all_1(i,:) = speed_inst_s;
        end

    %%%%%%%%%%%%%  ADULT CONSUMPTION [scenario 2]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(mu_a_vec)
            mu_a = mu_a_vec(i);
            [speed_inst_s,~,~,~,~,~] = ide_herb_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta,gflag);
            speed_inst_s_all_2(i,:) = speed_inst_s;
        end


    %%%%%%%%%%%%%  REDUCED SEED DISPERSAL [scenario 3]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(delta_vec_neg)
            delta = delta_vec_neg(i);
            [speed_inst_s,~,~,~,~,~] = ide_herb_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta,gflag);
            speed_inst_s_all_3(i,:) = speed_inst_s;
        end


    %%%%%%%%%%%%%  PRE-DISPERSAL SEED CONSUMPTION + SEED DISPERSAL [scenario 4]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(mu_s_vec)
            mu_s = mu_s_vec(i);
            delta = delta_vec_pos(i);
            [speed_inst_s,~,~,~,~,~] = ide_herb_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta,gflag);
            speed_inst_s_all_4(i,:) = speed_inst_s;
        end

    %%%%%%%%%%%%%  ADULT CONSUMPTION + SEED DISPERSAL [scenario 5]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(mu_a_vec)
            mu_a = mu_a_vec(i);
            delta = delta_vec_pos(i);
            [speed_inst_s,~,~,~,~,~] = ide_herb_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta,gflag);
            speed_inst_s_all_5(i,:) = speed_inst_s;
        end


    %%%%%%%%%%%%%  SEEDLING CONSUMPTION + SEED DISPERSAL [scenario 6]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(mu_g_vec)
            mu_g = mu_g_vec(i);
            delta = delta_vec_pos(i);
            [speed_inst_s,~,~,~,~,~] = ide_herb_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta,gflag);
            speed_inst_s_all_6(i,:) = speed_inst_s;
        end


    %%%%%%%%%%%%% PRE-DISPERSAL SEED CONSUMPTION + REDUCED SEED DISPERSAL [scenario 7]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(delta_vec_neg)
            mu_s = mu_s_vec(i);
            delta = delta_vec_neg(i);
            [speed_inst_s,~,~,~,~,~] = ide_herb_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta,gflag);
            speed_inst_s_all_7(i,:) = speed_inst_s;
        end
        
    %Dispersal kernel
    if kflag == 1
        save results_simulated_gaussian.mat * % gaussian kernel
    elseif kflag == 2
        save results_simulated_laplace.mat * % laplace kernel
    else
        error('unrecognized kflag')
    end
    
end
    
toc

