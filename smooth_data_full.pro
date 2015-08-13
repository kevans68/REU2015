;NAME:  
;smooth_data_full.pro
;PURPOSE:  
;to plot the area vs. time data smoothed over 1 year 
;BY: 
;Kaitlin Evans
;-
@/Users/evans/idllib/sym.pro
@/Users/evans/idllib//astron/pro/plot/legend.pro
@stamps
;set main directory to search for data 
maindir = '/users/evans/iss_data/'

;search for all subdirectories that begin with output (these contain the .sav files)  
datadir = file_search(maindir+'*/','output*')

;find number of subdirectories 
elem_datadir = n_elements(datadir)

;pointer array to store area data for each data set 
ptr_area=dblarr(elem_datadir) 

;pointer array to store time stamp data for each data set
ptr_tstamp=ptrarr(elem_datadir) 

fit_scale=ptrarr(elem_datadir) 
ptr_fit=ptrarr(elem_datadir) 
i=0
j=0
l=0

;create array of lcc values 
avg_arr = dblarr(elem_datadir) 

	;loop over all subdirectories 
	for i=0, elem_datadir-1 do begin

	       	newdir= datadir[i]

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

				;store area and lcc in array for each file 
				arr_area[j] = area 
				arr_lcc[j] = lcc
				
			endfor 

		;create an array of average lcc values(one lcc value per dataset) 
		avg_arr[i] = mean(arr_lcc)
		avg_arr_str = string(avg_arr)

		;run stamps to create time stamps 
		savefile=newfiles
		stamps,savefile,tstamps=tstamps
		

		;find min and max values for tstamps (earliest and latest dates)
		stamp_max = max(tstamps)
		stamp_min = round(min(tstamps)) 

		;find total number of days 
		stamp_num = stamp_max-stamp_min

		;find number of full rotational periods 
		rota_num = fix(stamp_num/(26.24))+1
                
		;number of elements in tstamps
		elem_tstamp = n_elements(tstamps)	
		
		k=0 

		;bottom of the range for first timespan 
		bottom = stamp_min

		;top of the range for first timespan 
		top = stamp_min+26.24
		
		;array for the average area of each timespan 
		avg_area=dblarr(rota_num)

		;array containing the average date for each timespan 
		avg_tstamp=dblarr(rota_num)

	
	
			;starting at the first range increase k until stamp_max has been reached 
			repeat begin  
				;find indces where tstamp falls within the current range 
				stamp_w= where((tstamps ge bottom) and (tstamps le top),count)
				
				;number of elements in stamp_w
				elem_w =n_elements(stamp_w)
				
				;array of areas for each timespan 	
				area_sum=dblarr(elem_w)
				tstamp_sum =dblarr(elem_w) 

					;loop over each element in the timespan 
					for l=0, elem_w-1 do begin 
						
						;get the areas corresponding to the current timespan 
						area=arr_area[stamp_w[l]]

						;store the areas in array 
						area_sum[l]=area

						;calculate the mean of the areas for the timespan 
						avg_area_calc =mean(area_sum)

						;store time stamps in array 
						tstamp_sum[l] = tstamps[stamp_w[l]]

						;calculate the average time stamp 
					       avg_tstamp_calc=mean(tstamp_sum)	
					endfor 

				;store the means in an array 
				avg_area[k]=avg_area_calc
				avg_tstamp[k]=avg_tstamp_calc
					
				;increment k  
				k=k+1
				;redefine bottom using k 
				bottom = stamp_min+26.24*k
				;redifine top using k 
				top= stamp_min+(26.24*(k+1))
				print,k
			print, stamp_w
			
				
			endrep until bottom gt stamp_max
		
		fits = regress(avg_tstamp,avg_area,yfit=yfit)
		fits_ref = reform(yfit)
		fits_var=ptr_new(fits_ref)
		;store fits in pointer array for use in overplotting all data sets 
		ptr_fit[i]=fits_var
		
		;normalized data
	        fits_max = max(*ptr_fit[i])
       		fits_min = min(*ptr_fit[i])      
		fits_scaletop=*ptr_fit[i]-fits_min
		fits_scalebottom= fits_max-fits_min
		fit_scale[i] = ptr_new(fits_scaletop/fits_scalebottom)
		

		;store avg_tstamp in pointer array for use in overplotting all data sets 
		ptr_tstamp[i]=ptr_new(avg_tstamp)

		lcc_var=strcompress(avg_arr_str[i],/REMOVE_ALL)	
		input = lcc_var.replace('.','_')
		
		set_plot,'PS' 
		device,filename=maindir+'avt_full_smooth_'+input+'.eps'

		;plot the smoothed data over time
	       loadct,0,/silent	
		plot,avg_tstamp,avg_area,psym=sym(1), xtickformat = 'LABEL_DATE', xtitle='Time (Year/Month/Day)',ytitle='Area', title='Area Vs. Time Smoothed Over Full Rotation (Line:'+lcc_var+')'
		device,/close
		set_plot,'X' 
		
	endfor
device,decompose=0
loadct,0,/silent
color_arr=intarr(elem_datadir)
set_plot,'PS'
!P.FONT=1
device,filename='/Users/evans/iss_data/full_smoothed_curves.eps',/color
plot,*ptr_tstamp[0],*fit_scale[0],font=16, xtickformat='LABEL_DATE', ytitle = 'Area', xtitle='Time(Year/Month/Day)', title = 'Area Curves Over Time: Smoothed Over Full Rotation',/nodata

m=0 
loadct,25,/silent
	for m=0, elem_datadir-1 do begin 
		color=m*20+5
		oplot,*ptr_tstamp[m],*fit_scale[m],color=color
		color_arr[m]=color

	endfor
legend,strcompress(avg_arr_str),textcolor=color_arr
device,/close
set_plot,'X' 
cd,'/Users/evans/'

end
