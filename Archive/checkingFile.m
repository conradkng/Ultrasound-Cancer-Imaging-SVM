
% clc
% clear all
% close all

figure
plot(Mean_Axial_Disp_category1); 
legend('Location','best')
figure
plot(Mean_Axial_Disp_category2); 
maxx1 = max(abs(Mean_Axial_Disp_category1),[],1);
maxx2 = max(abs(Mean_Axial_Disp_category2),[],1);
legend('Location','best')