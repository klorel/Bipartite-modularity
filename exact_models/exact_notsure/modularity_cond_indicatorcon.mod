# AMPL model for clustering 
# qualified cut - LP - 
# (original model by Zhang, Li, Wang, Wang)
#
# March 2011
#

# graph
param n >= 1, integer;   # number of nodes

set V := 1..n;
set E within {V,V};

param m:= card(E);    # number of edges

# edge weights
param c{E};

# edge inclusions
param I{E};

param d{u in V} := card({v in V: (u,v) in E or (v,u) in E});
param A{u in V, v in V} := if ((u,v) in E or (v,u) in E) then 1 else 0;


param cl; # number of clusters
set K := 1..cl; # communities

# y[u,k] = 1 if vertex u is in community k, 0 otherwise
var y{V,K} binary;

# x[l,k] = 1 if edge l=(u,v) is in community k, 0 otherwise
var x{E,K} binary;

# linearization of the extra-weak condition
var z{E,K,K} binary;
var zz{E,K,K} binary;

maximize modularity: sum{k in K} ((sum{(u,v) in E} x[u,v,k])/m - ((sum{u in V} d[u]*y[u,k])/(2*m))^2); 

# maximize cohesion: sum{k in K} (4*sum{(u,v) in E} x[u,v,k] - sum{u in V} d[u]*y[u,k]); 

subject to assignment {u in V} : sum{k in K} y[u,k] = 1; 

subject to edge_vertex1 {(u,v) in E, k in K} : y[u,k] = 0 ==> x[u,v,k] = 0;

subject to edge_vertex2 {(u,v) in E, k in K} : y[v,k] = 0 ==> x[u,v,k] = 0;

#subject to edge_vertex3 {(u,v) in E, k in K} : y[u,k] + y[v,k] - 1 <= x[u,v,k];
#subject to edge_vertex3 {(u,v) in E, k in K} : 
 #                                           ((y[u,k] = 1) && (y[v,k] = 1) && (x[u,v,k] = 1)) ;
 #                                           || ((y[u,k] = 0) && (x[u,v,k] = 0)) || ((y[v,k] = 0) && (x[u,v,k] = 0));
 #                                             (y[u,k] + y[v,k] = 2)  ==> (x[u,v,k] = 1);
 #                                            x[u,v,k] = 0 ==> ((y[u,k] + y[v,k]) <= 1); 

##subject to weak_cond {k in K} : 4*sum{(u,v) in E} x[u,v,k] >= sum{u in V} (d[u]*y[u,k]) + 1;

##subject to strong_cond {k in K, u in V} : sum{v in V : v != u} A[u,v] * y[v,k] >= y[u,k] * (floor(d[u]/2)+1);

##subject to semistrong_cond {k in K, l in K, u in V : l!=k} : 
##                        sum{v in V : v != u} A[u,v] * y[v,k] >= sum{v in V : v != u} A[u,v] * y[v,l] + 1 - (1 - y[u,k])*(d[u]+1);

subject to extraweak_cond {k in K, l in K : l!=k} : 2* sum{(u,v) in E} x[u,v,k] >=  sum{(u,v) in E} (z[u,v,k,l] + zz[u,v,k,l]) + 1;

## remark: constraint weak_cond does not allow to have empty classes (because of +1)

subject to empty_class {k in K} : sum{u in V} y[u,k] >= 1;

# only for extra weak:
subject to extraweak_lin1 {k in K, l in K, (u,v) in E: l!=k} : z[u,v,k,l] <= y[u,k];
subject to extraweak_lin2 {k in K, l in K, (u,v) in E: l!=k} : z[u,v,k,l] <= y[v,l];
subject to extraweak_lin3 {k in K, l in K, (u,v) in E: l!=k} : z[u,v,k,l] >= y[u,k] + y[v,l] - 1;
subject to extraweak_lin4 {k in K, l in K, (u,v) in E: l!=k} : zz[u,v,k,l] <= y[v,k];
subject to extraweak_lin5 {k in K, l in K, (u,v) in E: l!=k} : zz[u,v,k,l] <= y[u,l];
subject to extraweak_lin6 {k in K, l in K, (u,v) in E: l!=k} : zz[u,v,k,l] >= y[v,k] + y[u,l] - 1;


subject to sym_break1 {u in V : u <= cl} : sum{l in 1..u} y[u,l] = 1;

subject to sym_break2 {k in 3..cl-1, u in k..n} : sum{v in 2..u-1} sum{l in 1..k-1} y[v,l] - sum{l in 1..k} y[u,l] <= u - 3;


#include dataind;


