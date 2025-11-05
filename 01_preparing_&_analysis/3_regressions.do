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


//Descriptive statistics

sum lnet_imp lco2 lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy
sum lnet_imp lco2 lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy if development == 1
sum lnet_imp lco2 lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy if development == 0

// pairwise correaltion
pwcorr lnet_imp lco2 lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy, sig star(0.05)

* no multicoliearity

*************Panel Data Analysis*****************

encode country, gen(id)
xtset id time_period

xtdescribe
// Cross sectional dependence test
*ssc install xtcdf
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
*xtcips urban , maxlags(2) bglags(1)
*xtcips d.urban , maxlags(2) bglags(1)
*xtcips leci , maxlags(2) bglags(1)
*xtcips d.leci , maxlags(2) bglags(1)
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
*I(0)
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




// Panel Cointegration test

xtcointtest kao lnet_imp lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing lenergy linternet, demean

xtcointtest kao lnet_imp lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing lenergy linternet, demean

xtcointtest westerlund lnet_imp lngdp_pct lngdp_pct2 ltrade_openness lmanufacturing linternet lenergy, trend allpanels demean

*All panels are cointegrated. It justifies the PCSE technique


**********

*gen dlnet_imp= D.lnet_imp
*gen dlngdp_pct = D.lngdp_pct
*gen dlngdp_pct2 = D.lngdp_pct2
*gen dlrenewable = D.lrenewable
*gen dlenergy = D.lenergy
*gen dlmanufac = D.lmanufacturing
*gen dltrade_openness  = D.ltrade_openness 

 



//NET_IMP
//xtreg net_imp gdp_pct gdp_pct2 trade_openness manufacturing energy renewable eci_sitc internet, fe

//estimates store fe

//xtreg net_imp gdp_pct gdp_pct2 trade_openness manufacturing energy renewable eci_sitc internet, re

//estimates store re

//hausman fe re, sigmamore



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



************************************ Fitted Line Graph********
twoway (qfit net_imp gdp_pct if development == 1, clcolor(midblue)), title("Advanced economies") ytitle("Net Import of embodied GHG") xtitle("GDP per capita") name(p1, replace)
twoway (qfit net_imp gdp_pct if development == 0, clcolor(orange_red)), title("Developing economies") ytitle("Net Import of embodied GHG") xtitle("GDP per capita") name(p2, replace)
twoway (qfit co2 gdp_pct if development == 1, clcolor(midblue)), title("Advanced economies") ytitle("CO2 Emissionsper capita") xtitle("GDP per capita") name(p3, replace)
twoway (qfit co2 gdp_pct if development == 0, clcolor(orange_red)), title("Developing economies") ytitle("CO2 Emissions per capita") xtitle("GDP per capita") name(p4, replace)
graph combine p1 p2 p3 p4, cols(2) title("Quadratic Fits by Development Status")


graph export "D:\project2025\Pollution\Trading_Pollution\plots\Fig4.tif", as(tif) name("Graph")



//// Dumitrescu and Hurlin Panel noncausality test (panel granger causality)
*ssc install xtgcause
xtgcause lnet_imp lngdp_pct
xtgcause lngdp_pct net_imp
xtgcause lnet_imp ltrade_openness
xtgcause ltrade_openness lnet_imp
xtgcause lnet_imp linternet
xtgcause linternet lnet_imp
xtgcause lnet_imp lmanufacturing
xtgcause lmanufacturing lnet_imp
xtgcause lnet_imp lenergy
xtgcause lenergy lnet_imp
















