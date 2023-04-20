README [last updated 23-March-2023]


This dataset is from the paper
	Title: TBD
	By: Lauren L. Sullivan & Allison K. Shaw
	Published in: TBD
	
This directory contains the fillowing files:

  fft_conv.m: Matlab function that does convolution and polynomial multiplication

  ide_herb_fxn.m: Matlab function that simulates a plant population with that is spreading out across space. Plant are either seeds or adults and can be subject to herbivory.
  
  analytix_speed_fxn.m: Matlab function that calculated the analytic upper bound on spread speed;

  figure_runsims.m: runs simulations for different herbivory scenarios; creates results_simulated_gaussian.mat and results_simulated_laplace.mat
  
  figure_calculate_analytic.m: does analytic calculations for different herbivory scenarios; creates results_analytic_gaussian.mat and results_analytic_laplace.mat
  
  figure2_plotsims.m: plots simulated and analytic results for different herbivory scenarios with a gaussian dispersal kernel; creates fig2.jpg

  figure3_plotsims.m: plots simulated and analytic results for different herbivory scenarios with a gaussian dispersal kernel; creates fig3.jpg

  figureS1.m: plots simulated and analytic results for different herbivory scenarios with a laplace dispersal kernel; creates figS1.jpg

  figureS2.m: plots simulated and analytic results for different herbivory scenarios with a laplace dispersal kernel; creates figS2.jpg

  fig2.jpg: output from figure2_plotsims.m
  
  fig3.jpg: output from figure3_plotsims.m
  
  figS1.jpg: output from figureS1.m
  
  figS2.jpg: output from figureS2.m
  
  results_simulated_gaussian.mat: simulation results with a gaussian dispersal kernel; output from figure_runsims.m
  
  results_analytic_gaussian.mat: analytic results with a gaussian dispersal kernel; output from figure_calculate_analytic.m

  results_simulated_laplace.mat: simulation results with a laplace dispersal kernel; output from figure_runsims.m
  
  results_analytic_laplace.mat: analytic results with a laplace dispersal kernel; output from figure_calculate_analytic.m

