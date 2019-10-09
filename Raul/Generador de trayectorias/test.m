    %%
        close all
        clear
        
        XYZini=CinematicaDirecta([0 0 0]);
        XYZfin=CinematicaDirecta([0.5 0.5 0.5]);
        N_puntos=5;
        Tini=0.5;
        Duracion=0.5;
        Tsim=1.5;
        
        
        
        sim('slGTC_3gdl')
        
       
        figure(5);
        plot(t,qdr,'LineWidth',1);grid;
        %plot3(xr,yr,zr,'LineWidth',1);grid;