#!/usr/bin/bash
standstring_day2="MonTueWedThuFriSatSun"
standstring_month2="JanFebMarAprMayJunJulAugSepOctNovDec"
stand="MonTueWedThuFriSatSunJanFebMarAprMayJunJulAugSepOctNovDec"
declare -A arr
arr["Jan"]="01"
arr+=( ["Feb"]="02" ["Mar"]="03" ["Apr"]="04" ["May"]="05" ["Jun"]="06" ["Jul"]="07" ["Aug"]="08" ["Sep"]="09" ["Oct"]="10" ["Nov"]="11" ["Dec"]="12")

for filename in *.log; do 
while read -r line
do
     if [ -n "$line" ];then
	log_line="$line"
	pattern=""
	value=""
	temp1=$(echo $log_line | cut -f 1 -d " ")
	temp2=$(echo $log_line | cut -f 1 -d " ")
	temp2=${temp2:1} #strip of temp2
	temp2orig=$temp2
	if [ "${#temp2}" -eq "3" ]
	then
	temp2=$temp2
	log_line=${log_line:1}
	else
	temp2=$temp1
	fi


	result_date=""
	result_time=$(echo $log_line | grep -o '[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}'| head -n1)
	
#echo "Name read from file - $result_time"

	result_date=$(echo $log_line | grep -o '[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}'| head -n1)
	
	if [ -z "$result_date" ];then
	result_date=$(echo $log_line | grep -o '[0-9]\{2\}/[0-9]\{2\}/[0-9]\{4\}'| head -n1)
	fi

	if [ -z "$result_date" ];then
	result_date=$(echo $log_line | grep -o '[0-9]\{2\}/[a-zA-Z]\{3\}/[0-9]\{4\}'| head -n1)
		if [ -n "$result_date" ];then
		pattern=$(echo $result_date | grep -o '[a-zA-Z]\{3\}')  #get the month from the date Eg. Mar
		value=$arr[$pattern]    #then convert month to its corresponding month count using key value array
		result_date="${result_date/$pattern/${arr[$pattern]}}"   #replacing the character month with integer month so that date could work
		fi
	fi
	if [ -z "$result_date" ]; then
		if [ `echo $standstring_day2 | grep $temp2` ]
		then
		result_date=$(echo $log_line | cut -d' ' -f1-3)
	elif [ `echo $standstring_month2 | grep $temp2` ]
		then
		result_date=$(echo $log_line | cut -d' ' -f1-2 )
	else
		echo "This format is not yet logged in the program :-C"
	    fi
	 fi
	
	result_date=$(date --date="$result_date" '+%d-%m-%Y')
echo $result_date

#echo $result_date


	string=$filename";-)"$result_date";-)"$result_time";-)"$log_line
	echo $string >> final.log
	fi
done < "$filename" 
done

