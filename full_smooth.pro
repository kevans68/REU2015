PRO full_smooth,tstamps,arr_area,avg_area_full=avg_area_full,avg_tstamp_full=avg_tstamp_full  
;NAME
;full_smooth 
;PURPOSE 
;To smooth area vs. time data over a full solar cycle 
;INPUT: 
; tstamps: time stamp data created by stamps.pro
;arr_area: array of area information 
;OUTPUT 
; avg_area_full: the smoothed area data 
; avg_tstamp_full: the smoothed time stamps 
; 
;BY 
;Kaitlin Evans
;-
avg_area_full = 0*arr_area
full_rot = 13.2
for i=0,n_elements(tstamps)-1 do begin 
	w = where(abs(tstamps-tstamps[i]) LT full_rot,count)
	if (count gt 0) then avg_area_full[i] = mean(arr_area[w])
endfor

avg_tstamp_full = tstamps


end
				
