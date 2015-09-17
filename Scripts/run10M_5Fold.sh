#! /bin/bash

BASE_FOLDER="/home/jmistry2/Assign3"
BASE_FOLDER_OUTPUT=$BASE_FOLDER"/output/"
DATASET_MAIN_FILE1="/home/dbarbara/MOVIELENS/ml-1m/ratings.dat"
DATASET_MAIN_FILE2="/home/dbarbara/MOVIELENS/ml-1m/movies.dat"
STREAMING_JAR="/apps/hadoop-2/share/hadoop/tools/lib/hadoop-streaming-2.4.1.jar"
HADOOP_USER_INPUT="/user/jmistry2/input/"
HADOOP_USER_OUTPUT="/user/jmistry2/output/"
INPUT1=$HADOOP_USER_INPUT"ratings.dat"
OUTPUT1=$HADOOP_USER_OUTPUT"output1"
OUTPUT2=$HADOOP_USER_OUTPUT"output2"
OUTPUT3=$HADOOP_USER_OUTPUT"output3"
OUTPUT4=$HADOOP_USER_OUTPUT"output4"
GLOBALAVG=$HADOOP_USER_OUTPUT"globalAvg"
USERAVG=$HADOOP_USER_OUTPUT"userAvg"
MOVIEAVG=$HADOOP_USER_OUTPUT"movieAvg"
PRECOMPUTED_FILES=$BASE_FOLDER"/Files_1M/"

#mkdir $BASE_FOLDER_OUTPUT
#hadoop fs -rm $HADOOP_USER_INPUT"ratings.dat"
#hadoop fs -rm $HADOOP_USER_INPUT"globalAvg.txt"
#hadoop fs -rm $HADOOP_USER_INPUT"userRatings_Avg.txt"
#hadoop fs -rm $HADOOP_USER_INPUT"movieRatings_Avg.txt"

for j in 1 2 3 4 5
do
	rm $BASE_FOLDER_OUTPUT"RMSE_train.dat"
	rm $BASE_FOLDER_OUTPUT"RMSE_test.dat"
	
	hadoop fs -rm -r /user/jmistry2/output/
	hadoop fs -rm -r /user/jmistry2/input/
	hadoop fs -mkdir /user/jmistry2/input/
	
	hadoop fs -put /home/jmistry2/Assign3/10M_Input/r$j.train /user/jmistry2/input/
	hadoop fs -put /home/jmistry2/Assign3/10M_Input/r$j.test /user/jmistry2/input/

	echo "------------------"
	echo "Creating Global average, User average and Movie average files...."
	echo "------------------"
	hadoop jar $STREAMING_JAR \
			   -input /user/jmistry2/input/r$j.train \
			   -output $GLOBALAVG \
			   -mapper $BASE_FOLDER"/GlobalAvgMap.py" \
			   -reducer $BASE_FOLDER"/GlobalAvgReduce.py"
	hadoop fs -get $GLOBALAVG/part-00000 $BASE_FOLDER_OUTPUT"globalAvg_"$j".txt"
	cp $BASE_FOLDER_OUTPUT"globalAvg_"$j".txt" $BASE_FOLDER_OUTPUT"save/globalAvg"$j".txt"

	hadoop jar $STREAMING_JAR \
			   -input /user/jmistry2/input/r$j.train \
			   -output $USERAVG \
			   -mapper $BASE_FOLDER"/UserAvgMap.py" \
			   -reducer $BASE_FOLDER"/UserAvgReduce.py"
	hadoop fs -get $USERAVG/part-00000 $BASE_FOLDER_OUTPUT"userRatings_Avg_"$j".txt"
	cp $BASE_FOLDER_OUTPUT"userRatings_Avg_"$j".txt" $BASE_FOLDER_OUTPUT"save/userRatings_Avg_"$j".txt"

	hadoop jar $STREAMING_JAR \
			   -input /user/jmistry2/input/r$j.train \
			   -output $MOVIEAVG \
			   -mapper $BASE_FOLDER"/MovieAvgMap.py" \
			   -reducer $BASE_FOLDER"/MovieAvgReduce.py"
	hadoop fs -get $MOVIEAVG/part-00000 $BASE_FOLDER_OUTPUT"movieRatings_Avg_"$j".txt"
	cp $BASE_FOLDER_OUTPUT"movieRatings_Avg_"$j".txt" $BASE_FOLDER_OUTPUT"save/movieRatings_Avg_"$j".txt"

	#echo "moving files to hdfs..."
	#hadoop fs -put $BASE_FOLDER_OUTPUT"globalAvg.txt" /user/jmistry2/input/
	#hadoop fs -put $BASE_FOLDER_OUTPUT"userRatings_Avg.txt" /user/jmistry2/input/
	#hadoop fs -put $BASE_FOLDER_OUTPUT"movieRatings_Avg.txt" /user/jmistry2/input/

	echo "------------------"
	echo "Global average, User average and Movie average files created...."
	echo "------------------"

	echo "------------------"
	echo "Computing U and V matrices..."
	echo "------------------"
	hadoop jar $STREAMING_JAR \
			   -cacheFile '/user/jmistry2/output/globalAvg/part-00000#globalAvg.txt' \
			   -cacheFile '/user/jmistry2/output/userAvg/part-00000#userRatings_Avg.txt' \
			   -cacheFile '/user/jmistry2/output/movieAvg/part-00000#movieRatings_Avg.txt' \
			   -input /user/jmistry2/input/r$j.train \
			   -output $OUTPUT1 \
			   -mapper $BASE_FOLDER"/MovieRecoMap1.py" \
			   -reducer $BASE_FOLDER"/MovieRecoReduce1.py"
	hadoop fs -get $OUTPUT1/part-00000 $BASE_FOLDER_OUTPUT"UVMat.txt"
	cp $BASE_FOLDER_OUTPUT"UVMat.txt" $BASE_FOLDER_OUTPUT"save/UVMat0.txt"
	echo "------------------"
	echo "U and V matrices created..."
	echo "------------------"

	echo "------------------"
	echo "Updating the U and V matrices..."
	echo "------------------"
	for i in {1..10}
	do
		echo "------------------"
		echo "Update $i ..."
		echo "------------------"
		hadoop fs -rm /user/jmistry2/input/UVMat.txt
		hadoop fs -put $BASE_FOLDER_OUTPUT"UVMat.txt" /user/jmistry2/input/
		
		hadoop jar $STREAMING_JAR \
			   -cacheFile '/user/jmistry2/output/globalAvg/part-00000#globalAvg.txt' \
			   -cacheFile '/user/jmistry2/output/userAvg/part-00000#userRatings_Avg.txt' \
			   -cacheFile '/user/jmistry2/output/movieAvg/part-00000#movieRatings_Avg.txt' \
			   -cacheFile '/user/jmistry2/input/UVMat.txt#UVMat.txt' \
			   -input /user/jmistry2/input/r$j.train \
			   -output $OUTPUT2 \
			   -mapper $BASE_FOLDER"/MovieRecoMap2.py" \
			   -reducer $BASE_FOLDER"/MovieRecoReduce2.py"
		
		rm $BASE_FOLDER_OUTPUT"UVMat.txt"
		hadoop fs -get $OUTPUT2/part-00000 $BASE_FOLDER_OUTPUT"UVMat.txt"
		cp $BASE_FOLDER_OUTPUT"UVMat.txt" $BASE_FOLDER_OUTPUT"save/UVMat_"$j"_"$i".txt"
		hadoop fs -rm -r $OUTPUT2
	done

	echo "------------------"
	echo "Computing RMSE for training data..."
	echo "------------------"
	hadoop fs -rm /user/jmistry2/input/UVMat.txt
	hadoop fs -put $BASE_FOLDER_OUTPUT"UVMat.txt" /user/jmistry2/input/
	hadoop jar $STREAMING_JAR \
			   -cacheFile '/user/jmistry2/output/globalAvg/part-00000#globalAvg.txt' \
			   -cacheFile '/user/jmistry2/output/userAvg/part-00000#userRatings_Avg.txt' \
			   -cacheFile '/user/jmistry2/output/movieAvg/part-00000#movieRatings_Avg.txt' \
			   -cacheFile '/user/jmistry2/input/UVMat.txt#UVMat.txt' \
			   -input /user/jmistry2/input/r$j.train \
			   -output $OUTPUT3 \
			   -mapper $BASE_FOLDER"/RMSE_Map1.py" \
			   -reducer $BASE_FOLDER"/RMSE_Reduce1.py"
	hadoop fs -get $OUTPUT3/part-00000 $BASE_FOLDER_OUTPUT"RMSE_train.dat"
	cp $BASE_FOLDER_OUTPUT"RMSE_train.dat" $BASE_FOLDER_OUTPUT"save/RMSE_"$j"_train.dat"

	echo "------------------"
	echo "Computing RMSE for test data..."
	echo "------------------"
	#hadoop fs -rm /user/jmistry2/input/UVMat.txt
	#hadoop fs -put $BASE_FOLDER_OUTPUT"UVMat.txt" /user/jmistry2/input/
	hadoop jar $STREAMING_JAR \
			   -cacheFile '/user/jmistry2/output/globalAvg/part-00000#globalAvg.txt' \
			   -cacheFile '/user/jmistry2/output/userAvg/part-00000#userRatings_Avg.txt' \
			   -cacheFile '/user/jmistry2/output/movieAvg/part-00000#movieRatings_Avg.txt' \
			   -cacheFile '/user/jmistry2/input/UVMat.txt#UVMat.txt' \
			   -input /user/jmistry2/input/r$j.test \
			   -output $OUTPUT3 \
			   -mapper $BASE_FOLDER"/RMSE_Map1.py" \
			   -reducer $BASE_FOLDER"/RMSE_Reduce1.py"
	hadoop fs -get $OUTPUT3/part-00000 $BASE_FOLDER_OUTPUT"RMSE_test.dat"
	cp $BASE_FOLDER_OUTPUT"RMSE_test.dat" $BASE_FOLDER_OUTPUT"save/RMSE_"$j"_test.dat"
	
	hadoop fs -rm /user/jmistry2/input/r$j.test
	hadoop fs -rm /user/jmistry2/input/r$j.train
	
done

echo "------------------"
echo "Done" 
echo "------------------"
