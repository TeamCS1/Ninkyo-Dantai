# Ninkyo-Dantai

## About

Ninkyo Dantai is the first game in the Ninkyo Dantai series: a top-down JRPG,
action-adventure narrative built with **GameMaker Studio 1.4**, using the
**GMX project format**.

The development manual is on the repo's Wiki.

## Project structure

- `Ninkyo Dantai.gmx/Ninkyo Dantai.project.gmx` — main project file; every
  resource (object, script, room, sprite, etc.) must be registered here to be
  picked up by GameMaker.
- `Ninkyo Dantai.gmx/objects/` — ~250 object definitions (`*.object.gmx`).
- `Ninkyo Dantai.gmx/scripts/` — ~120 GML scripts (`*.gml`), mostly one
  function per file, using camelCase names (e.g. `characterStepEvent.gml`,
  `isCollisionCharacter.gml`).
- `Ninkyo Dantai.gmx/rooms/` — room definitions (`*.room.gmx`), including city
  maps, menus, and template rooms.
- `Ninkyo Dantai.gmx/sprites/`, `background/`, `sound/`, `fonts/`, `shaders/`,
  `paths/` — corresponding asset resources.
- `Ninkyo Dantai.gmx/extensions/` — third-party GMS 1.4 extensions
  (Draw Text Shadow, GMSched, RAM, Text Input Field, winmenu).
- `Ninkyo Dantai.gmx/datafiles/` — included files bundled with the game
  (e.g. `Game/Memory/CleanMem.dll`, `Assets/...`).
- `Ninkyo Dantai.gmx/Configs/Default.config.gmx` — build configuration.

## Compatibility

- Use only GameMaker Studio 1.4-compatible GML.
- Do not use GameMaker Studio 2 or modern GameMaker syntax.
- Do not use structs, constructors, methods, function declarations,
  `array_push`, static variables, or modern accessor syntax.
- Preserve the existing project structure and naming conventions.
- Prefer `ds_list`, `ds_map`, and `ds_grid` for complex data structures.
- Use scripts in the traditional GameMaker Studio 1.4 style.
- Do not rename resources unless explicitly requested.
- Scripts don't have optional arguments: GMS1.4 fixes a script's required
  argument count at the highest `argumentN` referenced anywhere in its body,
  even inside a branch that wouldn't run at runtime (e.g. guarded by
  `argument_count`). Calling it with fewer arguments than that is a
  compile-time error, not a graceful default. If a script needs to work both
  with and without extra parameters, write two separate scripts (e.g.
  `scr_FindSupportHeight()` / `scr_FindSupportHeightAt(x, y)`) rather than
  branching on `argument_count` inside one.

## Project changes

- Inspect related scripts and objects before making changes.
- Keep changes small and focused.
- Explain which files were modified.
- Avoid changing project metadata unnecessarily.
- When adding a resource, ensure it is properly registered in the main
  `.project.gmx` file.
- Do not delete existing resources without permission.

## Testing

GameMaker Studio 1.4 is used locally to compile and test the project. When
compilation errors are provided, fix the underlying source files without
introducing modern GML syntax.

## Architecture notes & known issues

Findings from an in-depth review (2026-07-18) of the player/collision system,
save/load & global state, and NPC AI/battle/dialogue systems. File paths are
relative to `Ninkyo Dantai.gmx/`. Ranked most severe first within each area.

### Dead/orphaned code (do not extend, safe to ignore or remove)

- **A whole Mario-style platformer collision engine is unused.**
  `scripts/characterCreateEvent.gml`, `characterStepEvent.gml`,
  `characterDrawEvent.gml`, `calculateCollisionBounds.gml`,
  `canLandOnPlatforms.gml`, `canPushMoveableSolids.gml`, every
  `getIdCollision*`/`isCollision*` script, and the objects they reference
  (`oCharacter`, `oSolid`, `oMoveableSolid`, `oPlatform`, `oLadder`, `oWater`,
  `oGame`) do not exist anywhere in `Ninkyo Dantai.project.gmx` or the
  `objects/` folder — verified by grep. This is a leftover template, unrelated
  to the actual player object (`objects/obj_player_buruwasu.object.gmx`),
  which uses GameMaker's built-in `speed`/`direction`/`friction` plus
  per-collision-object events instead.
- **`scripts/scr_load_script_SBB.gml`** is leftover from a different game
  (references "Super Bandonio Bros" level names like
  `worldOneLevelTwoStatus`, `qCratesDestroyedWorldOneLevelOne`) and is never
  called anywhere. It also contains a real bug if it were ever wired up: line
  46 reads `ini_read_real("save01", "global.deathsWorldOneLevelThree", 0)`
  — every other line uses a bare key name, so this key would never match
  anything actually written.
- **`scripts/scr_save_configs.gml` / `scripts/scr_load_configs.gml`** (display
  settings persistence: fullscreen, vsync, anti-aliasing, name tags) are
  internally consistent with each other but are never called from the actual
  options menu (`obj_main_menu_options`, `obj_optionsMenuBuruwasuController`,
  etc.) — display settings likely don't persist across sessions as a result.

### Player & collision (`obj_player_buruwasu.object.gmx`)

- **Taxi icon collision is a no-op stub.** The `obj_taxi_icon` collision
  event (line ~250) is just `x = x` / `y = y`, while every sibling vehicle
  icon (car, scooter, truck, ambulance, police car) spawns a rideable vehicle
  and sets `global.inVehicle = true`. Touching the taxi icon currently does
  nothing — looks like an unfinished feature.
- **Parked taxi (`obj_taxi_static`) ignores the no-clip debug toggle.**
  Unlike every other solid prop (trees, benches, bins, fences, cones, boxes,
  NPCs), which gate their `x = xprevious; y = yprevious;` revert behind
  `if global.enablePlayerCollisionsInWorldBuruwasu == true`, the taxi's
  collision event does the revert unconditionally.
- **Collision reverts both axes at once.** All the gated collision handlers
  do `x = xprevious; y = yprevious;` as a single block instead of resolving
  X and Y independently, so diagonal contact with any prop cancels all
  motion for the step rather than sliding along the surface — this is why
  the player can feel "stuck" on corners/edges of static objects.
- **`global.enablePlayerCollisionsInWorldBuruwasu` initialization order.**
  Set in `obj_global_buruwasu`'s Create event but read from player collision
  events; GMS1.4 doesn't guarantee Create-event order across differently
  named objects, so this is a latent "read before set" risk if instance
  order ever changes.

### Save/load & global state

- **~190 distinct `global.*` variables** are initialized ad-hoc across at
  least three places (`scr_globals.gml`, `obj_splash_screen_buruwasu`'s
  Create event, and scattered per-object Create events) with no single
  authoritative init entry point. This is the standing risk factor for
  "variable not set before read" bugs whenever room/instance order changes.
- **`global.daysOfWeekIndex` is initialized in two places with different
  values**: `obj_splash_screen_buruwasu` sets it to `1`, while
  `scr_load.gml` later overwrites it with the saved value (default `0`) —
  the "true" default for a new game depends on room/instance order, not one
  central script.
- **`scr_save.gml`/`scr_load.gml` only persist a subset of `global.*`
  state.** Nothing structurally ties the save/load key list to
  `scr_globals.gml`, so a future global added there is easy to forget to
  add to save/load too.
- **Shrine count `5` is hardcoded independently in four files**
  (`scr_save.gml`, `scr_load.gml`, `scr_check_nearby_shrines.gml`,
  `scr_globals.gml`) with no shared constant — adding a 6th shrine without
  updating all four silently drops its save/load/check logic (GML 2D arrays
  don't throw on out-of-range access, so this fails silently, not loudly).
- **`global.previousLocation` is stored as a raw room index and passed
  straight to `room_goto`** in `obj_optionsMenuLoadButton`, with no
  `room_exists()` guard. If rooms are ever reordered/added/removed (which
  changes GMS1.4 room indices), an old save file can silently teleport the
  player into the wrong room instead of erroring.

### NPC AI, spawning & battle

- **`scripts/scr_UniversalNPCSpawner.gml` line 55 checks the wrong
  position.** `if !place_meeting(x,y,obj_block_modern_mall_floor1)` tests
  the spawner's own fixed position, not the randomly rolled candidate point
  (`xx,yy`/`instVert`). This condition is invariant across the whole spawn
  loop, so a mall spawner either places *every* NPC or *none* of them,
  never actually gating per-candidate-point as intended.
- **Same script, lines 57-66: `with createNPC` targets the wrong
  instances.** `instance_create(...)`'s return value is discarded, so
  `createNPC` still holds the *object type*, not the newly created
  instance. `with createNPC { ... instance_destroy(); npcCount++; }`
  therefore can destroy *any* pre-existing NPC of that species already
  standing near `obj_modern_mall_interior_block`, not just the one just
  spawned, silently depopulating unrelated NPCs. Fix: capture
  `var inst = instance_create(...)` and use `with (inst)`.
- **`scripts/scr_alarmAI.gml`: `actiontelephonebox` state is dead and
  doesn't re-arm the alarm.** No code path ever sets
  `characterstates.actiontelephonebox` (confirmed by project-wide grep),
  and unlike the other cases in the same switch, its `case` block doesn't
  reset `alarm[0]` before `break`. If this state is ever wired up in the
  future without also fixing that, the NPC's AI loop will freeze
  permanently once it enters this state.
- **`objects/obj_battle_start_dialogue.object.gmx`: dialogue resolves the
  wrong encounter if two exist at once.** Its Step event finds the target
  via `instance_nearest(obj_player_buruwasu.x, obj_player_buruwasu.y,
  obj_battle_encounter)` instead of storing an owner reference at creation
  (the pattern `obj_battle_enemy_hud` already uses correctly via
  `encounter_id`). With a single on-screen encounter this is harmless; with
  two, the wrong encounter can get `battleStage = 2` while the real one
  stays stuck at `battleStage == 1` forever (softlock).
- **Minor:** `scr_UniversalNPCSpawner.gml` line 7 declares its loop counter
  `i` without `var`, leaking it as a persistent instance variable instead of
  a local. `obj_battleNPC_man_blue` has no health/death logic at all
  (reads as incomplete feature, not a bug).

No `argument_count`/optional-argument bugs, and no `ds_list`/`ds_map`/
`ds_grid` leaks, were found in any of the areas reviewed above.
