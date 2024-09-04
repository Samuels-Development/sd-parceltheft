# sd-parceltheft

`sd-parceltheft` is a straightforward script that lets players steal parcels from houses and open them for random rewards. Parcels are synced globally, with taken parcels respawning after a set time. The script includes 23 default locations, with easy customization to add more. Props dynamically spawn and despawn based on player proximity.

## 🎥 Preview
https://streamable.com/6bnx5d

## 🔔 Contact
Author: Samuel#0008  
Discord: [Join the Discord](https://discord.gg/samueldev)<br>
Store: [Click Me](https://fivem.samueldev.shop) (use code `qbox` at checkout)

## 💾 Installation
1. Download the latest release from the [GitHub repository](https://github.com/Samuels-Development/sd-parceltheft/releases).
2. Extract the downloaded file and rename the folder to `sd-parceltheft`.
3. Place the `sd-parceltheft` folder into your server's `resources` directory.
4. Add `ensure sd-parceltheft` to your `server.cfg` to ensure the resource starts with your server.

## 📦 Item
Add an item called 'parcel' to your inventory or framework.

If you're using `qb-core`, add it in `qb-core/shared/items.lua`.<br>
If you're using `es_extended`, add it to the items table in your database (or whatever it is that ESX users do lol)

In the case of `ox_inventory`, add the following to the items.lua:
```lua
	["parcel"] = {
		label = "Parcel",
		weight = 350,
		stack = false,
		close = true,
		consume = 0,
		description = "Small package filled with something.",
		client = {
			image = "parcel.png",
		},
		server = {
			export = 'sd-parceltheft.useParcel'
		}
	},
```

## 📖 Dependencies
[SD Library](https://github.com/Samuels-Development/sd_lib/releases)

By utilizing my library, this script is compatible with `QBCore`, `QBox`, and `ESX` frameworks. In terms of interaction methods, it supports `qb-target`, `qtarget`, and `ox_target`, as well as `qb-drawtext`, `cd_drawtextui`, and `ox_lib's` textUI.
