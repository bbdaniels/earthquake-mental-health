** Master do-file for earthquake analysis

* Set directory: the location of the downloaded repository

global directory "/Users/bbdaniels/GitHub/earthquake-mental-health"

* Load adofiles only from here

  sysdir set PLUS "${directory}/ado/"

* For data preparation: experimental version of |iecodebook|

  global data "/Users/bbdaniels/Box/Earthquake/Constructed"
	qui do "${directory}/ado/iecodebook.ado"

  net from "https://github.com/bbdaniels/stata/raw/master/"
    net install forest , replace
  net from "https://github.com/bbdaniels/stata/raw/master/"
    net install outwrite , replace

  foreach dta in analysis_hh analysis_mental analysis_all {

    iecodebook export ///
      "${data}/`dta'.dta" ///
    using "${directory}/data/`dta'.xlsx" ///
    , replace reset copy hash ///
      trim("${directory}/do/figures.do" ///
        "${directory}/do/tables.do" ///
        "${directory}/do/appendix-figures.do" ///
        "${directory}/do/appendix-tables.do")

  }

* Graph scheme: https://graykimbrough.github.io/uncluttered-stata-graphs/

  cd "${directory}/ado/"
  set scheme uncluttered

* Global options

	global graph_opts ///
		title(, justification(left) color(black) span pos(11)) ///
		graphregion(color(white) lc(white) lw(med) la(center)) /// <- Delete la(center) for version < 15
		ylab(,angle(0) nogrid) xtit(,placement(left) justification(left)) ///
		legend(region(lc(none) fc(none)))

	global comb_opts graphregion(color(white) lc(white) lw(med) la(center))
	global hist_opts ylab(, angle(0) axis(2)) yscale(noline alt axis(2)) ytit(, axis(2)) ytit(, axis(1)) yscale(off axis(2)) yscale(alt)
	global xpct `" 0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%" "'
	global numbering `""(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)" "(10)""'

* Run all program files

  do "${directory}/do/figures.do"
  do "${directory}/do/tables.do"
  do "${directory}/do/appendix-figures.do"

* End of master do-file
