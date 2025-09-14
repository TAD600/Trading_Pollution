import delimited "D:\project2025\core-periphery\Trading_Pollution\data\cleaned\nodal_time_series.csv"

gen after = ( time_period >= 2013) if !missing( time_period )

gen treated = development 
tab treated
gen did = after* treated
encode iso_o , gen(country1)
xtset country1 time_period
des did country1 after treated
des time_period
xtdidregress ( gdp_pct ) (did), group(country1) time(time_period)
estat ptrends
estat trendplots, ytitle( gdp_pct)

xtreg gdp_pct did i.time, fe vce(cluster country1)

bysort time treated_num: egen mean_gdp_pct = mean(gdp_pct)

twoway (line mean_gdp_pct time if treated == 0, sort) (line mean_gdp_pct time if treated == 1, sort lpattern(dash)), legend(label(1 "Control") label(2 "Treated")) xline(2009)