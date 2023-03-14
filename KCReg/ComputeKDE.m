%compute the Kernel Density Estimation defined by the N by 2 array P
function KDE = ComputeKDE(P)

global resolution;
global min_val;
global max_val;

%find the range of grid points
grids = round( (max_val-min_val)/resolution)+20;
KDE = zeros(grids);

start = min_val - 10*resolution*ones(1,2);

%find the points whose centers are within range
index = find( P(:,1)>=min_val(1)- 6*resolution & P(:,1) <= max_val(1)+ 6*resolution & ...
    P(:,2)>=min_val(2)- 6*resolution & P(:,2)<=max_val(2)+ 6*resolution);

for ii = 1:length(index);
    point = P(index(ii),:);
    center = round( (point-start)/resolution);
    x_range = center(1)-3:center(1)+3;
    y_range = center(2)-3:center(2)+3;
    x_val = start(1) + x_range * resolution - point(1);
    y_val = start(2) + y_range * resolution - point(2);
    kernel_x = exp(- x_val.*x_val/(resolution*resolution));
    kernel_x = kernel_x/sum(kernel_x);
    kernel_y = exp(- y_val.*y_val/(resolution*resolution));
    kernel_y = kernel_y/sum(kernel_y);
    KDE(x_range,y_range) = KDE(x_range,y_range) + kernel_x'*kernel_y;
end;

nm = sqrt(sum(sum(KDE.^2)));
KDE = KDE/nm;