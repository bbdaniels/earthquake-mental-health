* Exogeneity in baseline characteristics

use "${directory}/data/analysis_all.dta" , clear

forest reg ///
  (vil_t39v3 vil_t39v4 vil_t39v5 vil_t39v11 vil_t39v6 vil_edu_primary ///
    vil_fem_secondary vil_t39v23 vil_t39v18 vil_t39v22 vil_t39v21 vil_infra ///
    if tag_village) ///
  (indiv_male_height indiv_female_height indiv_male_age indiv_female_age ///
    indiv_edu_primary_m indiv_edu_primary_f ///
    if indiv_dead == 0 & indiv_age > 17 ) ///
  (hh_stats_electricity_pre hh_water_inhouse_pre hh_perm_house_pre /// hh stats
    hh_stats_market_pre hh_stats_water_dist_pre hh_stats_medical_pre ///
    hh_stats_privateschool_pre hh_stats_govtschool_pre ///
    if tag_hh == 1) ///
  , t(hh_faultdist) bh b d  ///
    graph(note(,size(vsmall)) xoverhang ylab(,labsize(vsmall)) graphregion(margin(50 2 2 2))) ///
    controls(hh_epidist hh_slope hh_district_1 hh_district_2 hh_district_3) sort(local)

  graph export "${directory}/outputs/F_exogeneity.png", replace width(4000)

* Final figure set for eathquake mental health paper

use "$directory/data/analysis_mental.dta", clear

xtile check = hh_logcons , n(2)

binsreg indiv_mentalhealth hh_faultdist ///
  hh_epidist hh_slope hh_district_1 hh_district_2 hh_district_3 ///
  indiv_male indiv_age indiv_edu_binary ///
  if hh_faultdist < 60 ///
, ${graph_opts} ytit("") by(check) line(3 3) cb(3 3) ///
  cbplotopt(fc(gray%50)) bycolors(red black) bylpatterns(solid dash) ///
  xtit("Distance to Activated Fault (km) {&rarr}") ///
  legend(on size(small) c(1) r(1) pos(6) ring(0) ///
      order( 2 "Low Consumption" 5 "High Consumption" 6 "95% Confidence Band")) ///
  samebinsby

 graph export "${directory}/outputs/F_distance.png", replace width(4000)


// Mental health gradient by

use "$directory/data/analysis_mental.dta", clear

  binsreg indiv_mentalhealth hh_logcons ///
    hh_epidist hh_slope hh_district_1 hh_district_2 hh_district_3 ///
    indiv_male indiv_age indiv_edu_binary ///
  if hh_logcons > 10 ///
  , ${graph_opts}  ytit("")  by(hh_far_from_quake) line(3 3) cb(3 3) ///
    cbplotopt(fc(gray%50)) bycolors(red black) bylpatterns(solid dash) ///
    xtit("(log) Household Consumption {&rarr}") ///
    legend(on size(small) c(1) r(1) pos(6) ring(0) ///
        order( 2 "Near Fault" 5 "Far From Fault" 6 "95% Confidence Band")) ///
    samebinsby

	graph export "${directory}/outputs/F_consumption.png", replace width(4000)

* Have a lovely day!
