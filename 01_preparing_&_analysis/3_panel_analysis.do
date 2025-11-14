import delimited "D:\project2025\Pollution\Trading_Pollution\data\cleaned\pollution_trade.csv"


gen gdp_pct2 = gdp_pct*gdp_pct
gen gdp_pct3 = gdp_pct*gdp_pct*gdp_pct
gen lnet_imp = sign(net_imp) * ln(abs(net_imp) + 1)
gen lngdp_pct = ln(gdp_pct)
gen lngdp_pct2 = lngdp_pct ^2
gen lngdp_pct3 = lngdp_pct^3
gen ltrade_openness = ln(trade_openness)
gen lmanufacturing = ln(manufacturing)
gen lrenewable = ln(renewable+1)
gen lenergy = ln(energy)
gen lfdi = ln(fdi +1)
gen leci = sign(eci_sitc) * ln(abs(eci_sitc) + 1)
gen lco2 = ln(co2) 
gen lurban = ln(urban)
gen linternet = ln(internet+1)
gen lpop = ln(population)

//Descriptive statistics

sum lnet_imp lco2 lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy if development == 1
sum lnet_imp lco2 lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy if development == 0

// pairwise correaltion
pwcorr lnet_imp lco2 lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy if development == 1, sig star(0.05)

pwcorr lnet_imp lco2 lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy if development == 0, sig star(0.05)


// Fitted Line Graph

twoway (scatter net_imp gdp_pct if development == 1, mcolor(eltblue%40)) || (qfit net_imp gdp_pct if development == 1, clcolor(navy) clwidth(thick)),  name(g1, replace) legend(position(6) row(1) order(1 "Net import of embodied CO2" 2 "Fitted values") size(small)) title("Advanced economies") ytitle("Fitted values of net import" "of embodied CO2 (metric tons)", size(small)) xtitle("GDP per capita (Constant prices, in USD)", size(small)) xlabel(, labsize(small)) ylabel(, labsize(small)) 


twoway (scatter net_imp gdp_pct if development == 0, mcolor(eltblue%40)) || (qfit net_imp gdp_pct if development == 0, clcolor(orange_red) clwidth(thick)),  name(g2, replace) legend(position(6) row(1) order(1 "Net import of embodied CO2" 2 "Fitted values") size(small)) title("Developing economies") ytitle("Fitted values of net import" "of embodied CO2 (metric tons)", size(small)) xtitle("GDP per capita (Constant prices, in USD)", size(small)) xlabel(, labsize(small)) ylabel(, labsize(small)) 

*yscale(range(-1500 1000))

twoway (scatter co2 gdp_pct if development == 1, mcolor(eltblue%40)) || (qfit co2 gdp_pct if development == 1, clcolor(navy) clwidth(thick)), name(g3, replace) legend(position(6) row(1) order(1 "CO2 emission (domestic)" 2 "Fitted values") size(small)) title("Advanced economies") ytitle("Fitted values of CO2 Emissions" "per capita (metric tons)", size(small)) xtitle("GDP per capita (Constant prices, in USD)", size(small)) xlabel(, labsize(small)) ylabel(, labsize(small))

twoway (scatter co2 gdp_pct if development == 0, mcolor(eltblue%40)) || (qfit co2 gdp_pct if development == 0, clcolor(orange_red) clwidth(thick)), name(g4, replace) legend(position(6) row(1) order(1 "CO2 emission (domestic)" 2 "Fitted values") size(small)) title("Developing economies") ytitle("Fitted values of CO2 Emissions" "per capita (metric tons)", size(small)) xtitle("GDP per capita (Constant prices, in USD)", size(small)) xlabel(, labsize(small)) ylabel(, labsize(small))

graph combine g1 g2 g3 g4, cols(2)

graph export "D:\project2025\Pollution\Trading_Pollution\plots\Fig4.jpg", as(jpg) name("Graph") quality(100)




*************Panel Data Analysis*****************

encode country, gen(id)
xtset id time_period

******************* Advanced Economies***************
keep if development == 1
xtcdf lnet_imp lco2 lngdp_pct ltrade_openness lmanufacturing linternet lenergy

************Panel Unit root tests*************
// CIPS unit root tests
*If CIPS Statistic < Critical Value: reject null
xtcips lnet_imp , maxlags(2) bglags(1)
xtcips d.lnet_imp , maxlags(2) bglags(1)
*I(1)
xtcips lco2 , maxlags(2) bglags(1)
xtcips d.lco2 , maxlags(2) bglags(1)
*I(1)
xtcips lngdp_pct, maxlags(2) bglags(1)
xtcips d.lngdp_pct, maxlags(2) bglags(1)
*I(1)
xtcips ltrade_openness, maxlags(2) bglags(1)
xtcips d.ltrade_openness, maxlags(2) bglags(1)
*I(1)
xtcips lmanufacturing, maxlags(2) bglags(1)
xtcips d.lmanufacturing, maxlags(2) bglags(1)
*I(1)
xtcips linternet, maxlags(2) bglags(1)
xtcips d.linternet, maxlags(2) bglags(1)
*I(0)
xtcips lenergy , maxlags(2) bglags(1)
xtcips d.lenergy , maxlags(2) bglags(1)
*I(1)


// CADF unit root tests
*ssc install pescadf
pescadf lnet_imp, lags(1)
pescadf d.lnet_imp, lags(1)
*I(1)
pescadf lco2, lags(1)
pescadf d.lco2, lags(1)
*I(1)
pescadf lngdp_pct, lags(1) 
pescadf d.lngdp_pct, lags(1) 
*I(1)
pescadf ltrade_openness, lags(1)
pescadf d.ltrade_openness, lags(1)
*I(1)
pescadf lmanufacturing, lags(1)
pescadf d.lmanufacturing, lags(1)
*I(1)
pescadf linternet, lags(1)
pescadf d.linternet, lags(1)
*I(0)
pescadf lenergy, lags(1)
pescadf d.lenergy, lags(1)
*I(1)

// Cointegration tests
xtcointtest westerlund lnet_imp lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing lenergy linternet, allpanels demean

xtcointtest westerlund lco2 lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing lenergy linternet, allpanels demean

******************* Developing Economies***************
clear
import delimited "D:\project2025\Pollution\Trading_Pollution\data\cleaned\pollution_trade.csv"

gen gdp_pct2 = gdp_pct*gdp_pct
gen gdp_pct3 = gdp_pct*gdp_pct*gdp_pct
gen lnet_imp = sign(net_imp) * ln(abs(net_imp) + 1)
gen lngdp_pct = ln(gdp_pct)
gen lngdp_pct2 = lngdp_pct ^2
gen lngdp_pct3 = lngdp_pct^3
gen ltrade_openness = ln(trade_openness)
gen lmanufacturing = ln(manufacturing)
gen lrenewable = ln(renewable+1)
gen lenergy = ln(energy)
gen lfdi = ln(fdi +1)
gen leci = sign(eci_sitc) * ln(abs(eci_sitc) + 1)
gen lco2 = ln(co2) 
gen lurban = ln(urban)
gen linternet = ln(internet+1)
gen lpop = ln(population)

encode country, gen(id)
xtset id time_period

keep if development == 0
xtcdf lnet_imp lco2 lngdp_pct ltrade_openness lmanufacturing linternet lenergy

************Panel Unit root tests*************
// CIPS unit root tests
*If CIPS Statistic < Critical Value: reject null
xtcips lnet_imp , maxlags(2) bglags(1)
xtcips d.lnet_imp , maxlags(2) bglags(1)
*I(0)
xtcips lco2 , maxlags(2) bglags(1)
xtcips d.lco2 , maxlags(2) bglags(1)
*I(1)
xtcips lngdp_pct, maxlags(2) bglags(1)
xtcips d.lngdp_pct, maxlags(2) bglags(1)
*I(0)
xtcips ltrade_openness, maxlags(2) bglags(1)
xtcips d.ltrade_openness, maxlags(2) bglags(1)
*I(1)
xtcips lmanufacturing, maxlags(2) bglags(1)
xtcips d.lmanufacturing, maxlags(2) bglags(1)
*I(1)
xtcips linternet, maxlags(2) bglags(1)
xtcips d.linternet, maxlags(2) bglags(1)
*I(0)
xtcips lenergy , maxlags(2) bglags(1)
xtcips d.lenergy , maxlags(2) bglags(1)
*I(1)


// CADF unit root tests
*ssc install pescadf
pescadf lnet_imp, lags(1)
pescadf d.lnet_imp, lags(1)
*I(1)
pescadf lco2, lags(1)
pescadf d.lco2, lags(1)
*I(1)
pescadf lngdp_pct, lags(1) 
pescadf d.lngdp_pct, lags(1) 
*I(1)
pescadf ltrade_openness, lags(1)
pescadf d.ltrade_openness, lags(1)
*I(1)
pescadf lmanufacturing, lags(1)
pescadf d.lmanufacturing, lags(1)
*I(1)
pescadf linternet, lags(1)
pescadf d.linternet, lags(1)
*I(0)
pescadf lenergy, lags(1)
pescadf d.lenergy, lags(1)
*I(1)

// Cointegration tests
xtcointtest westerlund lnet_imp lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing lenergy linternet, allpanels demean

xtcointtest westerlund lco2 lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing lenergy linternet, allpanels demean




****** Regressions******
clear
import delimited "D:\project2025\Pollution\Trading_Pollution\data\cleaned\pollution_trade.csv"
gen gdp_pct2 = gdp_pct*gdp_pct
gen gdp_pct3 = gdp_pct*gdp_pct*gdp_pct
*mdesc
gen lnet_imp = sign(net_imp) * ln(abs(net_imp) + 1)
gen lngdp_pct = ln(gdp_pct)
gen lngdp_pct2 = lngdp_pct ^2
gen lngdp_pct3 = lngdp_pct^3
gen ltrade_openness = ln(trade_openness)
gen lmanufacturing = ln(manufacturing)
gen lrenewable = ln(renewable+1)
gen lenergy = ln(energy)
gen lfdi = ln(fdi +1)
gen leci = sign(eci_sitc) * ln(abs(eci_sitc) + 1)
gen lco2 = ln(co2) 
gen lurban = ln(urban)
gen linternet = ln(internet+1)
gen lpop = ln(population)

encode country, gen(id)
xtset id time_period

sum lngdp_pct
sum lngdp_pct if development==1
*min 8.44, max 11.38
sum lngdp_pct if development==0
*min 5.34, max 10.12

**********************************************FGLS**************
//NET_GHG

**** Advanced Economies****
xtgls lnet_imp lngdp_pct lngdp_pct2 if development==1, panels(correlated)
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))

xtgls lnet_imp lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy if development==1, panels(correlated)
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))

**** Developing Economies****
xtgls lnet_imp lngdp_pct lngdp_pct2 if development==0, panels(correlated)
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))

xtgls lnet_imp lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy if development==0, panels(correlated)
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))

// CO2
**** Advanced Economies****
xtgls lco2 lngdp_pct lngdp_pct2 if development==1, panels(correlated)
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))

xtgls lco2 lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy if development==1, panels(correlated)
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))

**** Developing Economies****
xtgls lco2 lngdp_pct lngdp_pct2 if development==0, panels(correlated)
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))

xtgls lco2 lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy if development==0, panels(correlated)
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))



************************************************ PCSE ****************
//Net_GHG
**** Advanced Economies****
xtpcse lnet_imp lngdp_pct lngdp_pct2 if development==1
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))

xtpcse lnet_imp lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy if development==1
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))
* 10.53 and significant


**** Developing Economies****
xtpcse lnet_imp lngdp_pct lngdp_pct2 if development==0
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))

xtpcse lnet_imp lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy if development==0
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))


//CO2

**** Advanced Economies****
//PCSE
xtpcse lco2 lngdp_pct lngdp_pct2 if development==1
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))

xtpcse lco2 lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy if development==1
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))
* 10.53 and significant


**** Developing Economies****
//PCSE
xtpcse lco2 lngdp_pct lngdp_pct2 if development==0
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))

xtpcse lco2 lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy if development==0
nlcom (_b[lngdp_pct]/(-2*_b[lngdp_pct2]))
* 8.71 and significant


//// Dumitrescu and Hurlin Panel noncausality test (panel granger causality)
*ssc install xtgcause

**** Advanced Economies ***
xtgcause lnet_imp lngdp_pct if development == 1
xtgcause lngdp_pct lnet_imp if development == 1
xtgcause lnet_imp ltrade_openness if development == 1
xtgcause ltrade_openness lnet_imp if development == 1
xtgcause lnet_imp lmanufacturing if development == 1
* lmanufac does not Granger-cause lnet_imp
xtgcause lmanufacturing lnet_imp if development == 1
xtgcause lnet_imp linternet if development == 1
xtgcause linternet lnet_imp if development == 1
xtgcause lnet_imp lenergy if development == 1
xtgcause lenergy lnet_imp if development == 1

xtgcause lco2 lngdp_pct if development == 1
xtgcause lngdp_pct lco2 if development == 1
*lco2 does not Granger-cause lngdp_pct
xtgcause lco2 ltrade_openness if development == 1
xtgcause ltrade_openness lco2 if development == 1
xtgcause lco2 linternet if development == 1
xtgcause linternet lco2 if development == 1
*lco2 does not Granger-cause linternet
xtgcause lco2 lmanufacturing if development == 1
xtgcause lmanufacturing lco2 if development == 1
xtgcause lco2 lenergy if development == 1
xtgcause lenergy lco2 if development == 1


**** Developing Economies ***
xtgcause lnet_imp lngdp_pct if development == 0
xtgcause lngdp_pct lnet_imp if development == 0
xtgcause lnet_imp ltrade_openness if development == 0
xtgcause ltrade_openness lnet_imp if development == 0
xtgcause lnet_imp lmanufacturing if development == 0
xtgcause lmanufacturing lnet_imp if development == 0
xtgcause lnet_imp linternet if development == 0
xtgcause linternet lnet_imp if development == 0
xtgcause lnet_imp lenergy if development == 0
* lenergy Granger-causes lnet_imp at 5% level
xtgcause lenergy lnet_imp if development == 0
* lnet_imp does not Granger-cause lenergy

xtgcause lco2 lngdp_pct if development == 0
xtgcause lngdp_pct lco2 if development == 0
xtgcause lco2 ltrade_openness if development == 0
xtgcause ltrade_openness lco2 if development == 0
xtgcause lco2 linternet if development == 0
xtgcause linternet lco2 if development == 0
xtgcause lco2 lmanufacturing if development == 0
xtgcause lmanufacturing lco2 if development == 0
xtgcause lco2 lenergy if development == 0
xtgcause lenergy lco2 if development == 0


























