;NAME: 
;area_v_time.pro 
;PURPOSE: 
;plot the area vs. time data for one specified spectral line 
;BY: 
;Kaitlin Evans 
;-

@/Users/evans/idllib/sym.pro

;define directory where sav files can be found

;maindir '/Users/evans/iss_data/C_I_band/'
maindir = ''
subdir = '' 
subtitle = ''
band = ''
read,maindir, prompt = 'Enter main directory where sav files are stored: ' 
read,subdir, prompt = 'Enter subdirectory where sav files are stored: ' 
read,band, prompt = 'Band: '
read,subtitle, prompt = 'Enter line information and core wavlegeth here(title): ' 
savdir = maindir + subdir 
subdirp = subdir.remove(-1)
;search for save files 
savfiles = file_search(savdir,'*.sav')

;return number of elements in savefiles 
sav_elem = n_elements(savfiles) 

;create a string array with same number of elements as sav_elem  
stamps = dblarr(sav_elem)
areas = dblarr(sav_elem)
i=0 
	for i=0, sav_elem-1 do begin 
		savfile = savfiles[i]
		b_sav = file_basename(savfile)
		year = double(strmid(b_sav,5,2))
		month = double(strmid(b_sav,7,2))
		day = double(strmid(b_sav,9,2))
		hour = double(strmid(b_sav,12,2))
		min = double(strmid(b_sav,14,2))
		sec = double(strmid(b_sav,16,2))
		julian = julday(month,day,year,hour,min,sec)
		stamps[i] = julian
		restore, savdir+b_sav
		areas[i] = area
	endfor
	;plot area vs. time 
	date = label_date(date_format=['%Z/%N/%D'])
	loadct,0,/silent
	plot, stamps,areas,xtitle='Date (Year/Month/Day)', ytitle='Area', title=subtitle, xtickformat = 'LABEL_DATE', PSYM=SYM(1), SYMSIZE=0.25, yrange = [1e-5,3e-4],font=14
	
	

	;write out plot to file
	set_plot, 'PS'
	!P.FONT=1
	device, filename = maindir+band+'_avt_'+subdirp+'.eps',/TT_FONT, SET_FONT="Helvetica", FONT_SIZE=12
	plot, stamps,areas,xtitle='Date (Year/Month/Day)', ytitle='Area', title=subtitle, xtickformat = 'LABEL_DATE', PSYM=SYM(1), SYMSIZE=0.25, yrange = [1e-5,3e-4]

	device,/close 
	set_plot,'X' 
end
