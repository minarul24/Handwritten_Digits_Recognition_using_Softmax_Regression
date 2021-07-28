clear;
%
%Author:    Minarul Shawon
%Date:      July 20, 2021
%

%loading the datasets given in the lab
load Te28.mat;
load X1600.mat;
load Lte28.mat;

%Preparing the data :: code from the lab manual
u = ones(1,1600);
ytr = [u 2*u 3*u 4*u 5*u 6*u 7*u 8*u 9*u 10*u];
Dtr = [X1600; ytr];
Dte = [Te28; 1+Lte28(:)'];

%Preprocesssing Stage for HOG
Dhtr = pre_process_stage(X1600,ytr);

%Testing Stage HOG
tic
Dhte = test_stage(Lte28, Te28);
toc
TimeHOG = toc;

%weight for non-HOG
[Ws, f] = SRMCC_bfgsML(Dtr, 'f_SRMCC','g_SRMCC',0.002,10,62);

%weight for HOG
[Whs, fh] = SRMCC_bfgsML(Dhtr,'f_SRMCC','g_SRMCC',0.001,10,57);

%Classification HOG
tic
[Ch, HOG_acc] = run_class(Whs,Dhte,10,Lte28);
toc
HOG_class_time = toc;

%Classification non-HOG
tic
[C, non_HOG_acc] = run_class(Ws, Dte,10,Lte28);
toc
nonHOG_class_time = toc;

%TIME
time_nonHOG = nonHOG_class_time/10000;
time_HOG = (TimeHOG + HOG_class_time)/10000;

%per sec
nonHOG_per_sec = 1/time_nonHOG;
HOG_per_sec = 1/time_HOG;

fprintf('Accuracy - HOG %.2f%% \n',HOG_acc*100);
fprintf('Time HOG %f seconds \n',time_HOG);
fprintf('HOG per sec %.2f samples/second \n',HOG_per_sec);

fprintf('Accuracy - Non-HOG %.2f%% \n',non_HOG_acc*100);
fprintf('Time Non-HOG %f seconds \n',time_nonHOG);
fprintf('Non-HOG per sec %.2f samples/second \n',nonHOG_per_sec);

%FUNCTIONS

%the pre_process_stage function || from lab manual
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

%the test_stage function || from lab manual
function [Dhte_Out] = test_stage(Lte, Te)
Hte = [];
for i = 1:length(Lte)
    xi = Te(:,i);
    mi = reshape(xi,28,28);
    hi = hog20(mi,7,9);
    Hte = [Hte hi];
end
Dhte_Out = [Hte; 1+Lte(:)'];
end
%end of function

%the run_class function
function [C, accu] = run_class(Ws,Dte,K,Lte28)
l = size(Dte,1);
Dtest = Dte;
Dtest(l,:) = ones;

[~, ind_pre] = max((Dtest'*Ws)');
ytest = 1 + Lte28(:)';

C = zeros(K,K);

for i = 1:K
    ind_i = find(ytest == i);
    for j = 1:K
        ind_pre_j = find(ind_pre == j);
        C(i,j) = length(intersect(ind_i,ind_pre_j));
    end
    %end of first for loop
end

accu = trace(C)./sum(C,'all');

end
%end of the function