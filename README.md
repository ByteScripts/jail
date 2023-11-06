<div align='center'><img src='https://github.com/Mirrrrrow/byte_licenses/assets/95571243/bd44ecf7-36a0-4ee5-8845-622f436ebacb' width='100rem'/></div>
<div align='center'><h2>BYTE-SCRIPTS</h2></div>

### Description
Simple automatic jail-system. Performance: 0.00ms and up to 0.01ms (while in use)
Attention: to use this script properly you need another script like an mdt to manage the jailtime. The methods for setting Jailtime are written down here but you could also just add or set values via the created column.

### WIP
This script is in the ALPHA. Use it with your own risk.

### Preview
TODO: @mirow

### Setup
You can just start the script. Changes can be made in the [Settings](data/settings.lua) file.

### Methods
**Adding Jailtime**:
```lua
    exports['jail']:addWanteds(playerId, time)
```
**Removing Jailtime**:
```lua
    exports['jail']:removeWanteds(playerId, time)
```
**Setting Jailtime**:
```lua
    exports['jail']:setWanteds(playerId, time)
```

### Dependencies
- oxmysql
- ox_lib
- es_extended (Legacy)

### Links
- Discord: https://discord.gg/6XwewsSk9W