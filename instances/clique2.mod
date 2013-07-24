
model base.mod;

# set RB2 := { (ir,ib) in RB, (jr,jb) in RB};
set RB2 := { (ir,ib) in RB, (jr,jb) in RB : ir<jr or ib<jb};

var x{RB} binary;

var cut1{(ir, ib, jr, jb) in RB2}= +x[ir,ib]+x[ir,jb]+x[jr,ib]-x[jr,jb];
var cut2{(ir, ib, jr, jb) in RB2}= +x[ir,ib]+x[ir,jb]-x[jr,ib]+x[jr,jb];
var cut3{(ir, ib, jr, jb) in RB2}= +x[ir,ib]-x[ir,jb]+x[jr,ib]+x[jr,jb];
var cut4{(ir, ib, jr, jb) in RB2}= -x[ir,ib]+x[ir,jb]+x[jr,ib]+x[jr,jb];

param _cut1{(ir, ib, jr, jb) in RB2};
param _cut2{(ir, ib, jr, jb) in RB2};
param _cut3{(ir, ib, jr, jb) in RB2};
param _cut4{(ir, ib, jr, jb) in RB2};

param n1;
param n2;
param n3;
param n4;


maximize modularity: sum{(i,j) in RB} w[i,j]*x[i,j];

subject to ctr1{(ir, ib, jr, jb) in RB2}: cut1[ir, ib, jr, jb]<=2; 
subject to ctr2{(ir, ib, jr, jb) in RB2}: cut2[ir, ib, jr, jb]<=2; 
subject to ctr3{(ir, ib, jr, jb) in RB2}: cut3[ir, ib, jr, jb]<=2; 
subject to ctr4{(ir, ib, jr, jb) in RB2}: cut4[ir, ib, jr, jb]<=2; 