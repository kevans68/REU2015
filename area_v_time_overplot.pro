;NAME: 
;area_v_time_overplot
;PURPOSE: 
;To overplot data smoothed over 6 months and one year and the Area vs Time graph for an individual line 
;BY: 
;Kaitlin Evans 
;-
@/Users/evans/idllib/sym.pro
@/Users/evans/idllib//astron/pro/plot/legend.pro
@stamps
@half_smooth
@full_smooth
;set main directory to search for data 
maindir = '/users/evans/iss_data/'

;search for all subdirectories that begin with output (these contain the .sav files)  
datadir = file_search(maindir+'*/','output*')

;find number of subdirectories 
elem_datadir = n_elements(datadir)

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
		lcc_var=strcompress(avg_arr_str[i],/remove_all)
		input = lcc_var.replace('.','_')

		;run stamps to create time stamps 
		savefile=newfiles
		stamps,savefile,tstamps=tstamps
		
		;run half_smooth 
		half_smooth,tstamps,arr_area,avg_area=avg_area,avg_tstamp=avg_tstamp
		
		;run full smooth 
		full_smooth,tstamps,arr_area,avg_area_full=avg_area_full,avg_tstamp_full=avg_tstamp_full
		
		;TEST smoothing fuction over set number of points 
		test_sm= smooth(arr_area,13)
		set_plot,'PS'
		!P.FONT=1
		device,filename='/Users/evans/iss_Data/avt_overplot_'+input+'.eps'
		;plot area vs. time 
		loadct,0,/silent
		plot,tstamps,arr_area, xtitle='Date (Year/Month/Day)', ytitle='Area',title='Area vs. Time (Line: '+lcc_var+')',xtickformat = 'LABEL_DATE',FONT=12, PSYM=SYM(1), SYMSIZE=0.25
		color_arr =[50,100,250]
		;overplot data smoothed over 1/2 rotation 
		loadct,13,/silent
		oplot,avg_tstamp[sort(avg_tstamp)],avg_area[sort(avg_tstamp)],color=color_arr[0],thick=2

		;overplot data smoothed over full rotation
		oplot,avg_tstamp_full[sort(avg_tstamp_full)],avg_area_full[sort(avg_tstamp_full)],color=color_arr[1]
		
		;TEST over plot smoothing function output 
		oplot,tstamps,test_sm,color=color_arr[2]
		legend,['1/2 Rotation','Full Rotation','Smooth Function' ],textcolor=color_arr,thick=2
		device,/close 
		set_plot,'X'

		
	endfor
cd,'/Users/evans/'

end
