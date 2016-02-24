echo "SPEEDD UI - starting"

echo "Starting sshd"

/usr/sbin/sshd

cd $APP_DIR

echo "Installing required node modules"

npm install

echo "Sleep 1m till kafka is up and topics initialized"

sleep 1m

node app --zk zk:2181 --ui 3000

echo "Start completed."