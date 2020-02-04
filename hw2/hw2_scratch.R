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

df = df %>% mutate(days_of_stay = as.numeric((disch_time - admit_time), "days"))

ggplot(df) + 
  geom_histogram(aes(days_of_stay), fill = "navy", binwidth = 5) +
  xlab("Length of Stay (Days)") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Length of Stay")
           
## Admission type

ggplot(distinct(df)) +
  geom_bar(aes(admit_type), fill = "navy") +
  xlab("Admit Type") +
  ylab("Count") +
  ggtitle("Frequency of Admissions by Admit Type")

## Number of admissions per patient

ggplot() +
  geom_bar(aes(table(df$sub_id)), fill = "navy") +
  xlab("Number of admissions per patient") + 
  ylab("Count") + 
  ggtitle("Number of Admissions per Patient")

## Admissions location

df %>% group_by(sub_id) %>% 
ggplot() + 
  geom_bar(aes(admit_location), fill = "navy") +
  xlab("Admission Location") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Location") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

## Insurance

df %>% group_by(sub_id) %>% 
  ggplot() + 
  geom_bar(aes(insurance), fill = "navy") +
  xlab("Insurance Type") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Insurance Type")   

## Language

# Maybe do only top appears, others have low freq

df %>% group_by(sub_id) %>% filter(n() == 1) %>%
ggplot() +
  geom_bar(aes(language), fill = "navy") +
  xlab("Language") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Language") +
  theme(axis.text.x = element_text(size = 5, angle = 90, hjust = 1))

## Religion

df %>% group_by(sub_id) %>% filter(n() == 1) %>%
ggplot() + 
  geom_bar(aes(religion), fill = "navy") +
  xlab("Religion") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Religion") +
  theme(axis.text.x = element_text(size = 10, angle = 90, hjust = 1))

## Marital Status

df %>% group_by(sub_id) %>% filter(n() == 1) %>%
ggplot() + 
  geom_bar(aes(mar_stat), fill = "navy") +
  xlab("Marital Status") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Marital Status") +
  theme(axis.text.x = element_text(size = 10, angle = 90, hjust = 1))

## Ethnicity

df %>% group_by(sub_id) %>% filter(n() == 1) %>%
  ggplot() + 
  geom_bar(aes(ethnicity), fill = "navy") +
  xlab("Ethnicity") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Ethnicity") +
  theme(axis.text.x = element_text(size = 10, angle = 90, hjust = 1))

## Death

deaths = df %>% drop_na(death_time)

ggplot(deaths) + 
  geom_boxplot(aes("", death_time), fill = "navy") +
  ylab("Time of Death") +
  ggtitle("Frequency of Admission by Ethnicity") +
  theme(axis.text.x = element_text(size = 10, angle = 90, hjust = 1))