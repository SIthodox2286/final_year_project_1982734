NoiseLevel = 0.05;
M = (rand(30,2)-.5*ones(30,2))*5; 
S = TransformPoint(.25*randn(1,6)+[1 0 0 1 0 0],M); 
% Adding noise
M = M + randn(size(M))*NoiseLevel;
S = S + randn(size(S))*NoiseLevel;
% display the original setting;
figure(1); clf;

X = KCReg(M,S,1,1,'affine');
%%
transformed = TransformPoint(X,M);

msebefore = mse(M,S)
mseafter = mse(transformed,S)
mseafter-msebefore