M = (rand(30,2)-.5*ones(30,2))*5; 
S = TransformPoint(.25*randn(1,6)+[1 0 0 1 0 0],M); 
figure(1); clf;
X = KCReg(M,S,1,1,'affine');

