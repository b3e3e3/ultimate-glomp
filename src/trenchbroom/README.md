# README
This repository will update frequently. It is designed to be contributed to alongside the [Main Game Repository](https://github.com/b3e3e3/ultimate-glomp).
Feel free to add new textures, entities, or whatever is needed! To add anything other than textures, you will need to use the main game repository to access the tooling within the Godot editor.

# Prerequisites

You will need to clone the [Main Game Repository](https://github.com/b3e3e3/ultimate-glomp). This repo alone is **not enough to make levels with** because you need the game project to generate the FGD and config files.

You will also need [TrenchBroom editor](https://trenchbroom.github.io/) and [Godot](https://godotengine.org/download/). See the main game repository for info on which version of Godot to use.

# Setup
Most of this only needs to be done once unless specified otherwise.

## 1. Set up TrenchBroom game directory
Navigate to the TrenchBroom folder.

| Platform | Location |
| :------- | :------ |
| Windows  | C:\Users\<username>\AppData\Roaming\TrenchBroom |
| Mac      | ~/Library/Application Support/TrenchBroom |
| Linux    | ~/.TrenchBroom |

If there is not a `games/` directory here, create one. Then, create `games/GlompDev`. I think this matters??? Really unsure.

## 2. Create a config resource & set it up
Navigate to `trenchbroom/` within the cloned game repo and create a **new resource file** of the type `FuncGodotLocalConfig`. Name this file `trenchbroom_config.tres`. This file is **ignored by the git repository**.
Then, edit the properties `fgd_output_folder`, `trenchbroom_game_config_folder` to point to the `games/GlompDev` directory from step 1.

Finally, edit the property `map_editor_game_path` to point to the cloned game repository.

## 3. Generate config files
Click on the button that says `Export func_godot settings`. This will generate the needed config files to add the game to TrenchBroom.

## 4. Create a map & configure mods :D
From the TrenchBroom start screen, click `New map...`. Select the new game option `GlompDev` and create the map. Once inside of the editor, open the `Map` tab on the right and locate `trenchbroom` under the Available column. Double click on it to enable it.

Then, open the `File` menu in the menu bar and select both `Reload Material Collections` and `Reload Entity Definitions`. Use these options to refresh the material collections and entity definitions whenever you add textures and entities via the `trenchbroom/textures` directory and the Godot editor respectively.

**When saving your map, please make sure to save it to `maps/`, which is located at `trenchbroom/maps` in the main game repository.**

## 5. Load a map into the game and run it
To load a map into the game, duplicate the file `base_map.tscn` from the main game repository. Then, select the FuncGodotMap node, choose a `local_map_file`, and click `Build map`. Sometimes, it may try to load a cached version of the map, and you will need to select `Clear map` before building it again.

**Now you're ready to make maps!!! \\^o^/**

# Design philosophy
This is gonna be a stub cuz I really don't know but **remember that this is a 2.5D platformer, currently with no Z-axis movement.** Eventually, there will be Z-axis movement, but for now there is no such thing and you should keep that in mind. You are essentially designing 2D levels in 3D space.

**Feel free to contribute to this section, or any other part of the README.**
