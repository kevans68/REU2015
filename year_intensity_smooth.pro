PRO year_intensity_smooth,tstamps,arr_intense,avg_int_year=avg_int_year
;NAME: 
;year_intensity_smooth
;PURPOSE: 
;to smooth intensity vs time data over 1 year 
;INPUTS:  
;tstamps: time stamps data from stamps.pro 
;arr_intense: array of intensity information
;KEYWORDS:
;avg_int_year: Intensity information smoothed over a year 
;BY: 
;Kaitlin Evans
;-
avg_int_year = 0*arr_intense
yr = 182 

for i=0, n_elements(tstamps)-1 do begin 
	w =where(abs(tstamps-tstamps[i]) LT yr,count)
	if (count gt 0) then avg_int_year[i] = mean(arr_intense[w])
endfor

end 

