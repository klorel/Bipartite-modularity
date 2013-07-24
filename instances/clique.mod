
model base.mod;

var x{V2} binary;

var cut1{(i,k,j) in Set1} = +x[i,j]+x[j,k]-x[i,k];
var cut2{(j,k,i) in Set2} = +x[i,j]-x[j,k]+x[i,k];
var cut3{(i,j,k) in Set3} = -x[i,j]+x[j,k]+x[i,k];


maximize modularity: sum{(i,j) in RB} w[i,j]*x[i,j];

subject to ctr1 {(i,k,j) in Set1}: cut1[i,k,j]<=1; 
subject to ctr2 {(j,k,i) in Set2}: cut2[j,k,i]<=1; 
subject to ctr3 {(i,j,k) in Set3}: cut3[i,j,k]<=1; 

