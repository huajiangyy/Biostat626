library('tidyverse')
library('neuralnet')
library('pROC')


# load dataset
training_data <- read.table("training_data.txt", quote="\"", comment.char="",
                            header=T) %>%
  tibble() %>%
  dplyr::select(-subject)


# generate binary labels
binary_train <- training_data %>%
  mutate(target = 1*(activity %in% c(1, 2, 3))) %>%
  dplyr::select(-activity)

# check distribution of labels
table(binary_train$target)

# split data into train and test
set.seed(13)
indx <- sample(nrow(binary_train), 0.8*nrow(binary_train))
train <- binary_train[indx,]
valid <- binary_train[-indx,]

# fit a logistic regression model
fit_binary <- glm(target ~ . ,data=train,family=binomial() )

# make prediction for test data
y_prob_glm <- predict(fit_binary, newdata = valid, type='response') 
y_pred_glm <- y_prob_glm > 0.5
glm_valid_acc <- mean(y_pred_glm == valid$target)

# fit a NN
nn_fit_binary = neuralnet(target ~ . ,
                          data=binary_train,
                          hidden = 3,
                          act.fct = "logistic", startweights=rep(0.1,29),
                          linear.output=F)

y_prob_nn <- predict(nn_fit_binary, newdata = valid)
y_pred_nn <- y_prob_nn > 0.5
nn_valid_acc <- mean(y_pred_nn == valid$target)


data.frame(model = c('Logistic', 'Neural Network'),
           valid_accuracy=c(glm_valid_acc, nn_valid_acc)) 



roc_nn <- roc(factor( valid$target), y_prob_nn)
roc_glm <- roc(factor( valid$target), y_prob_glm)

plot(roc_glm, main='Logistic')
plot(roc_nn, main='Neural Network')

