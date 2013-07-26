model base.mod;

param KindOfN symbolic;
param N_min   symbolic := "MIN";
param N_max   symbolic := "MAX";
param N_inter symbolic := "INTER";
param N_union symbolic := "UNION";
param N_full  symbolic := "FULL";

set Neighbor2{ (i,j) in V2} := 
	if (KindOfN == N_min) then
		(if (card(Neighbor1[i]) < card(Neighbor1[j])) then Neighbor1[i] diff{j} else Neighbor1[j] diff{i})
	else if (KindOfN == N_max) then
		(if (card(Neighbor1[i]) > card(Neighbor1[j])) then Neighbor1[i] diff{j} else Neighbor1[j] diff{i})
	else if (KindOfN == N_inter) then
		(Neighbor1[i] inter Neighbor1[j]) diff{i, j}
	else if (KindOfN == N_union) then
		(Neighbor1[i] union Neighbor1[j]) diff{i, j}
	else if (KindOfN == N_full) then
		V diff{i,j}
	else
		{}
	;

# set Neighbor2{ (i,j) in V2} := (Neighbor1[i] inter Neighbor1[j]) diff{i, j};
# set Neighbor2{ (i,j) in V2} := (Neighbor1[i] union Neighbor1[j]) diff{i, j};

set Set1 := {(i,k) in V2, j in Neighbor2[i,k] : i<j<k};
set Set2 := {(j,k) in V2, i in Neighbor2[j,k] : i<j<k};
set Set3 := {(i,j) in V2, k in Neighbor2[i,j] : i<j<k};

# set Set1 := {(i,k) in V2, j in V : i<j<k};
# set Set2 := {(j,k) in V2, i in V : i<j<k};
# set Set3 := {(i,j) in V2, k in V : i<j<k};

param _cut1{(i,k,j) in Set1};
param _cut2{(j,k,i) in Set2};
param _cut3{(i,j,k) in Set3};

param n1;
param n2;
param n3;



var x{V2} binary;

maximize modularity: sum{(i,j) in RB} w[i,j]*x[i,j];

subject to ctr1 {(i,k,j) in Set1}: +x[i,j]+x[j,k]-x[i,k]<=1; 
subject to ctr2 {(j,k,i) in Set2}: +x[i,j]-x[j,k]+x[i,k]<=1; 
subject to ctr3 {(i,j,k) in Set3}: -x[i,j]+x[j,k]+x[i,k]<=1; 

