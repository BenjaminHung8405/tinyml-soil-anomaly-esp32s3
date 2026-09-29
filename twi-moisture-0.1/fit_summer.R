# Fit summer vwc-twi correlations
# 08 Mar 2022

library(data.table)
library(purrr)

vwc <- fread('data/moisture_summer.csv')
twi <- fread('data/processed_twi.csv')

# Join TWI with depth covariate
logger_lookup <- fread('data/LoggerLocations.csv')
logger_lookup <- logger_lookup[!is.na(Port)]
setnames(logger_lookup, old = c('Logger','Port'), new = c('logger','port'))
twi[logger_lookup, on = .(logger, port), depth := i.Depth]

# This function returns the correlation between observed and predicted
fit_twi_moisture <- function(yr, idx, depth_covariate = FALSE) {
  x <- twi[index_raw == idx, .(logger, port, depth, TWI)]
  y <- vwc[year %in% yr, .(logger, port, VWC)]
  d <- x[y, on = .(logger, port)]
  
  d <- d[complete.cases(d)]
  if (depth_covariate) {
    fit <- lm(VWC ~ TWI + depth, data = d)
  } else {
    fit <- lm(VWC ~ TWI, data = d)
  }
  y_pred <- predict(fit)
  cor(d[['VWC']], y_pred)
}

# This function returns the correlation between observed and predicted, but uses cross-validation.
fit_twi_moisture_CV <- function(yr, idx, depth_covariate = FALSE) {
  x <- twi[index_raw == idx, .(logger, port, depth, TWI)]
  y <- vwc[year %in% yr, .(logger, port, VWC)]
  d <- x[y, on = .(logger, port)]
  
  d <- d[complete.cases(d)]
  loggers <- unique(d$logger)
  
  out <- map_dfr(loggers, function(logger_holdout) {
    d_train <- d[!logger %in% logger_holdout]
    d_test <- d[logger %in% logger_holdout]
    
    if (depth_covariate) {
      fit <- lm(VWC ~ TWI + depth, data = d_train)
    } else {
      fit <- lm(VWC ~ TWI, data = d_train)
    }
    
    data.frame(y_obs = d_test[['VWC']], y_pred = predict(fit, newdata = d_test)) 
    
  })
  
  with(out, cor(y_obs, y_pred))
}

# Combinations, summer only
indexes <- unique(twi$index_raw)
combos_summer <- data.table(year = unique(vwc$year))[, .(index_raw = indexes), by = .(year)]

# Fit all combinations. 
rs_summer <- combos_summer[, .(r = fit_twi_moisture(yr=year, idx=index_raw, depth_covariate=FALSE)), by = .(year, index_raw)]
rs_depth_summer <- combos_summer[, .(r_depth = fit_twi_moisture(yr=year,idx=index_raw, depth_covariate=TRUE)), by = .(year, index_raw)]

# Fit all combinations with the cross-validation. Takes somewhat longer.
rs_CV_summer <- combos_summer[, .(r_CV = fit_twi_moisture_CV(yr=year, idx=index_raw, depth_covariate=FALSE)), by = .(year, index_raw)]
rs_depth_CV_summer <- combos_summer[, .(r_depth_CV = fit_twi_moisture_CV(yr=year, idx=index_raw, depth_covariate=TRUE)), by = .(year, index_raw)]

# Combine with the full information on each index
twi_info <- unique(twi[, .(index_raw, index, filter, dem_resolution, suction_factor, filter_window, sigma, flow_algorithm, convergence_factor)])

rs_summer <- rs_summer[rs_depth_summer, on = .NATURAL]
rs_summer <- rs_summer[rs_CV_summer, on = .NATURAL]
rs_summer <- rs_summer[rs_depth_CV_summer, on = .NATURAL]
rs_summer <- rs_summer[twi_info, on = .NATURAL]

fwrite(rs_summer, 'data/all_rs_summer.csv')
