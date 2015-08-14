Pro corr_grid_ai, area_info,intensity_info,xlabels1, xlabels2,labels 
;NAME: 
;corr_grid_ai 
;PURPOSE: 
;create an image of correlation coefficients for area and intensity 
;INPUT:
;area_info: array of area information 
;intensity_info: array of intensity information 
;xlabels1: string array of line types 
;xlabels2: string array of line wavelengths 
;labels :  string array of y labels (line information and wavelength) 
;BY:
;Kaitlin Evans 
;-
;find number of elements in area info 
elem_area=n_elements(area_info) 

;create array to hold correlations for each line against all other lines 
corr = dblarr(elem_area) 

;create a double array with dimensions needed for grid 
corr_block=make_array(elem_area+1,elem_area+1) 
 
xax= findgen(elem_area+1) 
yax = findgen(elem_area+1)

device,decompose=1 
loadct,0,/silent 

set_plot,'PS'
device, filename='/users/evans/iss_data/comp_ai.eps',/color,/encapsulated
device, xsize= 15, ysize=15
device, bits_per_pixel=8
;create grid 
contour,corr_block,xax,yax,title= 'Correlation Coefficients: Area-Intensity', ticklen=1.0,xtickinterval=1,ytickinterval=1,xtickname=replicate(' ',30) ,ytickname=replicate(' ',30),xminor=1,yminor=1,/nodata

loadct,13,/silent

	for l=0, n_elements(area_info)-1 do begin
		    xyouts,.17+.075*l,.08,xlabels1[l],charsize=.6,/normal
	endfor  

	for n=0,n_elements(area_info)-1 do begin
       		xyouts,.16+.075*n,.065,xlabels2[n],charsize=.6,/normal
	 endfor  

	for m=0, n_elements(area_info)-1 do begin 
		xyouts,.05,.13+.08*m, labels[m],charsize=.6,/normal 
	endfor 
xyouts,.01,.5,'Area',/normal
xyouts,.5,.045,'Intensity',/normal
xyouts,.01,.05,'0',/normal
xyouts,.98,.05,'1',/normal
	 
	for i=0, elem_area-1 do begin 

		;find all correlation values for the ith elements with all other elements 
		for j=0,elem_area-1 do begin 
			corr[j] = correlate(*area_info[i],*intensity_info[j])
			corr_abs = abs(corr)
		endfor
		
		;for each correlation find the color corresponding to the correlation value and fill 
		for k=0, elem_area-1 do begin 

			;multiply the coeffcient by 255 to find color 
			color= fix(corr_abs[k]*255)

			;x values for the square to fill 
			x=[i,i+1,i+1,i]
		
			;y values for the square to fill 
			y=[k,k,k+1,k+1] 
			
			;fill in square 	
			polyfill,x,y,color=abs(color), /data
		endfor
	endfor
cb_xsz=512 
cb_ysz=15
; continuous color bar 
color = 255*DINDGEN(cb_xsz)/(cb_xsz-1)
scale = color # REPLICATE(1.0,cb_ysz)

TVSCL,scale

LOADCT, 0, /SILENT

        
device,/close
loadct,0,/silent


device,/close
loadct,0,/silent
cd,'/users/evans/'

end 
