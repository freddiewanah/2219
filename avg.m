function a=avg(A)
Q = A(A(:,12)>=0,:);
n=size(Q,1);
s=sum(Q(:,12));
a=s/n;
end