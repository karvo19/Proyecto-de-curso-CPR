/*
 *  Generador de trayectorias cartesianas rectilineas para un robot de 3 grados de libertad
 *  
 *  Tiene 5 entradas:
 *      - Xinicial
 *      - Yinicial
 *      - Zinicial
 *
 *      - Xfinal
 *      - Yfinal
 *      - Zfinal
 *
 *      - Numero de puntos
 *
 *      - Tiempo de inicio
 *
 *      - Duracion
 *
 *  Tendra 1 salida:
 *      - q(t)
 *
 */

#define S_FUNCTION_NAME GTCL_R3GDL
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#include <math.h>

/*** Variables del espacio de trabajo ***/
#define   FLAG_INIT       iwork[ 0]

/**** Entradas ****/
#define     XYZinicio   (*uPtrs0)
#define     XYZfin      (*uPtrs1)
#define     N           (*uPtrs2)
#define     inicio      (*uPtrs3)
#define     duracion    (*uPtrs4)

/*** Salida ***/
#define     q           (yPtrs0)


/****** Parámetros articulares  ******/
#define L0	1.00
#define L1  0.40
#define L2  0.70
#define L3  0.50

/*****************************************************************************/


static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumSFcnParams(S, 1);       /* Número de parámetros esperados: 1 Tm */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return; /*Si faltan parametros se da mensaje */
    }
    
    ssSetNumContStates(    S, 0);      /* Número de estados continuos: 0 */
    ssSetNumDiscStates(    S, 0);      /* Número de estados discretos: 0 */

    if (!ssSetNumInputPorts(S, 5)) return;      /* 5 puerto de entrada (Puertos: 0, 1, 2, 3 y 4) */
    ssSetInputPortWidth(S, 0, 3);               /* Dimensión del puerto de entrada 0: 3 entradas */
    ssSetInputPortWidth(S, 1, 3);               /* Dimensión del puerto de entrada 1: 3 entradas */
    ssSetInputPortWidth(S, 2, 1);               /* Dimensión del puerto de entrada 2: 1 entrada */
    ssSetInputPortWidth(S, 3, 1);               /* Dimensión del puerto de entrada 3: 1 entrada */
    ssSetInputPortWidth(S, 4, 1);               /* Dimensión del puerto de entrada 4: 1 entrada */
    //ssSetInputPortDirectFeedThrough(S, 0, 1);   /* y 1 salida directa desde el puerto 0 */

    if (!ssSetNumOutputPorts(S, 1)) return;      /* 1 puerto de salida */
    ssSetOutputPortWidth(S, 0, 3);          /* Dimensión del puerto de salida 0: q(t) [3] */
    
    ssSetNumSampleTimes(   S,  1);      /* Numero de muestreos */
    ssSetNumRWork(         S,  0);      /* Vector de numeros reales (rwork) */
    ssSetNumIWork(         S,  1);      /* Vector de numeros enteros (iwork) */
    ssSetNumPWork(         S,  0);      /* Vector de punteros */
    ssSetNumModes(         S,  0);      /* Vector de modos de trabajo */
    ssSetNumNonsampledZCs(S,   0);      /* Número de paso por cero sin muestreo */
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
 }


 /*
 * mdlInitializeSampleTimes - Inicializa muestreos 
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    real_T  Tm = mxGetPr(ssGetSFcnParam(S,0))[0];  /* Parámetro 1 */
    if (Tm<1.e-8)
    {
     printf("\n\n Valor del tiempo de muestreo no válido\n\n");
     ssSetStopRequested(S,1);
    }
    ssSetSampleTime(S, 0, Tm );  /* Automatico segun bloque anterior */
    ssSetOffsetTime(S, 0, 0.0);
}


#define MDL_INITIALIZE_CONDITIONS
static void mdlInitializeConditions(SimStruct *S)
{
 int_T  *iwork = ssGetIWork(S); /* Puntero al vector de n. enteros */
 FLAG_INIT = 1;   
}

static void mdlOutputs(SimStruct *S, int_T tid)
{
  real_T *yPtrs0 = ssGetOutputPortRealSignal(S,0);          /* Accede a la salida 0 vía un puntero */
    
  InputRealPtrsType uPtrs0 = ssGetInputPortRealSignalPtrs(S,0);      /* Accede a la entrada 0 vía un puntero */
  InputRealPtrsType uPtrs1 = ssGetInputPortRealSignalPtrs(S,1);      /* Accede a la entrada 1 vía un puntero */
  InputRealPtrsType uPtrs2 = ssGetInputPortRealSignalPtrs(S,2);      /* Accede a la entrada 2 vía un puntero */
  InputRealPtrsType uPtrs3 = ssGetInputPortRealSignalPtrs(S,3);      /* Accede a la entrada 3 vía un puntero */
  InputRealPtrsType uPtrs4 = ssGetInputPortRealSignalPtrs(S,4);      /* Accede a la entrada 4 vía un puntero */
  
  int_T  *iwork = ssGetIWork(S); /* Puntero al vector de n. enteros */
  real_T  Tm = mxGetPr(ssGetSFcnParam(S,0))[0];  /* Tiempo de muestreo */

  

/******* DECLARACIONES DE LAS VARIABLES (TAMBIEN LAS ESTATICAS PERO NO SU INICIALIZACION) *******/  
  double t;
  int T;
/****************************************************/ 
  
 if (FLAG_INIT)
 {
 /***** INICIALIZACIÓN (NO LA DECLARACIÓN) DE LAS VARIABLES TIPO STATIC *****/
   
/*****************************************************************/ 
    FLAG_INIT=0;
 }


/**** CÓDIGO DEL PROGRAMA DEL GENERADOR DE TRAYECTORIAS *****/
   t = ssGetT(S);  /* Tiempo de la simulación */
  
  /* NO ES NECESARIO INCLUIR return */
  /* BASTA CON DEJAR EN LA VARIABLE q EL VALOR FINAL DE SALIDA */  
}


static void mdlTerminate(SimStruct *S)
{
}


#ifdef  MATLAB_MEX_FILE    
#include "simulink.c"      
#else
#include "cg_sfun.h"       
#endif
