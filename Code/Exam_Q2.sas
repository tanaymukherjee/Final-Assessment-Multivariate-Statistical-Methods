TITLE 'Question 2';
TITLE 'Stock price dataset';

DATA stock;
  INFILE "/folders/myfolders/data/stock_price.txt" DLM='09'x;
  INPUT stock $ JPM Citi WF RDS EM;
  RUN;
  

TITLE 'Principal Component Analysis of Stock Returns';  
/* PCA USING S*/
PROC PRINCOMP COV OUT=RESULTS plots(ncomp =2)=score(ellipse);
  VAR JPM Citi WF RDS EM;
RUN;

PROC PLOT;
  PLOT PRIN2*PRIN1;
RUN; 

proc print data=RESULTS;
var PRIN1 PRIN2;
RUN;


/* PCA USING R */
PROC PRINCOMP OUT=RESULTS Plot=scores(ellipse);
  VAR JPM Citi WF RDS EM;
RUN;

PROC PLOT ;
  PLOT PRIN2*PRIN1;
RUN;
