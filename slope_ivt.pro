;NAME: 
;slope_ivt.pro
;PUPOSE: 
;using linear regression find the chage in slope for intensity vs time data 
;BY: 
;Kaitlin Evans 
;-


@/Users/evans/idllib/sym.pro
@/Users/evans/idllib//astron/pro/plot/legend.pro
@stamps
@year_intensity_smooth
@hyear_intensity_smooth

;set main directory to search for data 
maindir = '/users/evans/iss_data/'

cd,maindir

;search for all subdirectories that begin with output (these contain the .sav files)  
datadir = file_search(maindir+'*/','output*')

;find number of subdirectories 
elem_datadir = n_elements(datadir)

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


cd,'/Users/evans/'

fits = regress(tstamps, arr_intense,yfit=yfit)

rise = yfit[n_elements(yfit)-1]-yfit[0]
run = tstamps[n_elements(tstamps)-1]-tstamps[0] 
roc = rise/run

print, 'rate of change: ' + lcc_var 
print, roc
	endfor
end
