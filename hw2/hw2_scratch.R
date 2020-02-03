library(dplyr)
library(ggplot2)
library(lubridate)

# Load data

df = read_csv("/home/203bdata/mimic-iii/ADMISSIONS.csv")

# Change column names

col_names = c('rowid', 'sub_id', 'hadm_id', 'admit_time', 
              'disch_time', 'death_time', 'admit_type',
              'admit_location', 'disch_location', 'insurance',
              'language', 'religion', 'mar_stat', 'ethnicity', 
              'ed_reg_time', 'ed_out_time', 'diagnosis',
              'hospital_exp_flag', 'has_chart_events')

names(df) = col_names

# Parse out year/month/day from datetime columns

df = df %>% mutate(admit_year = year(admit_time), 
                   admit_month = month(admit_time),
                   admit_day = day(admit_time),
                   disch_year = year(disch_time),
                   disch_month = month(disch_time),
                   disch_day = day(disch_time),
                   death_year = year(death_time),
                   death_month = month(death_time),
                   death_day = day(death_time))

select(df, starts_with("admit"))
select(df, starts_with("disch")) 
select(df, starts_with("death"))

# Plotting

## Admission year

ggplot(df) +
  geom_bar(mapping = aes(x = admit_year), fill = "navy") + 
  xlab("Admission Year") +
  ylab("Count") +
  ggtitle("Frequency of Admissions by Year")

## Admission month

months = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
           "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

ggplot(df) +
  geom_bar(aes(x = admit_month), fill = "navy") +
  xlab("Admission Month") +
  scale_x_discrete(limits = months) +
  ylab("Count") +
  ggtitle("Frequency of Admissions by Month")

