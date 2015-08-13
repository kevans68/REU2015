;NAME: 
;avt_overplot_one 
;PURPOSE
;to create a plot of area vs time data for one specified line
;and then overplot smoothed data (6 month smooth and 1 yea smooth)  
;BY
;Kaitlin Evans 
;-

@/Users/evans/idllib/sym.pro
@/Users/evans/idllib//astron/pro/plot/legend.pro
@stamps
@halfyear_smooth
@year_smooth
maindir = ''
subdir=''

read,maindir, prompt='Enter directory where files are stored: ' 
read,subdir, prompt='Enter subdirectory where sav files are stored: ' 
newfiles=file_search(maindir+subdir,'*.sav')
elem_new = n_elements(newfiles) 
arr_area=dblarr(elem_new)
arr_lcc=dblarr(elem_new)
	for j=0, elem_new-1 do begin
		;restore area and lcc for each file 
		restore, newfiles[j]

		;store area and lcc in array for each file 
		arr_area[j] = area 
		arr_lcc[j] = lcc
					
		endfor 
lcc_mean=strcompress(string(mean(arr_lcc)),/remove_all)
savefile=newfiles
;run stamps to create time stamps 
savefile=newfiles
stamps,savefile,tstamps=tstamps
		
;run half_smooth 
halfyear_smooth,tstamps,arr_area,avg_area_hyear=avg_area_hyear
		
;run full smooth 
year_smooth,tstamps,arr_area,avg_area_year=avg_area_year
		
		
!P.FONT=1
;plot area vs. time 
loadct,0,/silent
plot1=plot(tstamps,arr_area, xtitle='Date (Year/Month/Day)', ytitle='Area',title='Area vs. Time (Line:'+lcc_mean+')',xtickformat = 'LABEL_DATE',FONT=14, SYMBOL='dot',linestyle=6 ,SYM_SIZE=0.70)
	

;overplot data smoothed over 1/2 year 
loadct,13,/silent
plot2=plot(tstamps,avg_area_year,color='green',thick=2,/overplot)

;overplot data smoothed over full year
plot3=plot(tstamps,avg_area_hyear,color='blue',/overplot)
		
leg=legend(target=[plot2,plot3],auto_text_color=1)
leg[0].label='1/2 Year'
leg[1].label='Year'
plot3.save,maindir+'new2_avt_plot'+lcc_mean+'.eps'			

		
cd,'/Users/evans/'

end
