PRO bisector_area, k, LCC, y0arr,bisectarr,unit, area=area
;NAME: 
;bisector_area
;PURPOSE: 
; To calculate the area between the line core and the associated spectral line 
;
;INPUTS: 
; bisectarr: array of x values 
; y0arr: array of y values 
; k: last index for bisectarr and y0arr
;
;KEYWORDS: 
; area: returns the total area
;
;BY: 
;Kaitlin Evans 
;-

;define counter 
i = 0

;define starting index for the loop 
startidx = 0

;define ending index of loop :k is the number of elements in y0arr and bisectarr 
stopidx = k-1 
; define variable	
area = 0.


	for i=startidx,stopidx-1 do begin
		
		;calculate area of current trapazoid  
		area_piece = 0.5*(y0arr[i+1]-y0arr[i])*(abs(bisectarr[i]-LCC)+abs(bisectarr[i+1]-LCC))

		;add up all trapezoid pieces to get total area 
		area = area+area_piece
	
	endfor 

print, 'area : '
print, area

end 
