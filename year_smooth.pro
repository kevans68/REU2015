PRO year_smooth,tstamps,arr_area,avg_area_year=avg_area_year
;NAME:
;year_smooth
;PURPOSE:  
;to smooth area vs. time data over a year 
;INPUT
;tstamps:time stamp data from stamps.pro 
;arr_area: Area array 
;KEWORDS 
;avg_area_year: area data smoothed over 1 year 
;BY: 
;Kaitlin Evans 
avg_area_year = 0*arr_area
yr = 182 

for i=0, n_elements(tstamps)-1 do begin 
	w =where(abs(tstamps-tstamps[i]) LT yr,count)
	if (count gt 0) then avg_area_year[i] = mean(arr_area[w])
endfor

end 

