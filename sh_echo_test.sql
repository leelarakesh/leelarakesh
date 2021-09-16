#!/usr/bin/bash
#leelar
for d in $(ls -d */); do  
	echo ${d%%/} 
	for f in $(find /gtapcommon/${d%%/}/dblog -name '*.TXT' -mtime 0) ; do 
	   echo "${d%%/}_dblog_$(date -r "$f" +%F).zip" "$f"
		#zip "/gtapcommon/${d%%/}/zip /${d%%/}_$(date -r "$f" +%F).zip" "$f"        # 2017-04-07.zip
	done
	
done
echo completed;