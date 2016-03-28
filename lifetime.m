function L=lifetime(A)
Q = A(A(:,11)>=0,:);
Q(:,12)=Q(:,11)-Q(:,10);
A(A(:,11)>=1,:) = Q;
L=A;

end

