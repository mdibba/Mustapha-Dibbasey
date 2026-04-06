library(readr)
library(tidyverse)
library(ggplot2)
#install.packages("openxlsx")
library("openxlsx")
library(readxl)
library(ggplot2)
library(tidyr) 
library(dplyr)



microbiology_data <- read_csv("Library/CloudStorage/OneDrive-LondonSchoolofHygieneandTropicalMedicine/Manuscript Folders/Microbiology data/2019_2024MicroCompleteEditedBN.csv")


#retrieve information about coliform species and strep species/group
coliform_Strep_Salmonella_species <- Invasive_dataset_cleaned_final %>% filter(Culture==c('Streptococcus species', 'Streptococcus Group', 'Coliform species', 'Salmonella species'))
write.xlsx(coliform_Strep_Salmonella_species, file = "/Users/mdibbasey/Documents/coliform_Strep_Salmonella_species.xlsx")


# ##################bacteria isolates prevalence from all the invasive samples (Blood, CSF and Aspirate) and their resistance pattern
# Invasive_dataset <- microbiology_data %>% filter(SampleType %in% c("Blood", "CSF", "Aspirate"))
# #removing some unwanted column
# Invasive_dataset <- Invasive_dataset[ , -c(6, 8, 10:14, 16:30)]
# 
# #removing non-sig bacteria and negative results in Invasive_dataset
# Invasive_dataset2_cleaned <- Invasive_dataset[!Invasive_dataset$Culture %in% c(
#   "90% polymorphs", "90% POLYMORPHS", "Few polymorphs seen","lymphocytes","LYMPHOCYTES", "Lymphocytes + seen", "mainly lymphocytes",
#   "MAINLY LYMPHOCYTES", "NEGATIVE RODS", "NO ORGANISM", "NO ORGANISM SEEN","NO ORGANISM SEEN WBC (++) MAINLY POLYMORPHS",
#   "no organism seen wbc(+)90% lymphocyts",  "no organism seen wbc(+)mainly lympcocyts", "no organism seen wbc(++++) mainly polymorphs",
#   "POLYMORPHS=45%", "WBC +", "WBC +++ 60% polymorphs", "wbc(+) 90% polymorphs", "wbc(+) 95% lymphocytes", "WBC(+) mainly polymorphs",
#   "VIRIDAN STREPTOCOCCI", "VIRIDAN STREPTOCOCCUS", "ONCHROBACTRUM ANTHROPI", "STREPTOCOCCUS SALIVARIUS",
#   "ABIOTROPHIA ADIACENS", "ACHROMOBACTER XYLOSOOXIDANS","ACINETOBACFER IWOFFII", "AEINETOBACTER BACIMANNII","BIFIDOBACTERIUM LONGUM",
#   "CORYNBACTERIUM JEIKEIUM", "DERMATOCOCCUS SPP", "HAFNEI ALVEI", "MORAXELLA CATAHALIS", "MORAXELLA OSLOVESIS", "MYROIDES ODORATIS", 
#   "SPHINGOMENAS PAUCIMOBILIS", "VIBRIO ALGINOLYTICUS", "Burkholderia pseud", "Candida species", "Coagulase Negative Staphylococcus", 
#   "Micrococci species", "No growth", "No growth after 48 hours", "No pathogens isolated", "Staphylococcus coagulase negative", 
#   "No significant growth", "STREP VIRIDANS", "Bacillus species", "VIRIDAN STREP", "No growth"), ]
# 
# #exported the excel version to do some cleaning
# #write.xlsx(Invasive_dataset2_cleaned, file = "/Users/mdibbasey/Documents/Invasive_dataset2_cleaned.xlsx")
# 
# #import the dataset again after cleaning the data in excel
# Invasive_dataset2_cleaned <- read_excel("Documents/Invasive_dataset4_cleaned.xlsx")
# #removing "OTHER" and other non-sig bacteria
# Invasive_dataset_cleaned_final <- Invasive_dataset2_cleaned[!Invasive_dataset2_cleaned$Culture %in% c(
#   "90% polymorphs", "90% POLYMORPHS", "Few polymorphs seen","lymphocytes","LYMPHOCYTES", "Lymphocytes + seen", "mainly lymphocytes",
#   "MAINLY LYMPHOCYTES", "NEGATIVE RODS", "NO ORGANISM", "NO ORGANISM SEEN","NO ORGANISM SEEN WBC (++) MAINLY POLYMORPHS",
#   "no organism seen wbc(+)90% lymphocyts",  "no organism seen wbc(+)mainly lympcocyts", "no organism seen wbc(++++) mainly polymorphs",
#   "POLYMORPHS=45%", "WBC +", "WBC +++ 60% polymorphs", "wbc(+) 90% polymorphs", "wbc(+) 95% lymphocytes", "WBC(+) mainly polymorphs",
#   "VIRIDAN STREPTOCOCCI", "VIRIDAN STREPTOCOCCUS", "ONCHROBACTRUM ANTHROPI", "STREPTOCOCCUS SALIVARIUS",
#   "ABIOTROPHIA ADIACENS", "ACHROMOBACTER XYLOSOOXIDANS","ACINETOBACFER IWOFFII", "AEINETOBACTER BACIMANNII","BIFIDOBACTERIUM LONGUM",
#   "CORYNBACTERIUM JEIKEIUM", "DERMATOCOCCUS SPP", "HAFNEI ALVEI", "MORAXELLA CATAHALIS", "MORAXELLA OSLOVESIS", "MYROIDES ODORATIS", 
#   "SPHINGOMENAS PAUCIMOBILIS", "VIBRIO ALGINOLYTICUS", "Burkholderia pseud", "Candida species", "Coagulase Negative Staphylococcus", 
#   "Micrococci species", "No growth", "No growth after 48 hours", "No pathogens isolated", "Staphylococcus coagulase negative", 
#   "No significant growth", "STREP VIRIDANS", "Bacillus species", "VIRIDAN STREP", "OTHER", "LYMPOCYTES 40% POLYM", "mainly porlymophs",
#   "NO ORGANISM SEEN  WBC + (lymphoctes mainly)", "no organism seen wbc (+++) mainly lymphocytes)", "NO ORGANISM SEEN WBC (+++) MAINLY POLYMPHS",
#   "NO ORGANISM SEEN WBC +++", "No organism seen wbc scanty mainly lymphocytes", "POLYMORPHS SEEN", "SCANTY MAINLY LYMPHOCYTES",
#   "no organism seen wbc (+++) mainly lymphocytes)", "ACTINOMYCES SPP", "AEROMONAS SPECIES", "no organism seen wbc (+++) mainly lymphocytes", 
#   "CORYNEBACTERIUM SPP", "DEPHTHERESDS  SPECIES", "DIPHTHEROIDS"),]
# 
# ##write.xlsx(Invasive_dataset_cleaned_final, file = "/Users/mdibbasey/Documents/Invasive_dataset_cleaned_final.xlsx")

#import the invasive_dataset_cleaned_final from the document

Invasive_dataset_cleaned_final <- read_excel("Documents/Invasive_dataset_cleaned_final.xlsx")
            

#FINAL INVASIVE DATASET IS Invasive_dataset_cleaned_final
sampletype_count <- table(Invasive_dataset_cleaned_final$SampleType)
# Calculate the percentage of each type of sample in invasive dataset
Percentage <- prop.table(sampletype_count) * 100
prop_table_sampletype <- data.frame(Sampletype=names(sampletype_count), Frequency = as.vector(sampletype_count), Percentage= as.vector(Percentage))
prop_table_sampletype
#write.xlsx(prop_table_sampletype, file = "/Users/mdibbasey/Documents/prop_table_sampletype.xlsx")

Bacteria_count_invasive <- table(Invasive_dataset_cleaned_final$Culture)
# Calculate the percentage of each type of bacteria
Percentage_invasive <- prop.table(Bacteria_count_invasive) * 100
# Combine the frequency and percentage into a data frame
prop_table_invasive <- data.frame(
  Culture = names(Bacteria_count_invasive),
  Frequency = as.vector(Bacteria_count_invasive),
  Percentage = as.vector(Percentage_invasive))
prop_table_invasive
#generate the excel sheet for other analysis
#write.xlsx(prop_table_invasive, file = "/Users/mdibbasey/Documents/prop_table_invasive.xlsx")

# #retrieve information about coliform species and strep species/group
# Strep_species <- Invasive_dataset_cleaned_final %>%
#   filter(Culture==('Streptococcus species'))
# write.xlsx(Strep_species, file = "/Users/mdibbasey/Documents/Strep_species.xlsx")
# 
# Strep_Group <- Invasive_dataset_cleaned_final %>%
#   filter(Culture==('Streptococcus Group'))
# write.xlsx(Strep_Group, file = "/Users/mdibbasey/Documents/Strep_Group.xlsx")
# 
# 
# Salmonella_species <- Invasive_dataset_cleaned_final %>%
#   filter(Culture==('Salmonella species'))
# write.xlsx(Salmonella_species, file = "/Users/mdibbasey/Documents/Salmonella_species.xlsx")
# 
# 
# Coliform_species <- Invasive_dataset_cleaned_final %>%
#   filter(Culture==('Coliform species'))
# write.xlsx(Coliform_species, file = "/Users/mdibbasey/Documents/Coliform_species.xlsx")
# 



#demographic (age) 
Agegroup1_dataset <- filter(Invasive_dataset_cleaned_final, Age >= 0 & Age <= 1)
Agegroup2_dataset <- filter(Invasive_dataset_cleaned_final, Age >= 2 & Age <= 4) 
Agegroup3_dataset <- filter(Invasive_dataset_cleaned_final, Age >= 5 & Age <= 14) 
Agegroup4_dataset <- filter(Invasive_dataset_cleaned_final, Age >= 15)
#proportion of bacteria isolates as per age group
#agegroup 1
Agegroup1_count <- table(Agegroup1_dataset$Culture)
Percentage <- prop.table(Agegroup1_count) * 100
prop_table_agegroup1 <- data.frame(
  Culture = names(Agegroup1_count),
  Frequency = as.vector(Agegroup1_count),
  Percentage = as.vector(Percentage))
print(prop_table_agegroup1)
#write.xlsx(prop_table_agegroup1, file = "/Users/mdibbasey/Documents/prop_table_agegroup1.xlsx")
#agegroup 2
Agegroup2_count <- table(Agegroup2_dataset$Culture)
Percentage <- prop.table(Agegroup2_count) * 100
prop_table_agegroup2 <- data.frame(
  Culture = names(Agegroup2_count),
  Frequency = as.vector(Agegroup2_count),
  Percentage = as.vector(Percentage))
print(prop_table_agegroup2)
#write.xlsx(prop_table_agegroup2, file = "/Users/mdibbasey/Documents/prop_table_agegroup2.xlsx")

#agegroup 3
Agegroup3_count <- table(Agegroup3_dataset$Culture)
Percentage <- prop.table(Agegroup3_count) * 100
prop_table_agegroup3 <- data.frame(
  Culture = names(Agegroup3_count),
  Frequency = as.vector(Agegroup3_count),
  Percentage = as.vector(Percentage))
print(prop_table_agegroup3)
#write.xlsx(prop_table_agegroup3, file = "/Users/mdibbasey/Documents/prop_table_agegroup3.xlsx")

#age group 4
Agegroup4_count <- table(Agegroup4_dataset$Culture)
Percentage <- prop.table(Agegroup4_count) * 100
prop_table_agegroup4 <- data.frame(
  Culture = names(Agegroup4_count),
  Frequency = as.vector(Agegroup4_count),
  Percentage = as.vector(Percentage))
print(prop_table_agegroup4)
#write.xlsx(prop_table_agegroup4, file = "/Users/mdibbasey/Documents/prop_table_agegroup4.xlsx")
#proportion of bacterial isolates based on young adults (15 to 24), adults (25 to 60) and elderly (≥60)
Agegroup4_15_24 <- filter(Agegroup4_dataset, Age >= 15 & Age <= 25)
Agegroup4_25_60 <- filter(Agegroup4_dataset, Age >= 25 & Age <= 59)
Agegroup4_60 <- filter(Agegroup4_dataset, Age >= 60)
#proportion of age group 4 sub_age group 1
Agegroup4_15_24 <- table(Agegroup4_15_24$Culture)
Percentage <- prop.table(Agegroup4_15_24)*100
prop_table_Agegroup4_15_24 <- data.frame(
  Culture = names(Agegroup4_15_24),
  Frequency = as.vector(Agegroup4_15_24),
  Percentage = as.vector(Percentage))
print(prop_table_Agegroup4_15_24)
#write.xlsx(prop_table_Agegroup4_15_24, file = "/Users/mdibbasey/Documents/prop_table_Agegroup4_15_24.xlsx")
#proportion of age group 4 sub_age group 2
Agegroup4_25_60 <- table(Agegroup4_25_60$Culture)
Percentage <- prop.table(Agegroup4_25_60)*100
prop_table_Agegroup4_25_60 <- data.frame(
  Culture = names(Agegroup4_25_60),
  Frequency = as.vector(Agegroup4_25_60),
  Percentage = as.vector(Percentage))
print(prop_table_Agegroup4_25_60)
#write.xlsx(prop_table_Agegroup4_25_60, file = "/Users/mdibbasey/Documents/prop_table_Agegroup4_25_60.xlsx")
#proportion of age group 4 sub_age group 3
Agegroup4_60 <- table(Agegroup4_60$Culture)
Percentage <- prop.table(Agegroup4_60)*100
prop_table_Agegroup4_60 <- data.frame(
  Culture = names(Agegroup4_60),
  Frequency = as.vector(Agegroup4_60),
  Percentage = as.vector(Percentage))
print(prop_table_Agegroup4_60)
#write.xlsx(prop_table_Agegroup4_60, file = "/Users/mdibbasey/Documents/prop_table_Agegroup4_60.xlsx")

#distribution of bacterial isolates in all the agegroups
Age_dataset <- read_excel("Documents/prop_table_agegroup1.xlsx", sheet = "Combinations")
View(Age_dataset)
Age_dataset$Sqrt.Frequency <- sqrt(Age_dataset$Frequency)

Age_dataset <- Age_dataset %>% 
  group_by(AgeGroup) %>% 
  mutate(
    AgeGroup_Total = sum(Frequency),
    Proportion = (Frequency / AgeGroup_Total)*100
  ) %>% 
  ungroup()
Age_dataset$Sqrt.proportion <- sqrt(Age_dataset$Proportion)
#head(Age_dataset)

Age_heatmap <- ggplot(Age_dataset,
                      aes(x = AgeGroup, 
                          y = Culture, 
                          fill = Sqrt.proportion)) +
  # Main heatmap
  geom_tile(colour = NA, linewidth = 0) +
  # Title and labels
  labs(
    title = "Bacterial Distribution Pattern Across Age Groups",
    x = "Age Group",
    y = "Bacterial Isolates",
    fill = "Proportion"
  ) +
  # High-quality, colour-blind friendly scale
  scale_fill_gradientn(
    colours = c("#F7FBFF", "#C6DBEF", "#6BAED6", "#2171B5", "#08306B"),
    limits = c(min(Age_dataset$Sqrt.proportion), 
               max(Age_dataset$Sqrt.proportion)),
    oob = scales::squish
  ) +
  # Reverse y order for clean top-down reading
  scale_y_discrete(limits = rev(unique(Age_dataset$Culture))) +
  # Base theme for publication
  theme_minimal(base_size = 14) +
  # Detailed theme refinement
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 12),
    axis.text.x = element_text(angle = 45,hjust = 1, vjust = 1,face = "bold",size = 12),
    axis.text.y = element_text(face = "bold", size = 12),
    axis.title = element_text(face = "bold", size = 15),
    legend.title = element_text(face = "bold", size = 13),
    legend.text  = element_text(size = 11),
    panel.grid = element_blank(),
    plot.margin = margin(1, 1, 1, 1, "cm")
  ) +
  # Optional: improve separation without borders
  scale_x_discrete(expand = c(0, 0))
  #scale_y_discrete(expand = c(0, 0))
A <- Age_heatmap
A+ggtitle(label = "A")
#subtitle = "Bacterial Distribution Pattern Across Age Groups"

#distribution of bacterial isolates in sub age groups of agegroup4
Age_dataset4 <- read_excel("Documents/prop_table_Agegroup4_15_24.xlsx", sheet = "Combination")
Age_dataset4$Sqrt.Frequency <- sqrt(Age_dataset4$Frequency)
#View(Age_dataset4)

Age_dataset4 <- Age_dataset4 %>% 
  group_by(AgeGroup) %>% 
  mutate(
    AgeGroup_Total = sum(Frequency),
    Proportion = (Frequency / AgeGroup_Total)*100
  ) %>% 
  ungroup()
Age_dataset4$Sqrt.proportion <- sqrt(Age_dataset4$Proportion)
head(Age_dataset4)

Age_heatmap <- ggplot(Age_dataset4,
                      aes(x = AgeGroup, 
                          y = Culture, 
                          fill = Sqrt.proportion)) +
  # Main heatmap
  geom_tile(colour = NA, linewidth = 0) +
  # Title and labels
  labs(
    title = "Bacterial Distribution Pattern Across Sub Age Group 4",
    x = "Age Group 4 (15 and above)",
    y = "Bacterial Isolates",
    fill = "Proportion"
  ) +
  # High-quality, colour-blind friendly scale
  scale_fill_gradientn(
    colours = c("#F7FBFF", "#C6DBEF", "#6BAED6", "#2171B5", "#08306B"),
    limits = c(min(Age_dataset$Sqrt.proportion), 
               max(Age_dataset$Sqrt.proportion)),
    oob = scales::squish
  ) +
  # Reverse y order for clean top-down reading
  scale_y_discrete(limits = rev(unique(Age_dataset$Culture))) +
  # Base theme for publication
  theme_minimal(base_size = 14) +
  # Detailed theme refinement
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 12),
    axis.text.x = element_text(
      angle = 45,
      hjust = 1,
      vjust = 1,
      face = "bold",
      size = 12
    ),
    axis.text = element_text(face = "bold", size = 12),
    axis.title = element_text(face = "bold", size = 15),
    legend.title = element_text(face = "bold", size = 13),
    legend.text  = element_text(size = 11),
    panel.grid = element_blank(),
    plot.margin = margin(1, 1, 1, 1, "cm")
  ) +
  # Optional: improve separation without borders
  scale_x_discrete(expand = c(0, 0))
  #scale_y_discrete(expand = c(0, 0))
B <- Age_heatmap
B+ ggtitle(label = "B")
#subtitle = "Bacterial Distribution Pattern Across Sub Age Group 4"



#barplot based on Agegroup
Bar_data_age <- ggplot(data = Age_dataset, 
                       mapping = aes(x = Proportion, 
                                     y = Culture, 
                                     fill = AgeGroup)) +
  geom_col(position = "dodge")+
  scale_x_continuous(expand = c(0, 0))+
  labs(ylab="Propotion", 
       xlab="Bacterial isolates")+
  theme_classic()+ 
  theme(
    axis.text = element_text(size = 12,face = "bold"), 
    axis.title.y = element_text(face = "bold"),
    axis.title.x = element_text(face = "bold"),
    plot.title = element_text(hjust = 0.5, face = "bold", size = 12)
    )

C <- Bar_data_age
C+ggtitle(label = "C")
#subtitle = "Individual Bacterial Distribution pattern in agegroups"

#barplots based on culture (bacterial isolates)
Bar_data_age2 <- ggplot(data = Age_dataset, 
                        mapping = aes(x = AgeGroup, 
                                      y = Frequency, 
                                      fill = Culture)) +
  geom_col() + 
  theme_classic()+ scale_y_continuous(expand = c(0,0))+
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size=12, face = "bold"),
    axis.title.y = element_text(face = "bold"),
    axis.title.x = element_text(face = "bold"),
    plot.title = element_text(hjust = 0.5, face = "bold", size = 12)
  )
D <- Bar_data_age2
D+ggtitle(label = "D")
# subtitle = "Individual Bacterial Distribution pattern in agegroups"

library(patchwork)

combined_plot <- (A + B) / (C + D) +
  plot_annotation(tag_levels = "A")

combined_plot




#gender
#proportion of bacteria isolated from the invasive samples
#male
Male_Invasive_dataset <- filter(Invasive_dataset_cleaned_final, Sex == "M")
Male_Invasive_count <- table(Male_Invasive_dataset$Culture)
Percentage <- prop.table(Male_Invasive_count) * 100
prop_table_male <- data.frame(
  Culture = names(Male_Invasive_count),
  Frequency = as.vector(Male_Invasive_count),
  Percentage = as.vector(Percentage))
print(prop_table_male)
write.xlsx(prop_table_male, file = "/Users/mdibbasey/Documents/prop_table_male.xlsx")
write.xlsx(Male_Invasive_dataset, file = "/Users/mdibbasey/Documents/Male_Invasive_dataset.xlsx")

#female
Female_Invasive_dataset <- filter(Invasive_dataset_cleaned_final, Sex == "F")
Female_Invasive_count <- table(Female_Invasive_dataset$Culture)
Percentage <- prop.table(Female_Invasive_count) * 100
prop_table_female <- data.frame(
  Culture = names(Female_Invasive_count),
  Frequency = as.vector(Female_Invasive_count),
  Percentage = as.vector(Percentage))
print(prop_table_female)
write.xlsx(prop_table_female, file = "/Users/mdibbasey/Documents/prop_table_female.xlsx")
write.xlsx(Female_Invasive_dataset, file = "/Users/mdibbasey/Documents/Female_Invasive_dataset.xlsx")




#seasonal variation in the microbial prevalence pattern
Invasive_dataset_cleaned_season <- read_excel("/Users/mdibbasey/Documents/Invasive_dataset_cleaned_season.xlsx")

Wet_season_Invasive_dataset <- filter(Invasive_dataset_cleaned_season, Seasonal %in% c("June", "July", "August", "September", "October"))
nrow(Wet_season_Invasive_dataset)
Dry_season_Invasive_dataset <- filter(Invasive_dataset_cleaned_season, Seasonal %in% c("November", "December", "January", "February", "March", "April", "May"))
nrow(Dry_season_Invasive_dataset)
#distribution accross the season (dry and wet season)
#dry season
Dry_season_Invasive_count <- table(Dry_season_Invasive_dataset$Culture)
Percentage <- prop.table(Dry_season_Invasive_count) * 100
prop_table_Dry_season <- data.frame(
  Culture = names(Dry_season_Invasive_count),
  Frequency = as.vector(Dry_season_Invasive_count),
  Percentage = as.vector(Percentage))
print(prop_table_Dry_season)
write.xlsx(prop_table_Dry_season, file = "/Users/mdibbasey/Documents/prop_table_Dry_season.xlsx")
#wet season
Wet_season_Invasive_count <- table(Wet_season_Invasive_dataset$Culture)
Percentage <- prop.table(Wet_season_Invasive_count) * 100
prop_table_Wet_season <- data.frame(
  Culture = names(Wet_season_Invasive_count),
  Frequency = as.vector(Wet_season_Invasive_count),
  Percentage = as.vector(Percentage))
print(prop_table_Wet_season)
write.xlsx(prop_table_Wet_season, file = "/Users/mdibbasey/Documents/prop_table_Wet_season.xlsx")

# #distribution pattern
heatmap_dataset <- read_excel("Documents/prop_table_Dry_Wet_season.xlsx", 
                               sheet = "Sheet2")
View(heatmap_dataset)
# Reshape the data into a wide format
#wide_data <- pivot_longer(heatmap_dataset, cols = everything(), names_from = Culture, values_to = Season)
heatmap_dataset <- heatmap_dataset %>%
  group_by(Season) %>%  
  mutate(proportion = (Frequency / sum(Frequency)) * 100) %>%
  ungroup()
View(heatmap_dataset)    
heatmap_dataset$Sqrt.proportion=sqrt(heatmap_dataset$proportion)


A <- ggplot(data = heatmap_dataset, 
            mapping = aes(x = Season, y = Culture, fill = Sqrt.proportion)) +
  geom_tile() +
  xlab(NULL) +
  ylab(NULL) +
  theme_classic() +
  scale_fill_gradient(
    name = "Sqrt.Frequency",
    low = "lightblue",
    high = "#012345"
  ) +
  theme(
    strip.placement = "outside",
    plot.title = element_text(hjust = 0.5, face = "bold"), 
    axis.title.y = element_text(face = "bold", size = 15),
    axis.title.x = element_text(face = "bold", size = 15), 
    axis.text.x = element_text(face = "bold", size = 12), 
    axis.text.y = element_text(face = "bold", size = 12),
    
    # 🔥 Remove axis lines and ticks
    axis.line = element_blank(),
    axis.ticks = element_blank()
  ) +
  ggtitle("C") +
  scale_y_discrete(limits = rev(levels(as.factor(heatmap_dataset$Culture))))

A

#barplot based on season (dry and wet season)
B <- ggplot(data = heatmap_dataset, mapping = aes(y = Culture, x = proportion, fill = Season)) +
  geom_col(position = "dodge")+
  theme_classic()+ ylab(NULL)+ scale_x_continuous(expand = c(0,0))+ xlab(label="proportion (%)")+
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"), 
    axis.title.y = element_text(face = "bold", size = 15),
    axis.title.x = element_text(face = "bold", size = 15), 
    axis.text.x = element_text(face = "bold", size = 12), 
    axis.text.y = element_text(face = "bold", size = 12)
    )+
  ggtitle(label = "B")
B
#barplots based on culture
C <- ggplot(data = heatmap_dataset, mapping = aes(x = Season, y = Frequency, fill = Culture)) +
  geom_col()+
  ggtitle(label = "A") + xlab(NULL)+ scale_y_continuous(expand = c(0,0))+ ylab("Frequency")+
  theme_classic()+
  theme(
    axis.title.y = element_text(face = "bold", size = 15),
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.title.x = element_text(face = "bold", size = 15), 
    axis.text.x = element_text(face = "bold", size = 12), 
    axis.text.y = element_text(face = "bold", size = 12)
    )
C

# combine the seasona plot
combined_plot <- (C+B)
combined_plot

#antimicrobial resistance pattern based on the bacterial isolates (heatmap) from invasive samples
#staph aureus
staph_AMR_dataset <- Invasive_dataset_cleaned_final[Invasive_dataset_cleaned_final$Culture=="Staph aureus",]
staph_AMR_dataset1 <- staph_AMR_dataset[,c(9, 10,12,14:17,19,22,27)]
#Strep Pneumo
Strep_Pneumo_AMR_dataset <- Invasive_dataset_cleaned_final[Invasive_dataset_cleaned_final$Culture=="Strep pneumoniae",]
Strep_Pneumo_AMR_dataset1 <- Strep_Pneumo_AMR_dataset[,c(9:11, 14:17,19,22,26,28,30,31)]
#Strep Pyogenes
Strep_Pyo_AMR_dataset <- Invasive_dataset_cleaned_final[Invasive_dataset_cleaned_final$Culture=="Strep pyogenes",]
Strep_Pyo_AMR_dataset1 <- Strep_Pyo_AMR_dataset[,c(9,10,11,14,16,17,22,30)]
#Strep group and strep species
Strep_grp_sp_AMR_dataset <- Invasive_dataset_cleaned_final[Invasive_dataset_cleaned_final$Culture==c("Streptococcus species","Streptococcus Group"),]
Strep_grp_sp_AMR_dataset1 <- Strep_grp_sp_AMR_dataset[,c(9,10,11,14,16,17,22, 27,28,30)]
#E.coli
Ecoli_AMR_dataset <- Invasive_dataset_cleaned_final[Invasive_dataset_cleaned_final$Culture=="Escherichia coli",]
Ecoli_AMR_dataset1 <- Ecoli_AMR_dataset[,c(9,11,14,15,16,17,19,21,27,28,29,31)]
#Klepsiella Pneumo
Klep_Pneumo_AMR_dataset <- Invasive_dataset_cleaned_final[Invasive_dataset_cleaned_final$Culture=="Klebsiella pneumoniae",]
Klep_Pneumo_AMR_dataset1 <- Klep_Pneumo_AMR_dataset[,c(9,11,14,15,16,17,19,21,27,28,29,31)]

# Reshape the dataset from wide to long format
#staph
staph_AMR_dataset1 <- staph_AMR_dataset1[-2,]
staph_AMR_dataset1 <- staph_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_staph_AMR_dataset <- staph_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Penicillin1"), starts_with("Cloxacillin1"),
      starts_with("Cotrimoxazole1"), starts_with("Gentamicin1"),
      starts_with("Chloramphenicol1"), starts_with("Tetracycline1"),
      starts_with("Ciprofloxacin1"), starts_with("Erythromycin1"),
      starts_with("Cefoxitin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )
long_staph_AMR_dataset <- long_staph_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

AMR_heatmap_staph <- ggplot(data = long_staph_AMR_dataset,aes(x = Antibiotic, y = factor(Culture, levels = unique(Culture)), fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors for Resistance (R), Susceptibility (S), and missing values (NA)
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "AMR Heatmap: Resistance and Susceptibility of Staph aureus Isolates",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"), # Rotate x-axis labels for readability
    axis.text.y = element_text(hjust=1, size = 3, face = "bold"), # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5) # Center-align the title
  )

# Print the heatmap
print(AMR_heatmap_staph)

#Strep pneumo
Strep_Pneumo_AMR_dataset1 <- Strep_Pneumo_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_streppneumo_AMR_dataset <- Strep_Pneumo_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Penicillin1"), starts_with("Ampicillin1"),
      starts_with("Cotrimoxazole1"), starts_with("Gentamicin1"),
      starts_with("Chloramphenicol1"), starts_with("Tetracycline1"),
      starts_with("Ciprofloxacin1"), starts_with("Erythromycin1"), starts_with("Oxacillin1"),
      starts_with("Cefotaxime1"), starts_with("Vancomycin1"), starts_with("Amoxicilin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )
long_streppneumo_AMR_dataset <- long_streppneumo_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

AMR_heatmap_streppneumo <- ggplot(data = long_streppneumo_AMR_dataset, aes(x = Antibiotic, 
                                                                           y = factor(Culture, levels = unique(Culture)), 
                                                                           fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors for Resistance (R), Susceptibility (S), and missing values (NA)
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "Resistance Pattern of Strep Pneumo Isolates",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1), # Rotate x-axis labels for readability
    axis.text.y = element_text(size = 6), # Adjust y-axis text size
    plot.title = element_text(hjust = 1) # Center-align the title
  )

# Print the heatmap
print(AMR_heatmap_streppneumo)

#Strep group
Strep_grp_sp_AMR_dataset1 <- Strep_grp_sp_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_strepgroup_AMR_dataset <- Strep_grp_sp_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Penicillin1"), starts_with("Cloxacillin1"),
      starts_with("Cotrimoxazole1"), starts_with("Gentamicin1"),
      starts_with("Chloramphenicol1"), starts_with("Tetracycline1"),
      starts_with("Ciprofloxacin1"), starts_with("Erythromycin1"),
      starts_with("Cefoxitin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )
long_strepgroup_AMR_dataset <- long_strepgroup_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

AMR_heatmap_Strepgroup <- ggplot(data = long_strepgroup_AMR_dataset, aes(x = Antibiotic, 
                                                                         y = factor(Culture, levels = unique(Culture)), 
                                                                         fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors for Resistance (R), Susceptibility (S), and missing values (NA)
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "AMR Heatmap: Resistance and Susceptibility of Staph aureus Isolates",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1), # Rotate x-axis labels for readability
    axis.text.y = element_text(size = 6), # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5) # Center-align the title
  )

# Print the heatmap
print(AMR_heatmap_Strepgroup)

#Strep pyo
Strep_Pyo_AMR_dataset1 <- Strep_Pyo_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_Streppyo_AMR_dataset <- Strep_Pyo_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Penicillin1"), starts_with("Ampicillin1"),
      starts_with("Cotrimoxazole1"), starts_with("Chloramphenicol1"), 
      starts_with("Tetracycline1"), starts_with("Erythromycin1"), starts_with("Vancomycin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )
long_Streppyo_AMR_dataset <- long_Streppyo_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

AMR_heatmap_Streppyo <- ggplot(data = long_Streppyo_AMR_dataset, aes(x = Antibiotic, 
                                                                     y = factor(Culture, levels = unique(Culture)), 
                                                                     fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors for Resistance (R), Susceptibility (S), and missing values (NA)
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "Resistance Pattern of Strep pyogenes Isolates",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"), # Rotate x-axis labels for readability
    axis.text.y = element_text(hjust=1, size = 8, face = "bold"), # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5) # Center-align the title
  )
# Print the heatmap
print(AMR_heatmap_Streppyo)


#E.coli
Ecoli_AMR_dataset1 <- Ecoli_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_Ecoli_AMR_dataset <- Ecoli_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Ampicillin1"),starts_with("Cefoxitin1"),
      starts_with("Cotrimoxazole1"), starts_with("Chloramphenicol1"), 
      starts_with("Tetracycline1"), starts_with("Gentamicin1"),
      starts_with("Ciprofloxacin1"), starts_with("Cefuroxime1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )
long_Ecoli_AMR_dataset <- long_Ecoli_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

AMR_heatmap_Ecoli <- ggplot(data = long_Ecoli_AMR_dataset, aes(x = Antibiotic, 
                                                               y = factor(Culture, levels = unique(Culture)), fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors for Resistance (R), Susceptibility (S), and missing values (NA)
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "Resistance Pattern of E.coli",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size= 8, face = "bold"), # Rotate x-axis labels for readability
    axis.text.y = element_text(hjust=1, size = 4), # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5) # Center-align the title
  )

# Print the heatmap
print(AMR_heatmap_Ecoli)

#Klep Pneumo
Klep_Pneumo_AMR_dataset1 <- Klep_Pneumo_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_Klep_AMR_dataset <- Klep_Pneumo_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Ampicillin1"),starts_with("Cefoxitin1"),
      starts_with("Cotrimoxazole1"), starts_with("Chloramphenicol1"), 
      starts_with("Tetracycline1"), starts_with("Gentamicin1"), starts_with("Ceftazidime1"),
      starts_with("Ciprofloxacin1"), starts_with("Amoxicilin1"), starts_with("Cefotaxime1"), starts_with("Cefuroxime1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )
long_Klep_AMR_dataset <- long_Klep_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

AMR_heatmap_Klep <- ggplot(data = long_Klep_AMR_dataset, aes(x = Antibiotic, 
                                                             y = factor(Culture, levels = unique(Culture)), fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors for Resistance (R), Susceptibility (S), and missing values (NA)
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "Resistance Pattern of Klep Pneumo",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"), # Rotate x-axis labels for readability
    axis.text.y = element_text(hjust=1, size = 6, face = "bold"), # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5) # Center-align the title
  )

# Print the heatmap
print(AMR_heatmap_Klep)

######Percentage of R and S in various bacterial isolates and antibiotics#######
# Remove rows with NA in the Resistance column
clean_staph_data <- na.omit(long_staph_AMR_dataset)

# Calculate percentages
library(dplyr)
staph_percentage <- clean_staph_data %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count / sum(Count) * 100)

# Plot percentages with labels
Bar_staph <- ggplot(staph_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Antibiotic Resistance Level in Invasive Staph aureus"
  ) +
  theme_minimal()+theme(axis.text.x = element_text(hjust = 1, angle = 45, face = "bold"))

# Display the plot
print(Bar_staph)

#####
#Strep pneumo
# Remove rows with NA in the Resistance column
clean_streppneumo_data <- na.omit(long_streppneumo_AMR_dataset)

# Calculate percentages
strep_percentage <- clean_streppneumo_data %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count / sum(Count) * 100)

# Plot percentages with labels
Bar_streppneumo <- ggplot(strep_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Strep Pneumo Resistance Level in Invasive Sample"
  ) +
  theme_classic()+theme(axis.text.x = element_text(hjust = 1, angle = 45, face = "bold"))

# Display the plot
Bar_streppneumo

###Strep Group########
# Remove rows with NA in the Resistance column
clean_strepgroup_data <- na.omit(long_strepgroup_AMR_dataset)

# Calculate percentages
#library(dplyr)
strepgroup_percentage <- clean_strepgroup_data %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count / sum(Count) * 100)

# Plot percentages with labels
Bar_strepgroup <- ggplot(strepgroup_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Antibiotic Resistance and Susceptibility in Strep Group"
  ) +
  theme_minimal()

# Display the plot
Bar_strepgroup

#Strep Pyo#####
# Remove rows with NA in the Resistance column
clean_streppyo_data <- na.omit(long_Streppyo_AMR_dataset)

# Calculate percentages
#library(dplyr)
streppyo_percentage <- clean_streppyo_data %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count / sum(Count) * 100)

# Plot percentages with labels
Bar_streppyo <- ggplot(streppyo_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Resistance Level in Strep Pyogenes"
  ) +
  theme_classic()+theme(axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"),
                        axis.text.y = element_text(face = "bold"))
Bar_streppyo


####E.coli#####
# Remove rows with NA in the Resistance column
clean_Ecoli_data <- na.omit(long_Ecoli_AMR_dataset)

# Calculate percentages
#library(dplyr)
Ecoli_percentage <- clean_Ecoli_data %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count / sum(Count) * 100)

# Plot percentages with labels
Bar_Ecoli <- ggplot(Ecoli_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Resistance Level of E.coli from Invasive Samples"
  ) +
  theme_classic()+ theme(axis.text.x = element_text(angle = 45, face = "bold", hjust = 1), axis.text.y = element_text(face = "bold"))
Bar_Ecoli

###Klep Pneumo########
# Remove rows with NA in the Resistance column
clean_Klep_data <- na.omit(long_Klep_AMR_dataset)

# Calculate percentages
Klep_percentage <- clean_Klep_data %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count / sum(Count) * 100)

# Plot percentages with labels
Bar_Klep <- ggplot(Klep_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Resistance Levels of Klepsiella Pneumo"
  ) +
  theme_classic()+theme(axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"),
                        axis.text.y = element_text(face = "bold"))
Bar_Klep


#bacteria isolates from individual invasive sample (i.e. blood, CSF and aspirate)
#blood 
Bacteraemia_dataset <- Invasive_dataset_cleaned_final %>% filter(SampleType %in% c("Blood"))
write.xlsx(Bacteraemia_dataset, file = "/Users/mdibbasey/Documents/Bacteraemia_dataset.xlsx")

#proportion of bacteria isolated from the blood samples
Bacteraemia_count <- table(Bacteraemia_dataset$Culture)
Percentage_Bacteraemia <- prop.table(Bacteraemia_count) * 100
prop_table_bacteraemia <- data.frame(
  Culture = names(Bacteraemia_count),
  Frequency = as.vector(Bacteraemia_count),
  Percentage = as.vector(Percentage_Bacteraemia))
prop_table_bacteraemia
write.xlsx(prop_table_bacteraemia, file = "/Users/mdibbasey/Documents/prop_table_bacteraemia.xlsx")

#antimicrobial resistance pattern from staph, strep pneumo, strep pyo, strep s/group, E.coli, klep, and salmonela in blood

#staph from blood
staph_bacteraemia_AMR_dataset <- Bacteraemia_dataset[Bacteraemia_dataset$Culture=="Staph aureus",]
staph_bacteraemia_AMR_dataset1 <- staph_bacteraemia_AMR_dataset[,c(9, 10,12,14:17,19,22,27)]
staph_bacteraemia_AMR_dataset1 <- staph_bacteraemia_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_staph_bacteraemia_AMR_dataset <- staph_bacteraemia_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Penicillin1"), starts_with("Cloxacillin1"),
      starts_with("Cotrimoxazole1"), starts_with("Gentamicin1"),
      starts_with("Chloramphenicol1"), starts_with("Tetracycline1"),
      starts_with("Ciprofloxacin1"), starts_with("Erythromycin1"),
      starts_with("Cefoxitin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )

long_staph_bacteraemia_AMR_dataset <- long_staph_bacteraemia_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

# Plot the heatmap
AMR_bacteraemia_heatmap_staph <- ggplot(data = long_staph_bacteraemia_AMR_dataset, 
                                           aes(x = Antibiotic, 
                                               y = factor(Culture, levels = unique(Culture)), 
                                               fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "AMR Heatmap: Resistance and Susceptibility of Staph Isolates",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"), # Rotate x-axis labels
    axis.text.y = element_text(size = 6),              # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5)             # Center-align the title
  )

# Print the heatmap
print(AMR_bacteraemia_heatmap_staph)

####Staph Barplot summary of heatmap
# Remove rows with NA in the Resistance column
clean_Staph_bacteraemia_data <- na.omit(long_staph_bacteraemia_AMR_dataset)

# Calculate percentages
staph_bacteraemia_percentage <- clean_Staph_bacteraemia_data  %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count / sum(Count) * 100)

# Plot percentages with labels
Bar_staph_bacteraemia <- ggplot(staph_bacteraemia_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Staph Antibiotic Resistance and Susceptibility in Blood"
  ) + theme_classic()+theme(axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"))
Bar_staph_bacteraemia

#strep pneumo from blood
strep_bacteraemia_AMR_dataset <- Bacteraemia_dataset[Bacteraemia_dataset$Culture=="Strep pneumoniae",]
strep_bacteraemia_AMR_dataset1 <- strep_bacteraemia_AMR_dataset[,c(9, 10,11,14,16,17,19,22,26,30,31)]
strep_bacteraemia_AMR_dataset1 <- strep_bacteraemia_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_strep_bacteraemia_AMR_dataset <- strep_bacteraemia_AMR_dataset1 %>%
  pivot_longer(
    cols = c(starts_with("Penicillin1"), starts_with("Ampicillin1"),
      starts_with("Cotrimoxazole1"), starts_with("Gentamicin1"),
      starts_with("Chloramphenicol1"), starts_with("Tetracycline1"),
      starts_with("Ciprofloxacin1"), starts_with("Erythromycin1"), starts_with("Oxacillin1"),
      starts_with("Cefotaxime1"), starts_with("Vancomycin1"), starts_with("Amoxicilin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )
long_strep_bacteraemia_AMR_dataset <- long_strep_bacteraemia_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

AMR_bacteraemia_heatmap_strep <- ggplot(data = long_strep_bacteraemia_AMR_dataset, 
                                           aes(x = Antibiotic, 
                                               y = factor(Culture, levels = unique(Culture)), 
                                               fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "Resistance pattern of Strep pneumo",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1), # Rotate x-axis labels
    axis.text.y = element_text(size = 8),              # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5)             # Center-align the title
  )
# Print the heatmap
print(AMR_bacteraemia_heatmap_strep)
####Strep pneumo Barplot summary of heatmap
# Remove rows with NA in the Resistance column
clean_Strep_bacteraemia_data <- na.omit(long_strep_bacteraemia_AMR_dataset)

# Calculate percentages
strep_bacteraemia_percentage <- clean_Strep_bacteraemia_data  %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count / sum(Count) * 100)

# Plot percentages with labels
Bar_strep_bacteraemia <- ggplot(strep_bacteraemia_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Resistance level of Strep pneumo"
  ) + theme_classic()+theme(axis.text.x = element_text(hjust = 1, angle = 45, face = "bold"))
Bar_strep_bacteraemia

#strep pyo from blood
streppyo_bacteraemia_AMR_dataset <- Bacteraemia_dataset[Bacteraemia_dataset$Culture=="Strep pyogenes",]
streppyo_bacteraemia_AMR_dataset1 <- streppyo_bacteraemia_AMR_dataset[,c(9, 10,11,14,16,17,22,30)]
streppyo_bacteraemia_AMR_dataset1 <- streppyo_bacteraemia_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_streppyo_bacteraemia_AMR_dataset <- streppyo_bacteraemia_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Penicillin1"), starts_with("Cloxacillin1"),
      starts_with("Cotrimoxazole1"), starts_with("Gentamicin1"),
      starts_with("Chloramphenicol1"), starts_with("Tetracycline1"), starts_with("Erythromycin1"),
      starts_with("Oxacillin1"), starts_with("Cefoxitin1"),
      starts_with("Ciprofloxacin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )

long_streppyo_bacteraemia_AMR_dataset <- long_streppyo_bacteraemia_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

# Plot the heatmap
AMR_bacteraemia_heatmap_streppyo <- ggplot(data = long_streppyo_bacteraemia_AMR_dataset, 
                                           aes(x = Antibiotic, 
                                               y = factor(Culture, levels = unique(Culture)), 
                                               fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "AMR Heatmap: Resistance and Susceptibility of Strep Pyogenes Isolates",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1), # Rotate x-axis labels
    axis.text.y = element_text(size = 8),              # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5)             # Center-align the title
  )

# Print the heatmap
print(AMR_bacteraemia_heatmap_streppyo)

####Streppyo Barplot summary of heatmap
# Remove rows with NA in the Resistance column
clean_Streppyo_bacteraemia_data <- na.omit(long_streppyo_bacteraemia_AMR_dataset)

# Calculate percentages
streppyo_bacteraemia_percentage <- clean_Streppyo_bacteraemia_data  %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count / sum(Count) * 100)

# Plot percentages with labels
Bar_streppyo_bacteraemia <- ggplot(streppyo_bacteraemia_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Strep Pyogenes Antibiotic Resistance and Susceptibility in Blood"
  ) + theme_minimal()
Bar_streppyo_bacteraemia


#strep sp/strep group
Strep_grp_sp_bacteraemia_AMR_dataset <- Bacteraemia_dataset[Bacteraemia_dataset$Culture==c("Streptococcus species","Streptococcus Group"),]
Strep_grp_sp_bacteraemia_AMR_dataset1 <- Strep_grp_sp_AMR_dataset[,c(9,10,11,14,16,17,22,30)]
Strep_grp_sp_bacteraemia_AMR_dataset1 <- Strep_grp_sp_bacteraemia_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_Strep_grp_sp_bacteraemia_AMR_dataset <- Strep_grp_sp_bacteraemia_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Penicillin1"), starts_with("Ampicillin1"), starts_with("Cotrimoxazole1"),
      starts_with("Chloramphenicol1"), starts_with("Tetracycline1"), starts_with("Erythromycin1"),
      starts_with("Vancomycin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )

long_Strep_grp_sp_bacteraemia_AMR_dataset <- long_Strep_grp_sp_bacteraemia_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

# Plot the heatmap
AMR_bacteraemia_heatmap_Strep_grp_sp <- ggplot(data = long_Strep_grp_sp_bacteraemia_AMR_dataset, 
                                           aes(x = Antibiotic, 
                                               y = factor(Culture, levels = unique(Culture)), 
                                               fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "AMR Heatmap: Resistance and Susceptibility of Strep Pyogenes Isolates",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1), # Rotate x-axis labels
    axis.text.y = element_text(size = 8),              # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5)             # Center-align the title
  )

# Print the heatmap
print(AMR_bacteraemia_heatmap_Strep_grp_sp)

####Streppyo Barplot summary of heatmap
# Remove rows with NA in the Resistance column
clean_Strep_grp_sp_bacteraemia_data <- na.omit(long_Strep_grp_sp_bacteraemia_AMR_dataset)

# Calculate percentages
Strep_grp_sp_bacteraemia_percentage <- clean_Strep_grp_sp_bacteraemia_data  %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count/sum(Count) * 100)

# Plot percentages with labels
Bar_Strep_grp_sp_bacteraemia <- ggplot(Strep_grp_sp_bacteraemia_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Strep Species Antibiotic Resistance and Susceptibility in Blood"
  ) + theme_minimal()
Bar_Strep_grp_sp_bacteraemia


#E.coli
E.coli_bacteraemia_AMR_dataset <- Bacteraemia_dataset[Bacteraemia_dataset$Culture=="Escherichia coli",]
E.coli_bacteraemia_AMR_dataset1 <- E.coli_bacteraemia_AMR_dataset[,c(9,11,14,15,16,17,19,27,28,29,31)]
E.coli_bacteraemia_AMR_dataset1 <- E.coli_bacteraemia_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_E.coli_bacteraemia_AMR_dataset <- E.coli_bacteraemia_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Ampicillin1"), starts_with("Cotrimoxazole1"),starts_with("Gentamycin1"),
      starts_with("Chloramphenicol1"), starts_with("Tetracycline1"), starts_with("Ciprofloxacin1"),
      starts_with("Cefoxitin1"), starts_with("Cefotaxime1"), starts_with("Ceftazidime1"), starts_with("Amoxicilin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )

long_E.coli_bacteraemia_AMR_dataset <- long_E.coli_bacteraemia_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

# Plot the heatmap
AMR_bacteraemia_heatmap_E.coli <- ggplot(data = long_E.coli_bacteraemia_AMR_dataset, 
                                               aes(x = Antibiotic, 
                                                   y = factor(Culture, levels = unique(Culture)), 
                                                   fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "Resistance Pattern of E.coli in Blood",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"), # Rotate x-axis labels
    axis.text.y = element_text(size = 4, face = "bold"),              # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5)             # Center-align the title
  )

# Print the heatmap
print(AMR_bacteraemia_heatmap_E.coli)

####E.coli Barplot summary of heatmap
# Remove rows with NA in the Resistance column
clean_E.coli_bacteraemia_data <- na.omit(long_E.coli_bacteraemia_AMR_dataset)

# Calculate percentages
E.coli_bacteraemia_percentage <- clean_E.coli_bacteraemia_data  %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count/sum(Count) * 100)

# Plot percentages with labels
Bar_E.coli_bacteraemia <- ggplot(E.coli_bacteraemia_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Resistance Level of E.coli in Blood"
  ) + theme_classic()+theme(axis.text.x = element_text(face = "bold", angle = 45, hjust = 1), axis.text.y = element_text(face = "bold"))
Bar_E.coli_bacteraemia

#Klep
Klep_bacteraemia_AMR_dataset <- Bacteraemia_dataset[Bacteraemia_dataset$Culture=="Klebsiella pneumoniae",]
Klep_bacteraemia_AMR_dataset1 <- Klep_bacteraemia_AMR_dataset[,c(9,11,14,15,16,17,19,27,28,29,31)]
Klep_bacteraemia_AMR_dataset1 <- Klep_bacteraemia_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_Klep_bacteraemia_AMR_dataset <- Klep_bacteraemia_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Ampicillin1"), starts_with("Cotrimoxazole1"),starts_with("Gentamicin1"),
      starts_with("Chloramphenicol1"), starts_with("Tetracycline1"), starts_with("Ciprofloxacin1"),
      starts_with("Cefoxitin1"), starts_with("Cefotaxime1"), starts_with("Ceftazidime1"), starts_with("Amoxicilin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )

long_Klep_bacteraemia_AMR_dataset <- long_Klep_bacteraemia_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

# Plot the heatmap
AMR_bacteraemia_heatmap_Klep <- ggplot(data = long_Klep_bacteraemia_AMR_dataset, 
                                         aes(x = Antibiotic, 
                                             y = factor(Culture, levels = unique(Culture)), 
                                             fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "Resistance Pattern of Klepsiella Pneumo in Blood",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"), # Rotate x-axis labels
    axis.text.y = element_text(size = 8, face = "bold"),              # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5)             # Center-align the title
  )

# Print the heatmap
print(AMR_bacteraemia_heatmap_Klep)

####Klep Barplot summary of heatmap
# Remove rows with NA in the Resistance column
clean_Klep_bacteraemia_data <- na.omit(long_Klep_bacteraemia_AMR_dataset)

# Calculate percentages
Klep_bacteraemia_percentage <- clean_Klep_bacteraemia_data  %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count/sum(Count) * 100)

# Plot percentages with labels
Bar_Klep_bacteraemia <- ggplot(Klep_bacteraemia_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Klepsiella Pneumo Resistance Level in Blood"
  ) + theme_classic()+theme(axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"),
                            axis.text.y = element_text(face = "bold"))
Bar_Klep_bacteraemia

#salmonela
Salmonella_bacteraemia_AMR_dataset <- Bacteraemia_dataset[Bacteraemia_dataset$Culture=="Salmonella species",]
Salmonella_bacteraemia_AMR_dataset1 <- Salmonella_bacteraemia_AMR_dataset[,c(9,11,14,15,16,17,19,27,28,29,31)]
Salmonella_bacteraemia_AMR_dataset1 <- Salmonella_bacteraemia_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_Salmonella_bacteraemia_AMR_dataset <- Salmonella_bacteraemia_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Ampicillin1"), starts_with("Cotrimoxazole1"),starts_with("Gentamycin1"),
      starts_with("Chloramphenicol1"), starts_with("Tetracycline1"), starts_with("Ciprofloxacin1"),
      starts_with("Cefoxitin1"), starts_with("Cefotaxime1"), starts_with("Ceftazidime1"), starts_with("Amoxicilin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )

long_Salmonella_bacteraemia_AMR_dataset <- long_Salmonella_bacteraemia_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

# Plot the heatmap
AMR_bacteraemia_heatmap_Salmonella <- ggplot(data = long_Salmonella_bacteraemia_AMR_dataset, 
                                       aes(x = Antibiotic, 
                                           y = factor(Culture, levels = unique(Culture)), 
                                           fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "Resistance Pattern of Salmonella Isolates",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"), # Rotate x-axis labels
    axis.text.y = element_text(size = 6, face = "bold"),              # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5)             # Center-align the title
  )

# Print the heatmap
AMR_bacteraemia_heatmap_Salmonella

####Streppyo Barplot summary of heatmap
# Remove rows with NA in the Resistance column
clean_Salmonella_bacteraemia_data <- na.omit(long_Salmonella_bacteraemia_AMR_dataset)

# Calculate percentages
Salmonella_bacteraemia_percentage <- clean_Salmonella_bacteraemia_data  %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count/sum(Count) * 100)

# Plot percentages with labels
Bar_Salmonella_bacteraemia <- ggplot(Salmonella_bacteraemia_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Salmonella Resistance Level in Blood"
  ) + theme_classic()+theme(axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"),
                            axis.text.y = element_text(face = "bold"))
Bar_Salmonella_bacteraemia



#methicillin resistance staph (cefoxitin) in the dataset
methicilin_resistant_staph <- staph_bacteraemia_AMR_dataset1[,c(1,10)]
methicilin_resistant_staph <- na.omit(methicilin_resistant_staph)
MRSA_count <- table(methicilin_resistant_staph$Cefoxitin1)
Percentage_MRSA <- prop.table(MRSA_count) * 100
prop_table_MRSA <- data.frame(
  Culture = names(MRSA_count),
  Frequency = as.vector(MRSA_count),
  Percentage = as.vector(Percentage_MRSA))
prop_table_MRSA
write.xlsx(prop_table_MRSA, file = "/Users/mdibbasey/Documents/prop_table_MRSA.xlsx")

#CSF
CSF_dataset <- Invasive_dataset_cleaned_final %>% filter(SampleType %in% c("CSF"))
write.xlsx(CSF_dataset, file = "/Users/mdibbasey/Documents/CSF_dataset.xlsx")
#proportion of bacteria isolated from the csf samples
Bacteria_count <- table(CSF_dataset$Culture)
Percentage_CSF <- prop.table(Bacteria_count)*100
prop_table_csf <- data.frame(
  Culture=names(Bacteria_count),
  Frequency=as.vector(Bacteria_count),
  Percentage=as.vector(Percentage_CSF))
#colnames(prop_table_csf) <- c("Culture", "Percentage")
print(prop_table_csf)
write.xlsx(prop_table_csf, file = "/Users/mdibbasey/Documents/prop_table_csf.xlsx")

#We cannot look into resistance pattern in only two isolates from E.coli and strep pneumo

#view(Invasive_dataset_cleaned_final)




############################ASPIRATES
Aspirate_dataset <- Invasive_dataset_cleaned_final %>% filter(SampleType %in% c("Aspirate"))
View(Aspirate_dataset)
write.xlsx(Aspirate_dataset, file = "/Users/mdibbasey/Documents/Aspirate_dataset.xlsx")
#proportion of bacteria isolated from the Aspirate samples
#Antimicrobial resistance pattern from Aspirate samples
#import the cleaned Aspirate sample

Cleaned_Aspirate_data <- read_excel("Documents/Aspirate_dataset_1.xlsx")

Bacteria_count <- table(Aspirate_dataset$Culture)
Percentage_Aspirate <- prop.table(Bacteria_count)*100
prop_table_aspirate <- data.frame(
  Culture=names(Bacteria_count),
  Frequency=as.vector(Bacteria_count),
  Percentage=as.vector(Percentage_Aspirate))
print(prop_table_aspirate)
write.xlsx(prop_table_aspirate, file = "/Users/mdibbasey/Documents/prop_table_aspirate.xlsx")

#antimicrobial resistance pattern of Strep pneumo, Klepsiella Pneumo, E.coli in invasive aspirate
#staph aureus
staph_Aspirate_AMR_dataset <- Aspirate_dataset[Aspirate_dataset$Culture=="Staph aureus",]
View(staph_Aspirate_AMR_dataset)
staph_Aspirate_AMR_dataset1 <- staph_Aspirate_AMR_dataset[,c(9, 10,12,14:17,19,22,27)]
staph_Aspirate_AMR_dataset1 <- staph_Aspirate_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))
View(staph_Aspirate_AMR_dataset1)


long_staph_Aspirate_AMR_dataset <- staph_Aspirate_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Ampicillin1"), starts_with("Cotrimoxazole1"),starts_with("Gentamycin1"),
      starts_with("Chloramphenicol1"), starts_with("Tetracycline1"), starts_with("Ciprofloxacin1"), starts_with("Cefuroxime1"),
      starts_with("Cefoxitin1"), starts_with("Cefotaxime1"), starts_with("Ceftazidime1"), starts_with("Amoxicilin1"), starts_with("Penicillin1"),
      starts_with("Gentamicin"), starts_with("Erythromycin1"), starts_with("Cloxacillin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )
View(long_staph_Aspirate_AMR_dataset)

long_staph_Aspirate_AMR_dataset <- long_staph_Aspirate_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))
View(long_staph_Aspirate_AMR_dataset)

# Plot the heatmap
AMR_Aspirate_heatmap_staph <- ggplot(data = long_staph_Aspirate_AMR_dataset, 
                                    aes(x = Antibiotic, 
                                        y = factor(Culture, levels = unique(Culture)), 
                                        fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "Resistance Pattern of staph in Aspirate",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"), # Rotate x-axis labels
    axis.text.y = element_text(size = 8, face = "bold"),              # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5)             # Center-align the title
  )

AMR_Aspirate_heatmap_staph

####staph in aspirate Barplot summary of heatmap
# Remove rows with NA in the Resistance column
clean_staph_Aspirate_data <- na.omit(long_staph_Aspirate_AMR_dataset)

# Calculate percentages
staph_Aspirate_percentage <- clean_staph_Aspirate_data  %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count/sum(Count) * 100)

# Plot percentages with labels
bar_staph_Aspirate <- ggplot(staph_Aspirate_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Resistance Level of Klep in Aspirates"
  ) + theme_classic()+theme(axis.text.x = element_text(angle = 45, hjust =1, face = "bold"),
                            axis.text.y = element_text(face = "bold"))
bar_staph_Aspirate


##########strep pyogenes#######################################################
pyo_Aspirate_AMR_dataset <- Aspirate_dataset[Aspirate_dataset$Culture=="Strep pyogenes",]
View(pyo_Aspirate_AMR_dataset)
pyo_Aspirate_AMR_dataset1 <- pyo_Aspirate_AMR_dataset[,c(9, 10,11,14,16,17,22,30)]
pyo_Aspirate_AMR_dataset1 <- pyo_Aspirate_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))
View(pyo_Aspirate_AMR_dataset1)


long_pyo_Aspirate_AMR_dataset <- pyo_Aspirate_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Ampicillin1"), starts_with("Cotrimoxazole1"),starts_with("Gentamycin1"),
      starts_with("Chloramphenicol1"), starts_with("Tetracycline1"), starts_with("Ciprofloxacin1"), starts_with("Cefuroxime1"),
      starts_with("Cefoxitin1"), starts_with("Vancomy"), starts_with("Ceftazidime1"), starts_with("Amoxicilin1"), starts_with("Penicillin1"),
      starts_with("Gentamicin"), starts_with("Erythromycin1"), starts_with("Cloxacillin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )
View(long_pyo_Aspirate_AMR_dataset)

long_pyo_Aspirate_AMR_dataset <- long_pyo_Aspirate_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))
View(long_pyo_Aspirate_AMR_dataset)

# Plot the heatmap
AMR_Aspirate_heatmap_pyo <- ggplot(data = long_pyo_Aspirate_AMR_dataset, 
                                     aes(x = Antibiotic, 
                                         y = factor(Culture, levels = unique(Culture)), 
                                         fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "Resistance Pattern of pyo in Aspirate",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"), # Rotate x-axis labels
    axis.text.y = element_text(size = 8, face = "bold"),              # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5)             # Center-align the title
  )

AMR_Aspirate_heatmap_pyo

####pyo in aspirate Barplot summary of heatmap
# Remove rows with NA in the Resistance column
clean_pyo_Aspirate_data <- na.omit(long_pyo_Aspirate_AMR_dataset)

# Calculate percentages
pyo_Aspirate_percentage <- clean_pyo_Aspirate_data  %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count/sum(Count) * 100)

# Plot percentages with labels
bar_pyo_Aspirate <- ggplot(pyo_Aspirate_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Resistance Level of pyo in Aspirates"
  ) + theme_classic()+theme(axis.text.x = element_text(angle = 45, hjust =1, face = "bold"),
                            axis.text.y = element_text(face = "bold"))
bar_pyo_Aspirate






#Klep in invasive aspirate
Klep_Aspirate_AMR_dataset <- Cleaned_Aspirate_data[Cleaned_Aspirate_data$Culture=="Klebsiella pneumoniae",]
Klep_Aspirate_AMR_dataset1 <- Klep_Aspirate_AMR_dataset[,c(9,11,12, 13,14,15,16,17,19,20,21,23)]
Klep_Aspirate_AMR_dataset1 <- Klep_Aspirate_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_Klep_Aspirate_AMR_dataset <- Klep_Aspirate_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Ampicillin1"), starts_with("Cotrimoxazole1"),starts_with("Gentamycin1"),
      starts_with("Chloramphenicol1"), starts_with("Tetracycline1"), starts_with("Ciprofloxacin1"), starts_with("Cefuroxime1"),
      starts_with("Cefoxitin1"), starts_with("Cefotaxime1"), starts_with("Ceftazidime1"), starts_with("Amoxicilin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )

long_Klep_Aspirate_AMR_dataset <- long_Klep_Aspirate_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

# Plot the heatmap
AMR_Aspirate_heatmap_Klep <- ggplot(data = long_Klep_Aspirate_AMR_dataset, 
                                       aes(x = Antibiotic, 
                                           y = factor(Culture, levels = unique(Culture)), 
                                           fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "Resistance Pattern of Klep Pneumo in Aspirate",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"), # Rotate x-axis labels
    axis.text.y = element_text(size = 8, face = "bold"),              # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5)             # Center-align the title
  )

# Print the heatmap
print(AMR_Aspirate_heatmap_Klep)

####klep in aspirate Barplot summary of heatmap
# Remove rows with NA in the Resistance column
clean_Klep_Aspirate_data <- na.omit(long_Klep_Aspirate_AMR_dataset)

# Calculate percentages
Klep_Aspirate_percentage <- clean_Klep_Aspirate_data  %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count/sum(Count) * 100)

# Plot percentages with labels
Bar_Klep_Aspirate <- ggplot(Klep_Aspirate_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Resistance Level of Klep in Aspirates"
  ) + theme_classic()+theme(axis.text.x = element_text(angle = 45, hjust =1, face = "bold"),
                            axis.text.y = element_text(face = "bold"))
Bar_Klep_Aspirate

###Strep Pneumo in Invasive aspirate sample
strep_Aspirate_AMR_dataset <- Cleaned_Aspirate_data[Cleaned_Aspirate_data$Culture=="Strep pneumoniae",]
strep_Aspirate_AMR_dataset1 <- strep_Aspirate_AMR_dataset[,c(9, 10,11,12,13,14,15,16,18,22)]
strep_Aspirate_AMR_dataset1 <- strep_Aspirate_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_strep_Aspirate_AMR_dataset <- strep_Aspirate_AMR_dataset1 %>%
  pivot_longer(
    cols = c(starts_with("Penicillin1"), starts_with("Ampicillin1"),
             starts_with("Cotrimoxazole1"), starts_with("Gentamicin1"),
             starts_with("Chloramphenicol1"), starts_with("Tetracycline1"),
             starts_with("Ciprofloxacin1"), starts_with("Erythromycin1"), starts_with("Vancomycin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )
long_strep_Aspirate_AMR_dataset <- long_strep_Aspirate_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

AMR_Aspirate_heatmap_strep <- ggplot(data = long_strep_Aspirate_AMR_dataset, 
                                        aes(x = Antibiotic, 
                                            y = factor(Culture, levels = unique(Culture)), 
                                            fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "Resistance pattern of Strep pneumo",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1), # Rotate x-axis labels
    axis.text.y = element_text(size = 8),              # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5)             # Center-align the title
  )
# Print the heatmap
print(AMR_Aspirate_heatmap_strep)
####Staph Barplot summary of heatmap
# Remove rows with NA in the Resistance column
clean_Strep_Aspirate_data <- na.omit(long_strep_Aspirate_AMR_dataset)

# Calculate percentages
strep_Aspirate_percentage <- clean_Strep_Aspirate_data  %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count / sum(Count) * 100)

# Plot percentages with labels
Bar_strep_Aspirate <- ggplot(strep_Aspirate_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Resistance Level of Strep Pneumo"
  ) + theme_classic()+ theme(axis.text.x = element_text(hjust = 1, angle = 45, face = "bold"))
Bar_strep_Aspirate

##E.coli in invasive aspirate
E.coli_Aspirate_AMR_dataset <- Cleaned_Aspirate_data[Cleaned_Aspirate_data$Culture=="Escherichia coli",]
E.coli_Aspirate_AMR_dataset1 <- E.coli_Aspirate_AMR_dataset[,c(9,11,14,15,16,19,20,21,23)]
E.coli_Aspirate_AMR_dataset1 <- E.coli_Aspirate_AMR_dataset1 %>%
  mutate(Culture = paste(Culture, row_number(), sep = "_"))

long_E.coli_Aspirate_AMR_dataset <- E.coli_Aspirate_AMR_dataset1 %>%
  pivot_longer(
    cols = c(
      starts_with("Ampicillin1"), starts_with("Cotrimoxazole1"),starts_with("Gentamycin1"),
      starts_with("Chloramphenicol1"), starts_with("Tetracycline1"), starts_with("Ciprofloxacin1"),
      starts_with("Cefoxitin1"), starts_with("Cefotaxime1"), starts_with("Ceftazidime1"), starts_with("Amoxicilin1")
    ),
    names_to = "Antibiotic",
    values_to = "Resistance"
  )

long_E.coli_Aspirate_AMR_dataset <- long_E.coli_Aspirate_AMR_dataset %>%
  tidyr::complete(Culture = unique(Culture), Antibiotic = unique(Antibiotic), fill = list(Resistance = NA))

# Plot the heatmap
AMR_Aspirate_heatmap_E.coli <- ggplot(data = long_E.coli_Aspirate_AMR_dataset, 
                                         aes(x = Antibiotic, 
                                             y = factor(Culture, levels = unique(Culture)), 
                                             fill = Resistance)) +
  geom_tile(color = "black") +  
  scale_fill_manual(
    values = c("R" = "red", "S" = "green", "NA" = "white"), # Define colors
    na.value = "white" # Handle missing data explicitly
  ) +
  labs(
    title = "Resistance Pattern of E.coli in Invasive Aspirates",
    x = "Antibiotics",
    y = "Isolate Number",
    fill = "Resistance Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"), # Rotate x-axis labels
    axis.text.y = element_text(size = 6, face = "bold"),              # Adjust y-axis text size
    plot.title = element_text(hjust = 0.5)             # Center-align the title
  )

# Print the heatmap
print(AMR_Aspirate_heatmap_E.coli)

####E.coli Barplot summary of heatmap
# Remove rows with NA in the Resistance column
clean_E.coli_Aspirate_data <- na.omit(long_E.coli_Aspirate_AMR_dataset)

# Calculate percentages
E.coli_Aspirate_percentage <- clean_E.coli_Aspirate_data  %>%
  group_by(Antibiotic, Resistance) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Antibiotic) %>%
  mutate(Percentage = Count/sum(Count) * 100)

# Plot percentages with labels
Bar_E.coli_Aspirate <- ggplot(E.coli_Aspirate_percentage, aes(x = Antibiotic, y = Percentage, fill = Resistance)) +
  geom_bar(stat = "identity", position = "stack") +  # Use "identity" for percentages
  geom_text(
    aes(label = sprintf("%.1f%%", Percentage)),  # Format percentage values
    position = position_stack(vjust = 0.5),      # Place text at the center of each bar segment
    color = "white",
    size = 3
  ) +
  labs(
    x = "Antibiotic",
    y = "% of Resistance",
    title = "Resistance Level of E.coli in Invasive Aspirate"
  ) + theme_classic()+theme(axis.text.x = element_text(angle = 45, face = "bold", hjust = 1),
                            axis.text.y = element_text(face = "bold"))
Bar_E.coli_Aspirate


##################### non-invasive samples ###################################
#Non_invasive_dataset <- microbiology_data %>% filter(SampleType %in% c("Sputum", "Stool", "Swab", "Urine"))
#Non_invasive_dataset <- Non_invasive_dataset[ , -c(6, 8, 10:14, 16:30)]
#write.xlsx(Non_invasive_dataset, file = "/Users/mdibbasey/Documents/Non_invasive_dataset.xlsx")




###logistic regression model to assess the association of bacteraemia with age, gender and seasonality
Logistic_model_data <- read_excel("Documents/Invasive_dataset_cleaned_season.xlsx")
# Logistic_model_data1 <- Logistic_model_data %>%
#   mutate(case_when(
#     Seasonal %in% c("June", "July", "August", "September", "October") ~ "Dry",
#     Seasonal %in% c("November", "December", "January", "February", "March", "April", "May") ~ "Wet",
#     TRUE ~ NA_character_ # Handle any unexpected or missing values
#   ), 
#   mutate(case_when(
#     Age %in% c[≥1]~ "Agegroup1",
#     Age %in% c[1-4]~ "Agegroup2",
#     Age %in% c[5-14]~ "Agegroup3",
#     Age %in% c[15-24] ~"Agegroup4_15_24",
#     Age %in% c[25-59]~ "Agegroup4_25_60",
#     Age %in% c[≥60]~ "Agegroup4_60")
#     ))
# Logistic_model_data1 <- Logistic_model_data1 %>%
#   rename(Season=`case_when(...)`)

Logistic_model_data1 <- Logistic_model_data %>%
  mutate(
    Seasonal = case_when(
      Seasonal %in% c("June", "July", "August", "September", "October") ~ "Dry",
      Seasonal %in% c("November", "December", "January", "February", "March", "April", "May") ~ "Wet",
      TRUE ~ NA_character_ # Handle any unexpected or missing values
    ),
    AgeGroup = case_when(
      Age >= 0 & Age < 5 ~ "Agegroup1_1_4",
      Age >= 5 & Age < 15 ~ "Agegroup2_5_14",
      Age >= 15 & Age < 25 ~ "Agegroup3_15_24",
      Age >= 25 & Age < 35 ~ "Agegroup4_25_34",
      Age >= 35 & Age < 45 ~ "Agegroup5_35_45",
      Age >= 45 & Age < 60 ~ "Agegroup6_45_60",
      Age >= 60 ~ "Agegroup7_60_plus",
      TRUE ~ NA_character_ # Handle any unexpected or missing values
    )
  )
  

#general regression for staph
# Step 1: Label "Staph aureus" as "Staph" and others as "Negative"
Staph_logistic_regression <- Logistic_model_data1 %>%
  mutate(Culture = case_when(
    Culture == "Staph aureus" ~ 1,
    TRUE ~ 0))

# # Step 2: Create a binary variable "Bacteria" where "Staph" = 1, others = 0
# Staph_logistic_regression <- Staph_logistic_regression %>%
#   mutate(Bacteria = case_when(
#     Culture == "Staph" ~ 1,
#     TRUE ~ 0
#   ))

# Step 3: Logistic regression model
model_staph <- glm(Culture ~ Seasonal+Age+Sex, 
             family = binomial(link = "logit"), 
             data = Staph_logistic_regression)

# Step 4: Summary of the model
summary(model_staph)


# Extract coefficients and compute Odds Ratios
coeffs <- summary(model_staph)$coefficients
ORs <- exp(coeffs[, 1])
CI_lower <- exp(coeffs[, 1] - 1.96 * coeffs[, 2])
CI_upper <- exp(coeffs[, 1] + 1.96 * coeffs[, 2])

# OR table
OR_table <- data.frame(
  Predictor = rownames(coeffs),
  Odds_Ratio = round(ORs, 2),
  CI_Lower = round(CI_lower, 2),
  CI_Upper = round(CI_upper, 2)
)

print(OR_table)

# Tabulated model summary
tab_model(model_staph)



#E.coli
E.coli_logistic_regression <- Logistic_model_data1 %>%
  mutate(Culture = case_when(
    Culture == "Escherichia coli" ~ 1,
    TRUE ~ 0))
#Logistic regression model
model_E.coli <- glm(Culture ~ AgeGroup, 
                   family = binomial(link = "logit"), 
                   data = E.coli_logistic_regression )

# Step 4: Summary of the model
summary(model_E.coli)

tab_model(model_E.coli)




#Strep pneumo
Streppneumo_logistic_regression <- Logistic_model_data1 %>%
  mutate(Culture = case_when(
    Culture == "Strep pneumoniae" ~ 1,
    TRUE ~ 0))
#Logistic regression model
model_Streppneumo <- glm(Culture ~ Seasonal+Age+Sex, 
                    family = binomial(link = "logit"), 
                    data = Streppneumo_logistic_regression)

# Step 4: Summary of the model
summary(model_Streppneumo)
tab_model(model_Streppneumo)


#strep pyogenes 
Strep_pyo_logistic_regression <- Logistic_model_data1 %>%
  mutate(Culture = case_when(
    Culture =="Strep pyogenes" ~ 1,
    TRUE ~ 0
  ))

# Step 2: Logistic regression model
model_pyo <- glm(Culture ~ Seasonal + Age + Sex, 
                   family = binomial(link = "logit"), 
                   data = Strep_pyo_logistic_regression)

# Step 3: Summary of the model
summary(model_pyo)
tab_model(model_pyo)

#klep pneumo
Klep_logistic_regression <- Logistic_model_data1 %>%
  mutate(Culture = case_when(
    Culture =="Klebsiella pneumoniae" ~ 1,
    TRUE ~ 0
  ))

# Step 2: Logistic regression model
model_klep <- glm(Culture ~ AgeGroup, 
                 family = binomial(link = "logit"), 
                 data = Klep_logistic_regression)

# Step 3: Summary of the model
summary(model_klep)
tab_model(model_klep)



#salmonella
Salmonella_logistic_regression <- Logistic_model_data1 %>%
  mutate(Culture = case_when(
    Culture %in% c("Salmonella enterica subsp. Enterica",  "Salmonella typhi") ~ 1,
    TRUE ~ 0
  ))

# Step 2: Logistic regression model
model_salmonella <- glm(Culture ~ AgeGroup, 
                  family = binomial(link = "logit"), 
                  data = Salmonella_logistic_regression)

# Step 3: Summary of the model
summary(model_salmonella)
tab_model(model_salmonella)

# model_salmonella1 <- glm(Culture ~ AgeGroup, 
#                         family = binomial(link = "logit"), 
#                         data = Salmonella_logistic_regression)
# 
# # Step 3: Summary of the model
# summary(model_salmonella1)


#bacteraemia odds from microbiological data- assessing the odds of bateraemia


####kalilu data
kalilu <- read_excel("Downloads/Kalilu_.xlsx", sheet = "Sheet1")
View(kalilu)



Bar_data <- ggplot(data = kalilu, 
                   mapping = aes(x = factor(Patients_ID, 
                                            levels = c("R052", "R005", "LIB-M23-647", 
                                                       "LIB-M22- 1049", "55-23", "LIB-M23-712", 
                                                       "R034_a", "LIB-M22- 1072", "LIB-M22- 1092")), 
                                 y = Frequency, fill = Viral_pathogens)) +
  geom_col() + 
  ggtitle(label = NULL) + 
  scale_y_continuous(expand = c(0, 0)) +
  xlab("Patients with single or multiple viral infection")+
  theme_classic() +
  theme(
    axis.title.y = element_text(face = "bold", size = 15),
    axis.title.x = element_text(face = "bold", size = 15), 
    axis.text.x = element_text(face = "bold", size = 12, angle = 90), 
    axis.text.y = element_text(face = "bold", size = 12)
  )

Bar_data

###making upset plot for antibiotics combinatorial resustance
resistance_data <- read_excel("Documents/Invasive_dataset_cleaned_final.xlsx", sheet = "Sheet1")
View(resistance_data)
install.packages("UpSetR")
library(UpSetR)

# Staph_upsetplot <- resistance_data %>% 
#   filter(Bacterial_pathogens=="Staph aureus")
# View(Staph_upsetplot)

# Filter for Staphylococcus aureus
Staph_data <- resistance_data %>%
  filter(Bacterial_pathogens == "Staph aureus")

# Keep only antibiotic resistance results (remove non-relevant columns)
Staph_binary <- Staph_data %>%
  dplyr::select(-c(Bacterial_pathogens, Amoxicilin, Ampicillin, Cloxacillin, Cefuroxime, Oxacillin, Cefotaxime, 
                   Ceftazidime, Vancomycin)) %>%
  mutate(across(everything(), ~ ifelse(. == "R", 1, 0))) %>% 
  drop_na()
View(Staph_binary)
# Ensure the result is a data frame

Staph_binary <- as.data.frame(Staph_binary)
View(Staph_binary)
# upset(Staph_binary, sets = colnames(Staph_binary), order.by = "freq")
# 
# upset(Staph_binary,
#       sets = colnames(Staph_binary),
#       order.by = "freq",
#       keep.order = TRUE,
#       sets.bar.color = "#2E86AB",         # Blue for set bars
#       main.bar.color = "blue",         # Red for intersection bars
#       text.scale = 3,
#       text="bold")


# Create plot
ComplexUpset::upset(Staph_binary,
                    intersect = colnames(Staph_binary),
                    name = "Antibiotic Resistance Staph aureus",
                    n_intersections=10,
                    min_size=1,
                    base_annotations = list(
                      'Intersection size' = intersection_size(
                        text = list(size = 4, face = "bold"),
                        fill= "#2E86AB", 
                        bar_number_threshold = 33)+
                        theme(panel.grid = element_blank())+
                        ylab("Antibiotic combinations Resistance")+
                        theme(axis.title.y = element_text(face = "bold", size = 15))
                      ),
                    themes = upset_modify_themes(list(
                      'intersect_size' = theme(
                        axis.text.x = element_blank(),
                        axis.ticks.x = element_blank(),
                        panel.grid = element_blank(),
                        plot.margin = margin(0, 0, 0, 0),
                      ),
                      'intersections_matrix' = theme(text = element_text(face = "bold", size = 15)),
                      'overall_sizes' = theme(
                        axis.text.y = element_blank(),
                        axis.ticks.y = element_blank(),
                        panel.grid = element_blank(),
                        plot.margin = margin(0, 0, 0, 0)
                      )
                      ))
                    )


#########Strep species
# Filter for Strep species
Strep_data <- resistance_data %>%
  filter(Bacterial_pathogens %in% c("Strep pneumoniae", "Strep pyogenes"))
View(Strep_data)
# Keep only antibiotic resistance results (remove non-relevant columns)
Strep_binary_data <- Strep_data %>%
  dplyr::select(-c(Bacterial_pathogens, Penicillin, Ampicillin, Cloxacillin, Gentamicin, Ciprofloxacin, Cefoxitin, Cefuroxime, Oxacillin, Cefotaxime, 
                   Ceftazidime, Amoxicilin)) %>%
  mutate(across(everything(), ~ ifelse(. == "R", 1, 0))) %>% 
  drop_na()
# Ensure the result is a data frame

Strep_binary_data <- as.data.frame(Strep_binary_data)
View(Strep_binary_data)

# Create plot
# Create plot
ComplexUpset::upset(Strep_binary_data,
                    intersect = colnames(Strep_binary_data),
                    name = "Antibiotic Resistance Strep species",
                    n_intersections=10,
                    min_size=1,
                    base_annotations = list(
                      'Intersection size' = intersection_size(
                        text = list(size = 4, face = "bold"),
                        fill= "#2E86AB", 
                        bar_number_threshold = 33)+
                        theme(panel.grid = element_blank())+
                        ylab("Antibiotic Resistance Combinations")+
                        theme(axis.title.y = element_text(face = "bold", size = 15))
                    ),
                    themes = upset_modify_themes(list(
                      'intersect_size' = theme(
                        axis.text.x = element_blank(),
                        axis.ticks.x = element_blank(),
                        panel.grid = element_blank(),
                        plot.margin = margin(0, 0, 0, 0),
                      ),
                      'intersections_matrix' = theme(text = element_text(face = "bold", size = 15)),
                      'overall_sizes' = theme(
                        axis.text.y = element_blank(),
                        axis.ticks.y = element_blank(),
                        panel.grid = element_blank(),
                        plot.margin = margin(0, 0, 0, 0)
                      )
                    ))
)






# ##Escherichia coli
# # Filter for E coli
# Ecoli_data <- resistance_data %>%
#   filter(Bacterial_pathogens == "Escherichia coli")
# View(Ecoli_data)
# # Keep only antibiotic resistance results (remove non-relevant columns)
# Ecoli_binary <- Ecoli_data %>%
#   dplyr::select(-c(Bacterial_pathogens, Penicillin, Cloxacillin, Cefuroxime, Erythromycin, Oxacillin, Vancomycin)) %>%
#   mutate(across(everything(), ~ ifelse(. == "R", 1, 0))) %>% 
#   drop_na()
# View(Ecoli_binary)
# # Ensure the result is a data frame
# 
# Ecoli_binary <- as.data.frame(Ecoli_binary)
# View(Ecoli_binary)
# 
# # Create plot
# ComplexUpset::upset(Ecoli_binary,
#                     intersect = colnames(Ecoli_binary),
#                     name = "Antibiotic Resistance E coli",
#                     base_annotations = list(
#                       'Intersection size' = intersection_size(
#                         text = list(size = 4, face = "bold"),
#                         fill= "#2E86AB",bar_number_threshold = 33)
#                       +theme(panel.grid (x=NULL, y=NULL))
#                       ),
#                     themes = upset_modify_themes(list(
#                       'intersect_size' = theme(axis.text = element_blank(),
#                       'overall_sizes' = theme(axis.text = element_blank(),
#                                               axis.text.y =element_blank())))))
#   
##Klepsiella pneumoniae
Klep_data <- resistance_data %>%
  filter(Bacterial_pathogens %in% c("Klebsiella pneumoniae", "Escherichia coli", "Salmonella enterica subsp. Enterica",
                                    "Salmonella typi", "Salmonella Enteritidis"))
View(Klep_data)
# Keep only antibiotic resistance results (remove non-relevant columns)
Klep_binary <- Klep_data %>%
  dplyr::select(-c(Bacterial_pathogens, Penicillin, Cloxacillin, Cefuroxime, Erythromycin, Oxacillin, Vancomycin)) %>%
  mutate(across(everything(), ~ ifelse(. == "R", 1, 0))) %>% 
  drop_na()
View(Klep_binary)
# Ensure the result is a data frame

Klep_binary <- as.data.frame(Klep_binary)
View(Klep_binary)

# Create plot
ComplexUpset::upset(Klep_binary,
                    intersect = colnames(Klep_binary),
                    name = "Gram Negative Organisms",
                    n_intersections=10,
                    min_size=1,
                    base_annotations = list(
                      'Intersection size' = intersection_size(
                        text = list(size = 4, face = "bold"),
                        fill= "#2E86AB", 
                        bar_number_threshold = 33)+
                        theme(panel.grid = element_blank())+
                        ylab("Antibiotic Resistance Combinations")+
                        theme(axis.title.y = element_text(face = "bold", size = 15))
                    ),
                    themes = upset_modify_themes(list(
                      'intersect_size' = theme(
                        axis.text.x = element_blank(),
                        axis.ticks.x = element_blank(),
                        panel.grid = element_blank(),
                        plot.margin = margin(0, 0, 0, 0),
                      ),
                      'intersections_matrix' = theme(text = element_text(face = "bold", size = 15)),
                      'overall_sizes' = theme(
                        axis.text.y = element_blank(),
                        axis.ticks.y = element_blank(),
                        panel.grid = element_blank(),
                        plot.margin = margin(0, 0, 0, 0)
                      )
                    ))
)



## Salmonella species
Ecoli_data <- resistance_data %>%
  filter(Bacterial_pathogens == "Escherichia coli")
View(Ecoli_data)
# Keep only antibiotic resistance results (remove non-relevant columns)
Ecoli_binary <- Ecoli_data %>%
  dplyr::select(-c(Bacterial_pathogens, Penicillin, Cloxacillin, Cefuroxime, Erythromycin, Oxacillin, Vancomycin)) %>%
  mutate(across(everything(), ~ ifelse(. == "R", 1, 0))) %>% 
  drop_na()
View(Ecoli_binary)
# Ensure the result is a data frame

Ecoli_binary <- as.data.frame(Ecoli_binary)
View(Ecoli_binary)

# Create plot
ComplexUpset::upset(Ecoli_binary,
                    intersect = colnames(Ecoli_binary),
                    name = "Antibiotic Resistance E coli",
                    base_annotations = list(
                      'Intersection size' = intersection_size(
                        text = list(size = 4, face = "bold"),
                        fill= "#2E86AB",bar_number_threshold = 33)
                      +theme(panel.grid (x=NULL, y=NULL))
                    ),
                    themes = upset_modify_themes(list(
                      'intersect_size' = theme(axis.text = element_blank(),
                                               'overall_sizes' = theme(axis.text = element_blank(),
                                                                       axis.text.y =element_blank())))))


##Gram positive and Gram Negative###############################################

# Filter for Staphylococcus aureus
Gram_positive_data <- resistance_data %>%
  filter(Bacterial_pathogens %in% c("Staph aureus", "Strep pneumoniae", "Strep pyogenes", "Strep agalactiae"))
View(Gram_positive_data)
# Keep only antibiotic resistance results (remove non-relevant columns)
Gram_positive_binary_data <- Gram_positive_data %>%
  dplyr::select(-c(Bacterial_pathogens, Ampicillin, Cloxacillin, Cefuroxime, Oxacillin, Cefotaxime, 
                   Ceftazidime, Amoxicilin)) %>%
  mutate(across(everything(), ~ ifelse(. == "R", 1, 0))) %>% 
  drop_na()
# Ensure the result is a data frame

Gram_positive_binary_data <- as.data.frame(Gram_positive_binary_data)
View(Gram_positive_binary_data)

# Create plot
ComplexUpset::upset(Gram_positive_binary_data,
                    intersect = colnames(Gram_positive_binary_data),
                    name = "Antibiotic Resistance Gram Positives",
                    base_annotations = list(
                      'Intersection size' = intersection_size(
                        text = list(size = 4, face = "bold"),
                        fill= "#2E86AB", 
                        bar_number_threshold = 33)),
                    themes = upset_modify_themes(list(
                      'intersect_size' = theme(axis.text = element_text(size = 12, face = "bold")),
                      'overall_sizes' = theme(axis.text = element_text(size = 12, face = "bold"),
                                              axis.text.y =element_text(size = 12, face = "bold")))))+
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title.x = element_text(face = "bold", size = 12),
    axis.text.y = element_text(face = "bold", size = 12)
  )
