# find the most performant indexes by different metrics
# of course using crossvalidated performance
all_rs <- fread('data/all_rs.csv')

# Averaged across years
by_year_avg <- all_rs[year > 0 & month == 0, .(r_CV = mean(r_CV), r_depth_CV = mean(r_depth_CV)), by = .(index_raw)]

by_year_top10_r <- by_year_avg[order(-r_CV)][1:10]
by_year_top10_rdepth <- by_year_avg[order(-r_depth_CV)][1:10]

union(by_year_top10_r$index_raw, by_year_top10_rdepth$index_raw) # 12 are found across both.

# Averaged across months
by_month_avg <- all_rs[year > 0 & month > 0, .(r_CV = mean(r_CV), r_depth_CV = mean(r_depth_CV)), by = .(index_raw)]

by_month_top10_r <- by_month_avg[order(-r_CV)][1:10]
by_month_top10_rdepth <- by_month_avg[order(-r_depth_CV)][1:10]

union(by_month_top10_r$index_raw, by_month_top10_rdepth$index_raw) # 12 are found across both.

Reduce(union, list(by_month_top10_r$index_raw, by_month_top10_rdepth$index_raw, by_year_top10_r$index_raw, by_year_top10_rdepth$index_raw))


# Top 5
by_year_top10_r <- by_year_avg[order(-r_CV)][1:5]
by_year_top10_rdepth <- by_year_avg[order(-r_depth_CV)][1:5]

union(by_year_top10_r$index_raw, by_year_top10_rdepth$index_raw) # 12 are found across both.

# Averaged across months
by_month_avg <- all_rs[year > 0 & month > 0, .(r_CV = mean(r_CV), r_depth_CV = mean(r_depth_CV)), by = .(index_raw)]

by_month_top10_r <- by_month_avg[order(-r_CV)][1:5]
by_month_top10_rdepth <- by_month_avg[order(-r_depth_CV)][1:5]

union(by_month_top10_r$index_raw, by_month_top10_rdepth$index_raw) # 12 are found across both.

best <- Reduce(union, list(by_month_top10_r$index_raw, by_month_top10_rdepth$index_raw, by_year_top10_r$index_raw, by_year_top10_rdepth$index_raw))

dput(best)
