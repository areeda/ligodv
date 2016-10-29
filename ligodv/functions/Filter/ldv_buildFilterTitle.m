function [ buildTitle ] = ldv_buildFilterTitle( name , filt , f  )
%This function will create a title for an IIR filter.
%   Inputs:
%       name   -   name of the filter
%       filt   -   struct with information on gain, frequencies, zeros and
%                  poles
%       f      -   the number of filters within the struct
%   Output:
%       buildTitle   -   The full title which is to be displayed
%

  %initialize variables
  freqPoles = '';
  totalPZ = '';
  totalZeros = '';
  freqZeros = [ '0 , 0' ];
  freqPZ = [ '0 , 0' ];
  gain = filt(f).gain;
  
  if(strcmp(name,'bandpass') || strcmp(name,'bandreject') || strcmp(name,'highpass') || strcmp(name,'lowpass'))
     freqC = filt(f).f;
  else
%----------------------------------------        
     if isempty(filt(f).poles)
         totalPZ = [ ' No Poles '];
     else     
        for i = 1:length(filt(f).poles)    
         
            freqPoles = [ num2str(filt(f).poles(i).f) , ',' , num2str(filt(f).poles(i).q)];   
            totalPZ = [ totalPZ , ' [ ' , freqPoles , ' ] '];
        end
     end
%----------------------------------------     
     if isempty(filt(f).zeros)
         totalZeros = [ ' No Zeros '];
     else 
         for i = 1:length(filt(f).zeros)
           
             freqZeros = [ num2str(filt(f).zeros(i).f) , ',' , num2str(filt(f).zeros(i).q)]; 
             totalZeros = [ totalZeros , '[' , freqZeros, ']' ];
         end    
     end
%----------------------------------------      
  end   

  if(strcmp(name,'bandpass') || strcmp(name,'bandreject'))
   
   buildTitle = [name,  ' filter ', ' from ',num2str(freqC(1)), ' to ', num2str(freqC(2)), ' hz.' ];
  end 
  if(strcmp(name,'highpass') || strcmp(name,'lowpass'))
   
   buildTitle = [name,  ' filter ', 'at a corner frequency ',num2str(freqC(1)), ' hz.']; 
  end 
  if(strcmp(name,'pzmodel'))
   
   buildTitle = [name,  ' filter :' , ' gain =' , num2str(gain) , ' : Poles(f/Q) =' , totalPZ , ' : Zeros(f/Q) =' , totalZeros ,];
  end  
  


end

