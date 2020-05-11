TITLE 'Question 3';
TITLE 'Salesman dataset';

DATA salesman;
  INFILE "/folders/myfolders/data/salesman.txt" DLM=' ';
  INPUT X1 X2 X3 X4 X5 X6 X7;
  LABEL X1='Growth of Sales' X2='Profitability of Sales' X3='New Account Sales' X4='Creativity'    
        X5='Mechanical Reasoning' X6='Abstract Reasoning' X7='Mathematical Ability' ;   
RUN;


/* PRINCPICAL COMPONENT METHOD */
TITLE 'Factor Analysis of Salesman';
PROC FACTOR METHOD=PRIN NFACT=3 ROTATE=VARIMAX PLOTS=ALL;
  VAR X1-X7;
RUN;

/* Iterated Principal Factor METHOD */
PROC FACTOR METHOD=PRINIT NFACT=3 PRIORS=SMC HEYWOOD MAXITER=100 ROTATE=VARIMAX CORR PLOTS=ALL;
RUN;


/* PRINCIPAL FACTOR METHOD */
PROC FACTOR METHOD=PRIN PRIORS=SMC NFACT=3 ROTATE=VARIMAX PLOTS=ALL;
  VAR X1-X7;
RUN;


/* PRINCIPAL FACTOR METHOD with 4 Factors */
TITLE 'Q3(f)';
PROC FACTOR METHOD=PRIN PRIORS=SMC NFACT=4 ROTATE=VARIMAX PLOTS=ALL;
  VAR X1-X7;
RUN;
