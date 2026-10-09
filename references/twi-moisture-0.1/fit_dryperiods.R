# Model fits for specific time segments (dry periods) 
# 28 Feb 2022

# Rerun 08 Mar 2022 with new data QC

library(data.table)
library(purrr)

# Read in raw data
moisture_qc <- fread('data/processed_moisture_qc.csv')
dry_periods <- fread('data/DryPeriods2017-2021.csv')
twi <- fread('data/processed_twi.csv')
logger_lookup <- fread('data/LoggerLocations.csv')

# port should be character variable
moisture_qc[, port := as.character(port)]
twi[, port := as.character(port)]
logger_lookup[, Port := as.character(Port)]

# Convert dry periods to date variables
cols <- c('start','End')
dry_periods[, (cols) := lapply(.SD, as.Date, format = '%m/%d/%Y'), .SDcols = cols]

# Get average VWC for each logger and port combination, for each of the dry periods
vwc <- dry_periods[, 
                   moisture_qc[date >= start & date <= End, .(VWC = mean(VWC_QC)), by = .(logger, port, depth)], 
                   by = .(start, End, Type)]

# Join TWI with depth covariate
logger_lookup <- logger_lookup[!is.na(Port)]
setnames(logger_lookup, old = c('Logger','Port'), new = c('logger','port'))
twi[logger_lookup, on = .(logger, port), depth := i.Depth]

# We have 11 dry periods and 546 indices so there will be 6006 combinations.

# Define functions:
# This function returns the correlation between observed and predicted
fit_twi_moisture_byperiod <- function(start_date, end_date, idx, depth_covariate = FALSE) {
  x <- twi[index_raw == idx, .(logger, port, depth, TWI)]
  y <- vwc[start == start_date & End == end_date, .(logger, port, VWC)]
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
fit_twi_moisture_CV_byperiod <- function(start_date, end_date, idx, depth_covariate = FALSE) {
  x <- twi[index_raw == idx, .(logger, port, depth, TWI)]
  y <- vwc[start == start_date & End == end_date, .(logger, port, VWC)]
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
combos <- dry_periods[, .(index_raw = indexes), by = .(start, End, Type)]

# Fit all combinations. 
rs <- combos[, .(r = fit_twi_moisture_byperiod(start_date=start, end_date=End, idx=index_raw, depth_covariate=FALSE)), by = .(start,End,Type,index_raw)]
rs_depth <- combos[, .(r_depth = fit_twi_moisture_byperiod(start_date=start, end_date=End, idx=index_raw, depth_covariate=TRUE)), by = .(start,End,Type,index_raw)]

# Fit all combinations with the cross-validation. Takes somewhat longer.
rs_CV <- combos[, .(r_CV = fit_twi_moisture_CV_byperiod(start_date=start, end_date=End, idx=index_raw, depth_covariate=FALSE)), by = .(start,End,Type,index_raw)]
rs_depth_CV <- combos[, .(r_depth_CV = fit_twi_moisture_CV_byperiod(start_date=start, end_date=End, idx=index_raw, depth_covariate=TRUE)), by = .(start,End,Type,index_raw)]

# Combine with the full information on each index
twi_info <- unique(twi[, .(index_raw, index, filter, dem_resolution, suction_factor, filter_window, sigma, flow_algorithm, convergence_factor)])

rs <- rs[rs_depth, on = .NATURAL]
rs <- rs[rs_CV, on = .NATURAL]
rs <- rs[rs_depth_CV, on = .NATURAL]
rs <- rs[twi_info, on = .NATURAL]

fwrite(rs, 'data/rs_dryperiods.csv')
