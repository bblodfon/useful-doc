# Database-related commands

## MySQL: Size of a MyISAM table in GB
`ls /var/lib/mysql/database/tableName.* | xargs stat --format=%s | awk '{s+=$1} 
END {print s/(1024*1024*1024)}'`

## MySQL: Drop many tables matching a pattern
`SELECT CONCAT( 'DROP TABLE ', GROUP_CONCAT(table_name) , ';' ) AS statement 
FROM information_schema.tables WHERE table_name LIKE 'patternToMatch%';`

## MySQL: Count rows and size of MyISAM tables that have the date in their name
```bash
#!/bin/bash
  
date=`date -d 'Oct 13 14:00:00 2020' +%s` ;
end_date=`date -d 'Nov 27 00:00:00 2020' +%s`;

while [ $date -lt $end_date ];
  do date -d @$date +%Y%m%d;
  date=$(expr $date + 86400) ;
  done |

while read x ;
do
        echo quering count: $x
        table=tableSuffix$x
        rows=`mysql -u username -p password -e "select count(*) from $table\G"|tail -n 1|awk '{print $2}'`
        size=`du -ch /var/lib/mysql/databaseName/$table* | tail -n1 | awk '{print $1}' | sed 's/G//'`
        echo $x,$rows,$size >> output.txt
done
```
