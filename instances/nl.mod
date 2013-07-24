
model base.mod;

# param maxC := min( card(R), card(B) );
param maxC :=20;
set Cluster := 1..maxC;

var exist{Cluster} binary;

var x{E,Cluster} binary;

var y{V,Cluster} binary;

var L{cluster in Cluster} = sum{(i,j) in E} x[i,j,cluster];

# W = y y 
var W{ r in R, b in B, cluster in Cluster} >= 0;


var dR{cluster in Cluster} = sum{r in R} d[r]*y[r,cluster];
var dB{cluster in Cluster} = sum{b in B} d[b]*y[b,cluster];

var dRdB{cluster in Cluster} = sum{b in B}sum{r in R}d[r]*d[b]*W[r, b, cluster];

param sumR :=  sum{r in R} d[r];
param sumB :=  sum{b in B} d[b];

subject to allocation{v in V}:sum{cluster in Cluster} y[v,cluster] = 1;

# subject to xy_link{(i,j) in E, cluster in Cluster}: 2*x[i,j,cluster] <= y[i,cluster]+y[j,cluster];
subject to xy_link1{(i,j) in E, cluster in Cluster}: x[i,j,cluster] <= y[i,cluster];
subject to xy_link2{(i,j) in E, cluster in Cluster}: x[i,j,cluster] <= y[j,cluster];

maximize modularity: sum{cluster in Cluster}
(
	# L[cluster]*inv_m-(sum{i in R}sum{j in B}(d[i]*d[j]*W[i,j,cluster])/m^2)
	L[cluster]*inv_m-dRdB[cluster]/m^2
);


subject to fortetlin{r in R, b in B, cluster in Cluster}: W[r,b,cluster]>= y[r,cluster]+y[b,cluster]-1;

subject to ul{ cluster in Cluster }: sumR*dB[cluster]-dRdB[cluster] >= 0;
subject to lu{ cluster in Cluster }: sumB*dR[cluster]-dRdB[cluster] >= 0;
subject to uu{ cluster in Cluster }: sumB*sumR-sumB*dR[cluster]-sumR*dB[cluster]+dRdB[cluster] >= 0;