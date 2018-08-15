## Graduation Project

This repo holds a Data Collection app, and the code for some subsequent Machine Learning models that were developed for a graduation project for Media Technology M. Sc. The purpose of the models, was to recognize if the drawings were from the same person, while all users were requested to draw the same symbol.

![The lock symbol that was drawn in the air by all participants](images/Lock_image.png)

### Data Collection Application

The Data Collection application was used to collect air drawings of the lock symbol above. The drawings were made by the fingertip of each participant while standing in front of a Kinect v2. The application works by keeping track of the closest point in front of the camera and it is designed to host an interactive session with a user in the sense of giving feedback for when the recording would star or stop.

![A plot of a lock instance collected with the application, with some Points of Interest identified that were used for features later](images/Lock_plot.png)

### Model Building

The models were built for each user after some pre-processing of the raw data and the construction of some higher level features. In total, there were 16 participants, and from each one of them 60 drawings were used. Also, there were two algorithms that have been tested: one-class SVM and Isolation Forest. In addition to the performance of the two algorithms across the 16 participants, different sets of features were evaluated, and the convergence rate of each algorithm was found. 

The best performing algorithm seemed to be one-class SVM across all participants and feature sets, with little differene than Isolation Forest. As far as the performance of the verification task, with the best set of features, one-class SVM had an AUC score of 0.988 which results in 4% EER (across all participants). That result is comparable with approaches in other Behavioral Biometrics, such as the 2D signature or mouse and keyboard dynamics.

![The 16 ROC curves of one-class SVM models trained with the best performing set of features, and the mean curve in blue](images/OCSVM_group24_tailor_tuned.png)