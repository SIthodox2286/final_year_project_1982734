M = (rand(30,2)-.5*ones(30,2))*5; 
S = TransformPoint(.2*randn(8,1)+[1 0 0 0 1 0 0 0 ]',M); 
figure(1); clf;
X = KCReg(M,S,2,1,'projective');
