   figure('color','white');
%    [x,y,z] = peaks(101);
%    c = gradient(z);
%    k = hypot(x,y)<3;
%    plot3k({x(k) y(k) z(k)},                                      ...
%       'Plottype','stem','FontSize',12,                           ...
%       'ColorData',c(k),'ColorRange',[-0.5 0.5],'Marker',{'o',2}, ...
%       'Labels',{'Peaks','Radius','','Intensity','Lux'});
  
  x = [1;1;1];y=[2,2,2];z=[1;2;3];
  plot3k({x y z},'ColorRange',[-0.5 0.5],'ColorData',[0;0;0],'Plottype','scatter','FontSize',12,'Labels',{'Title','X','Y','Z','Dummy'},'Marker',{'o',2})