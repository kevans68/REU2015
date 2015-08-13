;NAME: 
;correl.pro 
;PURPOSE: 
;to create correlation images for all parameter comparisions 
;BY 
;Kaitlin Evans 
;-
@/Users/evans/idllib/sym.pro
@/Users/evans/idllib//astron/pro/plot/legend.pro
@corr_grid
@corr_grid_ai
@corr_grid_ap
@corr_grid_pi
;set main directory to search for data 
maindir = '/users/evans/iss_data/'

;search for all subdirectories that begin with output (these contain the .sav files)  
datadir = file_search(maindir+'*/','output*')

;find number of subdirectories 
elem_datadir = n_elements(datadir)

i=0
j=0

labels = ['Fe I 537.68','Fe I 537.96','Fe I 538.34','Mn I 537.76','Ti II 538.10','Fe I 539.15','Fe I 539.32','Fe I 539.52','Fe I 539.71','Mn I 539.48','Ni I 539.23']

xlabels1 = ['Fe I','Fe I','Fe I','Mn I','Ti II','Fe I','Fe I','Fe I','Fe I','Mn I','Ni I']

xlabels2 = ['537.68','537.96','538.34','537.76','538.10','539.15','539.32',' 539.52','539.71','539.48','539.23']


;create array of lcc values 
area_info = ptrarr(elem_datadir)
intensity_info = ptrarr(elem_datadir) 
lcc_info =ptrarr(elem_datadir) 
avg_arr = dblarr(elem_datadir)
lcc_var_arr =strarr(elem_datadir) 

	;loop over all subdirectories 
	for i=0, elem_datadir-1 do begin

	       	newdir= datadir[i]

		;change current directory to subdirectory i 	
		cd, newdir	

		;search for .sav files in this subdir 
		newfiles = file_search(newdir,'*.sav')

		;find number of elements in this subdir 
		elem_new = n_elements(newfiles)

		;create an arrays to store information for each file in newdir
		arr_area = dblarr(elem_new)
		arr_lcc = dblarr(elem_new) 
		arr_intens = dblarr(elem_new) 

			;loop over all files in newdir 
			for j=0, elem_new-1 do begin

				;restore area and lcc for each file 
				restore, newfiles[j]

				;store area, inensity  and lcc in array for each file 
				arr_area[j] = area 
				arr_lcc[j] = lcc
			        arr_intens[j] = core_intens 	

			endfor

		area_info[i]=ptr_new(arr_area)
		intensity_info[i]= ptr_new(arr_intens) 
		lcc_info[i] = ptr_new(arr_lcc) 
	endfor
	

;corr_grid, area_info,xlabels1,xlabels2, labels

corr_grid_ai,area_info, intensity_info,xlabels1, xlabels2,labels

;corr_grid_ap, area_info,lcc_info,xlabels1,xlabels2, labels

;corr_grid_pi, lcc_info, intensity_info,xlabels1,xlabels2,labels 

end
