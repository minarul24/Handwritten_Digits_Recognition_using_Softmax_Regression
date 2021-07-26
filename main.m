%loading the datasets given in the lab
load Te28.mat;
load X1600.mat;
load Lte28.mat;

%Preparing the data :: code from the lab manual
u = ones(1,1600);
ytr = [u 2*u 3*u 4*u 5*u 6*u 7*u 8*u 9*u 10*u];
Dtr = [X1600; yt];
Dte = [Te28; 1+Lte28(:)'];

