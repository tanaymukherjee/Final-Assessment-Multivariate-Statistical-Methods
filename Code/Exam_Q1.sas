TITLE 'Question 1';
TITLE 'Iris dataset';


TITLE 'Q1(a)';
DATA iris;
  INFILE "/folders/myfolders/data/iris.txt" DLM=' ';
  INPUT X1 X2 X3 X4 group;
  LABEL X1='Sepal Length' X2='Sepal Width' X3='Petal Length' X4='Petal Width';
  
PROC GLM;
  CLASS group;
  MODEL X1 X2 X3 X4= group;
  MANOVA H=group/PRINTE PRINTH MSTAT=EXACT;
RUN;


TITLE 'Q1(b)';
PROC FORMAT;
  VALUE group 1 = ' Iris setosa' 2 = ' Iris versicolor' 3 = 'Iris virginica';
RUN;


TITLE 'Discriminant Function for Iris';
PROC CANDISC OUT=CAND MSTAT=EXACT;
  CLASS group;
RUN;
PROC PRINT DATA=CAND;
RUN;
PROC PLOT DATA=CAND;
  PLOT CAN2*CAN1=group;
RUN;


TITLE 'MANOVA Test for Iris';
TITLE'Q1(c)';
PROC GLM;
  CLASS group;
  MODEL X1 X2 X3 X4 = group;
  CONTRAST '1 v/s 2&3'
    group -1 .5 .5;
  CONTRAST '2 v/s 3'
    group 0 1 -1;
  MANOVA H=group/PRINTE PRINTH MSTAT=EXACT;
RUN;


TITLE'Q1(f)';
DATA iris;
  INFILE "/folders/myfolders/data/iris.txt" DLM=' ';
  INPUT X1 X2 X3 X4 group;
  
PROC DISCRIM LIST crossvalidate;
   CLASS group;
RUN;


proc discrim data=iris pool=no list crossvalidate;
class group;
var X1 X2 X3 X4;
RUN;


TITLE 'Discriminant Analysis of Iris Data';
proc discrim data=iris method=npar k=5 crossvalidate;
class group;
var X1 X2 X3 X4;
RUN;
