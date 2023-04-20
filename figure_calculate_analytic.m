clear all
% code to do analytics

tic

nu = 0.5;     % dispersal variance
sigma_s = 0.9;   % annual seed survival
gamma = 0.9;     % annual germination
sigma_a = 0.5;   % annual adult survival
phi = 5;         % annual adult fecundity (seed production)

for kflag = [1 2] % which dispersal kernel to use: 1=gaussian; 2=laplace

    %herbivore inputs
    mu_g_vec_ana = linspace(0,1,101);
    mu_a_vec_ana = linspace(0,1,101);
    mu_s_vec_ana = linspace(0,1,101);
    delta_vec_pos_ana = linspace(0,2,101);
    delta_vec_neg_ana = linspace(0,-nu,101);


    %%%%%%%%%%%%%  PRE-DISPERSAL SEED CONSUMPTION [scenario 1]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(mu_s_vec_ana)
            mu_s = mu_s_vec_ana(i);

            cstar = analytic_speed_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta);
            cstar_all_1(i) = cstar; % find the minimum value
        end

    %%%%%%%%%%%%%  ADULT CONSUMPTION [scenario 2]
    mu_g = 0; mu_s = 0; delta = 0;
        for i = 1:length(mu_a_vec_ana)
            mu_a = mu_a_vec_ana(i);
            cstar = analytic_speed_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta);
            cstar_all_2(i) = cstar; % find the minimum value
        end


    %%%%%%%%%%%%%  REDUCED SEED DISPERSAL [scenario 3]
        mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(delta_vec_neg_ana)
            delta = delta_vec_neg_ana(i);
            cstar = analytic_speed_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta);
            cstar_all_3(i) = cstar; % find the minimum value
        end


    %%%%%%%%%%%%%  PRE-DISPERSAL SEED CONSUMPTION + SEED DISPERSAL [scenario 4]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(mu_s_vec_ana)
            mu_s = mu_s_vec_ana(i);
            delta = delta_vec_pos_ana(i);
            cstar = analytic_speed_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta);
            cstar_all_4(i) = cstar; % find the minimum value
        end

    %%%%%%%%%%%%%  ADULT CONSUMPTION + SEED DISPERSAL [scenario 5]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(mu_a_vec_ana)
            mu_a = mu_a_vec_ana(i);
            delta = delta_vec_pos_ana(i);
            cstar = analytic_speed_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta);
            cstar_all_5(i) = cstar; % find the minimum value
        end


    %%%%%%%%%%%%%  SEEDLING CONSUMPTION + SEED DISPERSAL [scenario 6]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(mu_g_vec_ana)
            mu_g = mu_g_vec_ana(i);
            delta = delta_vec_pos_ana(i);
            cstar = analytic_speed_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta);
            cstar_all_6(i) = cstar; % find the minimum value
        end


    %%%%%%%%%%%%% PRE-DISPERSAL SEED CONSUMPTION + REDUCED SEED DISPERSAL [scenario 7]
    mu_g = 0; mu_a = 0; mu_s = 0; delta = 0;
        for i = 1:length(delta_vec_neg_ana)
            mu_s = mu_s_vec_ana(i);
            delta = delta_vec_neg_ana(i);
            cstar = analytic_speed_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta);
            cstar_all_7(i) = cstar; % find the minimum value
        end
        

    if kflag == 1
        save results_analytic_gaussian.mat * % gaussian kernel
    elseif kflag == 2
        save results_analytic_laplace.mat * % laplace kernel
    else
        error('unrecognized kflag')
    end
end

toc
