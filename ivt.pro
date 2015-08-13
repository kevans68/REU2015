;NAME:
;ivt.pro
;PURPOSE:
;to plot the intensity vs time data smoothed over 1 year and half a year 
;BY: 
;Kaitlin Evans 
;-

@/Users/evans/idllib/sym.pro
@/Users/evans/idllib//astron/pro/plot/legend.pro
@stamps
@year_intensity_smooth
@hyear_intensity_smooth
band=''
read,band,PROMPT='which band would you like to plot? '

;set main directory to search for data 
maindir = '/users/evans/iss_data/'+band+'/'

cd,maindir

;search for all subdirectories that begin with output (these contain the .sav files)  
datadir = file_search('output*')

;find number of subdirectories 
elem_datadir = n_elements(datadir)

;create array of lcc values 
avg_arr = dblarr(elem_datadir) 

;create pointer array of intensity information 
intens_scale=ptrarr(elem_datadir)
intens_scaleh=ptrarr(elem_datadir)

	;loop over all subdirectories 
	for i=0, elem_datadir-1 do begin

	       	newdir= maindir+datadir[i]

		;change current directory to subdirectory i 	
		cd, newdir	

		;search for .sav files in this subdir 
		newfiles = file_search(newdir,'*.sav')

		;find number of elements in this subdir 
		elem_new = n_elements(newfiles)
		
		arr_intense=dblarr(elem_new)
		arr_lcc=dblarr(elem_new)
		arr_area=dblarr(elem_new) 
	
			;loop over all files in newdir 
			for j=0, elem_new-1 do begin

				;restore area and lcc for each file 
				restore, newfiles[j]

				;store core intensity  and lcc in array for each file 
				arr_intense[j] = core_intens  
				arr_area[j] = area 
				arr_lcc[j] = lcc
					
			endfor 

		;create an array of average lcc values(one lcc value per dataset) 
		avg_arr[i] = mean(arr_lcc)
		avg_arr_str = string(avg_arr)
		lcc_var=strcompress(avg_arr_str[i],/remove_all)
		input = lcc_var.replace('.','_')

		;run stamps to create time stamps 
		savefile=newfiles
		stamps,savefile,tstamps=tstamps
		
		;smooth intensity over a year
		year_intensity_smooth,tstamps,arr_intense,avg_int_year=avg_int_year

		;smooth intensity over half a year 
		hyear_intensity_smooth,tstamps,arr_intense,avg_int_hyear=avg_int_hyear

		;normalized data (intesity over a year)
		fit_sum=avg_int_year/avg_int_year[0]
		intens_scale[i] = ptr_new(fit_sum)

		;normalixe data (intensity over half year)
		fit_sumh=avg_int_hyear/avg_int_hyear[0]
		intens_scaleh[i]=ptr_new(fit_sumh)
	
	endfor
cd,'/Users/evans/'

plot1=plot(tstamps,arr_intense,xtitle='Date (Month/Day/Year)', ytitle='Intensity',title='Core Intensity vs. Time Smoothed Over a Year (Band: '+band+')',xtickformat = 'LABEL_DATE',FONT=12,yrange=[0.94,1.06],window_title='I Year',/nodata)
k=0
decompose=0 
loadct,11,/silent

colors = ['blue','black','green','purple','crimson','dark orange','Fuchsia']

	for k=0,elem_datadir-1 do begin 
		plot2=plot(tstamps,*intens_scale[k],thick=3,overplot=1,color=colors[k])
	endfor
	leg=legend(label=avg_arr,auto_text_color=1)

m=0 
	for m=0,elem_datadir-1 do begin
		leg[m].label=avg_arr_str[m]
	endfor


plot2.save, '/users/evans/iss_data/paperplots/ivtyear'+band+'.eps'

;l=0

;plot3=plot(tstamps,arr_intense,xtitle='Date (Month/Day/Year)', ytitle='Intensity',title='Core Intensity vs. Time Smoothed over 1/2 Year (Band: '+band+')',xtickformat = 'LABEL_DATE',FONT=12,yrange=[0.8,1.15],window_title='I 1/2 year',/nodata)
;	for l=0,elem_datadir-1 do begin 
;		plot4=plot(tstamps,*intens_scaleh[l],thick=3,/overplot)
;	endfor

;	leg=legend(label=avg_arr,auto_text_color=1)
;n=0
;	for n=0, elem_datadir-1 do begin 
;		leg[n].label=avg_arr_str[n]
;	endfor

end
