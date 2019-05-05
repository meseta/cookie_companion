# Cookie Companion
![Cookie Companion Title Card](https://github.com/meseta/cookie_companion/blob/master/assets/cookie_companion_gm48icon.gif)

## About
This is the source code for my entry to the 48 hour [28th GM48](https://gm48.net/) game jam; the theme was "Companion". The released game can be [found on GM48.net](https://gm48.net/game/1037/cookie-companion-mmo)

The jam was an opportunity for me to explore a few topics:
* Network Multiplayer
* RPC in netcode
* Not bothering with binary packets and just using JSON
* Horizontally scaling server architecture

I'm now open-sourcing the code for educational purposes.

## Additional files
This project uses the font [Press Start 2P](https://fonts.google.com/specimen/Press+Start+2P) ([Open Font License](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL_web)) The font file is not included in the project, you will need to install it in your system.

The server is built using the following technologies:
* Docker, docker-compose
* Python
* Python Twisted framework
* Redis
* Python txredisapi library