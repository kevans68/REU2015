;NAME: 
;avt_band_compare 
;PURPOSE 
;Create plots of smoothed area vs. time data smoothed over 1 year and over half a year for a specified band  
;BY: 
;Kaitlin Evans 
;-
@/Users/evans/idllib/sym.pro
@/Users/evans/idllib/astron/pro/plot/legend.pro
@stamps
@halfyear_smooth
@year_smooth
band=''
bandinfo=''
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

;pointer array containing areas smoothed over half year 
area_halfyr = ptrarr(elem_datadir)  

;pointer array containing areas smoothed over full year 
area_yr =ptrarr(elem_datadir) 

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

				;store area and lcc in array for each file 
				arr_area[j] = area 
				arr_lcc[j] = lcc
					
			endfor 
		
		;create an array of average lcc values(one lcc value per dataset) 

	
		avg_arr[i]=mean(arr_lcc) 
		avg_arr2 = [[0],avg_arr]
		avg_arr_str =strcompress(string(avg_arr))
		lcc_var=strcompress(avg_arr_str[i],/remove_all)
		input = lcc_var.replace('.','_')
	
		;run stamps to create time stamps 
		savefile=newfiles
		stamps,savefile,tstamps=tstamps
		
		;run halfyear_smooth 
		halfyear_smooth,tstamps,arr_area,avg_area_hyear=avg_area_hyear

		;run year_smooth 
		year_smooth,tstamps,arr_area,avg_area_year=avg_area_year


		;normalized data
		fit_sum = avg_area_hyear/avg_area_hyear[0]
		area_halfyr[i] = ptr_new(fit_sum)
		
		fit_sumy=avg_area_year/avg_area_year[0]
		area_yr[i] = ptr_new(fit_sumy)
		
	endfor
cd,'/Users/evans/'


decompose = 0
loadct,0,/silent

;!P.FONT=1
;set up plot 

plot1=plot(tstamps, arr_area,yrange=[0,2.5],xtitle='Date (Month/Year)', ytitle='Normalized Area',title='Normalized Area vs. Time Smoothed Over 1/2 Year (Band:'+band+')',xtickformat = 'LABEL_DATE',FONT=18,FONT_STYLE=1,window_title='1/2 year', /nodata)

colors = ['blue','black','green','purple','crimson','dark orange','Fuchsia']
loadct,11,/silent 

j=0
	for j=0,elem_datadir-1 do begin 
		;plot area smoothed over 1/2 year vs. time 
		plot2=plot(tstamps,*area_halfyr[j],overplot=1,thick=3,color=colors[j])
		
	endfor

;plot2.save,'/users/evans/iss_data/area_halfyear'+band+'.eps'
leg=legend(label=(avg_arr),auto_text_color=1,units='nm')

l=0 
for l=0, elem_datadir-1 do begin 
	leg[l].label=avg_arr_str[l]
endfor


plot3=plot(tstamps,arr_area,yrange=[0.6,1.20],xtitle='Date (Month/Year)', ytitle='Normalized Area',title='Normalized Area vs. Time Smoothed Over 1 Year (Band:'+band+')',xtickformat = 'LABEL_DATE',FONT=18,FONT_STYLE=1,window_title='year', /nodata) 


;plot area smoothed over a year 
k=0
	for k =0 ,elem_datadir-1 do begin 
		plot4=plot(tstamps,*area_yr[k],overplot=1,thick=3,color=colors[k])

	endfor

leg=legend(label=avg_arr,auto_text_color=1,units='nm')

m=0
for m=0,elem_datadir-1 do begin 
	leg[m].label=avg_arr_str[m]
endfor

plot4.save,'/users/evans/iss_Data/paperplots/areayear'+band+'.eps'

end

