PRO cubic_spl,n, xnew, ynew, nspl=nspl , xspl=xspl, yspl=yspl


;NAME: 
;cubic_spl
;
;PURPOSE: 
; Use cubic spline interpolation for increased "resolution" of spectral line curve
;
;INPUTS: 
; n: number of data points
; x: array of x values 
; y: array of y values
;
; KEYWORDS: 
; nspl: n times a number to return the new number of points 
; xspl: array of x positions 
; yspl: array of interpolated y values at the elements of xspl 
;-

nspl=n*15

xelements = n_elements(x)

;take x[0] and add it an array which in incremented from 0 to nspl-1, multiply each element in the array by the distance between the last 
;element in x and the first element in x and divide everything by the number of elements in the array. Based on linspace.pro (Julien Spronck)
xspl = xnew[0]+findgen(nspl)*(xnew[xelements-1]-xnew[0])/(nspl-1)

yspl = spline(xnew,ynew,xspl,/double)

;plot the interpolated points 
loadct,18,/silent
oplot, xspl, yspl, psym=sym(6), thick = 1	;overplot interpoloated data points

end 
