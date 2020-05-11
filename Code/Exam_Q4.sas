TITLE 'Question 4';
TITLE 'University dataset';

DATA univ;
  INFILE "/folders/myfolders/DATA/university.txt" DLM=' ';
  INPUT university $ X1 X2 X3 X4 X5 X6;
  LABEL X1='Average SAT' X2='Top 10%' X3='% Accepted' X4='Student Faculty Ratio' X5='Estimated Annual Expense' X6='Graduation Rate %';
RUN;


PROC standard DATA=univ OUT=univ2 mean=0 std=1;
VAR X1 X2 X3 X4 X5 X6;
RUN;

PROC print DATA=univ2;
RUN;


TITLE'Q4(a)';
PROC cluster DATA=univ2 METHOD=average OUTTREE=ProTree;
VAR X1 X2 X3 X4 X5 X6;
id university;
RUN;


TITLE'Q4(b)';
PROC fastclus DATA=univ2 radius=1.5 maxc=4 replace=none maxiter=10 OUT=univ_cluster ;
VAR X1 X2 X3 X4 X5 X6;
id university;
RUN;

PROC sort DATA=univ_cluster;
by cluster distance;
RUN;

PROC candisc DATA=univ_cluster noprint OUT=ProCan(keep=university cluster Can1 Can2);
class cluster;
VAR X1 X2 X3 X4 X5 X6;
RUN;

goptions reset=all;
symbol pointlabel=("#university") font=, value=dot;
PROC sgplot DATA=ProCan;
plot Can2*Can1=cluster /  vaxis=axis2 haxis=axis1 nolegend;
axis1 label=("z1" justify=center);
axis2 label=("z2" justify=center r=0 a=90);
RUN;QUIT;


PROC print DATA=univ_cluster;
VAR university cluster distance;
RUN;


TITLE'Q4(c)';
/*  METHOD #4 for getting seeds:Use Average Linkage to get cluster centriods   */
PROC cluster DATA=univ2 METHOD=average OUTTREE=ProTree noprint;
VAR X1 X2 X3 X4 X5 X6;
id university;
RUN;

PROC tree DATA=ProTree nclusters=4 OUT=newDATA noprint;
id university;
copy X1 X2 X3 X4 X5 X6;
RUN;

PROC sort DATA=newDATA;
by cluster;
RUN;

PROC print DATA=newDATA;
VAR university cluster;
RUN;

PROC means DATA=newDATA noprint;
by cluster;
OUTput OUT=Seeds mean=X1 X2 X3 X4 X5 X6;
VAR X1 X2 X3 X4 X5 X6;
RUN;

PROC fastclus DATA=univ2 maxc=4 maxiter=50 seed=Seeds OUT=univ_cluster;
VAR X1 X2 X3 X4 X5 X6;
id university;
RUN;

PROC sort DATA=univ_cluster;
by cluster;
RUN;

PROC print DATA=univ_cluster;
VAR university cluster;
RUN;

PROC candisc DATA=univ_cluster noprint OUT=ProCan(keep=university cluster Can1 Can2);
class cluster;
VAR X1 X2 X3 X4 X5 X6;
RUN;

goptions reset=all;
symbol pointlabel=("#university") font=, value=dot;

PROC sgplot DATA=ProCan;
plot Can2*Can1=cluster /  vaxis=axis2 haxis=axis1 nolegend;
axis1 label=("z1" justify=center);
axis2 label=("z2" justify=center r=0 a=90);
RUN;QUIT;