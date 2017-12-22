# Script .torrent et .nfo rapide avec mktorrent et mediainfo

* Nécessite Debian 7/8/9
* Inclus mktorrent et mediainfo

**Auteur :** U3kiPyudNy6GT

## Installation :
(Remplacer User partout)
```
cd /tmp
git clone https://github.com/fatality899/up.sh
cp /tmp/up.sh/up.sh /home/user/up.sh
chmod a+x /home/user/up.sh
```

Modifier les variables en début de script :
```
nano /home/user/up.sh
```
```
USER="user_seedbox" # Utilisateur seedbox
TRACKER="http://jack.yggtorrent.com:8080//announce" #https://yggtorrent.com/user/upload_torrent
```

* Fichier NFO stocké dans /home/user/nfo
* Fichier torrent stocké dans /home/user/stocktorrent/film,serie,jeux etc....

### Utilisation :
```
./up.sh --film
./up.sh --serie
./up.sh --animation
./up.sh --musique
./up.sh --jeu
```
Pendant l'exécution du script il vous sera demander le nom du fichier/ou du dossier cible.

![caps1](https://user-images.githubusercontent.com/34775368/34308900-ac0ed54a-e74f-11e7-8923-d25017f27331.PNG)

![caps2](https://user-images.githubusercontent.com/34775368/34308918-c07f5900-e74f-11e7-90d1-3cbc65ccd03f.PNG)

![caps3](https://user-images.githubusercontent.com/34775368/34308923-c3a75146-e74f-11e7-8cd0-c8c2731d5db5.PNG)

![caps4](https://user-images.githubusercontent.com/34775368/34308928-c625e572-e74f-11e7-9e0d-439ff529643e.PNG)

![caps5](https://user-images.githubusercontent.com/34775368/34308933-cbcd83b8-e74f-11e7-8451-dab952c2b79a.PNG)

![caps6](https://user-images.githubusercontent.com/34775368/34308936-cf2c41fc-e74f-11e7-9163-3cf84ba2f802.PNG)
