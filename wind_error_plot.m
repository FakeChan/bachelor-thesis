clc;
nml={'d02','12tpoint_d02_0200','4tpoint_d02_0200','0200','0230','0300','0200_01_03_24t'};
mode=100;
ek_wind_error=zeros(mode,length(nml));
e_main=zeros(length(nml),1);
set(gcf, 'unit', 'centimeters', 'position', [13 0 25 18]);
set(gca, 'unit', 'centimeters', 'position', [3 3 20 13]);
for i=1:length(nml)
    [ek_wind_error(:,i),e_main(i)]=var_wind_error(nml{i});
    plot(0:100,log10([e_main(i);ek_wind_error(:,i)]),'LineWidth',2)
    hold on
end
nml={'Obs1.5\_Sep0min\_T1','Obs1.5\_Sep10min\_T12','Obs1.5\_Sep30min\_T4','Obs7.5\_Sep0min\_T1','Obs7.5\_Sep30min\_T3','Obs7.5\_Sep30min\_T5','Obs7.5\_Sep5min\_T24'};
legend(nml)
xlabel('wave numbers')
ylabel('log E')
saveas(gcf,'wind_error.png')
%==========================================================================
%面积积分
square_basic=zeros(7,1);
square_meso=square_basic;
square_small=square_meso;
for i=1:length(nml)
    square_basic(i)=trapz(1:1:7,[e_main(i);ek_wind_error(1:6,i)]);
    square_meso(i)=trapz(8:1:51,ek_wind_error(7:50,i));
    square_small(i)=trapz(51:1:100,ek_wind_error(51:100,i));
end