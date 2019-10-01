/*
 * sfuntmpl_basic.c: Basic 'C' template for a level 2 S-function.
 *
 * Copyright 1990-2013 The MathWorks, Inc.
 */


/*
 * You must specify the S_FUNCTION_NAME as the name of your S-function
 * (i.e. replace sfuntmpl_basic with the name of your S-function).
 */

#define S_FUNCTION_NAME  GTCL
#define S_FUNCTION_LEVEL 2

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */
#include "simstruc.h"
#include <math.h>

#define     XYZinicio   (*uPtrs0)
#define     XYZfin      (*uPtrs1)
#define     N           (*uPtrs2[0])
#define     inicio      (*uPtrs3[0])
#define     duracion    (*uPtrs4[0])


#define     q   (yPtrs0)
/* #define     qd  (yPtrs1)
/* #define     qdd (yPtrs2)
 
/****** Parámetros articulares  ******/
#define L0	1.00
#define L1  0.40
#define L2  0.70
#define L3  0.50

/*****************************************************************************/


/* Error handling
 * --------------
 *
 * You should use the following technique to report errors encountered within
 * an S-function:
 *
 *       ssSetErrorStatus(S,"Error encountered due to ...");
 *       return;
 *
 * Note that the 2nd argument to ssSetErrorStatus must be persistent memory.
 * It cannot be a local variable. For example the following will cause
 * unpredictable errors:
 *
 *      mdlOutputs()
 *      {
 *         char msg[256];         {ILLEGAL: to fix use "static char msg[256];"}
 *         sprintf(msg,"Error due to %s", string);
 *         ssSetErrorStatus(S,msg);
 *         return;
 *      }
 *
 */

/*====================*
 * S-function methods *
 *====================*/

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *    The sizes information is used by Simulink to determine the S-function
 *    block's characteristics (number of inputs, outputs, states, etc.).
 */
static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumSFcnParams(S, 0);  /* Number of expected parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        /* Return if number of expected != number of actual parameters */
        return;
    }
    
    
   
    
    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);

    if (!ssSetNumInputPorts(S, 5)) return;
    ssSetInputPortWidth(S, 0, 3);
    ssSetInputPortWidth(S, 1, 3);
    ssSetInputPortWidth(S, 2, 1);
    ssSetInputPortWidth(S, 3, 1);
    ssSetInputPortWidth(S, 4, 1);
//     ssSetInputPortRequiredContiguous(S, 0, true); /*direct input signal access*/
    /*
     * Set direct feedthrough flag (1=yes, 0=no).
     * A port has direct feedthrough if the input is used in either
     * the mdlOutputs or mdlGetTimeOfNextVarHit functions.
     */
    ssSetInputPortDirectFeedThrough(S, 0, 1);
    ssSetInputPortDirectFeedThrough(S, 1, 1);
    ssSetInputPortDirectFeedThrough(S, 2, 1);
    ssSetInputPortDirectFeedThrough(S, 3, 1);
    ssSetInputPortDirectFeedThrough(S, 4, 1);

    if (!ssSetNumOutputPorts(S, 1)) return;
    ssSetOutputPortWidth(S, 0, 6);
   

    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);

    /* Specify the sim state compliance to be same as a built-in block */
    ssSetSimStateCompliance(S, USE_DEFAULT_SIM_STATE);

    ssSetOptions(S, 0);
}



/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    This function is used to specify the sample time(s) for your
 *    S-function. You must register the same number of sample times as
 *    specified in ssSetNumSampleTimes.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);

}



#define MDL_INITIALIZE_CONDITIONS   /* Change to #undef to remove function */
#if defined(MDL_INITIALIZE_CONDITIONS)
  /* Function: mdlInitializeConditions ========================================
   * Abstract:
   *    In this function, you should initialize the continuous and discrete
   *    states for your S-function block.  The initial states are placed
   *    in the state vector, ssGetContStates(S) or ssGetRealDiscStates(S).
   *    You can also perform any other initialization activities that your
   *    S-function may require. Note, this routine will be called at the
   *    start of simulation and if it is present in an enabled subsystem
   *    configured to reset states, it will be call when the enabled subsystem
   *    restarts execution to reset the states.
   */
  static void mdlInitializeConditions(SimStruct *S)
  {
  }
#endif /* MDL_INITIALIZE_CONDITIONS */



#define MDL_START  /* Change to #undef to remove function */
#if defined(MDL_START) 
  /* Function: mdlStart =======================================================
   * Abstract:
   *    This function is called once at start of model execution. If you
   *    have states that should be initialized once, this is the place
   *    to do it.
   */
  static void mdlStart(SimStruct *S)
  {
  }
#endif /*  MDL_START */



/* Function: mdlOutputs =======================================================
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block.
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
//     const real_T *u = (const real_T*) ssGetInputPortSignal(S,0);
//     InputRealPtrsType uPtrs1 = ssGetInputPortRealSignalPtrs(S,1);
//     real_T       *y = ssGetOutputPortSignal(S,0);
//     real_T       *y1 = ssGetOutputPortSignal(S,1);
//     y[0] = 2*u[0];
//     y1[0] = *uPtrs1[1];
//     y1[1]= u[0];
    
    
    real_T *yPtrs0 = ssGetOutputPortRealSignal(S,0);
    /*real_T *yPtrs1 = ssGetOutputPortRealSignal(S,1);
    /*real_T *yPtrs2 = ssGetOutputPortRealSignal(S,2);*/
    
    InputRealPtrsType uPtrs0 = ssGetInputPortRealSignalPtrs(S,0);      /* Accede a la entrada 0 vía un puntero */
    InputRealPtrsType uPtrs1 = ssGetInputPortRealSignalPtrs(S,1);      /* Accede a la entrada 1 vía un puntero */
    InputRealPtrsType uPtrs2 = ssGetInputPortRealSignalPtrs(S,2);
    InputRealPtrsType uPtrs3 = ssGetInputPortRealSignalPtrs(S,3);
    InputRealPtrsType uPtrs4 = ssGetInputPortRealSignalPtrs(S,4);
    
    double t;
    static double q_tramos[3][50+2];       //N=50  **Reserva estática de memoria.
    static double qd_tramos[3][50+2];
    static double t_tramos[50+2];
    static double a[3][50+1];
    static double b[3][50+1];
    static double c[3][50+1];
    static double d[3][50+1];
    
    double pendiente[3];
    double XYZ[3];
    double incT=duracion/(N+1);
    int punto;
    int i,j;
    static int tramos;
  
    
    /**** CÓDIGO DEL PROGRAMA DEL GENERADOR DE TRAYECTORIAS *****/
   t = ssGetT(S);  /* Tiempo de la simulación */
 
  
   if(t==0){
       
       pendiente[0]=(XYZfin[0]-XYZinicio[0])/duracion;
       pendiente[1]=(XYZfin[1]-XYZinicio[1])/duracion;
       pendiente[2]=(XYZfin[2]-XYZinicio[2])/duracion;
       
       for(punto=0;punto<=(N+1);punto++){
           XYZ[0]=pendiente[0]*incT*punto + XYZinicio[0];
           XYZ[1]=pendiente[1]*incT*punto + XYZinicio[1];
           XYZ[2]=pendiente[2]*incT*punto + XYZinicio[2];
           
           q_tramos[0][punto]=atan(XYZ[1]/XYZ[0]);
           q_tramos[2][punto]=atan(sqrt(1-pow((XYZ[0]*XYZ[0]+XYZ[1]*XYZ[1]+(XYZ[2]-L0-L1)*(XYZ[2]-L0-L1)-L2*L2-L3*L3)/(2*L2*L3),2))/((XYZ[0]*XYZ[0]+XYZ[1]*XYZ[1]+(XYZ[2]-L0-L1)*(XYZ[2]-L0-L1)-L2*L2-L3*L3)/(2*L2*L3)));
           q_tramos[1][punto]=atan((XYZ[2]-L0-L1)/sqrt(XYZ[0]*XYZ[0]+XYZ[1]*XYZ[1]))-atan((L3*sin(q_tramos[2][punto]))/(L2+L3*cos(q_tramos[2][punto])));
           
           t_tramos[punto]=inicio+incT*punto;
           
//            printf("%d\t %f\t %f\t %f\t %f\t\n",punto,t_tramos[punto],q_tramos[0][punto],q_tramos[1][punto],q_tramos[2][punto]);
           
       }
       
       // ** Añadir criterio heurístico **
    for(i=0;i<3;i++){
        for(j=0;j<=N;j++){
            if ((j==0)|(j==N)){
                qd_tramos[i][j]=0;
            }
            else if (((q_tramos[i][j]-q_tramos[i][j-1])>0 & (q_tramos[i][j+1]-q_tramos[i][j])>0) | ((q_tramos[i][j]-q_tramos[i][j-1])<0 & (q_tramos[i][j+1]-q_tramos[i][j])<0))
            {
                qd_tramos[i][j+1]=((q_tramos[i][j+1]-q_tramos[i][j])/incT+(q_tramos[i][j]-q_tramos[i][j-1])/incT)/2;
            }
            else
            {
                qd_tramos[i][j]=0;
            }
     }
    }
            
    
    

       // ********************************
       
       
       for(i=0;i<3;i++){
           for(j=0;j<=N;j++){
               
               a[i][j]=q_tramos[i][j];
               b[i][j]=qd_tramos[i][j];
               c[i][j]=(3/(incT*incT))*(q_tramos[i][j+1]-q_tramos[i][j]) - (qd_tramos[i][j+1] + 2*qd_tramos[i][j])/incT;
               d[i][j]=(-2/pow(incT,3))*(q_tramos[i][j+1]-q_tramos[i][j]) + (qd_tramos[i][j+1] + qd_tramos[i][j])/(incT*incT);
               
               
           }
       }
       
       
   }
   
   
   if(t<=inicio){
       q[0]=q_tramos[0][0];
       q[1]=q_tramos[1][0];
       q[2]=q_tramos[2][0];
       q[3]=qd_tramos[0][0];
       q[4]=qd_tramos[1][0];
       q[5]=qd_tramos[2][0];
   }
   
   else if(t>=(inicio+duracion)){
       q[0]=q_tramos[0][(int)N+1];
       q[1]=q_tramos[1][(int)N+1];
       q[2]=q_tramos[2][(int)N+1];
       q[3]=qd_tramos[0][(int)N+1];
       q[4]=qd_tramos[1][(int)N+1];
       q[5]=qd_tramos[2][(int)N+1];
   }
   else
   {
       for(i=0;i<=N;i++){
           if((t_tramos[i] <= t) && (t<t_tramos[i+1])){
               tramos=i;
               break;
           }
       }
       q[0]=a[0][tramos] + b[0][tramos]*(t-t_tramos[tramos])+ c[0][tramos]*pow((t-t_tramos[tramos]),2)+ d[0][tramos]*pow((t-t_tramos[tramos]),3);
       q[1]=a[1][tramos] + b[1][tramos]*(t-t_tramos[tramos])+ c[1][tramos]*pow((t-t_tramos[tramos]),2)+ d[1][tramos]*pow((t-t_tramos[tramos]),3);
       q[2]=a[2][tramos] + b[2][tramos]*(t-t_tramos[tramos])+ c[2][tramos]*pow((t-t_tramos[tramos]),2)+ d[2][tramos]*pow((t-t_tramos[tramos]),3);
       q[3]=b[0][tramos] /*+ 2*c[0][tramos]*(t-t_tramos[tramos])+ 3*d[0][tramos]*pow((t-t_tramos[tramos]),2)*/;
       q[4]=b[1][tramos] /*+ 2*c[1][tramos]*(t-t_tramos[tramos])+ 3*d[1][tramos]*pow((t-t_tramos[tramos]),2)*/;
       q[5]=b[2][tramos] /*+ 2*c[2][tramos]*(t-t_tramos[tramos])+ 3*d[2][tramos]*pow((t-t_tramos[tramos]),2)*/;   
   }
     
    
    

}



#define MDL_UPDATE  /* Change to #undef to remove function */
#if defined(MDL_UPDATE)
  /* Function: mdlUpdate ======================================================
   * Abstract:
   *    This function is called once for every major integration time step.
   *    Discrete states are typically updated here, but this function is useful
   *    for performing any tasks that should only take place once per
   *    integration step.
   */
  static void mdlUpdate(SimStruct *S, int_T tid)
  {
  }
#endif /* MDL_UPDATE */



#define MDL_DERIVATIVES  /* Change to #undef to remove function */
#if defined(MDL_DERIVATIVES)
  /* Function: mdlDerivatives =================================================
   * Abstract:
   *    In this function, you compute the S-function block's derivatives.
   *    The derivatives are placed in the derivative vector, ssGetdX(S).
   */
  static void mdlDerivatives(SimStruct *S)
  {
  }
#endif /* MDL_DERIVATIVES */



/* Function: mdlTerminate =====================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.  For example, if memory was
 *    allocated in mdlStart, this is the place to free it.
 */
static void mdlTerminate(SimStruct *S)
{
}


/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
