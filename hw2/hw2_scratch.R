library(dplyr)
library(tidyverse)
library(ggplot2)
library(lubridate)
library(gridExtra)
library(grid)
library(stringr)
library(magrittr)

# Question 1

# Load data

admits = read_csv("/home/203bdata/mimic-iii/ADMISSIONS.csv")

# Change column names

col_names = c(
  'rowid',
  'sub_id',
  'hadm_id',
  'admit_time',
  'disch_time',
  'death_time',
  'admit_type',
  'admit_location',
  'disch_location',
  'insurance',
  'language',
  'religion',
  'mar_stat',
  'ethnicity',
  'ed_reg_time',
  'ed_out_time',
  'diagnosis',
  'hospital_exp_flag',
  'has_chart_events'
)

names(admits) = col_names

# Parse out year/month/day from datetime columns

admits = admits %>% mutate(
  admit_year = year(admit_time),
  admit_month = month(admit_time, label = T),
  admit_day = day(admit_time)
)

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

test[order(-test$Freq), ]

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
  theme(axis.text.x = element_text(
    size = 5,
    angle = 90,
    hjust = 1
  ))

## Religion

admits %>% group_by(sub_id) %>% filter(n() == 1) %>%
  ggplot() +
  geom_bar(aes(religion), fill = "navy") +
  xlab("Religion") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Religion") +
  theme(axis.text.x = element_text(
    size = 10,
    angle = 90,
    hjust = 1
  ))

## Marital Status

admits %>% group_by(sub_id) %>% filter(n() == 1) %>%
  ggplot() +
  geom_bar(aes(mar_stat), fill = "navy") +
  xlab("Marital Status") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Marital Status") +
  theme(axis.text.x = element_text(
    size = 10,
    angle = 90,
    hjust = 1
  ))

## Ethnicity

# create unique admits tibble
admits_unique = admits %>% group_by(sub_id) %>% filter(n() == 1)

#Raw plot is pretty useless
admits_unique %>% group_by(ethnicity) %>%
  ggplot() +
  geom_bar(aes(ethnicity), fill = "navy") +
  xlab("Ethnicity") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Ethnicity") +
  theme(axis.text.x = element_text(
    size = 10,
    angle = 90,
    hjust = 1
  ))

#Lets exclude white patients and those whose race was not provided
admits_unique %>% group_by(ethnicity) %>% filter(n() < 300) %>%
  ggplot() +
  geom_bar(aes(ethnicity), fill = "navy") +
  xlab("Ethnicity") +
  ylab("Count") +
  ggtitle("Frequency of Admission by Ethnicity") +
  theme(axis.text.x = element_text(
    size = 10,
    angle = 90,
    hjust = 1
  ))

## Death

admits = admits %>% mutate(survived = is.na(death_time))

ggplot(admits) +
  geom_bar(aes(survived), fill = "navy") +
  xlab("Survival Status") +
  ylab("Count") +
  ggtitle("Admissions by Survival Status") +
  scale_x_discrete(labels = c("Died", "Survived")) +
  theme(axis.text.x = element_text(
    size = 10,
    angle = 45,
    hjust = 1
  ))

# Question 2

patients = read_csv("/home/203bdata/mimic-iii/PATIENTS.csv")

pt_colnames = c("row_id",
                "sub_id",
                "gender",
                "dob",
                "dod",
                "dod_hosp",
                "dod_ssn",
                "exp_flag")

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
  theme(axis.text.x = element_text(
    size = 10,
    angle = 45,
    hjust = 1
  ))

# age at admission

names(admit_pts)

# create admit age in years
admit_pts = admit_pts %>%
  mutate(admit_age = as.numeric(admit_time - dob, "weeks") / 52.25)

#In the documentation, ages above 89 were modified. Based on the raw plot the discrepancy is obvious:

ggplot(admit_pts) +
  geom_histogram(aes(admit_age), fill = "navy", binwidth = 10) +
  xlab("Age at Admission") +
  ylab("Count") +
  ggtitle("Distribution of Age at Admission")

#Now we show two plots, one for ages 0-89, and one for ages over 89:

admit_pts %>% filter(admit_age <= 89) %>%
  ggplot() +
  geom_histogram(aes(admit_age), fill = "navy", binwidth = 5) +
  xlab("Age at Admission") +
  ylab("Count") +
  scale_x_continuous(breaks = seq(0, 90, 10)) +
  ggtitle("Distribution of Age at Admission, Ages 0-89")

admit_pts %>% filter(admit_age > 89) %>%
  ggplot() +
  geom_histogram(aes(admit_age), fill = "navy", binwidth = 2) +
  xlab("Age at Admission") +
  ylab("Count") +
  scale_x_continuous(breaks = seq(300, 312, 2)) +
  ggtitle("Distribution of Age at Admission, Ages 89+")

# Question 3

icu = read_csv("/home/203bdata/mimic-iii/ICUSTAYS.csv")

names(icu) = tolower(names(icu))

names(icu)

# Length of ICU Stay

ggplot(icu) +
  geom_histogram(aes(los), fill = "navy", binwidth = 5) +
  xlab("Length of ICU Stay") +
  ylab("Count") +
  ggtitle("Distribution of Length of ICU Stay (Days)")

#10 NA rows were dropped

# first ICU unit

ggplot(icu) +
  geom_bar(aes(first_careunit), fill = "navy") +
  xlab("First ICU Unit") +
  ylab("Count") +
  ggtitle("Frequency of First ICU Unit") +
  theme(axis.text.x = element_text(
    size = 10,
    angle = 45,
    hjust = 1
  ))

# Gender

icu_pts = left_join(icu, patients, by = "sub_id")

ggplot(icu_pts) +
  geom_bar(aes(gender), fill = "navy") +
  xlab("Gender") +
  ylab("Count") +
ggtitle("Gender among Patients with ICU Stay")

# Same pattern as in admitted patients

# Age

icu_admit_pts = left_join(icu, admit_pts, by = "hadm_id")

p1 = icu_admit_pts %>% filter(first_careunit == "CCU") %>% filter(admit_age <= 89) %>%
  ggplot() +
  geom_histogram(aes(admit_age), fill = "navy", binwidth = 5) +
  xlab("Age at Admission") +
  ylab("Count") +
  ggtitle("CCU") +
  scale_x_continuous(breaks = seq(0, 90, 10))

p2 = icu_admit_pts %>% filter(first_careunit == "CSRU") %>% filter(admit_age <= 89) %>%
  ggplot() +
  geom_histogram(aes(admit_age), fill = "navy", binwidth = 5) +
  xlab("Age at Admission") +
  ylab("Count") +
  ggtitle("CSRU") +
  scale_x_continuous(breaks = seq(0, 90, 10))

p3 = icu_admit_pts %>% filter(first_careunit == "MICU") %>% filter(admit_age <= 89) %>%
  ggplot() +
  geom_histogram(aes(admit_age), fill = "navy", binwidth = 5) +
  xlab("Age at Admission") +
  ylab("Count") +
  ggtitle("MICU") +
  scale_x_continuous(breaks = seq(0, 90, 10))

p4 = icu_admit_pts %>% filter(first_careunit == "SICU") %>% filter(admit_age <= 89) %>%
  ggplot() +
  geom_histogram(aes(admit_age), fill = "navy", binwidth = 5) +
  xlab("Age at Admission") +
  ylab("Count") +
  ggtitle("SICU") +
  scale_x_continuous(breaks = seq(0, 90, 10))

p5 = icu_admit_pts %>% filter(first_careunit == "TSICU") %>%
  filter(admit_age <= 89) %>%
  ggplot() +
  geom_histogram(aes(admit_age), fill = "navy", binwidth = 5) +
  xlab("Age at Admission") +
  ylab("Count") +
  ggtitle("TSICU") +
  scale_x_continuous(breaks = seq(0, 90, 10))

p6 = icu_admit_pts %>% filter(admit_age > 89) %>%
  ggplot() +
  geom_histogram(aes(admit_age - 210), fill = "navy", binwidth = 2) +
  xlab("Age at Admission") +
  ylab("Count") +
  scale_x_continuous(breaks = seq(90, 100, 2)) +
  ggtitle("Ages 89+, all ICUs")

grid.arrange(
  p1,
  p2,
  p3,
  p4,
  p5,
  p6,
  nrow = 2,
  top = textGrob("Age Distribution of ICU Admits",
                 gp = gpar(fontsize = 20, font = 2))
)

# Question 4

# CHARTEVENTS.csv (https://mimic.physionet.org/mimictables/chartevents/) contains all the charted data available for a patient.
# During their ICU stay, the primary repository of a patient’s information is their electronic chart. 
# The ITEMID variable indicates a single measurement type in the database. The VALUE variable is the value measured for ITEMID.
# 
# D_ITEMS.csv (https://mimic.physionet.org/mimictables/d_items/) is the dictionary for the ITEMID in 
# CHARTEVENTS.csv. Find potential values of ITEMID that correspond to systolic blood pressure, i.e., LABEL contains the string systolic.
# 
# Compile a tibble that contains the first ICU stay of unique patients, with the patient’s demographic information, 
# the first systolic blood pressure measurement during ICU stay, and whether the patient died within 30 days of hospitcal admission.

chart_events = read_csv("/home/203bdata/mimic-iii/CHARTEVENTS.csv")

names(chart_events) = tolower(names(chart_events))

dim(table(chart_events$subject_id))

d_items = read_csv("/home/203bdata/mimic-iii/D_ITEMS.csv", col_types = "ddcccccccc")

names(d_items) = tolower(names(d_items))

chart_labeled = left_join(chart_events, d_items, by = "itemid")

chart_labeled

chart_labeled %>% 
  filter(str_detect(label, regex('systolic', ignore_case = T))) %>% 
  select(itemid, label) %$% 
  table(itemid, label)

# use itemids 220050, 220059, 220179, 224167, 225309, 227243

final_a = chart_labeled %>% 
          filter(itemid %in% c(220050, 220059, 220179, 224167, 225309, 227243)) %>% 
          group_by(subject_id) %>%
          top_n(n = 1, wt = desc(charttime)) %>% filter(n() == 1) %>% 
          select(subject_id, hadm_id, icustay_id, value, valuenum, valueuom) %>% arrange(subject_id) 


final_a

final_b = icu_admit_pts %>%
  select(subject_id, hadm_id, first_careunit, admit_time, death_time, admit_type, admit_location, insurance, language, religion, mar_stat, ethnicity) %>% arrange(subject_id)

final_b


final_c = right_join(final_a, final_b, by ="hadm_id", "subject_id") %>% filter(!is.na(value)) 

final_c

final = final_c %>% mutate(died_within_30 = case_when(
                                    is.na(death_time) ~ F, 
                                    as.numeric(death_time - admit_time, "days") < 30 ~ T))
                 
final = final %>% select(subject_id.x, hadm_id, icustay_id, valuenum, valueuom, first_careunit, admit_time:died_within_30) %>% rename(subject_id = subject_id.x)
