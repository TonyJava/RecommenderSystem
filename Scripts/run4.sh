#! /bin/bash

BASE_FOLDER="/home/jmistry2/Assign3"
BASE_FOLDER_OUTPUT=$BASE_FOLDER"/output/"
#DATASET_MAIN_FILE1="/home/dbarbara/MOVIELENS/ml-1m/ratings.dat"
DATASET_MAIN_FILE2="/home/dbarbara/MOVIELENS/ml-1m/movies.dat"
STREAMING_JAR="/apps/hadoop-2/share/hadoop/tools/lib/hadoop-streaming-2.4.1.jar"
HADOOP_USER_INPUT="/user/jmistry2/input/"
HADOOP_USER_OUTPUT="/user/jmistry2/output/"
INPUT1=$HADOOP_USER_INPUT"ratings.dat"
OUTPUT1=$HADOOP_USER_OUTPUT"output1"
OUTPUT2=$HADOOP_USER_OUTPUT"output2"
OUTPUT3=$HADOOP_USER_OUTPUT"output3"
GLOBALAVG=$HADOOP_USER_OUTPUT"globalAvg"
USERAVG=$HADOOP_USER_OUTPUT"userAvg"
MOVIEAVG=$HADOOP_USER_OUTPUT"movieAvg"
PRECOMPUTED_FILES=$BASE_FOLDER"/Files_1M/"
DATASET_MAIN_FILE1="/home/jmistry2/Assign3/ip/ratings.dat"

#mkdir $BASE_FOLDER_OUTPUT
#hadoop fs -rm $HADOOP_USER_INPUT"ratings.dat"
#hadoop fs -rm $HADOOP_USER_INPUT"globalAvg.txt"
#hadoop fs -rm $HADOOP_USER_INPUT"userRatings_Avg.txt"
#hadoop fs -rm $HADOOP_USER_INPUT"movieRatings_Avg.txt"

hadoop fs -put $DATASET_MAIN_FILE1 $HADOOP_USER_INPUT

echo "------------------"
echo "Creating Global average, User average and Movie average files...."
echo "------------------"
hadoop jar $STREAMING_JAR \
		   -input $INPUT1 \
		   -output $GLOBALAVG \
		   -mapper $BASE_FOLDER"/GlobalAvgMap.py" \
		   -reducer $BASE_FOLDER"/GlobalAvgReduce.py"
hadoop fs -get $GLOBALAVG/part-00000 $BASE_FOLDER_OUTPUT"globalAvg.txt"
cp $BASE_FOLDER_OUTPUT"globalAvg.txt" $BASE_FOLDER_OUTPUT"save/globalAvg.txt"

hadoop jar $STREAMING_JAR \
		   -input $INPUT1 \
		   -output $USERAVG \
		   -mapper $BASE_FOLDER"/UserAvgMap.py" \
		   -reducer $BASE_FOLDER"/UserAvgReduce.py"
hadoop fs -get $USERAVG/part-00000 $BASE_FOLDER_OUTPUT"userRatings_Avg.txt"
cp $BASE_FOLDER_OUTPUT"userRatings_Avg.txt" $BASE_FOLDER_OUTPUT"save/userRatings_Avg.txt"

hadoop jar $STREAMING_JAR \
		   -input $INPUT1 \
		   -output $MOVIEAVG \
		   -mapper $BASE_FOLDER"/MovieAvgMap.py" \
		   -reducer $BASE_FOLDER"/MovieAvgReduce.py"
hadoop fs -get $MOVIEAVG/part-00000 $BASE_FOLDER_OUTPUT"movieRatings_Avg.txt"
cp $BASE_FOLDER_OUTPUT"movieRatings_Avg.txt" $BASE_FOLDER_OUTPUT"save/movieRatings_Avg.txt"

echo "moving files to hdfs..."

hadoop fs -put $BASE_FOLDER_OUTPUT"globalAvg.txt" $HADOOP_USER_INPUT
hadoop fs -put $BASE_FOLDER_OUTPUT"userRatings_Avg.txt" $HADOOP_USER_INPUT
hadoop fs -put $BASE_FOLDER_OUTPUT"movieRatings_Avg.txt" $HADOOP_USER_INPUT

echo "------------------"
echo "Global average, User average and Movie average files created...."
echo "------------------"

echo "------------------"
echo "Computing U and V matrices..."
echo "------------------"
hadoop jar $STREAMING_JAR \
		   -cacheFile '/user/jmistry2/input/globalAvg.txt#globalAvg.txt' \
		   -cacheFile '/user/jmistry2/input/userRatings_Avg.txt#userRatings_Avg.txt' \
		   -cacheFile '/user/jmistry2/input/movieRatings_Avg.txt#movieRatings_Avg.txt' \
		   -input $INPUT1 \
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
	hadoop fs -rm $HADOOP_USER_INPUT"UVMat.txt"
	hadoop fs -put $BASE_FOLDER_OUTPUT"UVMat.txt" $HADOOP_USER_INPUT
	
	hadoop jar $STREAMING_JAR \
		   -cacheFile '/user/jmistry2/input/globalAvg.txt#globalAvg.txt' \
		   -cacheFile '/user/jmistry2/input/userRatings_Avg.txt#userRatings_Avg.txt' \
		   -cacheFile '/user/jmistry2/input/movieRatings_Avg.txt#movieRatings_Avg.txt' \
		   -cacheFile '/user/jmistry2/input/UVMat.txt#UVMat.txt' \
		   -input $INPUT1 \
		   -output $OUTPUT2 \
		   -mapper $BASE_FOLDER"/MovieRecoMap2.py" \
		   -reducer $BASE_FOLDER"/MovieRecoReduce2.py"
	
	rm $BASE_FOLDER_OUTPUT"UVMat.txt"
	hadoop fs -get $OUTPUT2/part-00000 $BASE_FOLDER_OUTPUT"UVMat.txt"
	cp $BASE_FOLDER_OUTPUT"UVMat.txt" $BASE_FOLDER_OUTPUT"save/UVMat"$i".txt"
	hadoop fs -rm -r $OUTPUT2
done

echo "------------------"
echo "Computing RMSE..."
echo "------------------"
hadoop fs -rm $HADOOP_USER_INPUT"UVMat.txt"
hadoop fs -put $BASE_FOLDER_OUTPUT"UVMat.txt" $HADOOP_USER_INPUT
hadoop jar $STREAMING_JAR \
		   -cacheFile '/user/jmistry2/input/globalAvg.txt#globalAvg.txt' \
		   -cacheFile '/user/jmistry2/input/userRatings_Avg.txt#userRatings_Avg.txt' \
		   -cacheFile '/user/jmistry2/input/movieRatings_Avg.txt#movieRatings_Avg.txt' \
		   -cacheFile '/user/jmistry2/input/UVMat.txt#UVMat.txt' \
		   -input $INPUT1 \
		   -output $OUTPUT3 \
		   -mapper $BASE_FOLDER"/RMSE_Map1.py" \
		   -reducer $BASE_FOLDER"/RMSE_Reduce1.py"
hadoop fs -get $OUTPUT3/part-00000 $BASE_FOLDER_OUTPUT"RMSE.dat"
cp $BASE_FOLDER_OUTPUT"RMSE.dat" $BASE_FOLDER_OUTPUT"save/RMSE.dat"

echo "------------------"
echo "Done" 
echo "------------------"
