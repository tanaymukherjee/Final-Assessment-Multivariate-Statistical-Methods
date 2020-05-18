/*Question 4 university*/

DATA university;
  INFILE "/folders/myfolders/DATA/university.txt" DLM=' ';
  INPUT school $ x1 x2 x3 x4 x5 x6;
  LABEL X1='Average SAT' X2='Top 10%' X3='% Accepted' X4='Student Faculty Ratio' X5='Estimated Annual Expense' X6='Graduation Rate %';
run;

/*standardization of data */
proc standard data=university out=university mean=0 std=1;
var x1 x2 x3 x4 x5 x6;
run;
proc print data=university;
title '---------------------- Standardized Data ----------------------';
run;

/* Part a average linkage method for hierarchical clustering  */
proc cluster data=university outtree=tree_school method=average nonorm;
title '-------------- Part A: Hierarchical Clustering Wtih Average Linkage ----------------------';
   var x1 x2 x3 x4 x5 x6;
   id school;
run;


/* Before K-mean clustering  */
/*  Use principal components to guess the number of initial clusters to use   */
proc princomp data=university out=ProPC;
title '-------------- PCA to see how many cluster to use for k-mean clustering ----------------------';
var  x1 x2 x3 x4 x5 x6;
run;
proc sgplot	 data=ProPC;
scatter y = prin2 x = prin1 / datalabel=school;
label prin2 = 'Z2' prin1='Z1';
run;quit;







/* Part b K-mean cluster:  First 3 observations for getting seeds */
proc fastclus data=university radius=1.5 maxc=3 replace=none maxiter=10 out=Clus_out ;
title '--------- Part B: K-mean Clustering, Seeds=first 3 observations with Radius r=1.5 ----------';
var x1 x2 x3 x4 x5 x6;
id school;
run;
proc sort data=Clus_out;
by cluster distance;
run;

proc means data=newdata;
by cluster;
output out=Seeds mean=x1 x2 x3 x4 x5 x6;
var x1 x2 x3 x4 x5 x6;
run;

proc candisc data=Clus_out noprint out=ProCan(keep=school cluster Can1 Can2);
class cluster;
var  x1 x2 x3 x4 x5 x6;
run;

proc sgplot data=ProCan;
scatter y=Can2 x=Can1 / group=cluster datalabel=school;
label Can1="z1" Can2="z2";
run;quit;

proc print data=Clus_out;
var school cluster distance;
run;
 



/*  Part C: Use Average Linkage to get cluster centriods   */
title '-------- Part C: Use Average Linkage to get cluster centriods as seeds ------------';
proc cluster data=university method=average outtree=ProTree noprint;
var x1 x2 x3 x4 x5 x6;
id school;
run;
proc tree data=ProTree nclusters=3 out=newdata noprint;
id school;
copy x1 x2 x3 x4 x5 x6;
run;
proc sort data=newdata;
by cluster;
run;
proc print data=newdata;
var school cluster;
run;
proc means data=newdata;
by cluster;
output out=Seeds mean=x1 x2 x3 x4 x5 x6;
var x1 x2 x3 x4 x5 x6;
run;

proc fastclus data=university maxc=3 maxiter=50 seed=Seeds out=Clus_out;
var x1 x2 x3 x4 x5 x6;
id school;
run;
proc sort data=Clus_out;
by cluster distance;
run;
proc print data=Clus_out;
var school cluster distance;
run;

proc candisc data=Clus_out noprint out=ProCan(keep=school cluster Can1 Can2);
class cluster;
var x1 x2 x3 x4 x5 x6;
run;
proc sgplot data=ProCan;
scatter y=Can2 x=Can1 / group=cluster datalabel=school;
label Can1="z1" Can2="z2";
run;quit;
