#!/bin/bash

#check to make sure the user is entering a time in format 00:00
check_format()
{
	if [[ $1 == ??:?? ]]; then
		echo "pass"
	else
		echo "fail"
	fi
}

#extract the hour and minute supplied by the user in the format 00:00 using awk
extract_time()
{
	if [ $1 == "-h" ]; then
		echo $2 | awk -F: '{print $1}'	
	else if [ $1 == "-m" ]; then
		echo $2 | awk -F: '{print $2}'
		
	fi
	fi
}
#Calculate the length of how long the computer will be suspended for
time_difference()
{

		

	#pm to am
	if [ $1 -ge 12 ] && [ $1 -le 23 ];then
		if [ $2 -ge 0 ] && [ $2 -lt 12 ];then
			current_hour=$(($1-12)); hour_to_wake=$(($2+12))
			current_minute=$(date "+%M")
			current_total_m=$(( $current_minute +  $(($current_hour*60)) ))
			minutes_to_wake=$(( $3 + $(($hour_to_wake*60))))

			echo $(($minutes_to_wake-$current_total_m))
		fi
	fi

	#am to am
	if [ $1 -ge 0 ] && [ $1 -lt 12 ];then
		if [ $2 -ge 0 ] && [ $2 -lt 12 ];then
			current_hour=$1; hour_to_wake=$2
			current_minute=$(date "+%M")
			current_total_m=$(($(($current_hour*60)) + $current_minute))
			minutes_to_wake=$(($3 + $(($hour_to_wake*60))))

			echo $(($minutes_to_wake-$current_total_m))
		fi
	fi

	#am to pm
	if [ $1 -ge 0 ] && [ $1 -lt 12 ];then
		if [ $2 -ge 12 ] && [ $2 -le 23 ];then
			current_hour=$1; hour_to_wake=$2
			current_minute=$(date "+%M")
			current_total_m=$(($(($current_hour*60))+$current_minute))
			minutes_to_wake=$(($3 +$(($hour_to_wake*60))))

			echo $(($minutes_to_wake-$current_total_m))
		fi
	fi

	#pm to pm
	if [ $1 -ge 12 ] && [ $1 -le 23 ]; then
		if [ $2 -ge 12 ] && [ $2 -le 23 ]; then
			current_hour=$1; hour_to_wake=$2
			current_minute=$(date "+%M")
			current_total_m=$(($(($current_hour*60))+$current_minute))
			minutes_to_wake=$(($3+$(($hour_to_wake*60))))

			echo $(($minutes_to_wake-$current_total_m))
		fi
	fi


}


#main

#add a soundfile
if [[ $1 == 'as' ]]; then
	if [[ $2 != "" ]];then
		echo $2 > soundfile.txt
	fi
fi
#show saved soundfile
if [[ $1 == 'ss' ]]; then
	cat soundfile.txt
fi

#if the format matches 00:00 then proceed with setting up alarm
input=$(check_format $1)
if [[ $input == "pass" ]]; then

	#extract_time
	hour=$(extract_time -h $1)
	minute=$(extract_time -m $1)

	#extract current hour
	current_hour=$(date "+%H")

	minutes_to_sleep=$(time_difference $current_hour $hour $minute)
	echo "minutes to sleep  = "$minutes_to_sleep

	#convert to seconds
	seconds_to_sleep=$(($minutes_to_sleep*60))

	#set alarm and play music once done
	sudo rtcwake -m disk -s $seconds_to_sleep
	mpv $(cat soundfile.txt)	
	

fi
