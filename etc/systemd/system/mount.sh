#!/bin/bash

cuuid=9103af23-a48b-4740-9069-a370b4dff9ab
media=/media/key
keyfile=$media/compaq

sudo udiskie --no-notify --tray --use-udisks2 &

while true 
do
	if [[ -e /dev/disk/by-uuid/$cuuid && -e $keyfile ]]  
	then
		sudo cryptsetup open /dev/disk/by-uuid/$cuuid cstorage --key-file $keyfile 
		sudo mount /dev/mapper/cstorage /storage
		sudo udiskie-umount $media
		break
	else
		sleep 10
	fi
done

