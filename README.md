# .Torrent and fast .nfo script with mktorrent and mediainfo

* Need Debian 7/8/9
* Included mktorrent and mediainfo

**Author :** Asifagaria

## Installation :
(Replace User everywhere)
```
cd /tmp
git clone https://github.com/asifagaria/up.sh
cp /tmp/up.sh/up.sh /home/user/up.sh
chmod a+x /home/user/up.sh
```

Modify the variables at the beginning of the script:
```
nano /home/user/up.sh
```
```
USER="user_seedbox" # Utilisateur seedbox
TRACKER="http://tracker.bittorrent.com:8080//announce" #https://yggtorrent.com/user/upload_torrent
```

* NFO file stored in /home/user/nfo
* Torrent file stored in /home/user/stocktorrent/film,serie,games etc....

### How To use :
```
./up.sh --film
./up.sh --serie
./up.sh --animation
./up.sh --music
./up.sh --game
./up.sh --extra
```
While running the script you will be asked for the name of the target file / folder.

![caps1](https://user-images.githubusercontent.com/34775368/34308900-ac0ed54a-e74f-11e7-8923-d25017f27331.PNG)

![caps2](https://user-images.githubusercontent.com/34775368/34308918-c07f5900-e74f-11e7-90d1-3cbc65ccd03f.PNG)

![caps3](https://user-images.githubusercontent.com/34775368/34308923-c3a75146-e74f-11e7-8cd0-c8c2731d5db5.PNG)

![caps4](https://user-images.githubusercontent.com/34775368/34308928-c625e572-e74f-11e7-9e0d-439ff529643e.PNG)

![caps5](https://user-images.githubusercontent.com/34775368/34308933-cbcd83b8-e74f-11e7-8451-dab952c2b79a.PNG)

![caps6](https://user-images.githubusercontent.com/34775368/34308936-cf2c41fc-e74f-11e7-9163-3cf84ba2f802.PNG)
