Pro get_line,xall,wavestart,waveend,yall, xnew=xnew,ynew=ynew,xelements=xelements
;NAME:
;Kaitlin Evans 
;PURPOSE: 
;To return a shortened array of xi(wavelength) and y(intensity) values that give that focus
;in on the desired spectral line. 
;INPUT:  
;xall: array of all x values in the data 
;wavestart: User defined starting wavelength 
;waveend: Users defined ending wavelenth 
; yall array of all y values in the data 
;OUTPUT 
;xnew: array of x values from wavestart to waveend
;ynew: array of y values from wavestart to waveend 
;xelements: number of elements in the xnew and ynew
;BY: 
;Kaitlin Evans 
;-
; find the indices for x that are between starting and ending wavelength   
xtrim = where((xall GT wavestart) and (xall LT waveend))

; number of elements in xtrim 
xelements = n_elements(xtrim)

; first element in xtrim: use to find first value in xall within specified wavelengths
idx0 = xtrim[0]

; last element in xtrim: use to find last value in xall with specified wavelengths 
idxend = xtrim[xelements-1]

; create x and y arrays with the same number of values as xtrim 
xnew = dblarr(xelements-1)
ynew = dblarr(xelements-1)
j = 0 

	for j=0, xelements-2 do begin
		; get value of xtrim at index j 	
		 x_idx = xtrim[j]

		;create array of x values
		xnew[j] = xall[x_idx]
		
		;create array of y values	
		ynew[j] = yall[x_idx]	
	endfor
end
