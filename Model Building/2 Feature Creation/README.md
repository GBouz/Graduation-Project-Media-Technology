### Feature Creation

All the csv drawings for a given user, produced by the previous step, are used to make a total of 916 features. The product of this step is a new csv file for each user, in which every row represents a drawing, and every column represents a feature.

Some of the features come out of the x,y,z distributions of points of a given file, and some others come from calculations between some Points of Interest. These PoIs are points on the lock shape that are important to our perception (for example the two points in the 'neck' of the lock, the corners, etc.), and they are extracted in a way tailored to our case.

#### Best Ratio Features Selection

In addition to creating features, and because there is a group of features (the ratios between all the distances of the PoIs) that is very high dimensional (756 features), a feature selection of the 60 best is made. The way the selection is performed here, is by utilizing the feature importances feature of Random Forest in the context of multi class classification for the 16 participants. The goal of the selection notebook is to produce a csv with the names of the 60 ratio features (30 temporal distance ratios and 30 euclidean distance ratios between the PoIs) that are deemed the most important for classifying between the 16 participants.