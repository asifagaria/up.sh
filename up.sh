#!/bin/bash
# Auteur : Asifagaria
# Optimizes for Plex Media Server
# Creation of .torrent and .nfo with double check .torrent
###

# Variables
# Principal
USER="asifagaria" # User seedbox
TRACKER="http://jack.yggtorrent.com:8080/passkey/announce" #replace passkey with your private key
# Upload folder (edit with your exact locations)
UPSERIE="/home/$USER/torrents/series"
UPFILM="/home/$USER/server/HD-4/Games-5"
UPANIMATION="/home/$USER/torrents/animation"
UPGAME="/home/$USER/server/HD-4/Games-5"
UPMUSIC="/home/$USER/torrents/MUSIC"
UPEXTRA="/home/$USER/torrents/ext"
# Storage folder .torrent
TORSERIE="/home/$USER/stocktorrents/series"
TORFILM="/home/$USER/stocktorrents/film"
TORANIMATION="/home/$USER/stocktorrents/animation"
TORGAME="/home/$USER/stocktorrents/games"
TORMUSIC="/home/$USER/stocktorrents/MUSIC"
TOREXTRA="/home/$USER/stocktorrents/ext"
# .Nfo storage folder (to easily retrieve .nfo)
STOCKNFO="/home/$USER/nfo"
###

# Recuperation threads
THREAD=$(grep -c processor < /proc/cpuinfo)
if [ "$THREAD" = "" ]; then
	THREAD=1
fi
###

# Test of presence
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

# Detection of the size of the file (s)
FONCAUTOSERIE () {
	TAILLE=$(du -s "$UPSERIE"/"$FILE" | awk '{ print $1 }')
	if [ "$TAILLE" -lt 65536 ]; then # - of 64 Mb
		PIECE=15 # 32 Kb
	elif [ "$TAILLE" -lt 131072 ]; then # - of 128 Mb
		PIECE=16 # 64 Kb
	elif [ "$TAILLE" -lt 262144 ]; then # - of 256 Mb
		PIECE=17 # 128 Kb
	elif [ "$TAILLE" -lt 524288 ]; then # - of 512 Mb
		PIECE=18 # 256 Kb
	elif [ "$TAILLE" -lt 1048576 ]; then # - of 1 Gb
		PIECE=19 # 512 Kb
	elif [ "$TAILLE" -lt 2097152 ]; then # - of 2 Gb
		PIECE=20 # 1 Mb
	elif [ "$TAILLE" -lt 4194304 ]; then # - of 4 Gb
		PIECE=21  # 2 Mb
	elif [ "$TAILLE" -lt 8388608 ]; then # - of 8 Gb
		PIECE=22 # 4 Mb
	elif [ "$TAILLE" -lt 16777216 ]; then # - of 16 Gb
		PIECE=23 # 8 Mb
	elif [ "$TAILLE" -lt 33554432 ]; then # - of 32 Gb
		PIECE=24 # 16 Mb
	elif [ "$TAILLE" -ge 33554432 ]; then # + of 32 Gb
		PIECE=25 # 32 Mb
	fi
}

FONCAUTOFILM () {
        TAILLE=$(du -s "$UPFILM"/"$FILE" | awk '{ print $1 }')
        if [ "$TAILLE" -lt 65536 ]; then # - of 64 Mb
                PIECE=15 # 32 Kb
        elif [ "$TAILLE" -lt 131072 ]; then # - of 128 Mb
                PIECE=16 # 64 Kb
        elif [ "$TAILLE" -lt 262144 ]; then # - of 256 Mb
                PIECE=17 # 128 Kb
        elif [ "$TAILLE" -lt 524288 ]; then # - of 512 Mb
                PIECE=18 # 256 Kb
        elif [ "$TAILLE" -lt 1048576 ]; then # - of 1 Gb
                PIECE=19 # 512 Kb
        elif [ "$TAILLE" -lt 2097152 ]; then # - of 2 Gb
                PIECE=20 # 1 Mb
        elif [ "$TAILLE" -lt 4194304 ]; then # - of 4 Gb
                PIECE=21  # 2 Mb
        elif [ "$TAILLE" -lt 8388608 ]; then # - of 8 Gb
                PIECE=22 # 4 Mb
        elif [ "$TAILLE" -lt 16777216 ]; then # - of 16 Gb
                PIECE=23 # 8 Mb
        elif [ "$TAILLE" -lt 33554432 ]; then # - of 32 Gb
                PIECE=24 # 16 Mb
        elif [ "$TAILLE" -ge 33554432 ]; then # + of 32 Gb
                PIECE=25 # 32 Mb
        fi
}

FONCAUTOANIMATION () {
        TAILLE=$(du -s "$UPANIMATION"/"$FILE" | awk '{ print $1 }')
        if [ "$TAILLE" -lt 65536 ]; then # - of 64 Mb
                PIECE=15 # 32 Kb
        elif [ "$TAILLE" -lt 131072 ]; then # - of 128 Mb
                PIECE=16 # 64 Kb
        elif [ "$TAILLE" -lt 262144 ]; then # - of 256 Mb
                PIECE=17 # 128 Kb
        elif [ "$TAILLE" -lt 524288 ]; then # - of 512 Mb
                PIECE=18 # 256 Kb
        elif [ "$TAILLE" -lt 1048576 ]; then # - of 1 Gb
                PIECE=19 # 512 Kb
        elif [ "$TAILLE" -lt 2097152 ]; then # - of 2 Gb
                PIECE=20 # 1 Mb
        elif [ "$TAILLE" -lt 4194304 ]; then # - of 4 Gb
                PIECE=21  # 2 Mb
        elif [ "$TAILLE" -lt 8388608 ]; then # - of 8 Gb
                PIECE=22 # 4 Mb
        elif [ "$TAILLE" -lt 16777216 ]; then # - of 16 Gb
                PIECE=23 # 8 Mb
        elif [ "$TAILLE" -lt 33554432 ]; then # - of 32 Gb
                PIECE=24 # 16 Mb
        elif [ "$TAILLE" -ge 33554432 ]; then # + of 32 Gb
                PIECE=25 # 32 Mb
        fi
}

FONCAUTOGAME () {
        TAILLE=$(du -s "$UPGAME"/"$FILE" | awk '{ print $1 }')
        if [ "$TAILLE" -lt 65536 ]; then # - of 64 Mb
                PIECE=15 # 32 Kb
        elif [ "$TAILLE" -lt 131072 ]; then # - of 128 Mb
                PIECE=16 # 64 Kb
        elif [ "$TAILLE" -lt 262144 ]; then # - of 256 Mb
                PIECE=17 # 128 Kb
        elif [ "$TAILLE" -lt 524288 ]; then # - of 512 Mb
                PIECE=18 # 256 Kb
        elif [ "$TAILLE" -lt 1048576 ]; then # - of 1 Gb
                PIECE=19 # 512 Kb
        elif [ "$TAILLE" -lt 2097152 ]; then # - of 2 Gb
                PIECE=20 # 1 Mb
        elif [ "$TAILLE" -lt 4194304 ]; then # - of 4 Gb
                PIECE=21  # 2 Mb
        elif [ "$TAILLE" -lt 8388608 ]; then # - of 8 Gb
                PIECE=22 # 4 Mb
        elif [ "$TAILLE" -lt 16777216 ]; then # - of 16 Gb
                PIECE=23 # 8 Mb
        elif [ "$TAILLE" -lt 33554432 ]; then # - of 32 Gb
                PIECE=24 # 16 Mb
        elif [ "$TAILLE" -ge 33554432 ]; then # + of 32 Gb
                PIECE=25 # 32 Mb
        fi
}

FONCAUTOMUSIC () {
        TAILLE=$(du -s "$UPMUSIC"/"$FILE" | awk '{ print $1 }')
        if [ "$TAILLE" -lt 65536 ]; then # - of 64 Mb
                PIECE=15 # 32 Kb
        elif [ "$TAILLE" -lt 131072 ]; then # - of 128 Mb
                PIECE=16 # 64 Kb
        elif [ "$TAILLE" -lt 262144 ]; then # - of 256 Mb
                PIECE=17 # 128 Kb
        elif [ "$TAILLE" -lt 524288 ]; then # - of 512 Mb
                PIECE=18 # 256 Kb
        elif [ "$TAILLE" -lt 1048576 ]; then # - of 1 Gb
                PIECE=19 # 512 Kb
        elif [ "$TAILLE" -lt 2097152 ]; then # - of 2 Gb
                PIECE=20 # 1 Mb
        elif [ "$TAILLE" -lt 4194304 ]; then # - of 4 Gb
                PIECE=21  # 2 Mb
        elif [ "$TAILLE" -lt 8388608 ]; then # - of 8 Gb
                PIECE=22 # 4 Mb
        elif [ "$TAILLE" -lt 16777216 ]; then # - of 16 Gb
                PIECE=23 # 8 Mb
        elif [ "$TAILLE" -lt 33554432 ]; then # - of 32 Gb
                PIECE=24 # 16 Mb
        elif [ "$TAILLE" -ge 33554432 ]; then # + of 32 Gb
                PIECE=25 # 32 Mb
        fi
}

FONCAUTOEXTRA () {
        TAILLE=$(du -s "$UPEXTRA"/"$FILE" | awk '{ print $1 }')
        if [ "$TAILLE" -lt 65536 ]; then # - of 64 Mb
                PIECE=15 # 32 Kb
        elif [ "$TAILLE" -lt 131072 ]; then # - of 128 Mb
                PIECE=16 # 64 Kb
        elif [ "$TAILLE" -lt 262144 ]; then # - of 256 Mb
                PIECE=17 # 128 Kb
        elif [ "$TAILLE" -lt 524288 ]; then # - of 512 Mb
                PIECE=18 # 256 Kb
        elif [ "$TAILLE" -lt 1048576 ]; then # - of 1 Gb
                PIECE=19 # 512 Kb
        elif [ "$TAILLE" -lt 2097152 ]; then # - of 2 Gb
                PIECE=20 # 1 Mb
        elif [ "$TAILLE" -lt 4194304 ]; then # - of 4 Gb
                PIECE=21  # 2 Mb
        elif [ "$TAILLE" -lt 8388608 ]; then # - of 8 Gb
                PIECE=22 # 4 Mb
        elif [ "$TAILLE" -lt 16777216 ]; then # - of 16 Gb
                PIECE=23 # 8 Mb
        elif [ "$TAILLE" -lt 33554432 ]; then # - of 32 Gb
                PIECE=24 # 16 Mb
        elif [ "$TAILLE" -ge 33554432 ]; then # + of 32 Gb
                PIECE=25 # 32 Mb
        fi
}
###

# Function creation of .torrents
FONCCREATESERIE () {
	mktorrent -p -l "$PIECE" -a "$TRACKER" "$UPSERIE"/"$FILE"
	chown "$USER" "$FILE".torrent
}

FONCCREATEFILM () {
        mktorrent -p -l "$PIECE" -a "$TRACKER" "$UPFILM"/"$FILE"
        chown "$USER" "$FILE".torrent
}

FONCCREATEANIMATION () {
        mktorrent -p -l "$PIECE" -a "$TRACKER" "$UPANIMATION"/"$FILE"
        chown "$USER" "$FILE".torrent
}

FONCCREATEGAME () {
        mktorrent -p -l "$PIECE" -a "$TRACKER" "$UPGAME"/"$FILE"
        chown "$USER" "$FILE".torrent
}

FONCCREATEMUSIC () {
        mktorrent -p -l "$PIECE" -a "$TRACKER" "$UPMUSIQU"/"$FILE"
        chown "$USER" "$FILE".torrent
}

FONCCREATEEXTRA () {
        mktorrent -p -l "$PIECE" -a "$TRACKER" "$UPEXTRA"/"$FILE"
        chown "$USER" "$FILE".torrent
}
###

# NFO
# Creation nfo directory and .torrent
FONCCREATESTOCKNFO () {
	if [ ! -d "$STOCKNFO" ]; then
                echo "Creation of the file storage folder .nfo..."
                mkdir "$STOCKNFO"
                chown -Rf "$USER" "$STOCKNFO" && chmod 755 "$STOCKNFO"
        fi
}
FONCCREATESTOCKTOR () {
        if [ ! -d "/home/$USER/stocktorrents" ]; then
                echo "Creation of the file storage folder .torrent..."
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
FONCCREATENFOGAME () {
        mediainfo  --logfile="$STOCKNFO"/"$FILE".nfo "$UPGAME"/"$FILE"
}
FONCCREATENFOANIMATION () {
        mediainfo  --logfile="$STOCKNFO"/"$FILE".nfo "$UPANIMATION"/"$FILE"
}
FONCCREATENFOMUSIC () {
        mediainfo  --logfile="$STOCKNFO"/"$FILE".nfo "$UPMUSIC"/"$FILE"
}
FONCCREATENFOEXTRA () {
        mediainfo  --logfile="$STOCKNFO"/"$FILE".nfo "$UPEXTRA"/"$FILE"
}

###

# Creation of .torrent directory. They are sorted to facilitate recovery by category.
FONCCREATESTOCKTORSERIE () {
        if [ ! -d "$TORSERIE" ]; then
                echo "Creation of the file storage folder .torrent for the series..."
                mkdir "$TORSERIE"
                chown -Rf "$USER" "$TORSERIE" && chmod 755 "$TORSERIE"
        fi
}
FONCCREATESTOCKTORFILM () {
        if [ ! -d "$TORFILM" ]; then
                echo "Creation of the file storage folder .torrent for the films..."
                mkdir "$TORFILM"
                chown -Rf "$USER" "$TORFILM" && chmod 755 "$TORFILM"
        fi
}
FONCCREATESTOCKTORANIMATION () {
        if [ ! -d "$TORANIMATION" ]; then
                echo "Creation of the file storage folder .torrent for the animations..."
                mkdir "$TORANIMATION"
                chown -Rf "$USER" "$TORANIMATION" && chmod 755 "$TORANIMATION"
        fi
}
FONCCREATESTOCKTORGAME () {
        if [ ! -d "$TORGAME" ]; then
                echo "Creation of the file storage folder .torrent for the games..."
                mkdir "$TORGAME"
                chown -Rf "$USER" "$TORGAME" && chmod 755 "$TORGAME"
        fi
}
FONCCREATESTOCKTORMUSIC () {
        if [ ! -d "$TORMUSIC" ]; then
                echo "Creation of the file storage folder .torrent for the MUSICs..."
                mkdir "$TORMUSIC"
                chown -Rf "$USER" "$TORMUSIC" && chmod 755 "$TORMUSIC"
        fi
}
FONCCREATESTOCKTOREXTRA () {
        if [ ! -d "$TOREXTRA" ]; then
                echo "Creation of the file storage folder .torrent for the videos EXTRA..."
                mkdir "$TOREXTRA"
                chown -Rf "$USER" "$TOREXTRA" && chmod 755 "$TOREXTRA"
        fi
}
###

# Script
if [ "$1" = "--serie" ]; then
	if [ ! -d "$UPSERIE" ]; then
		echo "Creation of the file series..."
		mkdir "$UPSERIE"
		chown -Rf "$USER" && chmod 755 "$UPSERIE"
	fi
	echo "Please enter the name of the file or folder"
	read FILE
	FONCCREATESTOCKTORSERIE
	if [ -f "$TORSERIE"/"$FILE".torrent ]; then
		echo "The file .torrent there is left."
	fi
	FONCAUTOSERIE
	FONCCREATESERIE
	mv "$FILE".torrent "$TORSERIE"/"$FILE".torrent
	FONCCREATESTOCKNFO
	FONCCREATENFOSERIE

elif [ "$1" = "--film" ]; then
	if [ ! -d "$UPFILM" ]; then
                echo "Creation of the file film..."
                mkdir "$UPFILM"
                chown -Rf "$USER" && chmod 755 "$UPFILM"
        fi
        if [ -f "$TORFILM"/"$FILE".torrent ]; then
                echo "The file .torrent there is left."
        fi
        echo "Please enter the name of the file or folder"
        read FILE
	FONCCREATESTOCKTORFILM
        FONCAUTOFILM
        FONCCREATEFILM
        mv "$FILE".torrent "$TORFILM"/"$FILE".torrent
	FONCCREATESTOCKNFO
	FONCCREATENFOFILM

elif [ "$1" = "--animation" ]; then
	if [ ! -d "$UPANIMATION" ]; then
                echo "Creation of the file animation..."
                mkdir "$UPANIMATION"
                chown -Rf "$USER" && chmod 755 "$UPANIMATION"
        fi
        echo "Please enter the name of the file or folder"
        read FILE
	FONCCREATESTOCKTORANIMATION
        if [ -f "$TORANIMATION"/"$FILE".torrent ]; then
                echo "The file .torrent there is left."
        fi
        FONCAUTOANIMATION
        FONCCREATEANIMATION
        mv "$FILE".torrent "$TORANIMATION"/"$FILE".torrent
	FONCCREATESTOCKNFO
	FONCCREATENFOANIMATION

elif [ "$1" = "--game" ]; then
	if [ ! -d "$UPGAME" ]; then
                echo "Creation of the file games..."
                mkdir "$UPGAME"
                chown -Rf "$USER" && chmod 755 "$UPGAME"
        fi
        echo "Please enter the name of the file or folder"
        read FILE
	FONCCREATESTOCKTORGAME
        if [ -f "$TORGAME"/"$FILE".torrent ]; then
                echo "The file .torrent there is left."
        fi
        FONCAUTOGAME
        FONCCREATEGAME
        mv "$FILE".torrent "$TORGAME"/"$FILE".torrent
    FONCCREATESTOCKNFO
	FONCCREATENFOGAME

elif [ "$1" = "--music" ]; then
	if [ ! -d "$UPMUSIC" ]; then
                echo "Creation of the file music..."
                mkdir "$UPMUSIC"
                chown -Rf "$USER" && chmod 755 "$UPMUSIC"
        fi
        if [ -f "$TORMUSIC"/"$FILE".torrent ]; then
                echo "The file .torrent there is left."
        fi
        echo "Please enter the name of the file or folder"
        read FILE
	FONCCREATESTOCKTORMUSIC
        FONCAUTOMUSIC
        FONCCREATEMUSIC
        mv "$FILE".torrent "$TORMUSIC"/"$FILE".torrent
        FONCCREATESTOCKNFO
	FONCCREATENFOMUSIC

elif [ "$1" = "--extra" ]; then
	if [ ! -d "$UPEXTRA" ]; then
                echo "Creation of the file For Extra..."
                mkdir "$UPEXTRA"
                chown -Rf "$USER" && chmod 755 "$UPEXTRA"
        fi
        echo "Please enter the name of the file or folder"
        read FILE
	FONCCREATESTOCKTOREXTRA
        if [ -f "$TOREXTRA"/"$FILE".torrent ]; then
                echo "The file .torrent there is left."
        fi
        FONCAUTOEXTRA
        FONCCREATEEXTRA
        mv "$FILE".torrent "$TORMUSIC"/"$FILE".torrent
        FONCCREATESTOCKNFO
	FONCCREATENFOEXTRA
fi
