    %%
        close all
        clear
        
        XYZini=CinematicaDirecta([0 0 0]);
        XYZfin=CinematicaDirecta([0.5 0.5 0.5]);
        N_puntos=50;
        Tini=0.5;
        Duracion=0.5;
        Tsim=1.5;
        
        
        
        sim('slGTC_3gdl')
        
       
        figure(5);
    plot3(xr,yr,zr,'LineWidth',1);grid;