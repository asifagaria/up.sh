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

Utilisation :
```
./up.sh --film
./up.sh --serie
./up.sh --animation
./up.sh --musique
./up.sh --jeu
```
Pendant l'exécution du script il vous sera demander le nom du fichier/ou du dossier cible.

![caps1](https://user-images.githubusercontent.com/34775368/34308900-ac0ed54a-e74f-11e7-8923-d25017f27331.PNG)
