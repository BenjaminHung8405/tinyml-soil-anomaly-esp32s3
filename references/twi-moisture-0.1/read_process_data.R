# Script to read in and reshape the TWI and moisture data
# QDR / 01 Feb 2022

library(data.table)
library(readxl)
library(purrr)
library(stringr)
library(janitor)
library(lubridate)

# Read TWI data -----------------------------------------------------------

# Update 23 Feb 2022: New data through 2021.
# Read in the file with the majority of the TWI (use the first non-transposed sheet)
twi_filename <- 'data/Logger_Locations_TWI_2017-2021.xlsx'
twi_raw <- read_xlsx(twi_filename, sheet = 1) |> setDT()

# Correct name of Geomorphon column that is not the same in one of the tabs
names(twi_raw[[5]])[5] <- 'Geomorphon'

# Join all sheets other than the variable key to a single wide dataframe, then reshape
common_cols <- c('Lat', 'Lon', 'Logger', 'Depth', 'Geomorphon')
twi_wide <- reduce(twi_raw[-1], merge, by = common_cols) |> setDT()

twi <- melt(twi_raw, id.vars = c('Logger', 'Port', 'YearCommisioned', 'N', 'W'), variable.name = 'index_raw', value.name = 'TWI')

# Parse out the covariates from each index (not all covariates will be relevant for all indexes)

# My homemade function for pulling out a variable if present in string
pull_substring <- function(x, substrings) {
  idx <- map(substrings, ~ ifelse(grepl(., x), ., as.character(NA)))
  fcoalesce(idx)
}

twi[, index := ifelse(grepl('SWI', index_raw), 'SWI', 'TWI')]
twi[, filter := pull_substring(index_raw, c('NFNW', 'SSC', 'gauss'))]
twi[, dem_resolution := as.integer(str_extract_all(index_raw, '(?<=res)([0-9]+)'))]
twi[, suction_factor := as.integer(str_extract_all(index_raw, '(?<=SWI1E\\+)([0-9]+)'))]
twi[, filter_window := as.integer(str_extract_all(index_raw, '(?<=SSC)([0-9]+)'))]
twi[, sigma := as.numeric(str_extract_all(index_raw, '(?<=gauss_)([0-9.]+)'))]
twi[, flow_algorithm := pull_substring(index_raw, c('Braun', 'Dinf', 'FD8', 'MFD', 'MMDGBFD', 'MTFD', 'Rho8', 'DEMON', 'KRA'))]
twi[, convergence_factor := as.numeric(str_extract_all(index_raw, '(?<=MFD|MTFD)([0-9.]+)(?=\\.res)'))]

setnames(twi, old = c('Logger', 'Port', 'YearCommisioned'), new = c('logger', 'port', 'year_commissioned'))

fwrite(twi, 'data/processed_twi.csv')

# Read soil moisture logger data ------------------------------------------

# This will require more parsing.
# Each sheet is named after the logger. Each column >= 7 has the date and time as header row,
# then alternating VWC and temp in the next 6 rows (3 ports, each reads VWC and temp)
# janitor::excel_numeric_to_date() can be used to get the dates back out

yrs <- 2017:2020
moisture_files <- glue::glue('data/{yrs}_LoggerData_HEW.xlsx')
moisture_sheets <- map(moisture_files, excel_sheets) # All are the same
logger_ids <- moisture_sheets[[1]][-1]

# Max column is CFR
# cellranger::num_to_letter(2202)

# Nested map to read data. Read only the first 6 rows of each sheet.
moisture_raw <- map(moisture_files, function(file) {
  map(logger_ids, ~ read_xlsx(file, sheet = ., range = 'A1:CFR7'))
})

# Concatenate into one large list
moisture_raw <- do.call(c, moisture_raw)

### Define function to reshape data from a single sheet (logger x year)
reshape_moisture_sheet <- function(x, id) {
  setDT(x)
  names(x)[1:2] <- c('port', 'variable')
  
  # Data always begin on column 7,with first two columns identifying. Remove columns 3-6
  set(x, j = 3:6, value = NULL)
  
  # Manually assign port ID as integer, and variable ID alternating between VWC and temp
  x[, port := rep(1:3, each = 2)]
  x[, variable := rep(c('VWC', 'temp'), times = 3)]
  
  x_long <- melt(x, id.vars = c('port', 'variable'), variable.name = 'datetime', value.name = 'value')
  x_long[, datetime := excel_numeric_to_date(as.numeric(as.character(datetime)), include_time = TRUE, tz = 'America/Chicago')]
  x_long <- x_long[!is.na(datetime)]
  x_long <- dcast(x_long, port + datetime ~ variable)
  cbind(logger = id, x_long)
}

# Apply the function
moisture <- map2_dfr(moisture_raw, rep(logger_ids, 4), reshape_moisture_sheet)

# Append 2021 moisture data -----------------------------------------------

# This is in a different format which will require less reshaping.
# While we are at it, convert everything to the correct time zone and separate the date time columns so that none of that processing is required later.

moisture2021 <- fread('data/2021_HEW.csv')

moisture[, datetime := with_tz(datetime, tzone = 'America/Chicago')]

moisture2021[, datetime := strptime(`Measurement Time`, tz='America/Chicago', format = '%m/%d/%Y %H:%M')]
setnames(moisture2021, c('logger', 'time', 'port', 'VWC', 'temp', 'VWC_refined', 'datetime'))

moisture <- rbind(
  moisture,
  moisture2021[, .(logger, port, datetime, VWC, temp)]
)

moisture[, date := as.Date(datetime, tz = 'America/Chicago')]
moisture[, hour := hour(datetime)]
moisture[, datetime := NULL]

fwrite(moisture, 'data/processed_moisture.csv')
