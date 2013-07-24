# number of nodes
param n >= 1, integer;
#nodes in the first part
param p >= 1, integer;

set V := 1..n;

set R :={u in V: u<=p};
set B :={v in V: v>p};

set RB  :=  R cross B;
# set RB2 := { (i,j,ii,jj) in RB cross RB : jj!=j or ii!=i};

set E within RB;

set V2 :=  {(i,j) in V cross V : i<j};

param m := 1.0*card(E);
param inv_m := 1.0/m;

param c{RB} default 0;
param c2{(i,j) in RB} := if( (i,j) in E) then 1 else 0;
# param w{(i,j) in V2  } := if( (i,j) in RB) then ( c[i,j] -d[i]*d[j]*inv_m)*inv_m else 0;

# param d{u in V} := sum{(u,v) in E} c[u,v]+sum{(v,u) in E} c[v,u];
# param w{(i,j) in RB  } := ( c[i,j] -d[i]*d[j]*inv_m)*inv_m;

param d{u in V} := card({v in V: (u,v) in E or (v,u) in E});
param w{(i,j) in RB  } := ( c2[i,j] -d[i]*d[j]*inv_m)*inv_m;

param I{E};

set V3 :=  {(i,j) in V2, k in V : j<k};

set Neighbor1{ i in V} := {j in V : (i,j) in E or (j,i) in E };

# set Neighbor2{ (i,j) in V2} := {k in V diff {i,j} : k in Neighbor1[i] or k in Neighbor1[j] };
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

var cut1{(i,k,j) in Set1} = +x[i,j]+x[j,k]-x[i,k];
var cut2{(j,k,i) in Set2} = +x[i,j]-x[j,k]+x[i,k];
var cut3{(i,j,k) in Set3} = -x[i,j]+x[j,k]+x[i,k];


maximize modularity: sum{(i,j) in RB} w[i,j]*x[i,j];

subject to ctr1 {(i,k,j) in Set1}: cut1[i,k,j]<=1; 
subject to ctr2 {(j,k,i) in Set2}: cut2[j,k,i]<=1; 
subject to ctr3 {(i,j,k) in Set3}: cut3[i,j,k]<=1; 

