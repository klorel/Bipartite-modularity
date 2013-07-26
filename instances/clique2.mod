
model base.mod;

var x{RB} binary;
# var x{RB} >=0, <=1;

set Neighbor2{(ir,ib) in RB } := {(jr,jb) in RB : ir<jr or ib<jb};
set RB2 := {(ir,ib) in RB, (jr,jb) in Neighbor2[ir,ib]};

set Set1 := {(ir,ib,jr,jb) in RB2: w[ir,ib]>=0 or w[ir,jb]>=0 or w[jr,ib]>=0};
set Set2 := {(ir,ib,jr,jb) in RB2: w[ir,ib]>=0 or w[ir,jb]>=0 or w[jr,jb]>=0};
set Set3 := {(ir,ib,jr,jb) in RB2: w[ir,ib]>=0 or w[jr,ib]>=0 or w[jr,jb]>=0};
set Set4 := {(ir,ib,jr,jb) in RB2: w[ir,jb]>=0 or w[jr,ib]>=0 or w[jr,jb]>=0};


# set Set1 := {(ir,ib,jr,jb) in RB2: w[ir,ib]>=0 and w[ir,jb]>=0 and w[jr,ib]>=0};
# set Set2 := {(ir,ib,jr,jb) in RB2: w[ir,ib]>=0 and w[ir,jb]>=0 and w[jr,jb]>=0};
# set Set3 := {(ir,ib,jr,jb) in RB2: w[ir,ib]>=0 and w[jr,ib]>=0 and w[jr,jb]>=0};
# set Set4 := {(ir,ib,jr,jb) in RB2: w[ir,jb]>=0 and w[jr,ib]>=0 and w[jr,jb]>=0};

param _cut1{(ir,ib,jr,jb) in RB2};
param _cut2{(ir,ib,jr,jb) in RB2};
param _cut3{(ir,ib,jr,jb) in RB2};
param _cut4{(ir,ib,jr,jb) in RB2};

param n1;
param n2;
param n3;
param n4;


maximize modularity: sum{(i,j) in RB} w[i,j]*x[i,j];


 
# subject to ctr1{(ir,ib,jr,jb) in Set1}: +x[ir,ib]+x[ir,jb]+x[jr,ib]-x[jr,jb]<=2; 
# subject to ctr2{(ir,ib,jr,jb) in Set2}: +x[ir,ib]+x[ir,jb]-x[jr,ib]+x[jr,jb]<=2; 
# subject to ctr3{(ir,ib,jr,jb) in Set3}: +x[ir,ib]-x[ir,jb]+x[jr,ib]+x[jr,jb]<=2; 
# subject to ctr4{(ir,ib,jr,jb) in Set4}: -x[ir,ib]+x[ir,jb]+x[jr,ib]+x[jr,jb]<=2; 

subject to ctr1{(ir,ib,jr,jb) in RB2}: +x[ir,ib]+x[ir,jb]+x[jr,ib]-x[jr,jb]<=2; 
subject to ctr2{(ir,ib,jr,jb) in RB2}: +x[ir,ib]+x[ir,jb]-x[jr,ib]+x[jr,jb]<=2; 
subject to ctr3{(ir,ib,jr,jb) in RB2}: +x[ir,ib]-x[ir,jb]+x[jr,ib]+x[jr,jb]<=2; 
subject to ctr4{(ir,ib,jr,jb) in RB2}: -x[ir,ib]+x[ir,jb]+x[jr,ib]+x[jr,jb]<=2; 