/////////////////////////////// 1000 m buffer ///////////////////////////////
clear all
set more off, permanently
capture log close
global dir = "D:\Box Sync\Toxic Tides\ToxicTides_US\Code_Data_upload" /*set the working directory of your own*/
cd "$dir"

import delimited "Data\analysis_sum_EAE_1000m_buffer_US_25_std.csv", encoding(ISO-8859-9) 
xtset geoid_cty v1 
gen exposed_205 = rcp85_annual_2050>0
gen exposed_210 = rcp85_annual_2100>0

global xvars est_pct_poverty est_pct_poc est_pct_latinx est_pct_nhblack ///
	  est_pct_asianpi est_pct_native pop_density est_pct_otherpoc est_pct_renters ///
	  est_pct_langisolation est_pct_elderly est_pct_under18 est_pct_nocar ///
	  est_pct_singparents dac pct_novote

/////////////////////// logit model on whether exposed, 1000m buffer ///////////////////////
// 2050
local first_run = 1
foreach xvar of global xvars {
	logit exposed_205 `xvar' pop_density i.geoid_cty if low_lying==1,vce(cluster geoid_cty) or
	if `first_run' {
		esttab using "Results\exposed_205pop_density.csv", replace /// 
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
		local first_run = 0
	}
	else{
		esttab using "Results\exposed_205pop_density.csv",append ///
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
	}
}

//2100
local first_run = 1
foreach xvar of global xvars {
	logit exposed_210 `xvar' pop_density i.geoid_cty if low_lying==1,vce(cluster geoid_cty) or
	if `first_run' {
		esttab using "Results\exposed_210pop_density.csv", replace /// 
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
		local first_run = 0
	}
	else{
		esttab using "Results\exposed_210pop_density.csv",append ///
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
	}
}

/////////////////////// for exposed, linear model on eae, 1000 m buffer ///////////////////////
//2050
local first_run = 1
foreach xvar of global xvars {
	xtreg rcp85_annual_2050 `xvar' pop_density if (low_lying==1)&(exposed_205>0), fe vce(cluster geoid_cty)
	if `first_run' {
		esttab using "Results\eae_exposed_205pop_density.csv", replace /// 
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
		local first_run = 0
	}
	else{
		esttab using "Results\eae_exposed_205pop_density.csv",append ///
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
	}
}

//2100
local first_run = 1
foreach xvar of global xvars {
	xtreg rcp85_annual_2100 `xvar' pop_density if (low_lying==1)&(exposed_210>0), fe vce(cluster geoid_cty)
	if `first_run' {
		esttab using "Results\eae_exposed_210pop_density.csv", replace /// 
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
		local first_run = 0
	}
	else{
		esttab using "Results\eae_exposed_210pop_density.csv",append ///
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
	}
}

///////// for exposed, negative binomial model on # epxosed facilities, 1000 m buffer /////////
clear all
set more off, permanently
capture log close
global dir = "D:\Box Sync\Toxic Tides\ToxicTides_US\Code_Data_upload" /*set the working directory of your own*/
cd "$dir"

import delimited "Data\analysis_count_1000m_buffer_US_25_std.csv", encoding(ISO-8859-9) 
xtset geoid_cty v1 
gen exposed_205 = rcp85_annual_2050>0
gen exposed_210 = rcp85_annual_2100>0

//2050
local first_run = 1
foreach xvar of global xvars {
	nbreg rcp85_annual_2050 `xvar' pop_density i.geoid_cty if (low_lying==1)&(exposed_205>0), irr vce(cluster geoid_cty)
	if `first_run' {
		esttab using "Results\n_exposed_205pop_density.csv", replace /// 
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
		local first_run = 0
	}
	else{
		esttab using "Results\n_exposed_205pop_density.csv",append ///
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
	}
}
//2100
local first_run = 1
foreach xvar of global xvars {
	nbreg rcp85_annual_2100 `xvar' pop_density i.geoid_cty if (low_lying==1)&(exposed_210>0), irr vce(cluster geoid_cty)
	if `first_run' {
		esttab using "Results\n_exposed_210pop_density.csv", replace /// 
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
		local first_run = 0
	}
	else{
		esttab using "Results\n_exposed_210pop_density.csv",append ///
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
	}
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////// 3000 m buffer ///////////////////////////////
clear all
set more off, permanently
capture log close
global dir = "D:\Box Sync\Toxic Tides\ToxicTides_US\Code_Data_upload" /*set the working directory of your own*/
cd "$dir"

import delimited "Data\analysis_sum_EAE_3000m_buffer_US_25_std.csv", encoding(ISO-8859-9) 
xtset geoid_cty v1 
gen exposed_205 = rcp85_annual_2050>0
gen exposed_210 = rcp85_annual_2100>0

/////////////////////// logit model on whether exposed, 3000m buffer ///////////////////////
// 2050
local first_run = 1
foreach xvar of global xvars {
	logit exposed_205 `xvar' pop_density i.geoid_cty if low_lying==1,vce(cluster geoid_cty) or
	if `first_run' {
		esttab using "Results\exposed_205pop_density_3000m.csv", replace /// 
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
		local first_run = 0
	}
	else{
		esttab using "Results\exposed_205pop_density_3000m.csv",append ///
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
	}
}

//2100
local first_run = 1
foreach xvar of global xvars {
	logit exposed_210 `xvar' pop_density i.geoid_cty if low_lying==1,vce(cluster geoid_cty) or
	if `first_run' {
		esttab using "Results\exposed_210pop_density_3000m.csv", replace /// 
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
		local first_run = 0
	}
	else{
		esttab using "Results\exposed_210pop_density_3000m.csv",append ///
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
	}
}

/////////////////////// for exposed, linear model on eae, 3000 m buffer ///////////////////////
//2050
local first_run = 1
foreach xvar of global xvars {
	xtreg rcp85_annual_2050 `xvar' pop_density if (low_lying==1)&(exposed_205>0), fe vce(cluster geoid_cty)
	if `first_run' {
		esttab using "Results\eae_exposed_205pop_density_3000m.csv", replace /// 
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
		local first_run = 0
	}
	else{
		esttab using "Results\eae_exposed_205pop_density_3000m.csv",append ///
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
	}
}

//2100
local first_run = 1
foreach xvar of global xvars {
	xtreg rcp85_annual_2100 `xvar' pop_density if (low_lying==1)&(exposed_210>0), fe vce(cluster geoid_cty)
	if `first_run' {
		esttab using "Results\eae_exposed_210pop_density_3000m.csv", replace /// 
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
		local first_run = 0
	}
	else{
		esttab using "Results\eae_exposed_210pop_density_3000m.csv",append ///
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
	}
}

///////// for exposed, negative binomial model on # epxosed facilities, 3000 m buffer /////////
clear all
set more off, permanently
capture log close
global dir = "D:\Box Sync\Toxic Tides\ToxicTides_US\Code_Data_upload" /*set the working directory of your own*/
cd "$dir"

import delimited "Data\analysis_count_3000m_buffer_US_25_std.csv", encoding(ISO-8859-9) 
xtset geoid_cty v1 
gen exposed_205 = rcp85_annual_2050>0
gen exposed_210 = rcp85_annual_2100>0

//2050
local first_run = 1
foreach xvar of global xvars {
	nbreg rcp85_annual_2050 `xvar' pop_density i.geoid_cty if (low_lying==1)&(exposed_205>0), irr vce(cluster geoid_cty)
	if `first_run' {
		esttab using "Results\n_exposed_205pop_density_3000m.csv", replace /// 
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
		local first_run = 0
	}
	else{
		esttab using "Results\n_exposed_205pop_density_3000m.csv",append ///
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
	}
}
//2100
local first_run = 1
foreach xvar of global xvars {
	nbreg rcp85_annual_2100 `xvar' pop_density i.geoid_cty if (low_lying==1)&(exposed_210>0), irr vce(cluster geoid_cty)
	if `first_run' {
		esttab using "Results\n_exposed_210pop_density_3000m.csv", replace /// 
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
		local first_run = 0
	}
	else{
		esttab using "Results\n_exposed_210pop_density_3000m.csv",append ///
		keep(`xvar') scalars("N Number of observations") sfmt("%9.3f %9.0f" ) eform ///
		label b(%9.3f) ci(%9.3f) r2(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonumbers nogaps onecell compress noobs alignment(c)
	}
}

//end