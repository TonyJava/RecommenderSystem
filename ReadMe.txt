----------------------
ReadMe
----------------------

Contents:
---------
The contents of the folder are organized in the following way:

JatinMistry_Assign3
|
|----- ReadMe.txt (This file !)
|
|----- PseudoCode.txt (PseudoCode for all the Mappers and Reducers attached)
|
|----- Src (The actual Source Code for mappers and reducers)
|      |
|      |----- GlobalAvgReduce.py 	(Step 1 : Mappers and reducers to compute global average rating given)
|      |----- GlobalAvgMap.py
|      |
|      |----- UserAvgReduce.py 		(Step2 : Mappers and reducers to compute each user's average rating)
|      |----- UserAvgMap.py
|      |
|      |----- MovieAvgReduce.py 	(Step 3 : Mappers and reducers to compute each movie's average rating)
|      |----- MovieAvgMap.py
|      |
|      |----- MovieRecoReduce1.py 	(Step 4 : Mapper and reducer to compute the initial UV matrix)
|      |----- MovieRecoMap1.py
|      |
|      |----- MovieRecoReduce2.py 	(Step 5 : Mapper and reducer to update the previous UV Matrix)
|      |----- MovieRecoMap2.py
|      |
|      |----- RMSE_Reduce1.py 		(Step 6 : Mapper and reducer to compute the RMSE of the last UV Matrix after all the updation of matrices is done)
|      |----- RMSE_Map1.py
|
|
|----- Scripts (Scripts file that were used to run the mapreduce jobs)
|      |
|      |----- test_loop.sh 	(Loop tester)
|      |----- run3.sh 		(Analysis for MOVIELENS 1M dataset)
|      |----- run4.sh 		(Analysis for one of the training files in MOVIELENS 10M dataset)
|      |----- run10M_5Fold.sh 	(For 5 fold cross-validation)
|      |----- run10M_1Fold.sh 	(Just 1 execution of the 5 fold cross-validation)
|
|
|----- Outputs (sample outputs for U,V Matrices, calculated RMSE and Cross-Validation Results)
|      |
|      |----- VMat_Iter0(Initial).txt (The sample output for V matrix; Iter0 indicates initial computed V matrix, Iter5 indicates V matrix at the end of 
|      |----- VMat_Iter5.txt           5th iteration; Iter10 indicates V matrix after 10th iteration on which the RMSE is calculated)
|      |----- VMat_Iter10.txt
|      |
|      |----- UMat_Iter0(Initial).txt (The sample output for U matrix; Iter0 indicates initial computed U matrix, Iter5 indicates U matrix at the end of 
|      |----- UMat_Iter5.txt           5th iteration; Iter10 indicates U matrix after 10th iteration on which the RMSE is calculated)
|      |----- UMat_Iter10.txt
|      |
|      |----- RMSE.txt 	(RMSE calculated for the above U and V matrix. The RMSE is calculted for the Iter10 of U and V matrix)
|      |
|      |----- CrossValidation-Results.txt (This file shows the result of the cross-valdation for r1-r5 train and test data)

