# AMPL model for clustering 
# qualified cut - LP - 
# (original model by Zhang, Li, Wang, Wang)
#
# March 2011
#

# graph

param n >= 1, integer;   # number of nodes
param p >=1, integer; #nodes in the first part

set V := 1..n;
set R:={u in V: u<=p};
set B:={v in V: v>p};

set E within {R,B};



param m:= card(E);    # number of edges

# edge weights
param c{E};

# edge inclusions
param I{E};

param d{u in V} := card({v in V: (u,v) in E or (v,u) in E});

param cl; # number of clusters
set K := 1..cl; # communities

param tp:=sum{u in R} d[u];
param td:=sum{u in B} d[u];

param tR:=ceil((log(tp+1)/log(2))-1);
param tB:=ceil((log(td+1)/log(2))-1); 


set Rbin:=0..tR;
set Bbin:=0..tB;

var r{Rbin,K} binary;
var b{Bbin,K} binary;

var T{Rbin,Bbin,K} >=0;




# y[u,k] = 1 if vertex u is in community k, 0 otherwise
var y{V,K} binary;

# x[l,k] = 1 if edge l=(u,v) is in community k, 0 otherwise
var x{E,K};

# linearization 
#var W{R,B,K} >=0;

#uso cluster o no
var L{K} binary;  


maximize modularity_fortet: sum{k in K} ((sum{(u,v) in E} x[u,v,k])/m - (sum{i in Rbin}sum{j in Bbin}(2^(i+j)*T[i,j,k]))/m^2); 


#non ho bisogno con fortet di questi

subject to R1{k in K}: sum{i in R} d[i]*y[i,k]=sum{s in Rbin} 2^(s)*r[s,k];
subject to B1{k in K}: sum{j in B} d[j]*y[j,k]=sum{t in Bbin} 2^(t)*b[t,k];

#subject to R1{k in K}: sum{i in R} d[i]*y[i,k]=R[k];
#subject to B1{k in K}: sum{j in B} d[j]*y[j,k]=B[k];

#subject to R1bin{k in K}: sum{i in Rbin} 2^(i)*r[i,k]=R[k];
#subject to B1bin{k in K}: sum{j in Bbin} 2^(j)*b[j,k]=B[k];

#subject to fortetlin{i in R, j in B, k in K}: W[i,j,k]>= y[i,k]+y[j,k]-1;

subject to fortetT{i in Rbin, j in Bbin, k in K}: T[i,j,k]>=r[i,k]+b[j,k]-1;


subject to edge_vertex1 {(u,v) in E, k in K} : x[u,v,k] <= y[u,k];

subject to edge_vertex2 {(u,v) in E, k in K} : x[u,v,k] <= y[v,k];


subject to assignment {u in V} : sum{k in K} y[u,k] = 1; 



#subject to edge_vertex3 {(u,v) in E, k in K} : y[u,k] + y[v,k] - 1 <= x[u,v,k];


subject to usoclasse {k in K : k>1}: L[k]<=L[k-1];

subject to latocluster1 {k in K}: sum{(u,v) in E} x[u,v,k]>=L[k];
subject to latocluster2 {k in K}: sum{(u,v) in E} x[u,v,k]<=(m-1)*L[k];

subject to verticecluster1 {k in K}: sum{i in V} y[i,k]>=2*L[k];
subject to verticecluster2 {k in K}: sum{i in V} y[i,k]<=(n-2)*L[k];

subject to unrossounblu{k in K}: sum{i in Rbin}sum{j in Bbin} T[i,j,k]>=L[k];


subject to sym_break1 {u in V : u <= cl} : sum{l in 1..u} y[u,l] = 1;

subject to sym_break2 {k in 3..cl-1, u in k..n} : sum{v in 2..u-1} sum{l in 1..k-1} y[v,l] - sum{l in 1..k} y[u,l] <= u - 3;


#include data;


