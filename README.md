Script .torrent et .nfo rapide avec mktorrent et mediainfo

#Installation :
(Remplacer User partout)

cd /tmp
git clone https://github.com/fatality899/up.sh
cp /tmp/up.sh/up.sh /home/user/up.sh
chmod a+x /home/user/up.sh

Modifier les variables en début de script :

nano /home/user/up.sh

USER="user_seedbox" # Utilisateur seedbox
TRACKER="http://jack.yggtorrent.com:8080//announce" #https://yggtorrent.com/user/upload_torrent

Fichier NFO stocké dans /home/user/nfo
Fichier torrent stocké dans /home/user/stocktorrent/film,serie,jeux etc....

Utilisation :

./up.sh --film
./up.sh --serie
./up.sh --animation
./up.sh --musique
./up.sh --jeu
