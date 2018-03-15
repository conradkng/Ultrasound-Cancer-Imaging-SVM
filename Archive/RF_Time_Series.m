function feature = RF_Time_Series(RFTimeSeries, ROI_width, ROI_height, Kmax_fractal)
%   RF_Time_Series - extracts 7 time series features from RF data
%

%
% Inputs:	RFTimeSeries : 3D RF matrix [axial lateral temporal]
%           ROI_width    : Pixels of each ROI in lateral directin
%           ROI_height   : Pixels of each ROI in axial direction
%           Kmax_fractal : parameter required to calculate fractal
%           dimension using Higuchi's method

% Outputs:	feature      : 3D matrix [axial lateral feature#]
%                          feature contains 
%                          feature 1-4: Spectrum average in the four quarters of frequncy
%                          feature 5-6: Intercept and slope of regression line to the sepctrum
%                          feature 7  : Fractal dimension
% Other function required: Higuchi.m
          
%
% See also: Higuchi.m,
%Farhad Imani May 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



		[height, width, framecount] = size(RFTimeSeries);
		
		
		
        %%%Generating the number of ROIs in axial and lateral directions%%%%%%%%%%%%%%%
        ROI_No_x=floor(width/ROI_width);
        ROI_No_y=floor(height/ROI_height);
  		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%FFT_Points should be 8 * x %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        FFT_Points=framecount-mod(framecount,8);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
		
		for count_x=1:ROI_No_x
			for count_y=1:ROI_No_y
				start_x =(count_x-1)*ROI_width+1;
				end_x = start_x + ROI_width-1;
				start_y =(count_y-1)*ROI_height+1;
				end_y = start_y + ROI_height-1;                
                Spec_sum=zeros(1,(FFT_Points/2));
                Spec_avg=zeros(1,(FFT_Points/2));
                sum_FD=0;
				

                counter_pixels=0;

			    for pixel_j=start_y:end_y  
                    for pixel_i=start_x:end_x
						series=RFTimeSeries(pixel_j, pixel_i, 1:FFT_Points);
                        
						%convert to row vector
						series = series(:);
						series = series';
						series = double(series);                
          
                        %Generating fractal dimension of the time series using Higuchi's method                     
                      	temp=higuchi(series,Kmax_fractal);						
						sum_FD=sum_FD+temp;
                        
						series=series-mean(series);      
                        series=series.*(hamming(FFT_Points,'periodic'))';
						output_f = fft(series,FFT_Points);
                        %Generating spectrum of the time series 
						for in = 1 :(FFT_Points/2)
							sp(in) = (sqrt ( (real( output_f(in) ) )^2 + ( imag (output_f(in) ) ) ^2 ) );
                        end
                                   
						Spec_sum=Spec_sum+sp;
                             
                        counter_pixels=counter_pixels+1;                       
                        clear output_f series sp 
                        
                    end    
                end    


             
    			Spec_avg=Spec_sum/counter_pixels;
                Spec_avg=Spec_avg./max(Spec_avg);

                %Spectrum average in the first quarter of frequncy
                feature(count_x,count_y,1) = sum(Spec_avg(1:(FFT_Points/8)));
                %Spectrum average in the second quarter of frequncy
                feature(count_x,count_y,2) = sum(Spec_avg(1+(FFT_Points/8):(FFT_Points/4)));
                %Spectrum average in the third quarter of frequncy
                feature(count_x,count_y,3) = sum(Spec_avg(1+(FFT_Points/4):3*(FFT_Points/8)));
                %Spectrum average in the forth quarter of frequncy
                feature(count_x,count_y,4) = sum(Spec_avg(1+(3*FFT_Points/8):(FFT_Points/2)));

                
        		Spec_Points = 0 : 2/FFT_Points : 1-2/FFT_Points;
			    Reg_x=[ones( (FFT_Points/2) , 1) Spec_Points'];
			    Out_Reg = regress((Spec_avg(1:FFT_Points/2))',Reg_x);
			    %Intercept of regression line to the sepctrum
			    feature(count_x,count_y,5) = Out_Reg(1);
			    %Slope of regression line to the sepctrum
			    feature(count_x,count_y,6) = Out_Reg(2);
			    %Fractal dimenstion
			    feature(count_x,count_y,7) = sum_FD/counter_pixels;
                
               
                
			end
     end		
    
end      
