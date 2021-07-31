library(tidyverse)
library(ggplot2)

# load cleaned dataset
crash <- read_delim("data_clean.csv", ";", escape_double = FALSE, trim_ws = TRUE)
crash$year <- as.factor(crash$year)
crash$Month <- as.factor(crash$Month)
crash$Fatalities <- as.factor(crash$Fatalities)
crash$Injuries <- as.factor(crash$Injuries)
crash$Light_Condition <- as.factor(crash$Light_Condition)

# Monthly number of crashes
crash_no2021 <- filter(crash, year != 2021)
## histogram version
ggplot(crash_no2021,aes(x=Month))+
  geom_histogram(stat="count", fill="lightblue", col='darkblue') + 
  facet_wrap(~year) + 
  labs(title="Monthly number of crashes during the years 2016-2020",
       y = 'Count') +
  theme(axis.ticks = element_blank())

## line version
yearly_counts <- crash_no2021 %>%
  group_by(year, Month) %>%
  summarise(count=n())
yearly_counts$year <- as.factor(yearly_counts$year)
ggplot(yearly_counts, aes(x=Month, y=count, group=year, color=year)) +
  geom_line() + geom_point()

# Total number of crashes every hour
ggplot(crash,aes(x=Hour, fill=Fatalities))+
  geom_histogram(stat="count") + 
  labs(title="Hourly number of crashes during the years 2016-2020",
       y = 'Count') +
  theme(axis.ticks = element_blank())

# Fatality percentage per hour
fatality_hour <- read_csv('fatality_rate_per_hour.csv')
ggplot(fatality_hour,aes(x=Hour, y=Fatality_Rate))+
  geom_bar(col='black', fill='red', stat='identity') + 
  labs(title="Fatality Rate Per Hour",
       y = 'Fatality Rate') +
  theme(axis.ticks = element_blank())

# Injury percentage per hour
injury_hour <- read_csv('injury_rate_per_hour.csv')
ggplot(injury_hour,aes(x=Hour, y=Injury_Rate))+
  geom_bar(col='white', fill='blue', stat='identity') + 
  labs(title="Injury Rate Per Hour",
       y = 'Injury Rate') +
  theme(axis.ticks = element_blank())

## VEHICLE-WEATHER
vehicle_weather <- read_csv("vehicle_weather.csv")
vehicle_weather_clean <- filter(vehicle_weather, 
                                New_Vehicle != 'NONE' & Weather != 'NONE')
vehicle_notclear_weather <- filter(vehicle_weather, 
                                   New_Vehicle != 'NONE' & Weather != 'NONE' &
                                     Weather != 'CLEAR')

ggplot(vehicle_weather_clean, aes(x=New_Vehicle, fill = factor(Weather))) +
  geom_bar() +
  coord_flip() +   
  labs(title="Number of crashes grouped by weather condition & type of vehicle", 
       x = '', y='') +
  theme(axis.ticks = element_blank())

ggplot(vehicle_weather_clean, aes(x=New_Vehicle, fill = factor(Weather_2types))) +
  geom_bar(position = "fill") +
  coord_flip() + 
  scale_y_continuous(labels = scales::percent_format()) +
  labs(title="Crash percentage grouped by weather condition & type of vehicle", 
       x = '', y='') +
  theme(axis.ticks = element_blank())


# Road_Configuration and Light_Condition
# remove rows with 'NONE' values
conf_light_clean <- filter(crash, 
                           Road_Configuration != 'NONE' & Light_Condition != 'NONE'
                           )

ggplot(conf_light_clean, aes(x=Light_Condition, fill = factor(Road_Configuration))) +
  geom_bar(position = "fill") +
  coord_flip() + 
  scale_y_continuous(labels = scales::percent_format()) + 
  labs(title="Crash percentage grouped by light condition & road configuration", 
       x = '', y='') +
  theme(axis.ticks = element_blank())

### Chi-squared test of Independence
light_configuration <- filter(crash,
                              Light_Condition != 'NONE' & Road_Configuration != 'NONE')
levels_light_condition <- levels(light_configuration$Light_Condition)[1:6]
light_configuration$Light_Condition <- factor(light_configuration$Light_Condition, 
                                              levels= levels_light_condition)
light_configuration_chi <- table(light_configuration$Light_Condition, light_configuration$Road_Configuration)
chisq.test(light_configuration_chi)







