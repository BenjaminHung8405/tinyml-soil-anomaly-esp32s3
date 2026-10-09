# Relationships between different SWIs and TWIs and moisture

library(data.table)
library(purrr)

vwc <- fread('data/moisture_allmonths.csv')
twi <- fread('data/processed_twi.csv')

# Join TWI with depth covariate
logger_lookup <- fread('data/LoggerLocations.csv')
logger_lookup <- logger_lookup[!is.na(Port)]
setnames(logger_lookup, old = c('Logger','Port'), new = c('logger','port'))
twi[logger_lookup, on = .(logger, port), depth := i.Depth]

# For every possible TWI index parameter combination, do the following:
# Join with the soil moisture data grand means, by year, and by month
# Do a linear regression predicting the relationship between the two. We can include deep vs shallow as a covariate
# (Possibly include spatial as a random effect)
# Do five-fold CV within each one for a more conservative test
# Return performance metrics (r in-sample, r CV, RMSE in-sample, RMSE CV)

# Define function to be applied across all combinations of x and y:
# x is the twi index (546 different ones), y is the timeslice being used (57 months + 5 years + 1 grandmean = 63)
# total 34,398 combinations

# For now this function just returns the correlation between observed and predicted
fit_twi_moisture <- function(yr, mon, idx, depth_covariate = FALSE) {
  x <- twi[index_raw == idx, .(logger, port, depth, TWI)]
  y <- vwc[year %in% yr & month %in% mon, .(logger, port, VWC)]
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

# This function also returns the correlation between observed and predicted, but uses cross-validation.
# all ports from a single logger are used as the hold-out dataset each time
# This essentially approximates spatial leave one out cross validation because the single logger's ports are near each other
fit_twi_moisture_CV <- function(yr, mon, idx, depth_covariate = FALSE) {
  x <- twi[index_raw == idx, .(logger, port, depth, TWI)]
  y <- vwc[year %in% yr & month %in% mon, .(logger, port, VWC)]
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

# Combinations
indexes <- unique(twi$index_raw)
combos <- unique(vwc[, .(year, month)])[, .(index_raw = indexes), by = .(year, month)]

# Fit all combinations. This runs in <5 minutes per.
rs <- combos[, .(r = fit_twi_moisture(yr=year, mon=month, idx=index_raw, depth_covariate=FALSE)), by = .(year,month,index_raw)]
rs_depth <- combos[, .(r_depth = fit_twi_moisture(yr=year, mon=month, idx=index_raw, depth_covariate=TRUE)), by = .(year,month,index_raw)]

# Fit all combinations with the cross-validation. Takes somewhat longer.
rs_CV <- combos[, .(r_CV = fit_twi_moisture_CV(yr=year, mon=month, idx=index_raw, depth_covariate=FALSE)), by = .(year,month,index_raw)]
rs_depth_CV <- combos[, .(r_depth_CV = fit_twi_moisture_CV(yr=year, mon=month, idx=index_raw, depth_covariate=TRUE)), by = .(year,month,index_raw)]

# Combine with the full information on each index
twi_info <- unique(twi[, .(index_raw, index, filter, dem_resolution, suction_factor, filter_window, sigma, flow_algorithm, convergence_factor)])

rs <- rs[rs_depth, on = .NATURAL]
rs <- rs[rs_CV, on = .NATURAL]
rs <- rs[rs_depth_CV, on = .NATURAL]
rs <- rs[twi_info, on = .NATURAL]

fwrite(rs, 'data/all_rs.csv')

