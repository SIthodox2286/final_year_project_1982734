M = rand(30,2)*5; 
S = TransformPoint([1,1,.25].*randn(1,3),M); 

figure(1); clf;
KCReg(M,S,2,1);
