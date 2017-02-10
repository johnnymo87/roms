This script is meant to target the "most downloaded" section of a given ROM on www.emuparadise.me. Some pages are formatted different (e.g. the N64 page), and this script needs manual adjustment for those situations.

Example usage:
```sh
./app.rb /Neo-Geo_CD_ISOs/8 /Volumes/USB30FD/retropie/roms/neogeo
```

This assumes you've got a flash drive plugged into your computer at `/Volumes/USB30FD` and it has the directory stucture of the retropie filesystem (e.g. `retropie/roms/neogeo`).
