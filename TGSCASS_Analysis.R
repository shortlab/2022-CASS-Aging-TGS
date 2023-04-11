###################
#### Set working directory
###################

#setwd('~/Desktop')

####cleaning the data from the excel sheet (Don't uncomment) 
# my_data <- read.table(pipe("pbpaste"), sep="\t", header = TRUE)
# names(my_data) <- c('id', 'time', 'temp', 'freq', 'freq_err', 'diff', 'diff_error', 'tau1', 'tau2', 'tau3', 'pk_sp')
# attach(my_data)
# my_data$pk_sp <- as.integer(my_data$pk_sp)
# my_data <- subset(my_data, !is.na(my_data$pk_sp)&!is.na(my_data$diff))
# saveRDS(my_data, file="TGSCASSCF3.RDS")


###################
#### Reading the data
###################
setwd("/Users/aljazzyalahmadi/Desktop/TGSCASS CF3/MNM UROP/R script")
load("TGS_CASS_CF3.RData")
no_peak_split_data <- subset(my_data, pk_sp ==0)
peak_split_data <- subset(my_data, pk_sp ==1)
no_peak_split_data_rand <- no_peak_split_data[sample(nrow(no_peak_split_data),nrow(no_peak_split_data)/2),]
peak_split_data_rand <- peak_split_data[sample(nrow(peak_split_data),nrow(peak_split_data)/2),]
my_data_rand <- my_data[sample(nrow(my_data),nrow(my_data)/4),]
# temp_0 <-  subset(my_data, temp == 0)
# temp_290 <-  subset(my_data, temp == 290)
# temp_330 <-  subset(my_data, temp == 330)
# temp_360 <-  subset(my_data, temp == 360)
# temp_400 <-  subset(my_data, temp == 400)
# time_0 <-  subset(my_data, time == 0)
# time_1.5k <-  subset(my_data, time == 1500)
# time_10k <-  subset(my_data, time == 10000)
# time_30k <-  subset(my_data, time == 30000)
# my_data$aged <- ifelse(my_data$temp ==0, 'not aged', 'aged')
# my_data$peaksplit <- ifelse(my_data$pk_sp ==0, 'no peak splitting was observed', 'peak splitting observed')
# 
# t.test(my_data$diff~my_data$aged)
# chu_table <- table(my_data$aged, my_data$peaksplit)

t.test(my_data$diff~my_data$pk_sp) #prints p-value of 95% confidence - I read this manuall
t.test(my_data_rand$diff~my_data_rand$pk_sp) #prints p-value of 95% confidence - I read this manuall

unaged_my_data <- subset(my_data, temp == 0)
aged_my_data <- subset(my_data, temp != 0)

###################
#### This is what you need for the diffusivity hist
###################
diff_mean_pksp = mean(peak_split_data$diff)
diff_mean_nopksp = mean(no_peak_split_data$diff)  

#plotting the superimposition
#main = 'diffusivity histogram - only peak splitting', xlab = 'diffusivity m^2/s'
diff_nopksp <- hist(no_peak_split_data$diff, plot = FALSE) # hist diff of no pk_sp 289 data points
diff_pksp <- hist(peak_split_data$diff, plot = FALSE) # hist diff of pk_sp 218 data points 
c1 <- rgb(0, 0, 255, max = 255, alpha = 125, names = "blue50")
c2 <- mycol <- rgb(255, 0, 0, max = 255, alpha = 125, names = "red50")
plot(diff_nopksp, col= c1, main = 'diffusivity histogram', xlab = 'diffusivity m^2/s')
plot(diff_pksp, col=c2, add = TRUE)
abline(v=mean(no_peak_split_data$diff), col = 'blue', lwd=3, lty=2)
abline(v=mean(peak_split_data$diff), col = 'black', lwd=3, lty=2)
text(4.4e-06, 60, "p-value < 0.0011") #manually type in p-value
text(3.05e-06, 60, "no peak splitting mean", col = 'blue', cex =0.8)
text(3.05e-06, 55, "peak splitting mean", col = 'black', cex =0.8)

#creating the plots for diffusivities and frequencies
#diff_all <- hist(my_data$diff, main = 'Diffusivity Histogram', xlab = 'diffusivity m^2/s', col = 'antiquewhite') # hist diff of all 507 data points
abline(v = mean(peak_split_data$diff), col = "dodgerblue4", lwd=3, lty=2)
#text(3.05e-06, 100, "peak splitting mean", col = "dodgerblue4", cex =0.8)
#text(mean(peak_split_data$diff)+0.06e-06, 110, '3.7', pos =4, col = "dodgerblue4", cex = 1)
abline(v=mean(no_peak_split_data$diff), col = "darkred", lwd=3, lty=2)
#text(3.05e-06, 90, "no peak splitting mean", col = "darkred", cex =0.8)
#text(mean(no_peak_split_data$diff)-0.03e-06, 110, '3.6',  pos = 2, col = "darkred", cex = 1)
text(4.4e-06, 110, "p-value < 0.0011")


## adding standard error

library(errors) # https://cran.r-project.org/web/packages/errors/vignettes/rjournal.pdf
std_error <- function(x) sd(x)/sqrt(length(x))
pksp_diff_std_error <- std_error(peak_split_data$diff)
no_pksp_diff_std_error <- std_error(no_peak_split_data$diff)

diff1 <- peak_split_data$diff
errors(diff1) <- peak_split_data$diff_error
diff1_mean <- mean(diff1)
print(diff1_mean)
diff2 <- no_peak_split_data$diff
errors(diff2) <- no_peak_split_data$diff_error
diff2_mean <- mean(diff2)
print(diff2_mean)



## overlaid using ggplot
library(ggplot2)
df_ggplot <- data.frame(diffusivity = c(peak_split_data$diff,no_peak_split_data$diff), pk_sp = factor(c(peak_split_data$pk_sp,no_peak_split_data$pk_sp)))

ggplot(df_ggplot, aes(x=diffusivity, color=pk_sp)) +
  geom_histogram(fill="white", alpha=0.5, position="identity")

ggplot(df_ggplot, aes(x=diffusivity))+
  geom_histogram(color="black", fill="lightblue", binwidth=0.10e-6)

library('plyr')
library('scales')
mu <- ddply(df_ggplot, "pk_sp", summarise, grp.mean=mean(diffusivity))
ggplot(df_ggplot, aes(x=diffusivity, color=pk_sp, fill = pk_sp)) +
  geom_histogram(alpha = 0.3, position = "identity", binwidth=0.10e-6) + 
  geom_vline(data=mu, aes(xintercept=grp.mean, color=pk_sp),
             linetype="dashed") +
  scale_color_manual(values=c("#999999", "#E69F00"), labels=c("No Peak Splitting", "Peak Splitting")) +
  scale_fill_manual(values=c("#999999", "#E69F00"), labels=c("No Peak Splitting", "Peak Splitting")) +
  # annotate(geom = "rect", xmin=3.57e-06, xmax=3.65e-06, ymin=0, ymax=Inf, fill = '#999999', alpha=0.5)+
  # annotate(geom = "rect", xmin=3.66e-06, xmax=3.76e-06, ymin=0, ymax=Inf, fill = '#E69F00', alpha=0.5)+
  annotate(geom = "rect", xmin=3.59e-06, xmax=3.63e-06, ymin=0, ymax=Inf, fill = '#999999', alpha=0.3)+
  annotate(geom = "rect", xmin=3.69e-06, xmax=3.73e-06, ymin=0, ymax=Inf, fill = '#E69F00', alpha=0.3)+
  annotate("text", x=4.4*10^-6, y=33, label= "p-value ~ 0.001")+
  annotate("text", x=3.38*10^-6, y=36.5, label= "3.61 \u00B1 0.02", colour = '#999999')+
  annotate("text", x=3.95*10^-6, y=36.5, label= "3.71 \u00B1 0.02", colour = '#E69F00')+
  xlab(bquote("Thermal Diffusivity [m^2/s]"))+
  ylab("")+
  theme(
    panel.background = element_rect(fill='transparent'), #transparent panel bg
    plot.background = element_rect(fill='transparent', color=NA), #transparent plot bg
    # panel.grid.major = element_blank(), #remove major gridlines
    # panel.grid.minor = element_blank(), #remove minor gridlines
    legend.background = element_rect(fill='transparent'), #transparent legend bg
    legend.box.background = element_rect(fill='transparent'), #transparent legend panel
    legend.title=element_blank(), #remove legend title
    legend.position = "top"
  )

###################m2 s− 1, μ
#### END
###################""#E69F00", "#999999"


#t.test(my_data$diff~my_data$pk_sp)

#diff_nopksp <- hist(no_peak_split_data$diff, main = 'diffusivity histogram - no peak splitting', xlab = 'diffusivity m^2/s') # hist diff of no pk_sp 289 data points
#diff_pksp <- hist(peak_split_data$diff, main = 'diffusivity histogram - only peak splitting', xlab = 'diffusivity m^2/s') # hist diff of pk_sp 218 data points 



# freq_all <- hist(freq, main = 'SAW frequency histogram - all spots', xlab = 'frequency Hz') # hist freq of all 440 data points
# freq_nopksp <- hist(no_peak_split_data$freq, main = 'SAW frequency histogram - no peak splitting', xlab = 'frequency Hz') # hist freq of no pk_sp 289 data points
# freq_pksp <- hist(peak_split_data$freq, main = 'SAW frequency histogram - only peak splitting', xlab = 'frequency Hz') # hist freq of pk_sp 218 data points 
# 
# hrs_10k <- boxplot(diff~temp, data = time_10k, main = 'CF3 10khrs - Diffusivity vs. Temperature')
# hrs_30k <- boxplot(diff~temp, data = time_30k, main = 'CF3 30khrs - Diffusivity vs. Temperature')
# hrs_1.5k <- boxplot(diff~temp, data = time_1.5k, main = 'CF3 1.5khrs - Diffusivity vs. Temperature')
# 
# boxplot_temp_290 <- boxplot(diff~time, data = temp_290, main = 'CF3 290C - Diffusivity vs. Aging Time')
# boxplot_temp_330 <- boxplot(diff~time, data = temp_330, main = 'CF3 330C - Diffusivity vs. Aging Time')
# boxplot_temp_360 <- boxplot(diff~time, data = temp_360, main = 'CF3 360C - Diffusivity vs. Aging Time')
# boxplot_temp_400 <- boxplot(diff~time, data = temp_400, main = 'CF3 400C - Diffusivity vs. Aging Time')

# 
# library(ggplot2)
# chi_visualization <- ggplot(my_data) + aes(x = aged, fill = peaksplit) + geom_bar() +scale_fill_hue() + theme_minimal()
# 
# pdf('TGS_CASS_Stat_Analysis.pdf', )
# hist(diff, main = 'diffusivity histogram - all spots', xlab = 'diffusivity m^2/s') # hist diff of all 440 data points
# hist(no_peak_split_data$diff, main = 'diffusivity histogram - no peak splitting', xlab = 'diffusivity m^2/s') # hist diff of no pk_sp 230 data points
# hist(peak_split_data$diff, main = 'diffusivity histogram - only peak splitting', xlab = 'diffusivity m^2/s') # hist diff of pk_sp 199 data points 
# hist(freq, main = 'SAW frequency histogram - all spots', xlab = 'frequency Hz') # hist freq of all 440 data points
# hist(no_peak_split_data$freq, main = 'SAW frequency histogram - no peak splitting', xlab = 'frequency Hz') # hist freq of no pk_sp 230 data points
# hist(peak_split_data$freq, main = 'SAW frequency histogram - only peak splitting', xlab = 'frequency Hz') # hist freq of pk_sp 199 data points 
# chi_visualization
# boxplot(diff~temp, data = time_10k, main = 'CF3 10khrs - Diffusivity vs. Temperature')
# boxplot(diff~temp, data = time_30k, main = 'CF3 30khrs - Diffusivity vs. Temperature')
# boxplot(diff~temp, data = time_1.5k, main = 'CF3 1.5khrs - Diffusivity vs. Temperature')
# boxplot(diff~time, data = temp_290, main = 'CF3 290C - Diffusivity vs. Aging Time')
# boxplot(diff~time, data = temp_330, main = 'CF3 330C - Diffusivity vs. Aging Time')
# boxplot(diff~time, data = temp_360, main = 'CF3 360C - Diffusivity vs. Aging Time')
# boxplot(diff~time, data = temp_400, main = 'CF3 400C - Diffusivity vs. Aging Time')
# dev.off()
# 
# 
# hrs_10k
# hrs_30k
# hrs_1.5k
# boxplot_temp_290
# boxplot_temp_330
# boxplot_temp_360
# boxplot_temp_400
# 
# 
# t.test(freq~pk_sp)
# 
# chu_test <- chisq.test(chu_table)
# chu_test
# 
# 
# my_data <- subset(my_data, freq<4.5*10^8)
# 
# no_peak_split_data <- subset(my_data, pk_sp ==0)
# peak_split_data <- subset(my_data, pk_sp ==1)
# temp_0 <-  subset(my_data, temp == 0)
# temp_290 <-  subset(my_data, temp == 290)
# temp_330 <-  subset(my_data, temp == 330)
# temp_360 <-  subset(my_data, temp == 360)
# temp_400 <-  subset(my_data, temp == 400)
# time_0 <-  subset(my_data, time == 0)
# time_1.5k <-  subset(my_data, time == 1500)
# time_10k <-  subset(my_data, time == 10000)
# time_30k <-  subset(my_data, time == 30000)
# my_data$aged <- ifelse(temp ==0, 'not aged', 'aged')
# my_data$peaksplit <- ifelse(pk_sp ==0, 'no peak splitting was observed', 'peak splitting observed')
# chu_table <- table(my_data$aged, my_data$peaksplit)
# 
# #creating the plots for diffusivities and frequencies
# diff_all <- hist(diff, main = 'diffusivity histogram - all spots', xlab = 'diffusivity m^2/s') # hist diff of all 440 data points
# diff_nopksp <- hist(no_peak_split_data$diff, main = 'diffusivity histogram - no peak splitting', xlab = 'diffusivity m^2/s') # hist diff of no pk_sp 230 data points
# diff_pksp <- hist(peak_split_data$diff, main = 'diffusivity histogram - only peak splitting', xlab = 'diffusivity m^2/s') # hist diff of pk_sp 199 data points 
# freq_all <- hist(freq, main = 'SAW frequency histogram - all spots', xlab = 'frequency Hz') # hist freq of all 440 data points
# freq_nopksp <- hist(no_peak_split_data$freq, main = 'SAW frequency histogram - no peak splitting', xlab = 'frequency Hz') # hist freq of no pk_sp 230 data points
# freq_pksp <- hist(peak_split_data$freq, main = 'SAW frequency histogram - only peak splitting', xlab = 'frequency Hz') # hist freq of pk_sp 199 data points 
# 
# hrs_10k <- boxplot(diff~temp, data = time_10k, main = 'CF3 10khrs - Diffusivity vs. Temperature')
# hrs_30k <- boxplot(diff~temp, data = time_30k, main = 'CF3 30khrs - Diffusivity vs. Temperature')
# hrs_1.5k <- boxplot(diff~temp, data = time_1.5k, main = 'CF3 1.5khrs - Diffusivity vs. Temperature')
# 
# boxplot_temp_290 <- boxplot(diff~time, data = temp_290, main = 'CF3 290C - Diffusivity vs. Aging Time')
# boxplot_temp_330 <- boxplot(diff~time, data = temp_330, main = 'CF3 330C - Diffusivity vs. Aging Time')
# boxplot_temp_360 <- boxplot(diff~time, data = temp_360, main = 'CF3 360C - Diffusivity vs. Aging Time')
# boxplot_temp_400 <- boxplot(diff~time, data = temp_400, main = 'CF3 400C - Diffusivity vs. Aging Time')
# 
# 
# library(ggplot2)
# chi_visualization <- ggplot(my_data) + aes(x = aged, fill = peaksplit) + geom_bar() +scale_fill_hue() + theme_minimal()
# 
# pdf('TGS_CASS_Stat_Analysis_first_fit.pdf', )
# hist(diff, main = 'diffusivity histogram - all spots', xlab = 'diffusivity m^2/s') # hist diff of all 440 data points
# hist(no_peak_split_data$diff, main = 'diffusivity histogram - no peak splitting', xlab = 'diffusivity m^2/s') # hist diff of no pk_sp 230 data points
# hist(peak_split_data$diff, main = 'diffusivity histogram - only peak splitting', xlab = 'diffusivity m^2/s') # hist diff of pk_sp 199 data points 
# hist(freq, main = 'SAW frequency histogram - all spots', xlab = 'frequency Hz') # hist freq of all 440 data points
# hist(no_peak_split_data$freq, main = 'SAW frequency histogram - no peak splitting', xlab = 'frequency Hz') # hist freq of no pk_sp 230 data points
# hist(peak_split_data$freq, main = 'SAW frequency histogram - only peak splitting', xlab = 'frequency Hz') # hist freq of pk_sp 199 data points 
# chi_visualization
# boxplot(diff~temp, data = time_10k, main = 'CF3 10khrs - Diffusivity vs. Temperature')
# boxplot(diff~temp, data = time_30k, main = 'CF3 30khrs - Diffusivity vs. Temperature')
# boxplot(diff~temp, data = time_1.5k, main = 'CF3 1.5khrs - Diffusivity vs. Temperature')
# boxplot(diff~time, data = temp_290, main = 'CF3 290C - Diffusivity vs. Aging Time')
# boxplot(diff~time, data = temp_330, main = 'CF3 330C - Diffusivity vs. Aging Time')
# boxplot(diff~time, data = temp_360, main = 'CF3 360C - Diffusivity vs. Aging Time')
# boxplot(diff~time, data = temp_400, main = 'CF3 400C - Diffusivity vs. Aging Time')
# dev.off()
# 
# 
# hrs_10k
# hrs_30k
# hrs_1.5k
# boxplot_temp_290
# boxplot_temp_330
# boxplot_temp_360
# boxplot_temp_400
# 
# t.test(diff~pk_sp)
# t.test(freq~pk_sp)
# 
# chu_test <- chisq.test(chu_table)
# chu_test
