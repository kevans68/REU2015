;NAME: 
;ivt_slope.pro 
;PURPOSE: 
;to find the change in slope for each line in the area vs. time plot
;BY:
;Kaitlin Evans 
;- 
@/Users/evans/idllib/sym.pro
@/Users/evans/idllib//astron/pro/plot/legend.pro
@stamps


;set main directory to search for data 
maindir = '/users/evans/iss_data/'
cd,maindir

;search for all subdirectories that begin with output (these contain the .sav files)  
datadir = file_search(maindir+'*/','output*')

;find number of subdirectories 
elem_datadir = n_elements(datadir)

;fits_arr= make_array(elem_datadir)
i=0
j=0

;create array of lcc values 
avg_arr = dblarr(elem_datadir) 
sum = 0 
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
		arr_i = dblarr(elem_new)

		;create an array to store lcc values for each file in newdir
		arr_lcc = dblarr(elem_new)
		
		;create tstamps
		savefile=newfiles
		stamps,savefile,tstamps=tstamps

			;loop over all files in newdir 
			for j=0, elem_new-1 do begin 
			if tstamps[j] lt 2454470 then continue		
				;restore area and lcc for each file 
				restore, newfiles[j]

				arr_i[j] = core_intens 
				arr_lcc[j] = lcc
				
			endfor

		avg_arr[i] = mean(arr_lcc)

		fits = regress(tstamps,arr_i,yfit=yfit) 	
		
		;calculate rate of change 
		rise = yfit[n_elements(yfit)-1]-yfit[0]
		run = tstamps[n_elements(tstamps)-1]-tstamps[0]	

		roc = rise/run

		print, 'rate of change line : ' +strcompress(string(avg_arr[i]))
		print, roc	

		sum = (roc+ sum)/elem_datadir 
	endfor		
print,sum
;reset to main directory 		
cd, '/Users/evans/'
stop
end
