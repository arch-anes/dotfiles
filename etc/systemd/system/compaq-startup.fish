while not mountpoint -q '/storage'
  sleep 10 
end

sudo systemctl start syncthing@server.service 

/docker/start-all.sh

