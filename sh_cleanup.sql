#!/usr/bin/bash
for f in $(find /gtapcommon/HDEVDEV3/dblog -name '*.TXT' -mtime +2) ; do 
   #echo $f $(date -r "$f" +%F)
    zip $(date -r "$f" +%F).zip "$f"        # 2017-04-07.zip
done
find "/gtapcommon/HDEVDEV3/dblog" -name '*.TXT' -mtime +0 -exec rm -f {} \;

echo completed;