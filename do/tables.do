// Tables for eathquake mental health paper

// Table 1. Regressions
use "$directory/data/analysis_mental.dta", clear

lab var hh_near_quake "Distance to Fault"
lab def hh_near_quake 0 "Far (20km+)" 1 "Near (<20km)"
  lab val hh_near_quake hh_near_quake

  local fault_controls "hh_epidist hh_slope hh_district_1 hh_district_2 hh_district_3"
  local indiv_controls "c.indiv_age indiv_male 1.indiv_married 1.indiv_edu_binary"


  // Regression : Interaction regression
  reg indiv_mentalhealth ///
    c.hh_faultdist##c.hh_logcons `indiv_controls' `fault_controls' ///
  , cl(village_code)

    est sto interaction
    
  // Regression : Distance regression
  reg indiv_mentalhealth ///
    c.hh_faultdist##c.hh_logcons##c.hh_logcons  `indiv_controls' `fault_controls' ///
  , cl(village_code)

    est sto quad

  // Regression : Interaction regression
  reg indiv_mentalhealth ///
    c.hh_faultdist##c.hh_logcons `indiv_controls' `fault_controls' ///
  , cl(village_code) a(village_code)

    est sto villagefe

  // Regression : Interaction regression
  reg indiv_mentalhealth ///
    c.hh_faultdist##c.hh_logcons `indiv_controls' `fault_controls' ///
  if indiv_male == 0 ///
  ,  cl(village_code)

    est sto women

  // Regression : Interaction regression
  reg indiv_mentalhealth ///
    c.hh_faultdist##c.hh_logcons `indiv_controls' `fault_controls' ///
  if indiv_male == 1 ///
  , cl(village_code)

    est sto men

  outwrite interaction quad women men villagefe ///
  using "${directory}/outputs/T_regressions.tex" ///
  , replace stats(N r2) drop(hh_epidist hh_slope hh_district_*) format(%9.3f) ///
    col("Base" "Quadratic" "Women" "Men" "Village FE") ///
    row("Distance from Fault (km)" ""  ///
        "(log) HH Consumption" "" ///
        "Distance $\times$ Consumption" "" ///
        "Age" "" "Men" "" "Married" "" "Primary Education" "" ///
        "Consumption (Square)" "" "Distance $\times$ Consumption (Square)" "" ///
        "Constant" "" "Number of Observations" "Regression R-Square")

// Table 2. Child Death Regressions
use "$directory/data/analysis_mental.dta", clear

  lab var hh_near_quake "Distance to Fault"
  lab def hh_near_quake 0 "Far (20km+)" 1 "Near (<20km)"
    lab val hh_near_quake hh_near_quake

  local fault_controls "hh_epidist hh_slope hh_district_1 hh_district_2 hh_district_3"
  local indiv_controls "c.indiv_age indiv_male 1.indiv_married 1.indiv_edu_binary hh_logcons"

  // Regression : Child death
  reg indiv_mentalhealth ///
    hh_child_death 1.hh_child_death#indiv_male ///
    c.hh_faultdist##c.hh_logcons `indiv_controls' `fault_controls' ///
  , cl(village_code)

    est sto all

  // Regression : Child death
  reg indiv_mentalhealth ///
    hh_child_death ///
    c.hh_faultdist##c.hh_logcons `indiv_controls' `fault_controls' ///
  if indiv_male == 0 ///
  , cl(village_code)

    est sto female

  // Regression : Child death
  reg indiv_mentalhealth ///
    hh_child_death ///
    c.hh_faultdist##c.hh_logcons `indiv_controls' `fault_controls' ///
  if indiv_male == 1 ///
  , cl(village_code)

    est sto male

  // Regression : Child death
  areg indiv_mentalhealth ///
    1.hh_child_death#0.indiv_male ///
    c.hh_faultdist##c.hh_logcons `indiv_controls'  `fault_controls' ///
  , a(censusid) cl(village_code)

    est sto hh_fe

  // Regression : Child death
  reg indiv_mentalhealth ///
    hh_child_death 1.hh_child_death#indiv_male ///
    c.hh_faultdist##c.hh_logcons `indiv_controls'  `fault_controls'  ///
  , a(village_code) cl(village_code)

    est sto vil_fe

  // Regression : Child death
  reg indiv_mentalhealth ///
    hh_child_death ///
    hh_faultdist `indiv_controls'  `fault_controls' ///
  if indiv_male == 0 ///
  , a(village_code) cl(village_code)

    est sto f_vil_fe

  // Regression : Child death
  reg indiv_mentalhealth ///
    hh_child_death ///
    hh_faultdist `indiv_controls'  `fault_controls' ///
  if indiv_male == 1 ///
  , a(village_code) cl(village_code)

    est sto m_vil_fe

  outwrite all female male hh_fe vil_fe f_vil_fe m_vil_fe ///
  using "${directory}/outputs/T_regressions_death.tex" ///
  , replace stats(N r2) drop(indiv_male hh_epidist hh_slope hh_district_*) format(%9.3f) ///
    col("Pooled" "Women" "Men" "Household FE" "Village FE" "Women Village FE" "Men Village FE") ///
    row("Child Death in Household" "" ///
        "Child Death $\times$ Woman" "" ///
        "Distance from Fault (km)" ""  ///
        "(log) HH Consumption" "" ///
        "Distance $\times$ Consumption" "" ///
        "Age" "" "Married" "" "Primary Education" "" ///
        "Constant" "" "Number of Observations" "Regression R-Square")

// Have a lovely day!
