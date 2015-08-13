PRO half_smooth,tstamps,arr_area,avg_area=avg_area,avg_tstamp=avg_tstamp  
;NAME 
;half_smooth
;PURPOSE 
;to smooth the area vs. time data over half of a solar cycle 
;INPUT
;tstamps: time information
;arr_area: array of area information
;OUTPUT 
;avg_area: smoothed area data 
;avg_tstamps: smoothed time data 
;BY: 
;Kaitlin Evans 
;-
avg_area = 0*arr_area
half_rot = 6.56

for i=0,n_elements(tstamps)-1 do begin
        w = where(abs(tstamps-tstamps[i]) LT half_rot, count )
	if (count gt 0 ) then avg_area[i] = mean(arr_area[w])
endfor
avg_tstamp = tstamps


end
				
