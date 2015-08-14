;NAME: 
;create_profile
;PURPOSE: 
;to simulate sprectral data and  bisector calcualations using a perfect guassian
;to test accuracy
;-
@/Users/evans/idllib/sym.pro
@/Users/evans/idllib/vline.pro
@/Users/evans/idllib/hline.pro
@/Users/evans/idllib/gaussian.pro
@/Users/evans/idllib/astron/pro/math/tsum.pro
@line_core_calc.pro
@cubic_spl.pro
@lin_interpol.pro
@bisector_area.pro
@bisector_tsum.pro
@bisector_inttab.pro
@profileps.pro
device, decompose=0
loadct,0,/silent

n = 96                      ; number of data points
x =500+(dindgen(n)-n/2)/(n/2)      ; x-dimension array

params = [0.8,$                 ; maximum amplitude of Gaussian function
          500,$                ; center of Gaussian function
          0.2]                  ; standard deviation (sigma) of Gaussian function

y = 1.0-gaussian(x,params,/double)

plot, x, y, xtitle="X (lambda)", ytitle="Y (intensity)", title="'Spectral Line Profile'", yrange=[0,1.1], xrange=[499.99, 500.02]
oplot, x, y, psym=sym(1)


vline, params[1], linestyle=1                   ; denote line-core

ymax = 0.9 
ymin = 0.25
hline, [ymin,ymax], linestyle=2         ; upper- and lower-bounds for bisectors


;increase "resolution" of points using cubic spline
cubic_spl,n, x, y, nspl=nspl, xspl=xspl, yspl=yspl

;calculate the line core using second order polynomial 
line_core_calc, xspl, yspl, xdata=xdata, ydata=ydata, yfit=yfit, LCC=LCC, fit=fit

; find points using linear interpolation
lin_interpol, nspl, yspl, xspl, ymin, ymax, bisectarr=bisectarr, y0arr=y0arr, k=k

;find area of the bisector 
bisector_area, k, LCC, y0arr,bisectarr, area=area 

; find bisector area using TSUM 
;bisector_tsum, bisectarr, LCC, y0arr

; find bisector area using INT_TABULATED 
;bisector_inttab, bisectarr, LCC, y0arr

;create a post script file of the spectral profile with all previous information included  
;profileps, x, y, xdata, ydata, yfit, yspl, xspl, bisectarr, y0arr 

end 

