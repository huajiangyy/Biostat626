## Binary Classification
To train binary model which the following script:
```
Rscript training_binary.R
```

I compared two models for the binary classification: logisitic regression and neural network. The performance of the validation dataset is geven by:
```
           model valid_accuracy
1       Logistic              1
2 Neural Network              1
```

Both models give 100% validation accuracy. However, in the leaderboard Neural Network scored 0.561 and Logistic regression 1.000. This shows that the performance of the model on different validation sets could be significantly different. 


## Multiclass Classification
To train binary model which the following script:
```
Rscript training_multi.R
```
I compared two models for the multiclass classification: LDA and Random Forest. The performance of the validation dataset is geven by:
```
         model valid_accuracy
1           LDA      0.9761905
2 Random Forest      0.9774775
```
From this result, LDA has slightly worse performance. In the leaderboard, LDA scored 0.961 and Random Forest scored 0.931. Similar to the previous case, the leaderboard score and validation score are different. However, the gap is not as large as in the previous case. 
