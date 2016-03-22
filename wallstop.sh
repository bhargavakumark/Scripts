killall -9 wallchanger.sh
# For gnome
gsettings set org.gnome.desktop.background picture-uri "asdfasdf.jpg"
# For xfce
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "/usr/share/xfce4/backdrops/linuxmint.png"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVBOX0/workspace0/last-image -s "/usr/share/xfce4/backdrops/linuxmint.png"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorLVDS-0/workspace0/last-image -s "/usr/share/xfce4/backdrops/linuxmint.png"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorDP-3/workspace0/last-image -s "/usr/share/xfce4/backdrops/linuxmint.png"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorDP-0/workspace0/last-image -s "/usr/share/xfce4/backdrops/linuxmint.png"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitoreDP1/workspace0/last-image -s "/usr/share/xfce4/backdrops/linuxmint.png"

#gconftool-2 -s /desktop/gnome/background/picture_filename -t string asdfasdf.jpg

