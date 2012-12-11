function  fdlg_viewMultipleFilters( drespTotal , freq , filterTitle )


%   This function plots a frequency response with inputs: 
%   resp            -  vector of filter responses 
%   freq            -  vector of frequency values
%   filterTitle     -  Title you wish to show on the plot
%
%   fdlg_viewMultipleFilters( resp ,freq , filterTitle )
%


    ldv_disp('* plotting all selected filters ');
    figure;
    subplot(2,1,1)
    semilogx(freq, 20*log10(abs(drespTotal)), 'LineWidth', 2);
    legend('IIR response');                           
    title(filterTitle);
    ylabel('Amplitude [dB]');
    grid;
    subplot(2,1,2);
    semilogx(freq, (angle(drespTotal)*180/pi), 'LineWidth', 2);
    ylabel('Phase [Degrees]');
    xlabel('Frequency [Hz]');
    grid;

end

