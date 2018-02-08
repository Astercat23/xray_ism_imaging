#! /usr/bin/env bash
##
## logfile.sh -- Log file for creating a template for exclude region
##
##INPUT
##     1,2 = x and y coordinated for the center
##     1 = roll angle to be subtracted/added
##
## 2017.08.09 dbeeler@wisc.edu
##-------------------------------------------------------------------------

#setting variables
object=${1}
obsid=${2}
evt2=${1}/${2}/acis_${2}_evt2.fits

#template region 
#contam=GX13+1/2708/contam.reg

#we already found the center with the tgfindzo script previously
tg_outfile=regions/${2}_tgfindzo.fits

punlearn tg_findzo
pset tg_findzo clobber+
tg_findzo infile=${evt2} outfile=${tg_outfile} #zo_pos_x=4086 zo_pos_y=4116

#We want the x and y coordinates of the center and be able to roll from that center
punlearn dmstat
dmstat "${tg_outfile}[cols X]" centroid=no
xtg=`pget dmstat out_mean`
dmstat "${tg_outfile}[cols Y]" centroid=no
ytg=`pget dmstat out_mean`

#now we find the roll angle
#don't really need this because the roll angle will be passed with the outfile?
dmlist $evt2 header | grep ROLL_NOM

#the roll angle for the template obsid 2708 is
#Now we run the python script that will use the inputs x, y, and evt2 file we want to edit

~/Ciao/Scripts/contam_reg_translation.py ${xtg} ${ytg} ${evt2}


