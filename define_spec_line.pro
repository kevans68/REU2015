;NAME: 
; define_spec_line.pro 
;PURPOSE: 
;To define the wavelengths and process the given spectral line data 
;BY: 
;Kaitlin Evans 
;- 

@/Users/evans/idllib/sym.pro
@/Users/evans/idllib/vline.pro
@/Users/evans/idllib/hline.pro
@/Users/evans/idllib/gaussian.pro
@wavelength_define.pro
@get_line.pro
@line_core_calc.pro
@cubic_spl.pro
@lin_interpol.pro
@bisector_area.pro
loadct,0,/silent
device, decompose = 0


; define main directory where fits files can be found 
;dir = '/Users/evans/iss_data/Mn_I_band/*/'
 
; store user defined directory as a variable 
dirin = ''

;store user defined subdirectory as a variable 
output = ''

;ask user for directory where data files can be found 
ans = ''
	repeat begin            
	       	read,dirin, prompt='Enter directory: '
		read, ans, prompt= 'Is this correct?(y/n): '    
	endrep until ans Eq 'y'


;ask user for subdirectory in which to store output
ans_out = ''
	repeat begin
		read,output, prompt='Save output to:' 
		read, ans_out, prompt= 'Is this correct?(y/n): '
	endrep until ans_out Eq 'y'

file_mkdir, dirin+output

; add */ to supplied directory so files can be found in all subdirectories 
dir =dirin + '*/'

;ask user to define starting and ending wavelengths
wavelength_define,ans_ws=ans_ws,wavestart=wavestart,waveend=waveend,ans_we=ans_we

;search for all fits files 
datafiles = file_search(dir,'*fts.gz')

;number of data files 
elem_data = n_elements(datafiles)

i=0

;define variable in which to store confirmation of correct line 
confirm = ''

;define variable in which to store number of exculded observations (incomplete data) 
error_num = 0 
	
	;loop through each data file reading in and processing the data: 
	for i=0, elem_data-1 do begin
		
		getdata = datafiles[i]
		data = readfits(getdata,hdr)
		
		;print number of data files that still need to be processed 
		print, 'Files remaining: ' 
		print, (elem_data)-(i+1)

		print, 'Element number:'
		print, i 

		;create a new file to save program output (LCC, bisector area, other relevent information) 
		savefile = dirin + output + file_basename(datafiles[i], '.fts.gz')+'.sav'

		print, 'write data to:'
		print, savefile
		
		; wavelength values  
		xall = data[*,0] 

		; intensity values 
		yall= data[*,1]
	
		; plot spectra	
			if i Eq 0 then begin 
				read,ymax,prompt='define ymax: '
			endif

		loadct,0,/silent
		plot, xall, yall 

		;find x and y values corresponding to the desired spectral line 
 		get_line,xall,wavestart,waveend,yall,xnew=xnew,ynew=ynew, xelements=xelements

		;plot x and y values 
		loadct, 13, /silent
		oplot,xnew,ynew
		loadct,18,/silent
		hline,ymax,linestyle=1 
			
			;ask user if they wish to continue or redefine wavelengths
			if i Eq 0 then begin 
				read,confirm, prompt= 'Are the wavelengths correct?(y/n): '
			endif 

			;This loop is entered during only if the loop is in the first interation and confirm is /= y. 
			;Allows you to redefine wavelengths. 
			if (i Eq 0) and (confirm Ne 'y') then begin	
				repeat begin

					;ask user to define starting and ending wavelengths
			             	wavelength_define,wavestart=wavestart,waveend= waveend,ans_ws=ans_ws,ans_we=ans_we	
						
					;find x and y values corresponding the the desired spectral line
					get_line, xall,wavestart,waveend,yall,xnew=xnew,ynew=ynew,xelements=xelements
						
					;plot the entire band with xnew and ynew overploted 
              				loadct, 0, /silent
					oplot, xall, yall

		        		loadct,13,/silent	
					oplot,xnew,ynew

					loadct, 18,/silent
					hline,ymax, linestyle=1
				
					;ask user if this this the correct line. 
		       			read,confirm, prompt= 'Are the wavelengths correct?(y/n): '	
				endrep until confirm Eq 'y'
			endif
			
			;this loop asks the user to confirm ymax 
			if i Eq 0 then begin 
				yconfirm = ''
				read,yconfirm, prompt= 'Is ymax correct?(y/n): '
			endif	

			if (i Eq 0) and (yconfirm Ne 'y') then begin

				repeat begin 
					read,ymax,prompt='define ymax: '

					;plot the entire band with xnew and ynew overploted 
              				loadct, 0, /silent
					plot, xall, yall

		        		loadct,13,/silent	
					oplot,xnew,ynew
					
					loadct,18,/silent
					hline,ymax, linestyle=1


					read, yconfirm, prompt= 'Is ymax correct?: '
				endrep until yconfirm Eq 'y'
			endif
	

		;define n
		n =fix(xelements - 1) 

		;define ymin 
		ymin = min(ynew)+0.01

		loadct,0, /silent 
		plot, xnew,ynew,xtitle="X (lambda)", ytitle="Y (intensity)", title="Spectral Line Profile",psym = sym(1)

		hline, ymin, linestyle=1
		hline, ymax, linestyle=1

		;run cubic spline interpolation 
		cubic_spl,n,xnew,ynew,nspl=nspl ,xspl=xspl,yspl=yspl

		; run line_core_calc 
		line_core_calc, xspl,yspl,unit, xdata=xdata, ydata=ydata, yfit=yfit, LCC=LCC,fit=fit, core_intens=core_intens		
		;reset error handling variable to zero after each iteration of the loop 
		error_stat = 0
	
		;catch any index that has incomplete data (causes error at line_core calc) 
		catch, error_stat

			;if an error occurs print the index which has incomplete data 
			if error_stat NE 0 then begin
				print, 'Incomplete data at : '
				print, i
			       error_num = error_num + 1 	
			endif

			;start next iteration of the loop if there is incomplete data  
		if error_stat NE 0 then continue 
		;run lin_interpol 
		lin_interpol,nspl,yspl,xspl,ymin,ymax, bisectarr=bisectarr, y0arr=y0arr, k=k

		; run bisector_area 
		bisector_area, k, LCC, y0arr,bisectarr,unit, area=area
		
		;close save variables to savefile  
		save, filename = savefile,LCC, area, core_intens,wavestart,waveend
	endfor
	print, 'number of spectra excluded because of incomplete data: ' 
	print, error_num
end
