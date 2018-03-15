function feature = RF_Time_Series_wavelet_MCF(RFTimeSeries,ROI_width,ROI_height)
%   RF_Time_Series - extracts 2 time series features from RF data
%

%
% Inputs:	RFTimeSeries : 3D RF matrix [axial lateral temporal]
%           ROI_width    : Number of pixels for each ROI in lateral directin
%           ROI_height   : Number of pixels for each ROI in axial direction


% Outputs:	feature      : 3D matrix [axial lateral feature#]
%                          feature# contains 
%                          feature 1: MCF
%                          feature 2: wavelet

 
%Farhad Imani July 2013
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
                %count_x
                %count_y
				start_x =(count_x-1)*ROI_width+1;
				end_x = start_x + ROI_width-1;
				start_y =(count_y-1)*ROI_height+1;
				end_y = start_y + ROI_height-1;                
                Spec_sum=zeros(1,(FFT_Points/2));
				

                counter_pixels=0;

                A=0;
			    for pixel_j=start_y:end_y  
                    for pixel_i=start_x:end_x
						series=RFTimeSeries(pixel_j, pixel_i, 1:FFT_Points);
                        
						%convert to row vector
						series = series(:);
						series = series';
						series = double(series);                
          
                        %Generating approximation coefficient at the maximum decomposition level using db4 wavelet function                  
                        [Lo_D,Hi_D,Lo_R,Hi_R] = wfilters('db4');
                        level = wmaxlev(FFT_Points,'db4');
                        [c,l] = wavedec(series,level,Lo_D,Hi_D);
                        temp_wavelet = appcoef(c,l,Lo_R,Hi_R);
                        A=A+temp_wavelet(1,1);
                        
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

                %Generating MCF
                Spec_Points = 0 : 2/FFT_Points : 1-(2/FFT_Points);
                dot_product=dot(Spec_Points,Spec_sum(1:FFT_Points/2));
                feature(count_x,count_y,1)=dot_product/sum(Spec_sum(1:FFT_Points/2));   
            
                %Averaged wavelet feature
                feature(count_x,count_y,2)=A/counter_pixels;   
                
    
			end
        end		
    
end      
