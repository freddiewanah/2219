% This function computes the motion of neutrons at every time step.Neutrons
% are moving with initial velocity until either collision happens, when neutrons
% are absorbed into carbon rod and starts to perform n-C scattering motion,OR 
%neutron hits reactor wall,when it will bounce back without loss of energy/velocity.

function L1 = neutronmotion (A,C,r)
%% change of state
Q = A(A(:,1)==1,:);
n = size (Q,1);
for i = 1:n  
    B(1) = Q (i,2) + Q (i,4)* Q(i,6);                       
    B(2) = Q (i,3) + Q (i,5)* Q(i,6);  
    a = B(1)^2 + B(2)^2;
    b = (Q(i,2)-C(:,1)).^2 + (Q(i,3)-C(:,2)).^2;
    c = (b <= r(1)^2);
    % elastic bouncing when a neutron hits the wall
    while (a >= 25 )      
        theta = 2*pi*rand(1);
        Q(i,[4,5]) = [cos(theta) sin(theta)];
        B(1) = Q (i,2) + Q (i,4)*Q(i,6);                       
        B(2) = Q (i,3) + Q (i,5)*Q(i,6);                     
        a = B(1)^2 + B(2)^2;  
    end
    % neutron gets into carbon rod  (state 1 to state 2)
    if  sum(c~=0)~=0 
        [row, ~] = find (c);
        Q(i,1) = 2;
        Q(i,8) = C(row,1);
        Q(i,9) = C(row,2);
    end
end
A(A(:,1)==1,:) = Q;
%% neutron motion in the reactor zone
A(A(:,1)==1,2) = A(A(:,1)==1,2) + A(A(:,1)==1,4).*A(A(:,1)==1,6);                     
A(A(:,1)==1,3) = A(A(:,1)==1,3) + A(A(:,1)==1,5).*A(A(:,1)==1,6);                    

%% neutron motion in carbon rod 
M = A(A(:,1)==2,:);
m = size (M,1);
for j = 1:m
    t=0;
    d = (M(j,2)-M(j,8))^2 + (M(j,3)-M(j,9))^2;
    while (t<=10e-9&&M(j,1)==2 && d<= r(1)^2)
    v1 = 1e8*M(j,6);                                                       % convert velocity from m/10ns to m/s in order to calculate energy
    M(j,2) = M(j,2) + M(j,4) * 0.005;
    M(j,3) = M(j,3) + M(j,5) * 0.005;
    t=t+0.005/v1;
    theta1 = 2*pi*rand(1);
    M(j,[4 5]) = [cos(theta1) sin(theta1)];
    M(j,6) = M(j,6) * 0.7;
    v1=0.7*v1;
    M(j,7) = (1/1.6)*1e13 * 1.675e-27 * (v1)^2 / 2;                        % energy,unit:MeV
    if M (j,7) < 0.1e-6;                                                   % neutron is absorbed if energy is below the threshold kinetic energy
       M (j,1) = 3;
       M (j,11)=ceil((size(A(A(:,1)==1,:),1)+size(A(A(:,1)==2,:),1)+size(A(A(:,1)==3,:),1)+size(A(A(:,1)==4,:),1))/10);                         % time of neutron be absorbed                              
    end
    if (d>r(1)^2)
        if (M(j,7)< 0.1e-6)              
            M(j,1) = 4;
        else
            M(j,1) = 1;
        end
    end
    end
end
A(A(:,1)==2,:) = M;
L1 = A;
end

