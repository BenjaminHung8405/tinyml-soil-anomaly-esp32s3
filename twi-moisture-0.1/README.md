# Which topographic wetness indexes best predict soil moisture?

This repo contains all code and data necessary to reproduce the analysis presented in the manuscript:

Winzeler, H.E., Owens, P.R., Read Q.D.., Libohova, Z., Ashworth, A., Sauer, T. 2022. The Topographic Wetness Index as a Proxy for Soil Moisture in a Hillslope Catena: flow algorithms and map generalization techniques. Land, in review.

There are several steps to this analysis. The relevant scripts for each are listed below. The first step is to use the raw digital elevation data (DEM) to produce different versions of the topographic wetness index (TWI) for the study region (**Calculating TWI**). Then, these TWI output files are processed, along with soil moisture (volumetric water content or VWC) time series data from a number of sensors located within the study region, to create analysis-ready data objects (**Processing TWI and VWC**). Next, models are fit relating TWI to soil moisture (**Model fitting**) and results are plotted (**Visualizing main results**). A number of additional analyses were also done (**Additional analyses**).

## Input data

The DEM of the study region is not found within this repository. Instead, it is archived on Ag Data Commons along with the repository. 
The remaining input data are found in the folder `data/`. It contains the following files:

- `2017_LoggerData_HEW.csv` through `2021_HEW.csv`: Soil moisture (VWC) logger data for each year 2017-2021 (5 files total).
- `2882174.csv`: weather data from a nearby station.
- `DryPeriods2017-2021.csv`: starting and ending days for dry periods 2017-2021.
- `Logger_Locations_TWI_2017-2021.xlsx`: 546 topographic wetness indexes calculated at each VWC logger location. *note*: This is intermediate input created in the first step of the pipeline.
- `LoggerLocations.csv`: Geographic locations and metadata for each VWC logger.

## Code pipeline

To reproduce the analysis in the manuscript run these scripts in the following order. See the manuscript for more details on the methods.

### Calculating TWI

- `TerrainAnalysis.R`: Taking the DEM file as input, calculates 546 different topgraphic wetness indexes using a variety of different algorithms. Each algorithm is run multiple times with different input parameters, as described in more detail in the manuscript. After performing this step, it is necessary to use the SAGA-GIS GUI to extract the TWI values for each of the sensor locations. The output generated in this way is included in this repository as `Logger_Locations_TWI_2017-2021.xlsx`. Therefore it is not necessary to rerun this step of the analysis but the code is provided for completeness.

### Processing TWI and VWC

- `read_process_data.R`: Takes raw TWI and moisture data files and processes them into analysis-ready format, saving the results as CSV.
- `qc_avg_moisture.R`: Does additional quality control on the moisture data and averages it across different time periods.

### Model fitting

Models were fit regressing soil moisture (average VWC for a certain time period) against a TWI index, with and without **soil depth as a covariate**. In each case, for both the model without depth and the model with depth, prediction performance was calculated with and without **spatially-blocked cross-validation**. Where cross validation wasn't used, we simply used the predictions from the model fit to all the data. 

- `fit_combos.R`: Models were fit to each combination of soil moisture averaged over 57 months (all months from April 2017-December 2021) and 546 TWI indexes. In addition models were fit to soil moisture averaged over years, and to the grand mean across the full study period.
- `fit_dryperiods.R`: Models were fit to soil moisture averaged over previously identified dry periods within the study period (each 1 or 2 weeks in length), again for each of the 546 indexes.
- `fit_summer.R`: Models were fit to the soil moisture average for the months of June-September for each of the five years, again for each of the 546 indexes.

### Visualizing main results

Preliminary visualization of results was done in a series of RMarkdown notebooks. All the notebooks follow the same general format, plotting model performance (observed-predicted correlation) across different combinations of time period and characteristics of the TWI indexes being compared. The indexes are grouped by SWI versus TWI, DEM filter used, flow algorithm, and any other parameters that varied.

The notebooks show the model performance metrics with and without the soil depth covariate, and with and without spatially-blocked cross-validation. Crossing those two factors, there are four values for model performance for each combination of time period and TWI index presented.

- `performance_plots_bymonth.Rmd`: Using the results from the models fit to each month of data separately, prediction performance was averaged by month across the five years of data to show within-year trends.
- `performance_plots_byyear.Rmd`: Using the results from the models fit to each month of data separately, prediction performance was averaged by year to show trends across multiple years.
- `performance_plots_dry_periods.Rmd`: Prediction performance was presented for the models fit to the previously identified dry periods.
- `performance_plots_summer.Rmd`: Prediction performance was presented for the models fit to the June-September moisture averages.

### Additional analyses

Some additional analyses were done that may not be published in the final manuscript but which are included here for completeness. 

- `2019dryperiod.Rmd`: analysis, done separately for each day, of a specific dry period in 2019.
- `alldryperiodsbyday.Rmd`: analysis, done separately for each day, of the same dry periods discussed above.
- `best_indices.R`: after fitting models, this script was used to quickly identify some of the best-performing indexes for closer scrutiny.
- `wateryearfigs.R`: exploratory figures showing median and quantile interval of VWC for sensors in low and high TWI locations for each water year.
