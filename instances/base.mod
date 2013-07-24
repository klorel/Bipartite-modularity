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
