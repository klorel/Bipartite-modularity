reset;

param ZERO = 1e-4;
# number of nodes
param n >= 1, integer;
#nodes in the first part
param p >= 1, integer;

set V := 1..n;
set R:={u in V: u<=p};
set B:={v in V: v>p};

set RB =  R cross B;
set E within RB;
set V2 :=  {(i,j) in V cross V : i<j};

param m := 1.0*card(E);
param inv_m := 1.0/m;

param c{RB} default 0;
param d{u in V} := card({v in V: (u,v) in E or (v,u) in E});
param w{(i,j) in V2  } := if( (i,j) in RB) then ( c[i,j] -d[i]*d[j]*inv_m)*inv_m else 0;

param I{E};

set V3 :=  {(i,j,k) in V cross V cross V : i<j and j<k};

set Neighbor1{ i in V} := {j in V : (i,j) in E or (j,i) in E };
set Neighbor2{ (i,j) in V2} := {k in V diff {i,j} : k in Neighbor1[i] or k in Neighbor1[j] };

set RB2 := { (i,j,ii,jj) in RB cross RB : jj!=j or ii!=i};


set Set1 := {(i,j,k) in V3 : j in Neighbor2[i,k] };
set Set2 := {(i,j,k) in V3 : i in Neighbor2[j,k] };
set Set3 := {(i,j,k) in V3 : k in Neighbor2[i,j] };

param _cut1{(i,j,k) in Set1};
param _cut2{(i,j,k) in Set2};
param _cut3{(i,j,k) in Set3};

param n1;
param n2;
param n3;


