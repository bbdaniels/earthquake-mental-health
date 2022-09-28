// Figure 1. Exogeneity in baseline characteristics
use "${directory}/data/analysis_all.dta" , clear

forest reg ///
  (vil_t39v3 vil_t39v4 vil_t39v5 vil_t39v11 vil_t39v6 vil_edu_primary ///
    vil_fem_secondary vil_t39v23 vil_t39v18 vil_t39v22 vil_t39v21 vil_infra ///
    if tag_village) ///
  (hh_stats_electricity_pre hh_water_inhouse_pre hh_perm_house_pre /// hh stats
    hh_stats_market_pre hh_stats_water_dist_pre hh_stats_medical_pre ///
    hh_stats_privateschool_pre hh_stats_govtschool_pre ///
    if tag_hh == 1) ///
  (indiv_male_height indiv_female_height indiv_male_age indiv_female_age ///
    indiv_edu_primary_m indiv_edu_primary_f ///
    if indiv_dead == 0 & indiv_age > 17 ) ///
  , t(hh_faultdist) bh d cl(village_code) ///
    graph(note(,size(vsmall)) xoverhang ylab(,labsize(vsmall)) ) /// 
    controls(hh_epidist hh_slope hh_district_1 hh_district_2 hh_district_3) sort(local) mde 

  graph export "${directory}/outputs/F_exogeneity.png", replace width(4000)
  graph export "${directory}/outputs/F_exogeneity.eps", replace 
  

// Figure 2. Summary
  // indiv_mentalhealth_pct indiv_mentalhealth_q1 indiv_mentalhealth_q2 indiv_mentalhealth_q3 indiv_mentalhealth_q4 indiv_mentalhealth_q5 indiv_mentalhealth_q6 indiv_mentalhealth_q7 indiv_mentalhealth_q8 indiv_mentalhealth_q9 indiv_mentalhealth_q10 indiv_mentalhealth_q11 indiv_mentalhealth_q12 indiv_mentalhealth_q13 indiv_mentalhealth_q14
  use "$directory/data/analysis_mental.dta", clear
  
  local x = 1
  foreach var of varlist indiv_mentalhealth_q* {
    local graphs "`graphs' (lpoly `var' indiv_mentalhealth)"
    local next : var label `var'
      local next = substr("`next'",strpos("`next'","- ")+2,.)
      local ++x
      local legend `"`legend' `x' "`next'" "'
  }
  
  tw ///
    (histogram indiv_mentalhealth , frac yaxis(2) s(-9) w(0.5) lc(none) fc(gs12)) ///
    `graphs' ///
  , `hist_opts' xtit("Mental Health (PCA)") ytit("Density (Histogram)" , axis(2)) ///
    ylab(0 "Not at All" 1 "Little Bit" 2 "Moderately" 3 "Quite a Bit" 4 "Extremely") ///
    legend(on pos(3) c(1) symxsize(small) size(small) order(`legend')) 
    
    graph export "${directory}/outputs/F_summary.png", replace width(4000)
    graph export "${directory}/outputs/F_summary.eps", replace 
    
// Figure 3. Gradient
use "$directory/data/analysis_mental.dta", clear

lab var hh_near_quake "Distance to Fault"
lab def hh_near_quake 0 "Far (20km+)" 1 "Near (<20km)"
  lab val hh_near_quake hh_near_quake

  local fault_controls "hh_epidist hh_slope hh_district_1 hh_district_2 hh_district_3"
  local indiv_controls "indiv_age indiv_male indiv_married indiv_edu_binary"
  
    reg indiv_mentalhealth ///
      c.hh_faultdist##c.hh_logcons##c.hh_logcons  `indiv_controls' `fault_controls' ///
    , cl(village_code)
    
    margins, at(hh_faultdist=(0(2)60) hh_logcons=(9(0.2)14)) vce(unconditional) ///
      saving("${directory}/outputs/predictions.dta", replace)
    use "${directory}/outputs/predictions.dta", clear
      append using "$directory/data/analysis_mental.dta"
           winsor hh_logcons , p(0.05) g(w)

    lab var _margin "Predicted Mental Health (Higher = Better)"

    twoway ///
      (contour _margin _at2 _at1   if _at < ., ccuts(-3(0.25)1) ) ///
      (scatter hh_logcons hh_faultdist  , ///
        m(O) mc(black) mlw(vvthin) mfc(none) msize(tiny) ///
        jitter(1) jitterseed(123456))  ///
      if hh_faultdist< 60 | hh_faultdist == . ///
    , legend(on order(1 "True Sample") ring(0) pos(11)) xscale(reverse)
    
      graph export "${directory}/outputs/F_gradient.png", replace width(4000)
      graph export "${directory}/outputs/F_gradient.eps", replace 
      
// Figure 3. Gradient
use "$directory/data/analysis_mental.dta", clear

lab var hh_near_quake "Distance to Fault"
lab def hh_near_quake 0 "Far (20km+)" 1 "Near (<20km)"
  lab val hh_near_quake hh_near_quake

  local fault_controls "hh_epidist hh_slope hh_district_1 hh_district_2 hh_district_3"
  local indiv_controls "indiv_age indiv_male indiv_married indiv_edu_binary"
  
    reg indiv_mentalhealth ///
      c.hh_faultdist##c.hh_logcons  `indiv_controls' `fault_controls' ///
    , cl(village_code)
    
    margins, at(hh_faultdist=(0(2)60) hh_logcons=(9(0.2)14)) vce(unconditional) ///
      saving("${directory}/outputs/predictions.dta", replace)
    use "${directory}/outputs/predictions.dta", clear
      append using "$directory/data/analysis_mental.dta"
           winsor hh_logcons , p(0.05) g(w)

    lab var _margin "Predicted Mental Health (Higher = Better)"

    twoway ///
      (contour _margin _at2 _at1   if _at < ., ccuts(-3(0.25)1) ) ///
      (scatter hh_logcons hh_faultdist  , ///
        m(O) mc(black) mlw(vvthin) mfc(none) msize(tiny) ///
        jitter(1) jitterseed(123456))  ///
      if hh_faultdist< 60 | hh_faultdist == . ///
    , legend(on order(1 "True Sample") ring(0) pos(11)) xscale(reverse)
    
      graph export "${directory}/outputs/F_gradient-lin.png", replace width(4000)
      graph export "${directory}/outputs/F_gradient-lin.eps", replace 

// Have a lovely day!
