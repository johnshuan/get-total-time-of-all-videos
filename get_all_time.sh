# shows total time of all video files with $files_extension extension
# also shows average time and counts files
files_extension="*.mkv"

# finding time of each file and adding them to $all_time array
readarray -d '' all_time < <(find . -maxdepth 1 -iname "$files_extension" -exec ffprobe -v quiet -of csv=p=0 -show_entries format=duration {} \;)

files_count=$(ls *.mkv | wc -l)

# if no files then exit
if [ $files_count == 0 ]
then
	echo "No files with "$files_extension" found."
	exit 1
fi

# finding sum of all time
sum=0
for i in ${all_time[@]}; do
	sum=$(echo $sum + $i | bc -l);
done

average=$(echo $sum / $files_count | bc -l)

# sum_s=$sum
sum_m=$(bc <<< $sum/60)
sum_h=$(bc <<< $sum/60/60)

# av_s=$average
av_m=$(bc <<< $average/60)
av_h=$(bc <<< $average/60/60)

# output
echo "Total time:"
echo "in (hrs): $sum_h"
echo "in (min): $sum_m"
echo "in (sec): $sum"
echo "Average time:"
echo "in (hrs): $av_h"
echo "in (min): $av_m"
echo "in (sec): $average"
echo "files: $files_count"

