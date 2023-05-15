function [Ek,e_main]=var_wind_error(varname)
    clc;
    %========================================================================
    %计算坐标
    
    %计算笛卡尔坐标
    x_cart=zeros(26,26);
    y_cart=zeros(26,26);
    for i=1:26
        x_cart(:,i)=(i-13.5)*7.5;
        y_cart(i,:)=(13.5-i)*7.5;
    end
    %pcolor(x_cart,y_cart,q)
    %计算对应的极坐标系
    theta_polar=zeros(26,26);
    rho_polar=zeros(26,26);
    for i=1:26
        for j=1:26
            [theta_polar(i,j),rho_polar(i,j)]=cart2pol(x_cart(i,j),y_cart(i,j));
        end
    end
    
    %d_theta=1,d_r=1km,r=0--127km
    r=127;
    theta_new=zeros(r,360);%200*2
    rho_new=zeros(r,360);
    x_new=zeros(r,360);
    y_new=zeros(r,360);
    
    for i=1:r
        for j=1:360
            if j<=316
                theta_new(:,j)=(136-j)*pi/180;
            else
                theta_new(:,j)=(496-j)*pi/180;
            end
            rho_new(i,:)=90-i+1;
        end
    end
    for i=1:r
        for j=1:360
            [x_new(i,j),y_new(i,j)]=pol2cart(theta_new(i,j),rho_new(i,j));
        end
    end
    %=========================================================================
    %将变量插值到极坐标系中
    %NR
    u=load('NR_u_test.txt');
    v=load('NR_v_test.txt');
    nr_u_interp=griddata(x_cart,y_cart,u,x_new,y_new,'cubic');
    nr_v_interp=griddata(x_cart,y_cart,v,x_new,y_new,'cubic');
    
    %分析场变量

    u_varname=load([varname '_u_test.txt']);
    v_varname=load([varname '_v_test.txt']);
    var_u_interp=griddata(x_cart,y_cart,u_varname,x_new,y_new,'cubic');
    var_v_interp=griddata(x_cart,y_cart,v_varname,x_new,y_new,'cubic');
    
    %=====================================================================
    %fft
    q_interp=sqrt((var_u_interp-nr_u_interp).^2+(var_v_interp-nr_v_interp).^2);
    mode=100;
    r=127;
    dx=7.5;
    %=====================================================================
    q_ifft=zeros(r,360,mode);
    q_main=zeros(r,360);
    %主模态
    for r=1:127
        for mode=0
            vector=zeros(length(q_interp(1,:)),1);
            vector(mode+1)=1;%选择保留的模态
            q_fft=fft(q_interp(r,:),360);
            q_chosen_mod=vector'.*q_fft;
            q_main(r,:)=ifft(q_chosen_mod);
        end
    end
    %除了主模态之外的模态
    for mode=1:100
        for r=1:127
            vector=zeros(length(q_interp(1,:)),1);
            vector(mode+1)=1;%选择保留的模态
            q_fft=fft(q_interp(r,:),360);
            q_chosen_mod=vector'.*q_fft;
            q_ifft(r,:,mode)=ifft(q_chosen_mod);
        end
    end
    Ek=zeros(mode,1);
    for mode=1:100
        data=squeeze(abs(q_ifft(:,1,mode)));
        x=dx:dx:r*dx;
        y=0.5.*data.^2.*x';
        Ek(mode)=trapz(x,y);
    end
    y=0.5.*q_main(:,1).^2.*x';
    e_main=trapz(x,y);
end