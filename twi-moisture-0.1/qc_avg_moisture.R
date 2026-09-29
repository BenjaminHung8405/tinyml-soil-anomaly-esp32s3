# Apply QC to moisture data and calculate different time slices and averages
# QDR / 01 Feb 2022

# Edit 08 Mar: change cutoff to 0.5 for all depths, and add cutoffs of 10 days/month and 7 months/year

library(data.table)
library(lubridate)
library(stringr)

moisture <- fread('data/processed_moisture.csv')
logger_lookup <- fread('data/LoggerLocations.csv')

# Remove bad sensors. Update 23 Feb 2022: Use Edwin's lookup table to flag sensors for removal.
bad_sensors <- logger_lookup[!is.na(Port), .SD, .SDcols = patterns('Logger|Port|Status|Depth')]
bad_sensors <- melt(bad_sensors, id.vars = c('Logger', 'Port', 'Depth'), value.name = 'flag')
bad_sensors[, year := as.integer(str_extract(variable, '[0-9]+')) + 2000]
setnames(bad_sensors, old = c('Logger','Port'), new = c('logger','port'))

# Join moisture data with bad sensors and then remove flagged rows
moisture[, year := year(date)]
moisture[bad_sensors, on = .(logger, port, year), `:=`(flag = i.flag, depth = i.Depth)]

# Apply QC: VWC < 0.03 becomes 0.03, VWC > 0.33 becomes 0.33 for 15cm depth, upper cutoff is 0.42 for >15cm depth.
# Then remove flagged rows and ones with missing data.
moisture_qc <- copy(moisture)
moisture_qc[, VWC_QC := VWC]
moisture_qc[VWC < 0.03, VWC_QC := 0.03]
moisture_qc[VWC > 0.5, VWC_QC := 0.5]
# moisture_qc[VWC > 0.33 & depth <= 45, VWC_QC := 0.33]
# moisture_qc[VWC > 0.42 & depth > 45, VWC_QC := 0.42]
moisture_qc <- moisture_qc[!flag %in% 'failed' & !is.na(VWC)]
moisture_qc[, flag := NULL]

fwrite(moisture_qc, 'data/processed_moisture_qc.csv')

# Calculate time slices ---------------------------------------------------

# port should be character variable
moisture_qc[, port := as.character(port)]

moisture_qc[, month := month(date)]
moisture_qc[, day := day(date)]

# Added 08 Mar 2022: Set thresholds for the number of days in a month that a logger has to return valid readings for it to be included in the monthly averages
# Do the same for the minimum number of months and days in a year that a logger has to return valid readings to be included in the annual averages.

n_valid_days_month <- moisture_qc[, .(n_days = length(unique(day))), by = .(logger, port, year, month)]

# Number of months with at least 10 days of data each, in each year
n_valid_months_year <- n_valid_days_month[n_days >= 10, .(n_months = length(unique(month))), by = .(logger, port, year)]

n_valid_days_month[, month_use := n_days >= 10]
n_valid_months_year[, year_use := n_months >= 7]

moisture_qc[n_valid_days_month, on = .NATURAL, month_use := i.month_use]
moisture_qc[n_valid_months_year, on = .NATURAL, year_use := i.year_use]

moisture_year <- moisture_qc[(year_use), .(VWC = mean(VWC_QC)), by = .(logger, port, year)]
moisture_month <- moisture_qc[(month_use), .(VWC = mean(VWC_QC)), by = .(logger, port, year, month)]
moisture_day <- moisture_qc[, .(VWC = mean(VWC_QC)), by = .(logger, port, year, month, day)]

# Also get 'grand mean' across all time points. Use all the data for this.
moisture_grandmean <- moisture_qc[, .(VWC = mean(VWC_QC)), by = .(logger, port)]

# Combine months, years, and grand mean into one df and save
moisture_year[, month := 0]
moisture_grandmean[, year := 0]
moisture_grandmean[, month := 0]

moisture_allmonths <- rbindlist(list(moisture_month, moisture_year, moisture_grandmean), use.names = TRUE)

# Get rid of values with no date
moisture_allmonths <- moisture_allmonths[!is.na(year)]

fwrite(moisture_allmonths, 'data/moisture_allmonths.csv')

# Get summer averages as well (Jul-Sep)
moisture_summer <- moisture_qc[month_use == TRUE & month %in% 6:9, .(VWC = mean(VWC_QC)), by = .(logger, port, year)]
fwrite(moisture_summer, 'data/moisture_summer.csv')

