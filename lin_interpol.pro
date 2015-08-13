
PRO lin_interpol,nspl,yspl,xspl,ymin,ymax, bisectarr=bisectarr, y0arr=y0arr, k=k
;NAME: 
;lin_interp
;
;PURPOSE: 
;To use linear interpolation to find a point on the left side of the spectral curve 
;using two known data points on the right side. 
;
;INPUTS: 
; nspl: number of data points created in cubic_spl (increased resolution of points)
; yspl: array of y values (increased resolution) 
; xspl: array of x values (increased resolution)
; ymin: min value in y array 
; ymax: max value in y array
; 
;KEYWORDS 
; bisectarr: array of x values 
; y0arr: array of y values 
; LCspl: New line core positions
; k: last index in bisectarr and y0arr 
;-
loadct,0,/silent
k = 0 
bisectarr = 0*dblarr(nspl)-1
y0arr = 0*dblarr(nspl)-1
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

bisectarr = reform(bisectarr[0:k-1])
y0arr = reform(y0arr[0:k-1])
oplot, bisectarr,y0arr,psym=sym(6)

end 
