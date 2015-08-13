PRO hyear_intensity_smooth,tstamps,arr_intense,avg_int_hyear=avg_int_hyear
;NAME 
;hyear_intensity_smooth
;PURPOSE 
;to smooth the intensity vs. time data over half of a year 
;INPUT
;tstamps: time information from stamps.pro 
;arr_intense: array of intensity information
;OUTPUT 
;avg_int_hyear: smoothed intensity data 
;avg_tstamps: smoothed time data 
;BY: 
;Kaitlin Evans 
;-

avg_int_hyear = 0*arr_intense
yr = 91 

for i=0, n_elements(tstamps)-1 do begin 
	w =where(abs(tstamps-tstamps[i]) LT yr,count)
	if (count gt 0) then avg_int_hyear[i] = mean(arr_intense[w])
endfor

end 

