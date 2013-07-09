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
param A{u in R, v in B} := if ((u,v) in E or (v,u) in E) then 1 else 0;


var t{i in V, j in B : i<j} binary;

#var S{i in V, j in V, k in V} binary;


#maximize modularity_1: (1/m)*sum{i in R}sum{j in B}((A[i,j]-d[i]*d[j]/m)*(1-t[i,j]));
maximize modularity_2: -(1/m)*sum{i in R}sum{j in B}((A[i,j]-d[i]*d[j]/m)*(t[i,j]));



subject to vinc1{i in R, j in B, k in B: i<j<k}: t[i,j]+t[j,k]-t[i,k]>=0;
subject to vinc2{i in R, j in B, k in B: i<j<k}: t[i,j]-t[j,k]+t[i,k]>=0;
subject to vinc3{i in R, j in B, k in B: i<j<k}: -t[i,j]+t[j,k]+t[i,k]>=0;

#altro
#subject to vinc4{i in R, j in B, k in B: i<j<k}: t[i,j]+t[j,k]+t[i,k]<=2; #somma puo' essere 0, 2, 3 -- guardo anche i segni dei coeff di t per decidere che vincoli usare 

#o ho tra 2 e 3, oppure 0
#subject to vinc1a{i in V, j in V, k in V}: t[i,j]+t[j,k]+t[i,k]<=3*S[i,j,k];
#subject to vinc2b{i in V, j in V, k in V}: t[i,j]+t[j,k]+t[i,k]>=2*S[i,j,k];
