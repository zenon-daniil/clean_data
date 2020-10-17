CodeBook

Variables description

In the final "Tidy.txt" dataset the following variables are present:  
- ActivityID - type of activity  
- Subject ID - experiment subject ID   
- Other variables, which present information on:  
    - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.  
    - Triaxial Angular velocity from the gyroscope.  
    - A 561-feature vector with time and frequency domain variables.  

Datasets description

The main datasets are the dollowing:  
- data_mean_std - merged dataset with both training and test data with all the needed variables  
- data_mean_std_1 - merged dataset with both training and test data with all the needed variables with descriptive activity names within ActivityID variable  
- data_tidy - the final dataset with merged training and test data with all the needed variables with descriptive activity names within ActivityID variable with aggregated average of each variable for each activity and each subject.

The following script contains all the data cleaning and needed transformations as well as "Tidy" database compostion
