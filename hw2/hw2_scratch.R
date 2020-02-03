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
                   admit_month = month(admit_time, label=T),
                   admit_day = day(admit_time))

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

ggplot(df) +
  geom_bar(aes(x = admit_month), fill = "navy") +
  xlab("Admission Month") +
  ylab("Count") +
  ggtitle("Frequency of Admissions by Month")

## Admission day

df = df %>% mutate(admit_wday = wday(admit_time, label = T))

ggplot(df) +
  geom_bar(aes(x = admit_wday), fill = "navy") +
  xlab("Admission Day") +
  ylab("Count") +
  ggtitle("Frequency of Admissions by Day of Week")

## Admission hour

head(df)

df = df %>% mutate(admit_hour = hour(admit_time))

ggplot(df) + 
  geom_bar(aes(x = admit_hour), fill = "navy") +
  xlab("Admission Hour") +
  ylab("Count") +
  ggtitle("Frequency of Admissions by Hour")

## Duration of stay

df = df %>% mutate(days_of_stay = as.duration((disch_time - admit_time)))

select(df, days_of_stay)

ggplot(df) + 
  geom_bar(aes(x = as.duration(days_of_stay), fill = "navy"))
           