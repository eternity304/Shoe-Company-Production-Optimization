set I; # types of shoes, 557
set J; # types of raw material, 165
set K; # types of machine, 72
set L; # number of warehouse, 8
set Q; # quotas for using whare house l
set S; # number of store

var x{I} >= 0; # quantity of shoes I to produce
var y{L} binary;  # Whether or not to use warehouse L

param s{I};   # sales price of shoe i
param d{I};	  # demand of shoe i
param r{I,J}; # the quantity of raw material i required for shoe i
param c{J};   # the cost of raw material j
param m{J};   # the total amount of raw material j available for use
param o{K};   # the operation cost per minutes for machine k
param t{I,K}; # operational duration required of machine k for producing shoe k
param w{L};   # the operation cost of warehosue l
param p{L};   # storage capacity of ware house l
param u;	  # worker's rate per minute for operating on a machine
param try{I}; # try average demand

# profit                   sum{i in I}s[i]*x[i]
# worker cost              -sum{i in I, k in K}p*x[i]*t[i,k]
# machine operation cost   -sum{i in I, k in K}o[k]*x[i]*t[i, k]
# raw material cost        -sum{i in I, j in J}c[j]*r[i,j]*x[i]
# warehouse cost           -sum{l in L}y{l}*w[l]
# not meeting demand cost  -sum{i in I}20*d[i]-sum{i in I}10*x[i] equivalent to -sum{i in I}10*（2d[i]-x[i]）

maximize z: sum{i in I}s[i]*x[i]-sum{i in I, k in K}u*x[i]*t[i,k]-sum{i in I, k in K}o[k]*x[i]*t[i, k]-sum{i in I, j in J}c[j]*r[i,j]*x[i]-sum{l in L}w[l]*y[l]-sum{i in I}20*d[i]+sum{i in I}10*x[i];
 

# Raw material budget Constraint
subject to rm_budget: sum{i in I, j in J} c[j]*r[i,j]*x[i] <= 10000000;

# Raw material quantity constraint
subject to rm_limit {j in J}: sum{i in I} x[i]*r[i, j] <= m[j];

#Operation Limit Constraint
# 12*28 is 336, assume all machine is working for the maximum duration each month
# at most, each machine can be operated for 336 hour in a work month
subject to operation_limit {k in K}: sum{i in I} x[i]*t[i, k] <= 20160;

# Demand Limit constraint, product produced over demand won't sale, so produce as much as demand says
subject to demand_limit {i in I}: x[i] <= 2*d[i];

# warehouse constraint, the sum of the shoes produce must be less than the availabel space
# across all warehouses since distance is not a factor of consideration
subject to warehouse_cost: sum{l in L} y[l]*p[l] - sum{i in I} x[i] >= 0;
