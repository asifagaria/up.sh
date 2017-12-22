*#!/bin/bash
# Auteur : U3kiPyudNy6GT
# Optimise pour Plex Media Server
# Creation des .torrent et .nfo avec verification doublons .torrent
###

# Variables
# Principal
USER="" # Utilisateur seedbox
TRACKER="http://jack.yggtorrent.com:8080/passkey/announce"
# Dossier upload (a modifier avec vos emplacements exact)
UPSERIE="/home/$USER/torrents/series"
UPFILM="/home/$USER/torrents/film"
UPANIMATION="/home/$USER/torrents/animation"
UPJEU="/home/$USER/torrents/jeux"
UPMUSIQUE="/home/$USER/torrents/musique"
UPXXX="/home/$USER/torrents/cul"
# Dossier stockage .torrent
TORSERIE="/home/$USER/stocktorrents/series"
TORFILM="/home/$USER/stocktorrents/film"
TORANIMATION="/home/$USER/stocktorrents/animation"
TORJEU="/home/$USER/stocktorrents/jeux"
TORMUSIQUE="/home/$USER/stocktorrents/musique"
TORXXX="/home/$USER/stocktorrents/cul"
# Dossier stockage .nfo (pour recuperer facilement les .nfo)
STOCKNFO="/home/$USER/nfo"
###

# Recuperation threads
THREAD=$(grep -c processor < /proc/cpuinfo)
if [ "$THREAD" = "" ]; then
	THREAD=1
fi
###

# Test de presence
#Mktorrent
command -v mktorrent >/dev/null 2>&1
if [ $? = 1 ]; then
	apt-get install -y mktorrent
fi
#Mediainfo
command -v mediainfo >/dev/null 2>&1
if [ $? = 1 ]; then
	apt-get install -y mediainfo
fi
###

# Detection de la taille du/des fichier(s)
FONCAUTOSERIE () {
	TAILLE=$(du -s "$UPSERIE"/"$FILE" | awk '{ print $1 }')
	if [ "$TAILLE" -lt 65536 ]; then # - de 64 Mo
		PIECE=15 # 32 Ko
	elif [ "$TAILLE" -lt 131072 ]; then # - de 128 Mo
		PIECE=16 # 64 Ko
	elif [ "$TAILLE" -lt 262144 ]; then # - de 256 Mo
		PIECE=17 # 128 Ko
	elif [ "$TAILLE" -lt 524288 ]; then # - de 512 Mo
		PIECE=18 # 256 Ko
	elif [ "$TAILLE" -lt 1048576 ]; then # - de 1 Go
		PIECE=19 # 512 Ko
	elif [ "$TAILLE" -lt 2097152 ]; then # - de 2 Go
		PIECE=20 # 1 Mo
	elif [ "$TAILLE" -lt 4194304 ]; then # - de 4 Go
		PIECE=21  # 2 Mo
	elif [ "$TAILLE" -lt 8388608 ]; then # - de 8 Go
		PIECE=22 # 4 Mo
	elif [ "$TAILLE" -lt 16777216 ]; then # - de 16 Go
		PIECE=23 # 8 Mo
	elif [ "$TAILLE" -lt 33554432 ]; then # - de 32 Go
		PIECE=24 # 16 Mo
	elif [ "$TAILLE" -ge 33554432 ]; then # + de 32 Go
		PIECE=25 # 32 Mo
	fi
}

FONCAUTOFILM () {
        TAILLE=$(du -s "$UPFILM"/"$FILE" | awk '{ print $1 }')
        if [ "$TAILLE" -lt 65536 ]; then # - de 64 Mo
                PIECE=15 # 32 Ko
        elif [ "$TAILLE" -lt 131072 ]; then # - de 128 Mo
                PIECE=16 # 64 Ko
        elif [ "$TAILLE" -lt 262144 ]; then # - de 256 Mo
                PIECE=17 # 128 Ko
        elif [ "$TAILLE" -lt 524288 ]; then # - de 512 Mo
                PIECE=18 # 256 Ko
        elif [ "$TAILLE" -lt 1048576 ]; then # - de 1 Go
                PIECE=19 # 512 Ko
        elif [ "$TAILLE" -lt 2097152 ]; then # - de 2 Go
                PIECE=20 # 1 Mo
        elif [ "$TAILLE" -lt 4194304 ]; then # - de 4 Go
                PIECE=21  # 2 Mo
        elif [ "$TAILLE" -lt 8388608 ]; then # - de 8 Go
                PIECE=22 # 4 Mo
        elif [ "$TAILLE" -lt 16777216 ]; then # - de 16 Go
                PIECE=23 # 8 Mo
        elif [ "$TAILLE" -lt 33554432 ]; then # - de 32 Go
                PIECE=24 # 16 Mo
        elif [ "$TAILLE" -ge 33554432 ]; then # + de 32 Go
                PIECE=25 # 32 Mo
        fi
}

FONCAUTOANIMATION () {
        TAILLE=$(du -s "$UPANIMATION"/"$FILE" | awk '{ print $1 }')
        if [ "$TAILLE" -lt 65536 ]; then # - de 64 Mo
                PIECE=15 # 32 Ko
        elif [ "$TAILLE" -lt 131072 ]; then # - de 128 Mo
                PIECE=16 # 64 Ko
        elif [ "$TAILLE" -lt 262144 ]; then # - de 256 Mo
                PIECE=17 # 128 Ko
        elif [ "$TAILLE" -lt 524288 ]; then # - de 512 Mo
                PIECE=18 # 256 Ko
        elif [ "$TAILLE" -lt 1048576 ]; then # - de 1 Go
                PIECE=19 # 512 Ko
        elif [ "$TAILLE" -lt 2097152 ]; then # - de 2 Go
                PIECE=20 # 1 Mo
        elif [ "$TAILLE" -lt 4194304 ]; then # - de 4 Go
                PIECE=21  # 2 Mo
        elif [ "$TAILLE" -lt 8388608 ]; then # - de 8 Go
                PIECE=22 # 4 Mo
        elif [ "$TAILLE" -lt 16777216 ]; then # - de 16 Go
                PIECE=23 # 8 Mo
        elif [ "$TAILLE" -lt 33554432 ]; then # - de 32 Go
                PIECE=24 # 16 Mo
        elif [ "$TAILLE" -ge 33554432 ]; then # + de 32 Go
                PIECE=25 # 32 Mo
        fi
}

FONCAUTOJEU () {
        TAILLE=$(du -s "$UPJEU"/"$FILE" | awk '{ print $1 }')
        if [ "$TAILLE" -lt 65536 ]; then # - de 64 Mo
                PIECE=15 # 32 Ko
        elif [ "$TAILLE" -lt 131072 ]; then # - de 128 Mo
                PIECE=16 # 64 Ko
        elif [ "$TAILLE" -lt 262144 ]; then # - de 256 Mo
                PIECE=17 # 128 Ko
        elif [ "$TAILLE" -lt 524288 ]; then # - de 512 Mo
                PIECE=18 # 256 Ko
        elif [ "$TAILLE" -lt 1048576 ]; then # - de 1 Go
                PIECE=19 # 512 Ko
        elif [ "$TAILLE" -lt 2097152 ]; then # - de 2 Go
                PIECE=20 # 1 Mo
        elif [ "$TAILLE" -lt 4194304 ]; then # - de 4 Go
                PIECE=21  # 2 Mo
        elif [ "$TAILLE" -lt 8388608 ]; then # - de 8 Go
                PIECE=22 # 4 Mo
        elif [ "$TAILLE" -lt 16777216 ]; then # - de 16 Go
                PIECE=23 # 8 Mo
        elif [ "$TAILLE" -lt 33554432 ]; then # - de 32 Go
                PIECE=24 # 16 Mo
        elif [ "$TAILLE" -ge 33554432 ]; then # + de 32 Go
                PIECE=25 # 32 Mo
        fi
}

FONCAUTOMUSIQUE () {
        TAILLE=$(du -s "$UPMUSIQUE"/"$FILE" | awk '{ print $1 }')
        if [ "$TAILLE" -lt 65536 ]; then # - de 64 Mo
                PIECE=15 # 32 Ko
        elif [ "$TAILLE" -lt 131072 ]; then # - de 128 Mo
                PIECE=16 # 64 Ko
        elif [ "$TAILLE" -lt 262144 ]; then # - de 256 Mo
                PIECE=17 # 128 Ko
        elif [ "$TAILLE" -lt 524288 ]; then # - de 512 Mo
                PIECE=18 # 256 Ko
        elif [ "$TAILLE" -lt 1048576 ]; then # - de 1 Go
                PIECE=19 # 512 Ko
        elif [ "$TAILLE" -lt 2097152 ]; then # - de 2 Go
                PIECE=20 # 1 Mo
        elif [ "$TAILLE" -lt 4194304 ]; then # - de 4 Go
                PIECE=21  # 2 Mo
        elif [ "$TAILLE" -lt 8388608 ]; then # - de 8 Go
                PIECE=22 # 4 Mo
        elif [ "$TAILLE" -lt 16777216 ]; then # - de 16 Go
                PIECE=23 # 8 Mo
        elif [ "$TAILLE" -lt 33554432 ]; then # - de 32 Go
                PIECE=24 # 16 Mo
        elif [ "$TAILLE" -ge 33554432 ]; then # + de 32 Go
                PIECE=25 # 32 Mo
        fi
}

FONCAUTOXXX () {
        TAILLE=$(du -s "$UPXXX"/"$FILE" | awk '{ print $1 }')
        if [ "$TAILLE" -lt 65536 ]; then # - de 64 Mo
                PIECE=15 # 32 Ko
        elif [ "$TAILLE" -lt 131072 ]; then # - de 128 Mo
                PIECE=16 # 64 Ko
        elif [ "$TAILLE" -lt 262144 ]; then # - de 256 Mo
                PIECE=17 # 128 Ko
        elif [ "$TAILLE" -lt 524288 ]; then # - de 512 Mo
                PIECE=18 # 256 Ko
        elif [ "$TAILLE" -lt 1048576 ]; then # - de 1 Go
                PIECE=19 # 512 Ko
        elif [ "$TAILLE" -lt 2097152 ]; then # - de 2 Go
                PIECE=20 # 1 Mo
        elif [ "$TAILLE" -lt 4194304 ]; then # - de 4 Go
                PIECE=21  # 2 Mo
        elif [ "$TAILLE" -lt 8388608 ]; then # - de 8 Go
                PIECE=22 # 4 Mo
        elif [ "$TAILLE" -lt 16777216 ]; then # - de 16 Go
                PIECE=23 # 8 Mo
        elif [ "$TAILLE" -lt 33554432 ]; then # - de 32 Go
                PIECE=24 # 16 Mo
        elif [ "$TAILLE" -ge 33554432 ]; then # + de 32 Go
                PIECE=25 # 32 Mo
        fi
}
###

# Fonction creation des .torrents
FONCCREATESERIE () {
	mktorrent -p -l "$PIECE" -a "$TRACKER" -t "$THREAD" "$UPSERIE"/"$FILE"
	chown "$USER" "$FILE".torrent
}

FONCCREATEFILM () {
        mktorrent -p -l "$PIECE" -a "$TRACKER" -t "$THREAD" "$UPFILM"/"$FILE"
        chown "$USER" "$FILE".torrent
}

FONCCREATEANIMATION () {
        mktorrent -p -l "$PIECE" -a "$TRACKER" -t "$THREAD" "$UPANIMATION"/"$FILE"
        chown "$USER" "$FILE".torrent
}

FONCCREATEJEU () {
        mktorrent -p -l "$PIECE" -a "$TRACKER" -t "$THREAD" "$UPJEU"/"$FILE"
        chown "$USER" "$FILE".torrent
}

FONCCREATEMUSIQUE () {
        mktorrent -p -l "$PIECE" -a "$TRACKER" -t "$THREAD" "$UPMUSIQU"/"$FILE"
        chown "$USER" "$FILE".torrent
}

FONCCREATEXXX () {
        mktorrent -p -l "$PIECE" -a "$TRACKER" -t "$THREAD" "$UPXXX"/"$FILE"
        chown "$USER" "$FILE".torrent
}
###

# NFO
# Creation repertoire nfo et .torrent
FONCCREATESTOCKNFO () {
	if [ ! -d "$STOCKNFO" ]; then
                echo "Creation du dossier de stockage des fichiers .nfo..."
                mkdir "$STOCKNFO"
                chown -Rf "$USER" "$STOCKNFO" && chmod 755 "$STOCKNFO"
        fi
}
FONCCREATESTOCKTOR () {
        if [ ! -d "/home/$USER/stocktorrents" ]; then
                echo "Creation du dossier de stockage des fichiers .torrent..."
                mkdir "/home/$USER/stocktorrents"
                chown -Rf "$USER" "/home/$USER/stocktorrents" && chmod 755 "/home/$USER/stocktorrents"
        fi
}
# Fonction creation .nfo
FONCCREATENFOSERIE () {
	mediainfo  --logfile="$STOCKNFO"/"$FILE".nfo "$UPSERIE"/"$FILE"
}
FONCCREATENFOFILM () {
        mediainfo  --logfile="$STOCKNFO"/"$FILE".nfo "$UPFILM"/"$FILE"
}
FONCCREATENFOANIMATION () {
        mediainfo  --logfile="$STOCKNFO"/"$FILE".nfo "$UPANIMATION"/"$FILE"
}
FONCCREATENFOMUSIQUE () {
        mediainfo  --logfile="$STOCKNFO"/"$FILE".nfo "$UPMUSIQUE"/"$FILE"
}
FONCCREATENFOXXX () {
        mediainfo  --logfile="$STOCKNFO"/"$FILE".nfo "$UPXXX"/"$FILE"
}

###

# Creation repertoire des .torrent. Ils sont tries pour faciliter la recuperation par categorie.
FONCCREATESTOCKTORSERIE () {
        if [ ! -d "$TORSERIE" ]; then
                echo "Creation du dossier de stockage des fichiers .torrent pour les series..."
                mkdir "$TORSERIE"
                chown -Rf "$USER" "$TORSERIE" && chmod 755 "$TORSERIE"
        fi
}
FONCCREATESTOCKTORFILM () {
        if [ ! -d "$TORFILM" ]; then
                echo "Creation du dossier de stockage des fichiers .torrent pour les films..."
                mkdir "$TORFILM"
                chown -Rf "$USER" "$TORFILM" && chmod 755 "$TORFILM"
        fi
}
FONCCREATESTOCKTORANIMATION () {
        if [ ! -d "$TORANIMATION" ]; then
                echo "Creation du dossier de stockage des fichiers .torrent pour les animations..."
                mkdir "$TORANIMATION"
                chown -Rf "$USER" "$TORANIMATION" && chmod 755 "$TORANIMATION"
        fi
}
FONCCREATESTOCKTORJEU () {
        if [ ! -d "$TORJEU" ]; then
                echo "Creation du dossier de stockage des fichiers .torrent pour les jeux..."
                mkdir "$TORJEU"
                chown -Rf "$USER" "$TORJEU" && chmod 755 "$TORJEU"
        fi
}
FONCCREATESTOCKTORMUSIQUE () {
        if [ ! -d "$TORMUSIQUE" ]; then
                echo "Creation du dossier de stockage des fichiers .torrent pour les musiques..."
                mkdir "$TORMUSIQUE"
                chown -Rf "$USER" "$TORMUSIQUE" && chmod 755 "$TORMUSIQUE"
        fi
}
FONCCREATESTOCKTORXXX () {
        if [ ! -d "$TORXXX" ]; then
                echo "Creation du dossier de stockage des fichiers .torrent pour les videos XXX..."
                mkdir "$TORXXX"
                chown -Rf "$USER" "$TORXXX" && chmod 755 "$TORXXX"
        fi
}
###

# Script
if [ "$1" = "--serie" ]; then
	if [ ! -d "$UPSERIE" ]; then
		echo "Creation du dossier series..."
		mkdir "$UPSERIE"
		chown -Rf "$USER" && chmod 755 "$UPSERIE"
	fi
	echo "Veullez saisir le nom du fichier ou du dossier"
	read FILE
	FONCCREATESTOCKTORSERIE
	if [ -f "$TORSERIE"/"$FILE".torrent ]; then
		echo "Le fichier .torrent existe deja."
	fi
	FONCAUTOSERIE
	FONCCREATESERIE
	mv "$FILE".torrent "$TORSERIE"/"$FILE".torrent
	FONCCREATESTOCKNFO
	FONCCREATENFOSERIE

elif [ "$1" = "--film" ]; then
	if [ ! -d "$UPFILM" ]; then
                echo "Creation du dossier film..."
                mkdir "$UPFILM"
                chown -Rf "$USER" && chmod 755 "$UPFILM"
        fi
        if [ -f "$TORFILM"/"$FILE".torrent ]; then
                echo "Le fichier .torrent existe deja."
        fi
        echo "Veullez saisir le nom du fichier ou du dossier"
        read FILE
	FONCCREATESTOCKTORFILM
        FONCAUTOFILM
        FONCCREATEFILM
        mv "$FILE".torrent "$TORFILM"/"$FILE".torrent
	FONCCREATESTOCKNFO
	FONCCREATENFOFILM

elif [ "$1" = "--animation" ]; then
	if [ ! -d "$UPANIMATION" ]; then
                echo "Creation du dossier animation..."
                mkdir "$UPANIMATION"
                chown -Rf "$USER" && chmod 755 "$UPANIMATION"
        fi
        echo "Veullez saisir le nom du fichier ou du dossier"
        read FILE
	FONCCREATESTOCKTORANIMATION
        if [ -f "$TORANIMATION"/"$FILE".torrent ]; then
                echo "Le fichier .torrent existe deja."
        fi
        FONCAUTOANIMATION
        FONCCREATEANIMATION
        mv "$FILE".torrent "$TORANIMATION"/"$FILE".torrent
	FONCCREATESTOCKNFO
	FONCCREATENFOANIMATION

elif [ "$1" = "--jeu" ]; then
	if [ ! -d "$UPJEU" ]; then
                echo "Creation du dossier jeux..."
                mkdir "$UPJEU"
                chown -Rf "$USER" && chmod 755 "$UPJEU"
        fi
        echo "Veullez saisir le nom du fichier ou du dossier"
        read FILE
	FONCCREATESTOCKTORJEU
        if [ -f "$TORJEU"/"$FILE".torrent ]; then
                echo "Le fichier .torrent existe deja."
        fi
        FONCAUTOJEU
        FONCCREATEJEU
        mv "$FILE".torrent "$TORJEU"/"$FILE".torrent

elif [ "$1" = "--musique" ]; then
	if [ ! -d "$UPMUSIQUE" ]; then
                echo "Creation du dossier musique..."
                mkdir "$UPMUSIQUE"
                chown -Rf "$USER" && chmod 755 "$UPMUSIQUE"
        fi
        if [ -f "$TORMUSIQUE"/"$FILE".torrent ]; then
                echo "Le fichier .torrent existe deja."
        fi
        echo "Veullez saisir le nom du fichier ou du dossier"
        read FILE
	FONCCREATESTOCKTORMUSIQUE
        FONCAUTOMUSIQUE
        FONCCREATEMUSIQUE
        mv "$FILE".torrent "$TORMUSIQUE"/"$FILE".torrent
        FONCCREATESTOCKNFO
	FONCCREATENFOMUSIQUE

elif [ "$1" = "--xxx" ]; then
	if [ ! -d "$UPXXX" ]; then
                echo "Creation du dossier pour adultes..."
                mkdir "$UPXXX"
                chown -Rf "$USER" && chmod 755 "$UPXXX"
        fi
        echo "Veullez saisir le nom du fichier ou du dossier"
        read FILE
	FONCCREATESTOCKTORXXX
        if [ -f "$TORXXX"/"$FILE".torrent ]; then
                echo "Le fichier .torrent existe deja."
        fi
        FONCAUTOXXX
        FONCCREATEXXX
        mv "$FILE".torrent "$TORMUSIQUE"/"$FILE".torrent
        FONCCREATESTOCKNFO
	FONCCREATENFOXXX
fi
