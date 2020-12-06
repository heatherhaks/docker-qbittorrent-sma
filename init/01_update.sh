#!/usr/bin/with-contenv bash
echo "updating packages"
apt-get update && apt-get upgrade

echo "installing pip packages"
pip install --upgrade PIP
pip install --upgrade requests
pip install --upgrade requests[security]
pip install --upgrade requests-cache
pip install --upgrade babelfish
pip install --upgrade 'guessit<2'
pip install --upgrade 'subliminal<2'
pip install --upgrade qtfaststart
pip install --upgrade python-qbittorrent
pip install --upgrade gevent
pip install --upgrade tmdbsimple
pip install --upgrade mutagen
pip uninstall --yes stevedore
pip install stevedore==1.19.1
