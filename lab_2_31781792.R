#Import Libraries
library(dplyr)
library(ggplot2)

#Read CSV
accidents <- read.csv(file = "accidents2014.csv")
nrow(accidents)
print("1. This is the dimensions for the original accidents.csv")
print(dim(accidents))

#Used select to create a new data set(shortaccidents) which eliminates Accident.Date,
#Time..24hr., Road.Surface, Lighting.Conditions, and Weather.Conditions
#But keeps everything else

shortaccidents <- select(accidents, Reference.Number, Grid.Ref..Easting,
                         Grid.Ref..Northing, Number.of.Vehicles, Number.of.Casualties, 
                         X1st.Road.Class, Casualty.Class, Casualty.Severity, Sex.of.Casualty, 
                         Age.of.Casualty, Type.of.Vehicle)

#Filtered the shortaccidents data set to create a new data set(shorteraccidents) which 
#only studies accidents for a private car(vehicle type 9) and accidents that are not on
#a motorway (Motorway accidents are classified as X1st.Road.Class=1)

shorteraccidents <- filter(shortaccidents, Type.of.Vehicle == 9, X1st.Road.Class != 1)

#Printing dimensions of the new shortestaccidents data set (Answer to number 2)
print("2. This is the dimensions after using select() and filter() ")
print(dim(shorteraccidents))

#Created a new data set(centeraccidents) from the shortestaccidents data set
#which adds a column (Distance.from.Center) which is the distance of the accident
#from the Centre of Leeds. The Centre of Leeds has
#Easting-Northing coordinates of 429967 and 434260 respectively. 
#This was calculated by using : (Accidents Easting coordinates - Leeds centre Easting coordinate)^2 +
# (Accidents Norting coordinates - Leeds centre Norting coordinate)^2
#Which was then square rooted to provide the distance from the centre in metres. (Answer to number 3)

centeraccidents <- mutate(shorteraccidents, Distance.from.Center = 
                            sqrt((Grid.Ref..Easting - 429967)^2 + (Grid.Ref..Northing - 434260)^2))

#Print the centeraccidents data set which is arranged in Ascending order for the Distance.from.Center 
#(Answer to number 3)
#print(arrange(centeraccidents, Distance.from.Center))
print("3. These are the last rows of the data sheet after adding the Distance.from.Center column arranged in Ascending order")
print(tail(arrange(centeraccidents, Distance.from.Center)))

#Created a Histogram(histaccidents) for the Age.of.Casualty which has been
#grouped into 10 year groups using binwidth=10
#The Axis labels were set to Casualty Age and No. of Casualties (Answer to number 4)
#This is the original plot which has the standard layout
#ggplot(centeraccidents) + geom_histogram(aes(x=Age.of.Casualty), binwidth=10) + labs(x= "Casualty Age", y= "No. of Casualties") + ggtitle("Answer to Number 5")

#This is the colored one which starts from -5 
#ggplot(centeraccidents) + geom_histogram(aes(x=Age.of.Casualty, fill=..count..), binwidth=10, col="blue")+ labs(x= "Casualty Age", y= "No. of Casualties")+ ggtitle("Answer to Number 5")

#This is the plot which starts from 0 and is colored blue with counts to look cool (My final submission for number 4)
histaccidents <- ggplot(centeraccidents) + geom_histogram(aes(x=Age.of.Casualty, fill=..count..), binwidth=10, col="blue", breaks=seq(0,120,by=10)) + 
    labs(x= "Casualty Age", y= "No. of Casualties") + ggtitle("Answer to Number 4")



#Saved this new histogram as histaccidents.png (Answer to Number 4)
ggsave(histaccidents, file="histaccidents_31781792.png", width=4, height=4)
print("Histogram plot was saved as histaccidents_31781792.png in working directory")