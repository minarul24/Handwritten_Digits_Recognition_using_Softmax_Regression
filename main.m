%loading the datasets given in the lab
load Te28.mat;
load X1600.mat;
load Lte28.mat;

%Preparing the data :: code from the lab manual
u = ones(1,1600);
ytr = [u 2*u 3*u 4*u 5*u 6*u 7*u 8*u 9*u 10*u];
Dtr = [X1600; yt];
Dte = [Te28; 1+Lte28(:)'];

%Preprocesssing Stage for HOG
Dhtr = pre_process_stage(X1600,ytr);

%Testing Stage HOG
tic
Dhte = test_stage(Lte28, Te28);
toc
TimeHOG = toc;

%the pre_process_stage function
function [Dhtr_Out] = pre_process_stage(mat_train, ytr)
H = [];
for i = 1:16000
    xi = mat_train(:,i);
    mi = reshape(xi,28,28);
    hi = hog20(mi,7,9);
    H = [H hi];
end
Dhtr_Out = [H; ytr];
end
%end of the function