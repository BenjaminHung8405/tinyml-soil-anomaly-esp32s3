# Moving window correlation analysis with precipitation sums
# QDR / 04 March 2022

# - Get 3-day moving average of VWC for every single day in the dataset
# - Get 30-day lagged sum of precip for every day in the dataset (already done by EW)
# - Regress VWC~TWI for each day and get performance of models (r's)
# - Regress the r's on the precipitation sums to see if VWC~TWI prediction performance correlates with previous month's precip total


# Read data and get rolling averages --------------------------------------

library(data.table)
library(purrr)

# Read in raw data
moisture_qc <- fread('data/processed_moisture_qc.csv')
twi <- fread('data/processed_twi.csv')
precip <- fread('data/2888744.csv', na.strings = '.')

# Get only needed variables from precip
precip[, date := as.Date(DATE, format = '%m/%d/%Y')]
precip <- precip[!is.na(Precip60DayPrevious), .(date, PRCP, DaysDry, Precip15DayPrevious, Precip30DayPrevious, Precip60DayPrevious)]

# port should be character variable
twi[, port := as.character(port)]

# Get average by day for each logger, then convert to a three-day rolling average covering target day and 2 preceding days.
# Note: the length of the moving window can easily be modified by changing the 3.
vwc_day <- moisture_qc[, .(VWC = mean(VWC_QC, na.rm = TRUE)), by = .(logger, port, depth, date)][order(logger, port, date)]
vwc_rolling <- vwc_day[, .(date = date, VWC = frollmean(VWC, 3)), by = .(logger, port, depth)]
vwc_rolling <- vwc_rolling[!is.na(VWC)]

# For initial purposes thin this out by every 10 days
date_range <- range(vwc_rolling$date)
dates_thinned <- seq(date_range[1], date_range[2], by = 10)
vwc_rolling_subset <- vwc_rolling[date %in% dates_thinned]
# This results in 173 days.

# Select only a subset of the TWI indexes for use.
# These are "good" ones as identified by cross-validation.
best_idx <- c("TWI.FD8.res7.NFNW", "TWI.FD8.res10.NFNW", "SWI1E+16.res5.NFNW", 
  "SWI1E+16.res7.NFNW", "TWI.MFD10.res7.NFNW", "TWI.MFD5.res7.NFNW", 
  "SWI1E+8.res1.SSC5", "TWI.Braun.res4.NFNW", "TWI.MFD0.5.res1.SSC4", 
  "SWI1E+16.res1.SSC5", "SWI1E+4.res1.SSC7")
twi_use <- twi[index_raw %in% best_idx]


# Fit models at each day to get correlations ------------------------------


# Do the correlations for each day.
# Define functions.
# This function just returns the correlation between observed and predicted, without cross-validation.
fit_twi_moisture_byday <- function(day, idx, depth_covariate = FALSE) {
  x <- twi_use[index_raw == idx, .(logger, port, TWI)]
  y <- vwc_rolling_subset[date == day, .(logger, port, depth, VWC)]
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
fit_twi_moisture_CV_byday <- function(day, idx, depth_covariate = FALSE) {
  x <- twi_use[index_raw == idx, .(logger, port, TWI)]
  y <- vwc_rolling_subset[date == day, .(logger, port, depth, VWC)]
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

# Combinations of index and day to fit models at:
combos <- CJ(date = dates_thinned, index_raw = best_idx)

# Fit all combinations. 
rs <- combos[, .(r = fit_twi_moisture_byday(day=date, idx=index_raw, depth_covariate=FALSE)), by = .(date,index_raw)]
rs_depth <- combos[, .(r_depth = fit_twi_moisture_byday(day=date, idx=index_raw, depth_covariate=TRUE)), by = .(date,index_raw)]

# Fit all combinations with the cross-validation. Takes somewhat longer.
rs_CV <- combos[, .(r_CV = fit_twi_moisture_CV_byday(day=date, idx=index_raw, depth_covariate=FALSE)), by = .(date,index_raw)]
rs_depth_CV <- combos[, .(r_depth_CV = fit_twi_moisture_CV_byday(day=date, idx=index_raw, depth_covariate=TRUE)), by = .(date,index_raw)]

rs <- rs[rs_depth, on = .NATURAL]
rs <- rs[rs_CV, on = .NATURAL]
rs <- rs[rs_depth_CV, on = .NATURAL]

fwrite(rs, 'data/rs_movingwindow.csv')

# Regress correlations on precipitation sums ------------------------------

rs_precip <- precip[rs, on = .(date)]
fwrite(rs_precip, 'results/rs_precip_movingwindow.csv')

# First make a plot to see what's going on.

ggplot(rs_precip, aes(x = Precip30DayPrevious, y = r)) + geom_point() + facet_wrap(~ index_raw)
ggplot(rs_precip, aes(x = Precip15DayPrevious, y = r)) + geom_point() + facet_wrap(~ index_raw)

ggplot(rs_precip, aes(x = Precip30DayPrevious, y = r_depth)) + geom_point() + facet_wrap(~ index_raw)
ggplot(rs_precip, aes(x = Precip15DayPrevious, y = r_depth)) + geom_point() + facet_wrap(~ index_raw)

ggplot(rs_precip, aes(x = Precip30DayPrevious, y = r_CV)) + geom_point() + facet_wrap(~ index_raw)
ggplot(rs_precip, aes(x = Precip15DayPrevious, y = r_CV)) + geom_point() + facet_wrap(~ index_raw)

ggplot(rs_precip, aes(x = Precip30DayPrevious, y = r_depth_CV)) + geom_point() + facet_wrap(~ index_raw)
ggplot(rs_precip, aes(x = Precip15DayPrevious, y = r_depth_CV)) + geom_point() + facet_wrap(~ index_raw)

# Similar plots with days dry

ggplot(rs_precip, aes(x = DaysDry, y = r)) + geom_point() + facet_wrap(~ index_raw)
ggplot(rs_precip, aes(x = DaysDry, y = r_depth)) + geom_point() + facet_wrap(~ index_raw)
ggplot(rs_precip, aes(x = DaysDry, y = r_CV)) + geom_point() + facet_wrap(~ index_raw)
ggplot(rs_precip, aes(x = DaysDry, y = r_depth_CV)) + geom_point() + facet_wrap(~ index_raw)

# Use days dry and 30 day to see if there is a correlation

library(purrr)
library(Rutilitybelt)

rs_precip_nest <- group_nest_dt(rs_precip, index_raw)
rs_precip_nest[, model := map(data, ~ lm(r ~ DaysDry + Precip30DayPrevious, data = .))]
