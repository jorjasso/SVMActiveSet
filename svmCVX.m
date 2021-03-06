%%
%run /home/jorjasso/Downloads/cvx/cvx_startup.m
%-----------------------------Data
rand('seed',88);
n = 100;
X1 = rand(n,2);
X2 = rand(n,2) + 0.5*ones(n,1)*[1 2];
y = [ones(n,1) ; -ones(n,1)];

X = [X1;X2];
[n,d] = size(X);

%-----------------------------matrices
Dy=diag(y);
e=ones(n,1);


%%
%-----------------------------primal matlab CVX
H=[eye(d), zeros(d,1); zeros(1,d),0];
A=[Dy*X,y];

cvx_begin
variable z(d+1) %z(w';b)
dual variable alphaD;
minimize( 0.5*z'*H*z)
subject to
alphaD : A*z-e>=0;
cvx_end
%-----------------------------primal solution
w=z(1:d);
b=z(d+1);

%%
%-----------------------------dual matlab CVX
G=Dy*(X*X')*Dy;
%G = (y*y').*(X*X');

cvx_begin
variable alpha(n);
dual variables bDual alDual;
minimize( 0.5*alpha'*G*alpha-e'*alpha)
subject to
bDual: alpha'*y==0;
alDual: alpha>=zeros(n,1);
cvx_end
%-----------------------------dual solution
alpha_cvx=alpha;
alDual

q=0.5*alpha'*G*alpha-e'*alpha;

%solution of cvx
alpha_cvx;
bDual;
I=find(alpha_cvx>0.00001);
plotHiperplane(X, X1,X2,y, alpha_cvx(I),-bDual,I)


%%
%----------------------------SOFT SVM DUAL
%-----------------------------dual matlab CVX
G=Dy*(X*X')*Dy;
C=10;

cvx_begin
variable alpha(n);
dual variables bDual alDual allDual;
minimize( 0.5*alpha'*G*alpha-e'*alpha)
subject to
bDual: alpha'*y==0;
%alDual: alpha>=zeros(n,1);
%allDual: C*e>=alpha
alDual: zeros(n,1)<=alpha<=C*e;
cvx_end
%-----------------------------dual solution
alpha_cvx=alpha;
alDual

q=0.5*alpha'*G*alpha-e'*alpha;

%solution of cvx
alpha_cvx;
bDual;
I=find(alpha_cvx>0.00001);
plotHiperplane(X, X1,X2,y, alpha_cvx(I),-bDual,I)



