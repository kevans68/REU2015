Pro dir_define, dirin=dirin, output=output
;NAME
;dir_define
;PURPOSE
;to define a directory and subdirectory, repeats until the user confirms the answers 
;INPUT
;dirin: user defined directory 
;output:user difined directory to save output to. 
;BY
;Kaitlin Evans 
;-
; store user defined directory as a variable 
dirin = ''

;store user defined subdirectory as a variable 
output = ''

;ask user for directory where data files can be found 
ans = ''
	repeat begin		
		read,dirin, prompt='Enter directory: '
		read, ans, prompt= 'Is this correct?(y/n): '	
	endrep until ans Eq 'y'


;ask user for subdirectory in which to store output
ans_out = ''
	repeat begin
		read,output, prompt='Save output to:' 
		read, ans_out, prompt= 'Is this correct?(y/n): '
	endrep until ans_out Eq 'y'

