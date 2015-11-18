## Loading and cleaning the data
## Loading the file
data <- read.xlsx2("data/JudicialPowerRanking.xlsx", header = FALSE, 
                   startRow = 3, endRow = 88, sheetIndex = 1, stringsAsFactors = FALSE)

data.countries <- read.xlsx2("data/JudicialPowerRanking.xlsx", header = FALSE, 
                             startRow = 1, endRow = 1, sheetIndex = 1, stringsAsFactors = FALSE)

## Adding the country names, and removing unnecessary columns
colnames(data)[4:28] <- data.countries[4:28]
colnames(data)[1] <- "Type"
## Let's remove the questions and the ID
data <- data[,c(1,4:28)]

## Convering values to numeric type
data[, 2:26] <- sapply(data[, 2:26], as.numeric)
data[,1] <- sapply(data[, 1], as.factor)

## Let's remove NAs
data <- data %>% filter(!is.na(data[,2]))

## Let's do a summary of the data
# First, we gather all the data to make sure we can add the values
data.melted <- data %>% gather(key = Country, value = Value, -Type)

# Next, we add all the values together to get a score.
data.summary <- data.melted %>% group_by(Type, Country) %>% 
    summarise(Total = sum(Value))

# Let's have a varible displaying the type of data
type <- unique(data.summary$Type)

# Loading the map
map <- readOGR("map", layer = "latinAmerica", verbose = FALSE)
