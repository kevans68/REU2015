PRO stamps, savfile, tstamps=tstamps
;NAME 
;stamps 
;PURPOSE 
;to extract time stamp information from the ISS data  
;INPUT
;savefile: The files to extract time stamp information from 
;OUTPUT 
;tstamps: extracted julian date time stamps 
;BY: 
;Kaitlin Evans 

elem_files =  n_elements(savfile)
tstamps = dblarr(elem_files)

	for i=0, elem_files-1 do begin 
		b_sav = file_basename(savfile[i])
		year = 2000+double(strmid(b_sav,5,2))
		month = double(strmid(b_sav,7,2))
		day = double(strmid(b_sav,9,2))
		hour = double(strmid(b_sav,12,2))
		min = double(strmid(b_sav,14,2))
		sec = double(strmid(b_sav,16,2))
		julian = julday(month,day,year,hour,min,sec)
		tstamps[i] = julian
	endfor

;format time stamp 
 date = label_date(date_format=['%N/%Y'])

end 
