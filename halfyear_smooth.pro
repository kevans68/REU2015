PRO halfyear_smooth,tstamps,arr_area,avg_area_hyear=avg_area_hyear
;NAME 
;halfyear_smooth
;PURPOSE 
;to smooth the area vs. time data over half of a year 
;INPUT
;tstamps: time informations from stamps.pro
;arr_area: array of area information
;OUTPUT 
;avg_area: smoothed area data 
;avg_tstamps: smoothed time data 
;BY: 
;Kaitlin Evans 
;-

avg_area_hyear = 0*arr_area 
halfyr = 91 

for i=0,n_elements(tstamps)-1 do begin 
	w = where(abs(tstamps-tstamps[i]) LT halfyr,count)
	if (count gt 0) then avg_area_hyear[i] = mean(arr_area[w])
endfor

end 

