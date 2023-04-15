library('tidyverse')

# load dataset
training_data <- read.table("training_data.txt", quote="\"", comment.char="",
                            header=T) %>%
  tibble() %>%
  dplyr::select(-subject)


# generate binary labels
multi_train <- training_data %>%
  mutate(target = ifelse(activity <= 6, activity, 7) %>% as.factor()) %>%
  dplyr::select(-activity)

# check distribution of labels
table(multi_train$target)

# split data into train and test
set.seed(123)
indx <- sample(nrow(multi_train), 0.8*nrow(multi_train))
train <- multi_train[indx,]
valid <- multi_train[-indx,]


# fit LDA model
lda.fit <- MASS::lda(target ~ . ,data=train)
lda.class <- predict(lda.fit, valid)$class
lda_valid_acc <- mean(lda.class == valid$target)

# fit random forest model
rf.fit <- randomForest::randomForest(target ~ . ,data=train, ntree=100, do.trace=1)
rf.class <- predict(rf.fit, valid)
rf_valid_acc <- mean(rf.class == valid$target)

data.frame(model = c('LDA', 'Random Forest'),
           valid_accuracy=c(lda_valid_acc, rf_valid_acc))


# diagonal elements are correct prediction and off diagonal are mistakes
# in this case, it seems the model make mistake between class 5 and 4 as their
# off-diagonal values are larger than other classes
data.frame(pred  = rf.class, actual = valid$target) %>%
  count(pred, actual) %>%
  complete(pred, actual, fill=list(n=0)) %>%
  ggplot(aes(x=pred, y=actual, fill=n)) + geom_tile() + 
  geom_text(aes(label=n)) + 
  ggtitle('Random Forest')
#


data.frame(pred  = lda.class, actual = valid$target) %>%
  count(pred, actual) %>%
  complete(pred, actual, fill=list(n=0)) %>%
  ggplot(aes(x=pred, y=actual, fill=n)) + geom_tile() + 
  geom_text(aes(label=n)) + 
  ggtitle('LDA')
