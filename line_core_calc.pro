 PRO line_core_calc, xspl,yspl,unit, xdata=xdata, ydata=ydata, yfit=yfit, LCC=LCC,fit=fit,core_intens=core_intens
; NAME:
;line_core_calc
;
;PURPOSE: 
; calculate the center of a spectral line core using a second order polynomial fit
;
;INPUT: 
; xspl:an array of x values 
; yspl:an array of y values 
; vline : funtion that creates a vertical line 
; sym: function used to create plotting symbols 
;
;KEYWORDS: 
;xdata: an array of seven x values centered around the line-core (LC) 
; ydata: an array of seven y values centered around the line-core (LC) 
; fit: the secound degree polynomial fit to xdata and ydata 
; yfit: the y values of the second degree polynomial fit 
; LCC: position of the line core 
;-


; Find min value point 
LCarr  = where(yspl eq min(yspl))
LC = LCarr[0] 
num = 15

;index of x values surrounding LC 
xdata =xspl[LC-num:LC+num]

;Shift xdata by wavelength value at LC to center around 0 
xshift = (xspl[LC-num:LC+num]-xspl[LC])

; y values surrounding LC 
ydata = yspl[LC-num:LC+num]

;loadct,0, /silent
loadct, 18, / silent 
oplot,xdata,ydata, psym=sym(1)


;Second order polynomial fit to the LC region i
fit = poly_fit(xshift,ydata,2,yfit=yfit,/double)


;plot the fit
loadct, 13,/silent
oplot, xdata, yfit, linestyle=3, thick=3	; overplot polynomial line-core fit

; here goes the line-core calculation...
;position of the line core
LCC = (-fit[1])/(2*fit[2])+ xspl[LC]
LCC_norm = (-fit[1])/(2*fit[2])
;intensity of the line core 
core_intens = fit[0]+fit[1]*LCC_norm+fit[2]*LCC_norm^2

;line core position 
vline, LCC, linestyle = 5
print,'LCC:' 
print, LCC
print, 'core intensity' 
print,core_intens

end
