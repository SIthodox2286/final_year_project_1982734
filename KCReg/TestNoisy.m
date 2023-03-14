NoiseLevel = 0.05;
M = rand(30,2)*5; 

%adding noise
S = TransformPoint([1,1,.25].*randn(1,3),M) + randn(size(M))*NoiseLevel; 
M = M + randn(size(M))*NoiseLevel;

% display the original setting;
figure(1); clf;
KCReg(M,S,2,1);
