/etc/init.d/ntp start
setsid sh -c 'python3 ./ParseIoStat.py & \
              python3 ./ParseTop.py & \
	      python3 ./ParseIfStat.py & \
	      python3 ./ParseIoTop.py & \
	      python3 ./ParseFreeMemStat.py' & pgid=$!
echo "kill -TERM -$pgid" > KillAll.sh
echo "Background tasks are running in process group $pgid, kill with kill -TERM -$pgid"
