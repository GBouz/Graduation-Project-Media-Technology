### Model Development

To train and evaluate models of each participant for the purposes of the project, first the best parameters for each models are identified, then two different kinds of models, an one-class SVM and an Isolation Forest are trained and evaluated for each participant and with different sets of features. Afterwards, a convergence rate analysis was performed for each algorithm.

#### Parameter Tuning

For the sake of tuning the parameters of the two models a Grid Search was performed (first a coarse search and then a finer one) in the Parameter Tuning notebook. Potentially the parameters could be tuned specifically for each group of features or each participant and that would probably give the best results. However, given how time consuming that is, the optimal parameters were found across all participants, and across many sets of features. The parameters that were tuned for one-class SVM and Isolation Forest were dropped in a csv to be used by the classification notebook.

It was also found out by experimenting that tuning specifically for a person did not matter but tuning for a specific group of features did matter. In fact the 0.988 AUC that is reported as the best score is achieved with tailored tuning, while the generally tuned previous parameters were only slightly less good (0.986). It is also worth mentioning that this notebook does not use AUC as metric for tuning, but the FPR and FNR. This is becuase of some early experimenting. It was not corrected because it works fine, and because there were some models that were already built with those parameters, and it would be very time consuming to run them again despite the fact that the AUC code was not hard to produce.

#### Classification

The classification notebook finds the AUC score for the mean ROC curve across all participants, as well as the respective EER, in a selected set of features that is specified in the beginning. The convergence rate for the 4 best and the 4 worst participants is also plotted for exploration purposes.

#### Convergence Rate

The convergence rate uses two notebooks, one to produce the AUC trajectories with different sized training groups and run some experiments, and the other one to plot it. The experiments besides AUC are also testing the FP and FN Rates from the predict() function of the sklearn API, that has a default and fix threshold.