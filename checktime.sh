mysql "--database=wordpress" < "update.sql"
echo "Check Time....."
`aws configure set region us-east-1`
EC2_INSTANCE_ID="`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id || die \"wget instance-id has failed: $?\"`"
TIMEOUT=3600
CURTIME=`date +%s`
LASTREQUESTTIME=`sudo date +%s -r /etc/httpd/logs/access_log`
DIFF=$((CURTIME-LASTREQUESTTIME))
echo "Last request was $DIFF seconds ago."
echo "Timeout is set at $TIMEOUT seconds"
TOGO=$((TIMEOUT-DIFF))
echo "Stop instance in $TOGO"
if [ $DIFF -gt $TIMEOUT ]
then
echo "Last update time greater than 2 hours."
echo "Stop this Instance."
`aws ec2 stop-instances --instance-ids $EC2_INSTANCE_ID`
else
echo "Keep it running."
echo "Check again in 1 hour."
fi
echo $EC2_INSTANCE_ID
