# AMPL model for clustering 
# qualified cut - LP - 
# (original model by Zhang, Li, Wang, Wang)
#
# March 2011
#

# graph

param n >= 1, integer;   # number of nodes
#param p >=1, integer; #nodes in the first part

set V := 1..n;
#set R:={u in V: u<=p};
#set B:={v in V: v>p};

set E within {V,V};

#set N{v in V} within {V}:= {u in V: (v,u) in E or (u,v) in E};
#let N{v in V}:= {u in V: (v,u) in E or (u,v) in E};


param m:= card(E);    # number of edges

# edge weights
param c{E};

# edge inclusions
param I{E};

param d{u in V} := card({v in V: (u,v) in E or (v,u) in E});
param A{u in V, v in V} := if ((u,v) in E or (v,u) in E) then 1 else 0;



var t{i in V, j in V: i<j} binary;

#var S{i in V, j in V, k in V} >=0, <=1;


#maximize modularity_1: (1/(2*m))*sum{i in V}sum{j in V}((A[i,j]-d[i]*d[j]/(2*m))*(1-t[i,j]));
maximize modularity_2: -(1/(m))*sum{i in V}sum{j in V:i<j}((A[i,j]-d[i]*d[j]/(2*m))*(t[i,j]));




#subject to dihnthai{i in V, j in V, k in {N[i] union N[j]} : i<>j }: t[i,k]+t[k,j]>=t[i,j];



subject to vinc1{i in V, j in V, k in V: i<j<k}: t[i,j]+t[j,k]-t[i,k]>=0;
subject to vinc2{i in V, j in V, k in V: i<j<k}: t[i,j]-t[j,k]+t[i,k]>=0;
subject to vinc3{i in V, j in V, k in V: i<j<k}: -t[i,j]+t[j,k]+t[i,k]>=0;
#subject to vinc4{i in V, j in V, k in V: i<j<k}: t[i,j]+t[j,k]+t[i,k]<=2;





#subject to vincm{i in V, j in V}: t[i,j]=t[j,i];

#subject to vincm{i in V}: t[i,i]=0;

#altro
##subject to vinc4{i in V, j in V, k in V: i<j<k}: t[i,j]+t[j,k]+t[i,k]<=2; #somma puo' essere 0, 2, 3 -- guardo anche i segni dei coeff di t per decidere che vincoli usare 

#o ho tra 2 e 3, oppure 0
####subject to vinc1a{i in V, j in V, k in V: i<j<k}: t[i,j]+t[j,k]+t[i,k]=2*S[i,j,k];
#subject to vinc2b{i in V, j in V, k in V: i<j<k}: t[i,j]+t[j,k]+t[i,k];


