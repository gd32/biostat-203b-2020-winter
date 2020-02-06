library(dplyr)
library(ggplot2)
library(lubridate)

# Question 1

# Load data

admits = read_csv("/home/203bdata/mimic-iii/ADMISSIONS.csv")

# Change column names

col_names = c('rowid', 'sub_id', 'hadm_id', 'admit_time', 
              'disch_time', 'death_time', 'admit_type',
              'admit_location', 'disch_location', 'insurance',
              'language', 'religion', 'mar_stat', 'ethnicity', 
              'ed_reg_time', 'ed_out_time', 'diagnosis',
              'hospital_exp_flag', 'has_chart_events')

names(admits) = col_names

# Parse out year/month/day from datetime columns

admits = admits %>% mutate(admit_year = year(admit_time), 
                   admit_month = month(admit_time, label=T),
                   admit_day = day(admit_time))

select(admits, starts_with("admit"))
select(admits, starts_with("disch")) 
select(admits, starts_with("death"))

# Plotting

## Admission year

summary(admits$admit_year)

ggplot(admits) +
  geom_boxplot(aes(x = "", y = admit_year), color = "navy") +
  xlab("") +
  ylab("Admission Year") +
  theme(axis.ticks = element_blank()) +
  ggtitle("Boxplot of Admission Year")

ggplot(admits) +
  geom_bar(mapping = aes(x = admit_year), fill = "navy") + 
  xlab("Admission Year") +
  ylab("Count") +
  ggtitle("Frequency of Admissions by Year")

## Admission month

ggplot(admits) +
  geom_bar(aes(x = admit_month), fill = "navy") +
  xlab("Admission Month") +
  ylab("Count") +
  ggtitle("Frequency of Admissions by Month") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

## Admission day

admits = admits %>% mutate(admit_wday = wday(admit_time, label = T))

ggplot(admits) +
  geom_bar(aes(x = admit_wday), fill = "navy") +
  xlab("Admission Day") +
  ylab("Count") +
  ggtitle("Frequency of Admissions by Day of Week") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

## Admission hour

admits = admits %>% mutate(admit_hour = hour(admit_time))

ggplot(admits) + 
  geom_bar(aes(x = admit_hour), fill = "navy") +
  scale_x_continuous(breaks = c(0, 4, 8, 12, 16, 20)) +
  scale_y_continuous(expand = c(0, 0),
                     limits = c(0, 5000)) +
  xlab("Admission Hour") +
  ylab("Count") +
  ggtitle("Frequency of Admissions by Hour")

## Duration of stay

admits = admits %>% mutate(days_of_stay = as.numeric((disch_time - admit_time), "days"))

ggplot(admits) + 
  geom_histogram(aes(days_of_stay), fill = "navy", binwidth = 5) +
  xlab("Length of Stay (Days)") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Length of Stay (Days)")

summary(admits$days_of_stay)
           
## Admission type

ggplot(admits) +
  geom_bar(aes(admit_type), fill = "navy") +
  xlab("Admit Type") +
  ylab("Count") +
  ggtitle("Frequency of Admissions by Admit Type")

## Number of admissions per patient

ggplot() +
  geom_bar(aes(table(admits$sub_id)), fill = "navy") +
  xlab("Number of admissions per patient") + 
  ylab("Count") + 
  ggtitle("Number of Admissions per Patient")

test = as.data.frame(table(admits$sub_id))

test[order(-test$Freq),]

summary(test$Freq)

## Admissions location

ggplot(admits) + 
  geom_bar(aes(admit_location), fill = "navy") +
  xlab("Admission Location") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Location") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

## Insurance

ggplot(admits) + 
  geom_bar(aes(insurance), fill = "navy") +
  xlab("Insurance Type") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Insurance Type")   

## Language

# Maybe do only top appears, others have low freq

admits %>% group_by(sub_id) %>% filter(n() == 1) %>%
ggplot() +
  geom_bar(aes(language), fill = "navy") +
  xlab("Language") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Language") +
  theme(axis.text.x = element_text(size = 5, angle = 90, hjust = 1))

## Religion

admits %>% group_by(sub_id) %>% filter(n() == 1) %>% select()
ggplot() + 
  geom_bar(aes(religion), fill = "navy") +
  xlab("Religion") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Religion") +
  theme(axis.text.x = element_text(size = 10, angle = 90, hjust = 1))

## Marital Status

admits %>% group_by(sub_id) %>% filter(n() == 1) %>%
ggplot() + 
  geom_bar(aes(mar_stat), fill = "navy") +
  xlab("Marital Status") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Marital Status") +
  theme(axis.text.x = element_text(size = 10, angle = 90, hjust = 1))

## Ethnicity

admits %>% group_by(sub_id) %>% filter(n() == 1) %>%
  ggplot() + 
  geom_bar(aes(ethnicity), fill = "navy") +
  xlab("Ethnicity") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Ethnicity") +
  theme(axis.text.x = element_text(size = 10, angle = 90, hjust = 1))

## Death

admits = admits %>% mutate(survived = is.na(death_time))

ggplot(admits) + 
  geom_bar(aes(survived), fill = "navy") +
  xlab("Survival Status") +
  ylab("Count") +
  ggtitle("Admissions by Survival Status") +
  scale_x_discrete(labels = c("Died", "Survived")) +
  theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1))

# Can do something else?

# Question 2

patients = read_csv("/home/203bdata/mimic-iii/PATIENTS.csv")

pt_colnames = c("row_id", "sub_id", "gender", "dob", "dod", "dod_hosp",
                "dod_ssn", "exp_flag")

names(patients) = pt_colnames

admit_pts = left_join(admits, patients, by = "sub_id")

# inner_admit_pts = inner_join(admits, patients, by = "sub_id")

# gender

ggplot(admit_pts) +
  geom_bar(aes(gender), fill = "navy") +
  xlab("Gender") +
  ylab("Count") +
  scale_x_discrete(labels = c("Female", "Male")) +
  ggtitle("Distribution of Gender in Admitted Patients") +
  theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1))

# age at admission

names(admit_pts)

# create admit age in years
admit_pts = admit_pts %>% 
  mutate(admit_age = as.numeric(admit_time - dob, "weeks")/52.25) 

select(admit_pts, dob)

range(admit_pts$dob)

range(admit_pts$admit_age)

ggplot(admit_pts) + 
  geom_histogram(aes(admit_age), fill = "navy", binwidth = 10) +
  xlab("Age at Admission") +
  ylab("Count") + 
  ggtitle("Distribution of Age at Admission")

dim(admit_pts)
  
# Question 3

icu = read_csv("/home/203bdata/mimic-iii/ICUSTAYS.csv")

names(icu) = tolower(names(icu))

names(icu)

# Length of ICU Stay

ggplot(icu) +
  geom_histogram(aes(los), fill = "navy", binwidth = 5) +
  xlab("Length of ICU Stay") +
  ylab("Count") +
  ggtitle("Distribution of Length of ICU Stay")

# first ICU unit

ggplot(icu) +
  geom_bar(aes(first_careunit), fill = "navy") +
  xlab("First ICU Unit") +
  ylab("Count") +
  ggtitle("Frequency of First ICU Unit")

#gender

icu_pts = left_join(icu, patients, by = "sub_id")

ggplot(icu_pts) +
  geom_bar(aes(gender), fill = "navy") +
  xlab("Gender") +
  ylab("Count") +
  ggtitle("Gender among Patients with ICU Stay")

#age
