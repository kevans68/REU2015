Pro wavelength_define,wavestart=wavestart,ans_ws=ans_ws,waveend=waveend, ans_we=ans_we
;NAME: 
;wavelength_define
;PURPOSE: 
;ask user for the desired starting and ending wavelength for spectral line  analysis
;KEYWORDS:
;wavestart: user defined starting wavelength for analysis
;waveend: user defined ending wavelength
;BY: 
;Kaitlin Evans 
;-

ans_ws = ''
        repeat begin
		 read, wavestart, prompt = 'Enter starting wavelenth: ' 
		 read, ans_ws, prompt= 'is this correct?(y/n): '
	 endrep until ans_ws Eq 'y'

 ;ask user to define ending wavelegth 
 ans_we = ''       
 	repeat begin 
		 read, waveend, prompt = 'Enter ending wavelength: '
		 read, ans_we, prompt= 'is this correct? (y/n): '       
	 endrep until ans_we Eq 'y'
 end           
