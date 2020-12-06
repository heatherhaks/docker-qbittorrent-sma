# docker-qbittorrent-sma
A modification of linuxserver/qbittorrent to include sickbeard mp4 automator

The following is an example of a docker-compose setup for this image:

```
version: '2.1'
services:
  qbittorrent:
    image: halfdeadgames/qbittorrent-sma
    container_name: qbittorrent
    environment:
      - PUID=1001 #set to your UID
      - PGID=1001 #set to your GID
      - TZ=<TimeZone info, for example America/Boise>
      - UMASK_SET=000
      - WEBUI_PORT=8080
    volumes:
      - /mnt/storage/config/qbittorrent:/config #the location of qbittorrent's config files
      - /mnt/storage/downloads/complete:/downloads/complete #the location where you want to store your downloads
      - /mnt/storage/config/sma/config:/mp4automator/config #the location of autoProcess.ini
    ports:
      - 6881:6881
      - 6881:6881/udp
      - 8080:8080 #should match the webui port environment variable
    restart: unless-stopped
```

Once started up, connect to the webui of qBittorrent. On the host machine this should be `localhost:8080` unless you've changed the webui port. In Options, in the Downloads tab, check the checkbox to run an external program on download finish. Enter precisely this: `/usr/bin/python /mp4automator/qBittorrentPostProcess.py "%L" "%T" "%R" "%F" "%N" "%I"`

Also inside the Downloads tab set where you want to keep complete/incomplete downloads relative to `/downloads/` or whatever other volumes you might add in your compose file.

Now would also be a good time to change  your webui password in the Web UI tab.

It stumped me for a while so I've decided to note it here for others to learn from. Sonarr/Radarr only delete torrents when the torrent stops seeding, regardless of settings inside Sonarr/Radarr. As such, you should set qBittorrent's seeding settings according to your needs in file management.

Now, configure your autoProcess.ini. You can grab a default copy from the github for sickbeard mp4 automator, in the config folder. Rename it so the extension is `.ini` and not `.sample`

In the section `[Converter]`, configure the following settings precisely as given here:

```
ffmpeg = /usr/bin/ffmpeg
ffprobe = /usr/bin/ffprobe
```

You may also want to change the permissions in the `[Permissions]` section to allow your other apps, such as Sonarr/Radarr, to access them.

Finally, in the `qBittorrent` section, set the `host` setting to `localhost`. Input your qBittorrent Web UI username and password in the appropriate places. Finally, set the output-directory to wherever you set qBittorrent to store completed downloads. Remember to set the various apps you may use to use whatever label you use in this setting corresponding with the app. For example, if using the default setting for radarr in this section, the label should be `radarr`, so within Radarr when you add qBittorrent as a download client be sure to set the label to `radarr`.
