function [cstar] = analytic_speed_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta)
% USAGE: [cstar] = analytic_speed_fxn(kflag,nu,sigma_s,sigma_a,gamma,phi,mu_g,mu_a,mu_s,delta)
%
% created: March 2023 (by Allison K Shaw)
% last updated: 19 April 2023 (by Allison K Shaw)
%
% INPUTS:
%   kflag = which dispersal kernel to use: 1=gaussian; 2=laplace
%   nu = dispersal kernel variance
%   sigma_s = annual seed survival
%   sigma_a = annual adult survival
%   gamma = annual germination
%   phi = annual fecundity (seeds produced)
%   mu_g = seedling consumption during germination (after dispersal)
%   mu_a = adult consumption
%   mu_s = seed consumption pre-dispersal
%   delta = change to dispersal kernel variance by herbivores
%
% OUTPUTS:
%   cstar = analytic upper bound of invasion speed

sigma = sqrt(nu + delta); % dispersal kernel variance

if kflag == 1
    smax = 8; % max possible shape
elseif kflag == 2
    if sigma==0; sigma=0.001; end % make sure not to divide by zero below
    smax = sqrt(2/sigma); % max possible shape (bound to keep real)
else
    error('unrecognized kflag')
end
    
svec = linspace(0.01,smax,1000); % possible shape values


lambda = NaN(1,length(svec)); % create empty vector to fill

for ii = 1:length(svec)
    s = svec(ii);
    
    if kflag == 1
        khat = exp((sigma.^2).*(s.^2) ./ 2); % gaussian kernel moment-generating function
    elseif kflag == 2
        khat = 2./(2-(sigma.^2).*(s.^2)); % laplace kernel moment-generating function
    else
        error('unrecognized kflag')
    end
    
    % generate the H matrix
    H11 = sigma_s*(1-gamma);
    H12 = sigma_a*(1-mu_a)*(1-mu_s)*phi*khat;
    H21 = sigma_s*gamma*(1-mu_g);
    H22 = sigma_a*(1-mu_a);
    
    % calculate the dominant eigenvalue of H
    lambda(ii) = 0.5*( H11+H22  + sqrt( (H11+H22).^2 - 4*(H11*H22 - H12*H21) )  );
    
end

% get the vector of invasion speeds
cvec = 1./svec.*log(lambda);

cstar = max(0,min(cvec)); % find the minimum value, bounded at zero
