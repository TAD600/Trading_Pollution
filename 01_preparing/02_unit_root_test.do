import delimited "D:\project2025\core-periphery\Trading_Pollution\data\cleaned\nodal_time_series.csv"
mdesc internet gdp_pct schooling 
histogram internet
histogram gdp_pct
histogram schooling

// Log transformation 
gen log_gdp_pct = log(gdp_pct)
histogram log_gdp_pct

// IPS tests
encode iso_o, gen(country_id)
tsset country_id time_period
xtunitroot ips gdp_pct, trend lags(aic)
xtunitroot ips log_gdp_pct, trend lags(aic)
gen D_log_gdp_pct = D.log_gdp_pct
xtunitroot ips D_log_gdp_pct, trend lags(aic)

xtunitroot ips internet, trend lags(aic)
gen D_internet = D.internet
xtunitroot ips D_internet, trend lags(aic)

xtunitroot ips schooling, trend lags(aic)
// Not enought time period 

export delimited using D:\project2025\core-periphery\Trading_Pollution\data\cleaned\nodal_time_series.csv, replace