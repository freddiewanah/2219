% This function computes initial position of new neutron
% There are constrains that neutrons must be generated 
%inside the reactor and outside carbon rods

function L = neutrongenerate1 (c,r)                    % c stands for each center point of carbon rods,r stands for radius of carbon rods.

% x = rand(1);
A = 5*[cos(2*pi*rand(1)) sin(2*pi*rand(1))];           % generate A inside the reactor wall
B = A(1)^2 + A(2)^2;                                   % distance between neutron and center of reactor wall
C = (A(1) - c(:,1)).^2 +  (A(2) - c(:,2)).^2;          % distance between neutron and each center of carbon rods
D = (C <= r(1)^2);

while ( B>=25 || sum(D~=0)~=0 )                       % constrains -neutron is outside the reactor wall OR situation of C<=r(1)^2 exists
    A = 5*[cos(2*pi*rand(1)) sin(2*pi*rand(1))];
    B = A(1)^2 + A(2)^2;
    C = (A(1) - c(:,1)).^2 +  (A(2) - c(:,2)).^2; 
    D = (C<= r(1)^2);
end
L = A;
end

       


