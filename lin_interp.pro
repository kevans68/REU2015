PRO lin_interp, nspl,yspl,xpsl
;Name: 
;lin_interp
;
;Purpose: 
;To use linear interpolation to find a point on the left side of the spectral curve 
;using two known data points on the right side. 
;
loadct,0,/silent
k = 0 
bisectarr = dblarr(nspl)
y0arr = dblarr(nspl)  
idx=0	
i=0
yminidx = where(yspl Eq min(yspl),count)
LCspl = yminidx[0]

; exterior for-loop: left side of spectral line
for i=LCspl,0,-1  do begin

	if ((yspl[i] LT ymin) OR (yspl[i] GT ymax)) then continue

	; interior for-loop: right side of spectral line 
	for j=LCspl,nspl-2 do begin

		; identify bracket which contains left-side intensity level
		if ( (yspl[j] LT yspl[i]) AND (yspl[j+1] GT yspl[i]) ) then begin
			idx = j		; index of lower point of bracket
			break 
		endif
	endfor 
	x1 = xspl[idx]		; lower bracket point
	y1 = yspl[idx] 
	x2 = xspl[idx + 1] 	; upper bracket point
	y2 = yspl[idx + 1]
 	m = (y2 - y1)/(x2 - x1) ; slope of line connecting bracket points
	x0 = (yspl[i] + m*x2 - y2)/m	; position right side point 

	; we'll likely replace the above linear interpolation with higher-order stuff...


	dist = x0 - xspl[i]
	bisector = dist/2 
	bisectarr[k] = bisector + xspl[i]
	y0arr[k] = yspl[i]
	k = k + 1 	
	
endfor
oplot, bisectarr,y0arr,psym=sym(6)
end 
