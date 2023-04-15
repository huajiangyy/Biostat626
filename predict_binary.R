library('tidyverse')

# load dataset
training_data <- read.table("training_data.txt", quote="\"", comment.char="",
                            header=T) %>%
  tibble() %>%
  dplyr::select(-subject)

test_data <- read.table("test_data.txt", quote="\"", comment.char="", header=T) %>%
  tibble()

# generate binary labels
binary_train <- training_data %>%
  mutate(target = 1*(activity %in% c(1, 2, 3))) %>%
  dplyr::select(-activity)

fit_binary = glm(target ~ . ,data=binary_train,family=binomial() )

# make prediction for test data
y_test_binary <- predict(fit_binary, 
                         newdata = test_data %>% dplyr::select(-subject)) > 0.5
test_data %>%
  dplyr::select(subject) %>%
  mutate( prediction=1*y_test_binary) %>%
  write.csv('test_binary_prediction.csv', row.names = F)