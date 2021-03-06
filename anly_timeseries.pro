;NAME: 
;anly_timeseries.pro 
;PUROPSE: 
;plot a linear regression of spectral lines in the specified band. 
;BY: 
;Kaitlin Evans 
;-

@/Users/evans/idllib/sym.pro
@/Users/evans/idllib//astron/pro/plot/legend.pro
@stamps
band = ''
read,band, prompt='Which band would you line to plot? ' 

;set main directory to search for data 
maindir = '/users/evans/iss_data/'+band+'/'
cd,maindir

;search for all subdirectories that begin with "output" (these contain the .sav files)  
datadir = file_search('output*')

;find number of subdirectories 
elem_datadir = n_elements(datadir)

;fits_arr= make_array(elem_datadir)
i=0
j=0
k=0

;create pointer array to store yfit arrays 
fits_arr = ptrarr(elem_datadir) 

;create array of lcc values 
avg_arr = dblarr(elem_datadir) 

;create pointer array to store scaled yfit values 
fit_scale = ptrarr(elem_datadir) 

	;loop over all subdirectories 
	for i=0, elem_datadir-1 do begin

	       	newdir= maindir+datadir[i]

		;change current directory to subdirectory i 	
		cd, newdir	

		;search for .sav files in this subdir 
		newfiles = file_search(newdir,'*.sav')

		;find number of elements in this subdir 
		elem_new = n_elements(newfiles)

		;create an array to store the areas for each file in newdir
		arr_area = dblarr(elem_new)

		;create an array to store lcc values for each file in newdir
		arr_lcc = dblarr(elem_new)
		

			;loop over all files in newdir 
			for j=0, elem_new-1 do begin 

				;restore area and lcc for each file 
				restore, newfiles[j]

				arr_area[j] = area 
				arr_lcc[j] = lcc
				
			endfor  
			avg_arr[i] = mean(arr_lcc)
		;create timestamps 
		savefile=newfiles
		stamps,savefile,tstamps=tstamps
		
		;fit a curve to the data 
		fits = regress(tstamps,arr_area,yfit=yfit)

		;reform yfit to be an array with one dimension (same number of elements) 
		fits_ref =reform(yfit)

		;create pointer array elements 
		fits_var = ptr_new(fits_ref)

		;add fits_var to pointer array 
		fits_arr[i]  = fits_var
		 
		;normalized data
		fit_sum= fits_ref/fits_ref[0]
		fit_scale[i] = ptr_new(fit_sum)
				
	endfor	

;reset to main directory 		
cd, '/Users/evans/'
avg_arr_str = string(avg_arr)
device, decompose=0
loadct,0, /silent
colors= ['blue','black','green','purple','crimson','dark orange','Fuchsia']
plot1= plot(tstamps,*fit_scale[0], xtickformat='LABEL_DATE', ytitle='Area',title='Linear Fits '+band,xtitle= 'Time (Month/Year)',/nodata) 

l=0
loadct,13, /silent
	for l=0, elem_datadir-1 do begin 
		plot2=plot(tstamps,*fit_scale[l],color=colors[l],/overplot)
	endfor 
leg=legend(label=str_avg_arr,auto_text_color=1)

m=0
	for m=0, elem_datadir-1 do begin 
		leg[m].label=avg_arr_str[m]
	endfor
plot2.save,'/users/evans/iss_data/paperplots/lin_regression'+band+'.eps'
end
