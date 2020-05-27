// Tables for eathquake mental health paper

// Table 1. Regressions
use "$directory/data/analysis_mental.dta", clear

lab var hh_near_quake "Distance to Fault"
lab def hh_near_quake 0 "Far (20km+)" 1 "Near (<20km)"
  lab val hh_near_quake hh_near_quake

  local fault_controls "hh_epidist hh_slope hh_district_1 hh_district_2 hh_district_3"
  local indiv_controls "c.indiv_age indiv_male 1.indiv_married 1.indiv_edu_binary"

  // Regression : Distance regression
  reg indiv_mentalhealth ///
    i.hh_near_quake hh_logcons  `indiv_controls' `fault_controls' ///
  , cl(village_code)

    est sto base

  // Regression : Interaction regression
  reg indiv_mentalhealth ///
    hh_near_quake##c.hh_logcons `indiv_controls' `fault_controls' ///
  , cl(village_code)

    est sto interaction

  // Regression : Interaction regression
  reg indiv_mentalhealth ///
    hh_near_quake##c.hh_logcons `indiv_controls' `fault_controls' ///
  , cl(village_code) a(village_code)

    est sto village_fe

  // Regression : Interaction regression
  reg indiv_mentalhealth ///
    hh_near_quake##c.hh_logcons `indiv_controls' `fault_controls' ///
  if indiv_male == 0 ///
  , a(village_code) cl(village_code)

    est sto female

  // Regression : Interaction regression
  reg indiv_mentalhealth ///
    hh_near_quake##c.hh_logcons `indiv_controls' `fault_controls' ///
  if indiv_male == 1 ///
  , a(village_code) cl(village_code)

    est sto male

  outwrite base interaction village_fe female male ///
  using "${directory}/outputs/T_regressions.xlsx" ///
  , replace stats(N r2) drop(hh_district_*) format(%9.3f)

// Table 2. Child Death Regressions
use "$directory/data/analysis_mental.dta", clear

  local fault_controls "hh_epidist hh_slope hh_district_1 hh_district_2 hh_district_3"
  local indiv_controls "c.indiv_age 1.indiv_married 1.indiv_edu_binary hh_logcons"

  // Regression : Child death
  reg indiv_mentalhealth ///
    hh_child_death ///
    hh_near_quake indiv_male `indiv_controls' `fault_controls' ///
  , cl(village_code)

    est sto all

  // Regression : Child death
  reg indiv_mentalhealth ///
    hh_child_death ///
    hh_near_quake `indiv_controls'  `fault_controls' ///
  if indiv_male == 0 ///
  , cl(village_code)

    est sto female

  // Regression : Child death
  reg indiv_mentalhealth ///
    hh_child_death ///
    hh_near_quake `indiv_controls'  `fault_controls' ///
  if indiv_male == 1 ///
  , cl(village_code)

    est sto male

  // Regression : Child death
  areg indiv_mentalhealth ///
    1.hh_child_death#indiv_male indiv_male ///
    hh_near_quake `indiv_controls'  `fault_controls' ///
  , a(censusid) cl(village_code)

    est sto hh_fe

  // Regression : Child death
  reg indiv_mentalhealth ///
    hh_child_death 1.hh_child_death#indiv_male indiv_male ///
    hh_near_quake `indiv_controls'  `fault_controls'  ///
  , a(village_code) cl(village_code)

    est sto vil_fe

  // Regression : Child death
  reg indiv_mentalhealth ///
    hh_child_death ///
    hh_near_quake `indiv_controls'  `fault_controls' ///
  if indiv_male == 0 ///
  , a(village_code) cl(village_code)

    est sto f_vil_fe

  // Regression : Child death
  reg indiv_mentalhealth ///
    hh_child_death ///
    hh_near_quake `indiv_controls'  `fault_controls' ///
  if indiv_male == 1 ///
  , a(village_code) cl(village_code)

    est sto m_vil_fe

  outwrite all female male hh_fe vil_fe f_vil_fe m_vil_fe ///
  using "${directory}/outputs/T_regressions_death.xlsx" ///
  , replace stats(N r2) drop(hh_district_* ) format(%9.3f)

// Have a lovely day!
