# TWI SOIL MOISTURE 
# Figures made for Geoderma revisions to show VWC seasonality
# QDR / 2022-08-30

# four plots, one for each water year Oct 1 - Sep 30, beginning Oct 1 2017 and going to Sep 30 2021.
# VWC versus time with two lines with daily medians for low and high TWI sensors, with central 50% quantile interval shaded

library(ggplot2)
library(data.table)
library(ggdist)
library(lubridate)

theme_set(
  theme_bw() + theme(strip.background = element_blank(),
                     panel.grid = element_blank(),
                     legend.position = 'none')
)

moisture_qc <- fread('C:/Users/qdread/onedrive_usda/ars_projects/libohova/data/processed_moisture_qc.csv')
logger_table <- fread('data/Loggers_highlowTWI.txt')

# Join high vs low column to moisture data
moisture_qc[logger_table, moisture_classification := i.TWI_based_moisture_Classification, on = c(logger = 'Logger', port = 'Port')]

# Calculate daily medians and quantiles
daily_q <- moisture_qc[, median_qi(VWC_QC, .width = 0.5), by = .(moisture_classification, date)]

# Create water year column
wyear <- function(date) year(date) + (month(date) >= 10)
daily_q[, water_year := wyear(date)]

seq_2mo <- function(wy) seq(as.Date(paste0(wy-1, '-10-01')), as.Date(paste0(wy, '-08-10')), by = 61)

water_year_figs <- lapply(2018:2021, function(wy)
ggplot(daily_q[water_year == wy], aes(x = date, y = y, ymin = ymin, ymax = ymax, color = moisture_classification, fill = moisture_classification, linetype = moisture_classification)) +
  geom_ribbon(alpha = 0.5, color = NA) +
  geom_line(size = 1) +
  scale_fill_brewer(palette = 'Dark2') + scale_color_brewer(palette = 'Dark2') +
  scale_x_date(expand = c(0, 0), date_labels = '%b %Y', breaks = seq_2mo(wy)) +
  scale_y_continuous(name = 'VWC', labels = scales::percent, limits = c(0, 0.48), expand = c(0, 0)) +
  theme(axis.title.x = element_blank())
)

# Add legend to 1 plot
water_year_figs[[1]] <- water_year_figs[[1]] + theme(legend.position = c(0.5, 0.15), legend.title = element_blank()) + scale_fill_brewer(palette = 'Dark2', labels = c('High TWI', 'Low TWI')) + scale_color_brewer(palette = 'Dark2', labels = c('High TWI', 'Low TWI')) + scale_linetype_discrete(labels = c('High TWI', 'Low TWI'))

lapply(1:4, function(i) ggsave(file.path('C:/Users/qdread/onedrive_usda/ars_projects/libohova/figures', paste0('wateryear', i+2017, '.png')), water_year_figs[[i]], height = 4, width = 9, dpi = 400))

### all in one long figure

longfig <- ggplot(daily_q, aes(x = date, y = y, ymin = ymin, ymax = ymax, color = moisture_classification, fill = moisture_classification, linetype = moisture_classification)) +
    geom_ribbon(alpha = 0.5, color = NA) +
    geom_line(size = 1) +
    scale_fill_brewer(palette = 'Dark2') + scale_color_brewer(palette = 'Dark2') +
    scale_x_date(expand = c(0, 0), date_labels = '%b %Y', breaks = as.Date(c('2017-10-01', '2018-10-01', '2019-10-01', '2020-10-01', '2021-10-01'))) +
    geom_vline(xintercept = as.Date(c('2017-10-01', '2018-10-01', '2019-10-01', '2020-10-01', '2021-10-01')), color = 'gray75', size = 0.4) +
    scale_y_continuous(name = 'VWC', labels = scales::percent, limits = c(0, 0.48), expand = c(0, 0)) +
    theme(axis.title.x = element_blank()) + theme(legend.position = c(0.45, 0.15), legend.title = element_blank()) + scale_fill_brewer(palette = 'Dark2', labels = c('High TWI', 'Low TWI')) + scale_color_brewer(palette = 'Dark2', labels = c('High TWI', 'Low TWI')) + scale_linetype_discrete(labels = c('High TWI', 'Low TWI'))

ggsave('C:/Users/qdread/onedrive_usda/ars_projects/libohova/figures/wateryearall.png', longfig, height = 4, width = 12, dpi = 400)
