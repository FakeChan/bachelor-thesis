clc;
varlist={'q','u','v','t','mu'};

for j=1:length(varlist)
    name=varlist{j};
    nml={'d02','12tpoint_d02_0200','4tpoint_d02_0200','0200','0230','0300','0200_01_03_24t','fg','NR'};
    for ii=1:length(nml)
        nml={'d02','12tpoint_d02_0200','4tpoint_d02_0200','0200','0230','0300','0200_01_03_24t','fg','NR'};
        filename=strcat(nml{ii},'_',name,'_test.txt');
        picname=strcat(nml{ii},'_',name,'_modes.png');
        [x_plot,y_plot,q_plot,q_main,q_ifft]=var_plt(filename);
        %绘制各个模态图
        figure(ii);
        
        colormap jet
        
        set(gcf, 'unit', 'centimeters', 'position', [13 0 30 30]);
        subplot(4,4,1)
        fig=pcolor(x_plot,y_plot,q_plot);
        %set(gca, 'unit', 'centimeters', 'position', [1 20.5 5.5 5.5]);
        set(fig,'LineStyle','none')
        subtitle('full filed')
        c=colorbar('horiz');
        c.Position(2)=c.Position(2)-0.075;
        
        
        subplot(4,4,2)
        q_all=q_main+sum(q_ifft,3);
        q_all=[q_all q_all(:,1)];
        fig=pcolor(x_plot,y_plot,real(q_all));
        set(fig,'LineStyle','none')
        subtitle('\Sigma0-100')
        c=colorbar('horiz');
        c.Position(2)=c.Position(2)-0.075;
        
        q_plot=zeros(127,361);
        mode_list=[0 1 2 3 5 7 10 15 20 50 70 100];
        for i=1:length(mode_list)
            if mode_list(i)==0
                q_plot=[q_main q_main(:,1)];       
                subplot(4,4,i+4)
                fig=pcolor(x_plot,y_plot,real(q_plot));
                set(fig,'LineStyle','none')
                subtitle('wave 0')
                c=colorbar('horiz');
                c.Position(2)=c.Position(2)-0.065-(2-floor((i+4)/4))*0.005;
            else
                q_chosen_mode=q_ifft(:,:,mode_list(i));
                q_plot=[q_chosen_mode q_chosen_mode(:,1)];
                subplot(4,4,i+4)
                fig=pcolor(x_plot,y_plot,real(q_plot));
                set(fig,'LineStyle','none')
                subtitle(strcat('wave ',num2str(mode_list(i))))
                c=colorbar('horiz');
                c.Position(2)=c.Position(2)-0.065-(2-floor((i+4)/4))*0.005;
            end
        end
        nml={'d02','12tpoint\_d02\_0200','4tpoint\_d02\_0200','0200','0230','0300','0200\_01\_03\_24t','fg','NR'};
        sgtitle(strcat(nml{ii},'\_',name),'FontSize',10)
        saveas(gcf,picname)
    end
end
