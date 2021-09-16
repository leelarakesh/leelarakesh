echo --------------------------------------------------------------------|& tee -a "$spoolloc"	
echo -------------------------Loading Started-------------------------------------------|& tee -a "$spoolloc"	
echo --------------------------------------------------------------------|& tee -a "$spoolloc"
export file_list=""
while IFS=":" read ctl file
do
	file_list=""$file_list" ! -name "*"$file".txt"" 
done <""$ControlLoc"/file_list_cdsc.config"
echo "file_list:: $file_list"|& tee -a "$spoolloc"


while IFS=":" read ctl file
do
	echo ------------------$ctl----------$file----------------------------------------|& tee -a "$spoolloc"
	echo --------------------------------------------------------------------|& tee -a "$spoolloc"
	echo --------------------------------------------------------------------|& tee -a "$spoolloc"
	file_list_lst=$(echo "$file_list" | sed "s/\b$file\b/"###"/g")
	echo "file_list_lst:: $file_list_lst"|& tee -a "$spoolloc"
	#for f in ""$cdscloc""/"INFILES"
	#		do 	
		echo $ctl
		#find ""$cdscloc""/"INFILES" -name "*"$file"*.*" |& tee -a datafile_tmp.log		
		for q in $(find ""$cdscloc""/"INFILES" -name "*"$file"*.*" $file_list_lst)
			do
				#foldername=`expr substr $q 53 2`
				foldername=$(basename $(dirname $q))
				filename=$(basename $q)
				log_bad_filename="$logtime"_"$(basename $q)_"$foldername""
				echo Loading File :: $foldername/$filename  ctl:: $ctl log_bad_filename:: $log_bad_filename  |& tee -a "$spoolloc"
 				sqlldr ""$login_STAGE" control='/"$ControlLoc"/"$ctl".txt' DATA='"$q"' log='"$cdscloc""/MigrationSpools/LoaderSpool/""$log_bad_filename".log' BAD='"$cdscloc""/BADFILE/""$log_bad_filename"_BAD.CSV'" |& tee -a "$spoolloc"
			done
		#done
	echo --------------------------------------------------------------------	
done <""$ControlLoc"/file_list_cdsc.config"
echo --------------------------------------------------------------------|& tee -a "$spoolloc"	
echo -------------------------Loading Complted-------------------------------------------|& tee -a "$spoolloc"	
echo --------------------------------------------------------------------|& tee -a "$spoolloc"	
