library('tidyverse')

# load dataset
training_data <- read.table("training_data.txt", quote="\"", comment.char="",
                            header=T) %>%
  tibble() %>%
  dplyr::select(-subject)

test_data <- read.table("test_data.txt", quote="\"", comment.char="", header=T) %>%
  tibble()


multi_train <- training_data %>%
  mutate(target = ifelse(activity <= 6, activity, 7) %>% as.factor()) %>%
  dplyr::select(-activity)


lda.fit <- MASS::lda(target ~ . ,data=multi_train)

# make prediction for test data
y_test_multi <- predict(lda.fit, 
                        newdata = test_data %>% dplyr::select(-subject))$class
test_data %>%
  dplyr::select(subject) %>%
  mutate( prediction=y_test_multi) %>%
  write.csv('test_multi_prediction.csv', row.names = F)
