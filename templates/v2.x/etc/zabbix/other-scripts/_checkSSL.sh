###################################
# This file is managed by puppet
# PLEASE DON'T MODIFY BY HAND
# ###################################

#!/bin/bash

SITE=$1

SPD=86400

end_date=`openssl s_client -connect ${SITE}:443 -state -servername ${SITE} < /dev/null 2>/dev/null | openssl x509 -noout -enddate | awk -F'=' '{print $2}'`

s_end_date=`date --date="${end_date}" +%s`

to_day=`date +%s`

date_diff=$(( ($s_end_date - $to_day) / $SPD ))

echo $date_diff
