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
- `Ninkyo Dantai.gmx/scripts/` — ~130 GML scripts (`*.gml`), mostly one
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

## Architecture notes

Background on how core systems actually work, based on an in-depth review
(2026-07-18) plus follow-up fixes. File paths are relative to
`Ninkyo Dantai.gmx/`.

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
  (references "Super Bandonio Bros" level names) and is never called
  anywhere.
- **`scripts/scr_save_configs.gml` / `scripts/scr_load_configs.gml`** (display
  settings persistence) are internally consistent with each other but never
  called from the actual options menu — display settings likely don't
  persist across sessions as a result.
- **`scripts/scr_BuruwasuDrawMap.gml` and `scripts/DrawArrowWaypoint.gml`**
  are also unreferenced anywhere in the project, same as
  `characterDrawEvent.gml` above. Both also contain real bugs that would
  surface immediately if ever wired up — see Map system and Rendering in
  Known Issues — so don't copy them as a starting point without fixing those
  first.

### Collision system

- Player-vs-world collision is **not** GameMaker's built-in `solid` flag
  (several objects have it checked but it does nothing on its own) — it's a
  per-object-type `Collision` event registered directly in
  `obj_player_buruwasu.object.gmx`, one event per solid object. A prop with
  no matching event in that object is invisible to the player, regardless of
  its own `solid` setting.
- Collision resolves X and Y independently via
  `scripts/scr_ResolvePlayerAxisCollision.gml` (falling back to reverting
  both axes only for genuine corner-clip cases), so the player slides along
  surfaces on diagonal contact instead of stopping dead.
- Every object in the "Props" folder and every building/shop exterior, the
  elevator, the Chicken Licken dining booths, and the home-customisation
  furniture (`obj_bed`/`obj_cabinet`/`obj_fridge`) now have a matching
  Collision event (43 added in total). Deliberately left non-solid, based on
  reading their actual Create code, not guessed: interaction/trigger markers
  (`obj_taxi_corona`, `obj_custom_waypoint_buruwasu`,
  `obj_gun_shop_corona_shine_of_light`, mall enter/exit triggers), pickups
  (`obj_health_pack`, `obj_drop_bag_of_money`, `obj_ninkyo_baseball_bat`,
  `obj_prayer_shrine_collectible`), and ground/ceiling decoration
  (`obj_floor3d`, `obj_roof_modular_buruwasu`,
  `obj_fire_escape_three_floors` — elevated on a building facade, not
  reachable at ground level).
- **Real 3D-model bounding boxes, computed from the model file itself.**
  `.d3d` model files in this project turn out to be plain text (GameMaker's
  own `d3d_model_save` format: version / vertex count / primitive-flags
  header, then one `marker x y z nx ny nz u v color alpha` line per vertex),
  not binary, so the true footprint can be measured instead of guessed.
  `scripts/scr_GetModelBounds.gml` parses and caches a model's real
  `[width, depth, height]`; `scripts/scr_ApplyModelCollisionBoundsScaled.gml`
  sizes the calling instance's `image_xscale`/`image_yscale` from those
  dimensions, multiplied by whatever scale the object's own Draw event
  applies (`d3d_transform_set_scaling`/`add_scaling`) and swapped for
  rotations of 90/270°. Rotation is passed in explicitly by a thin
  per-object wrapper script (`scr_ApplyChainLinkFenceCollisionBounds`,
  `scr_ApplyBedCollisionBounds`, etc.) rather than read off a hardcoded
  variable name, since objects disagree on this (`zDirection` vs
  `zRotation` vs no rotation variable at all). **The mask sprite must have
  a centered origin** (`xorig`/`yorigin` at its middle) — an off-center
  origin (e.g. `mask_32`'s `0,0`) produces a box that drifts away from the
  instance instead of surrounding it, at any rotation. `mask_32_32_actual`
  (centered, 32×32) is the established convention to use instead. Wired up
  as a proof of concept for the chain-link fence and the home furniture;
  most other 3D-model props still use a guessed `image_xscale`/`image_yscale`
  and would need the same treatment to be verified rather than assumed.
- **Build-mode gating.** While `global.homeBuildingMode` is true (toggled by
  `obj_home_customisation_controller`), the player's furniture Collision
  events (bed/cabinet/fridge) are skipped, matching the same
  `global.homeBuildingMode == false` style already used elsewhere in
  `obj_player_buruwasu` for its build-mode input handling.
- `obj_home_customisation_controller`'s build-mode toggle correctly
  destroys both the placement grid (`obj_grid_home_128`) and the furniture
  dropdown (`obj_dropdown_home_customisation`) on exit — a copy-paste bug
  used to `with obj_dropdown_home_customisation` twice instead of also
  targeting `obj_grid_home_128`, leaking a new grid instance on every
  toggle.
- **Home furniture now persists, per save slot, in a separate `home.ini`.**
  `global.currentSaveSlot` (1-5, default 1) selects which `"customN"`
  section is active; a shared `"defaults"` section holds the shipped
  layout (fridge/cabinet/bed positions), written by both
  `scr_SaveHomeFurniture` and `scr_LoadHomeFurniture` so it exists even on
  a fresh install. Each furniture item is one comma-joined ini string
  (`"objectName,x,y,z,zRotation"`), parsed by
  `scripts/scr_ParseHomeFurnitureItem.gml`. `scr_save.gml`/`scr_load.gml`
  call `scr_SaveHomeFurniture`/`scr_LoadHomeFurniture`, but the actual
  per-instance repositioning happens in
  `scripts/scr_ApplyHomeFurniturePositions.gml`, called from
  `obj_home_customisation_controller`'s **Room Start** event — Load itself
  can't reposition anything, since the furniture instances (placed
  directly in `rm_ShinjiHome`, non-persistent) don't exist yet at the
  moment `scr_load` runs from the options menu. Saving only writes the
  `"customN"` section while the player is actually standing in
  `rm_ShinjiHome` (`room == rm_ShinjiHome`), so saving from anywhere else
  never overwrites a previously-saved layout with nothing.
  `global.movableTypes` (already populated by `obj_placerParent`, also
  placed in that room) is reused as the list of furniture types to
  save/restore, so this scales automatically if more placeable furniture
  is added later. **Not built**: an actual slot-picker UI — the
  mechanism supports 5 slots, but nothing currently lets the player
  choose one, so `global.currentSaveSlot` always stays at its default of
  `1` in practice.

## Known issues

Remaining open findings, ranked most severe first within each area. Every
finding below was independently spot-checked against the actual source
before being recorded here. Numbers are stable references, not a count —
a fixed item is removed and its number retired (moved to Architecture
notes) rather than renumbering everything after it, so gaps are expected.

### Player & collision (`obj_player_buruwasu.object.gmx`)

- **1. Taxi icon collision is a no-op stub.** The `obj_taxi_icon` collision
  event is just `x = x` / `y = y`, while every sibling vehicle icon (car,
  scooter, truck, ambulance, police car) spawns a rideable vehicle and sets
  `global.inVehicle = true`. Touching the taxi icon currently does nothing —
  looks like an unfinished feature.
- **2. Parked taxi (`obj_taxi_static`) ignores the no-clip debug toggle.**
  Unlike every other solid prop, which gates its collision revert behind
  `if global.enablePlayerCollisionsInWorldBuruwasu == true`, the taxi's
  collision event reverts unconditionally.
- **3. `global.enablePlayerCollisionsInWorldBuruwasu` initialization order.**
  Set in `obj_global_buruwasu`'s Create event but read from player collision
  events; GMS1.4 doesn't guarantee Create-event order across differently
  named objects, so this is a latent "read before set" risk if instance
  order ever changes.
- **4. `obj_land_mask` and `object192` are suspicious but left untouched.**
  Both are placed only in `rm_city_ichihara`, and both have **identical**
  Create-event code loading the same `TERRAIN/hill.d3d` model. `object192`
  is GameMaker's auto-generated default name for a never-renamed object —
  strong evidence it's an accidental leftover duplicate of `obj_land_mask`
  rather than a second intentional hill. Whether either (or both) should be
  solid is a design call, not something to guess at.

### Save/load & global state

- **5. ~190 distinct `global.*` variables** are initialized ad-hoc across at
  least three places (`scr_globals.gml`, `obj_splash_screen_buruwasu`'s
  Create event, and scattered per-object Create events) with no single
  authoritative init entry point. This is the standing risk factor for
  "variable not set before read" bugs whenever room/instance order changes.
- **6. `global.daysOfWeekIndex` is initialized in two places with different
  values**: `obj_splash_screen_buruwasu` sets it to `1`, while
  `scr_load.gml` later overwrites it with the saved value (default `0`) —
  the "true" default for a new game depends on room/instance order, not one
  central script.
- **7. `scr_save.gml`/`scr_load.gml` only persist a subset of `global.*`
  state.** Nothing structurally ties the save/load key list to
  `scr_globals.gml`, so a future global added there is easy to forget to
  add to save/load too.
- **8. Shrine count `5` is hardcoded independently in four files**
  (`scr_save.gml`, `scr_load.gml`, `scr_check_nearby_shrines.gml`,
  `scr_globals.gml`) with no shared constant — adding a 6th shrine without
  updating all four silently drops its save/load/check logic (GML 2D arrays
  don't throw on out-of-range access, so this fails silently, not loudly).
- **9. `global.previousLocation` is stored as a raw room index and passed
  straight to `room_goto`** in `obj_optionsMenuLoadButton`, with no
  `room_exists()` guard. If rooms are ever reordered/added/removed (which
  changes GMS1.4 room indices), an old save file can silently teleport the
  player into the wrong room instead of erroring.

### NPC AI, spawning & battle

- **10. `scripts/scr_UniversalNPCSpawner.gml` line 55 checks the wrong
  position.** `if !place_meeting(x,y,obj_block_modern_mall_floor1)` tests
  the spawner's own fixed position, not the randomly rolled candidate point
  (`xx,yy`/`instVert`). This condition is invariant across the whole spawn
  loop, so a mall spawner either places *every* NPC or *none* of them,
  never actually gating per-candidate-point as intended.
- **11. Same script, lines 57-66: `with createNPC` targets the wrong
  instances.** `instance_create(...)`'s return value is discarded, so
  `createNPC` still holds the *object type*, not the newly created
  instance. `with createNPC { ... instance_destroy(); npcCount++; }`
  therefore can destroy *any* pre-existing NPC of that species already
  standing near `obj_modern_mall_interior_block`, not just the one just
  spawned, silently depopulating unrelated NPCs. Fix: capture
  `var inst = instance_create(...)` and use `with (inst)`.
- **12. `scripts/scr_alarmAI.gml`: `actiontelephonebox` state is dead and
  doesn't re-arm the alarm.** No code path ever sets
  `characterstates.actiontelephonebox`, and unlike the other cases in the
  same switch, its `case` block doesn't reset `alarm[0]` before `break`. If
  this state is ever wired up in the future without also fixing that, the
  NPC's AI loop will freeze permanently once it enters this state.
- **13. `objects/obj_battle_start_dialogue.object.gmx`: dialogue resolves the
  wrong encounter if two exist at once.** Its Step event finds the target
  via `instance_nearest(obj_player_buruwasu.x, obj_player_buruwasu.y,
  obj_battle_encounter)` instead of storing an owner reference at creation
  (the pattern `obj_battle_enemy_hud` already uses correctly via
  `encounter_id`). With a single on-screen encounter this is harmless; with
  two, the wrong encounter can get `battleStage = 2` while the real one
  stays stuck at `battleStage == 1` forever (softlock).
- **14. Minor:** `scr_UniversalNPCSpawner.gml` line 7 declares its loop counter
  `i` without `var`, leaking it as a persistent instance variable instead of
  a local. `obj_battleNPC_man_blue` has no health/death logic at all
  (reads as incomplete feature, not a bug).

### Battle system (deep dive)

- **15. State transitions live in a Draw event instead of Step.**
  `obj_battle_encounter`'s Step event is an empty `battleStage` skeleton;
  the actual side effects — spawning `obj_battle_enemy_hud` and binding
  `hud.encounter_id = id` — happen in its **Draw GUI event** instead. Draw
  isn't guaranteed to run under all conditions, so gameplay state changes
  shouldn't live there.
- **16. Combat input and death detection also live in a Draw event.**
  `obj_battle_enemy_hud`'s Draw GUI event applies damage on
  `mouse_check_button_released(mb_left)` and separately re-checks
  `enemyCurrentHealth <= 0` for death — duplicating the Step event's own
  check and coupling "attack" to rendering rather than Step/input handling.
- **17. "Damage Dealt!" renders every frame, not just on hit.**
  `obj_battle_enemy_hud`: `if enemyCurrentHealth < 90 { draw_text(150,150,
  "Damage Dealt!") }` is a fixed-threshold check, not an edge/hit-timer
  check — once HP first drops below 90 this renders continuously for the
  rest of the fight.
- **18. `draw_set_colour(c_aqua)` is never reset** in the same event — confirmed
  no matching `draw_set_colour(c_white)` anywhere in that object. Any later
  `draw_text` call anywhere in the project that doesn't set its own color
  renders aqua from that point on (see Rendering below).
- **19. `obj_battle_hud` is orphaned** — never `instance_create`'d and not
  placed in any room, so its Draw GUI event (meant to draw the HUD
  background frame) never runs.
- **20. Per-encounter isolation is broken.** `obj_battle_encounter` guards HUD
  and dialogue spawning with `!instance_exists(obj_battle_enemy_hud)` /
  `!instance_exists(obj_battle_start_dialogue)` — these check for *any*
  instance of that object type, not one scoped to `id`. Only one global
  HUD/dialogue can ever exist, so two concurrent encounters will misbehave.
- **21. No HP floor clamp** — `enemyCurrentHealth` can go negative before the
  death check tidies up; the healthbar can render a negative percentage for
  one frame. Minor.

### Rendering / draw-state hygiene (project-wide pattern)

GameMaker's draw state (`draw_set_color`/`colour`, `draw_set_alpha`,
`draw_set_halign`/`valign`, `draw_set_font`, `draw_set_alpha_test`,
`d3d_set_lighting`) persists across instances and frames until something
else changes it. This project has many places that change it and never
change it back, which makes bugs order-dependent and hard to reproduce
consistently:

- (Same issue as #18) `obj_battle_enemy_hud` leaves color set to `c_aqua`.
- **22.** `obj_waypoint_controller_buruwasu`'s Draw GUI event sets
  `draw_set_halign(fa_center)` and never restores `fa_left`.
- **23.** `obj_car_icon` / `obj_taxi_icon` only call `draw_set_alpha_test(false)`
  in the *out-of-range* branch, leaving alpha testing on indefinitely
  whenever the in-range branch draws instead.
- **24.** `obj_bin_ashtray_buruwasu` and `obj_street_lamp_post` toggle
  `d3d_set_lighting` off for their own draw and don't reliably restore it —
  the dev's own code comment on the ashtray ("make sure house lighting is
  false. Somehow lighting works when off lmao") shows this is already known
  to be fragile. Lighting is only re-enabled once per frame centrally by
  `obj_control`, so any lit object drawn after a lamp/ashtray at a lower
  depth in the same frame renders flat/unlit until the next frame's reset.
- **25.** Several menu/HUD objects (`obj_main_menu_options`,
  `obj_notification_system_out`, `obj_dropdown_home_customisation`,
  `obj_dropdown_slots`, `obj_vending_machine_ui`,
  `obj_property_management_slots`) set font/color in their Draw GUI events
  and never restore a default.
- Good examples already in the codebase to model fixes on:
  `scr_DrawCollisionBoxModel.gml` (resets alpha/color/transform at the end)
  and `obj_cursor_grab_64` (checks `instance_exists` before dereferencing
  its target).
- **26.** `scripts/DrawArrowWaypoint.gml` line 16 reads `_maxDistance`, which is
  never declared — the actual variable is `_maxLength`. Dead code today,
  but will throw immediately if ever wired up.
- **27.** `obj_gui_buruwasu`'s Draw GUI event computes health/stamina bar
  percentages with no guard against a zero max — a real divide-by-zero
  risk if either max stat is ever zeroed elsewhere.
- **28.** `draw_text_shadow_tooltips.gml` hardcodes its draw position to
  `(20, 1000)` regardless of caller-supplied coordinates, so if two
  interactables are ever in range at once, their prompts overwrite each
  other at the same spot.
- **29. TO DO: `obj_elevator` (Shinji's Home) doesn't use the elevator texture
  at most quality settings.** Its Draw GUI event switches on
  `global.buildingQuality`, but only `case 5` (the highest setting) draws
  with `spr_elevator_1024` — cases 1-4 all draw with `spr_block_house_*`,
  the same generic texture `obj_house_block001` uses for a plain house
  exterior. At every quality setting except the max, the elevator in the
  home room visually looks like a house block instead of an elevator.
  (Minor, adjacent: the `else` cleanup branch flushes
  `spr_block_house_1024_1024`, a sprite this object never actually draws,
  instead of `spr_elevator_1024`, the one `case 5` does use.)

### Dialogue controller (`obj_masterDialogueControllerBuruwasu`)

- **30. Hardcoded `message[]`/`message_end` desync risk, already bitten once.**
  Both this object and its near-clone `obj_battle_start_dialogue` define
  only `message[0]` with `message_end = 0`. The counts match today, but the
  code's own comment — *"if there are more messages left to show (0 -> 6,
  in our case)"* — is leftover from a 7-line template, i.e. this exact
  desync has already happened once before. Adding a new line without
  bumping `message_end` will make it silently unreachable.
- **31. Forced intro dialogue replays every time on 10+ rooms.** The same
  instance (identical hardcoded text) is placed non-persistently across
  most city/interior rooms. Its Draw GUI event shows the box unconditionally
  on room load with no "already seen" flag, so re-entering any of these
  rooms replays the same line every time.
- Input handling is solid: line-advance correctly uses
  `keyboard_check_pressed`, only the hold-to-speed-up uses the level check
  `keyboard_check` — no held-key multi-line-skip bug.

### Map system

- **32. `obj_buruwasu_map`'s Room Start event calls
  `room_instance_add(global.newRoomCityBuruwasuMap, 0, 0,
  obj_draw_map_buruwasu)`** — `obj_draw_map_buruwasu` is not a defined
  object anywhere in the project. `scr_BuruwasuDrawMap.gml` (unreferenced
  elsewhere) looks like the per-instance icon-draw code this object was
  meant to run, and it also references an undeclared variable `gsc` (the
  rest of the project uses `gui_scale`) — this looks like an
  abandoned/broken refactor.
- **33.** The `room_instance_add(...)` call above also runs **outside** the
  `if global.newRoomCityBuruwasuisGenerated == false` guard that correctly
  wraps the preceding `room_duplicate` — so it re-runs (and re-appends) on
  every map visit even though the room duplication itself is correctly
  gated to happen once.
- **34. Room-space/GUI-space mismatch for the debug map marker.** The middle
  mouse-press handler in `obj_buruwasu_map` stores room-space
  `mouse_x`/`mouse_y` into `global.targetedX/Y`, but the Draw GUI event then
  draws that value directly in GUI space — the marker lands in the wrong
  spot whenever the view scrolls/zooms.
- **35. `obj_ichihara_temp_map` is invisible.** Its Create event sets
  `image_alpha = 0` and nothing in the project ever restores it, yet it's
  placed as the background in `rm_city_ichihara` — that city's backdrop
  currently renders fully transparent.
- **36.** No fast-travel/unlock validation exists to check — the only
  destination-selection mechanic found is an in-city waypoint marker, no
  cross-city travel code path was located.

### Home customisation system

- **38. Dropdown menu leaks 9 UI instances per click.**
  `obj_dropdown_home_customisation`'s Pressed event calls
  `scr_CreateDropdownItems()` unconditionally on every click (both open and
  close), which always creates 9 `obj_dropdown_slots` rows with nothing
  anywhere destroying the previous batch first.
- **39. No placement validation at all.** `obj_placerParent`'s Draw GUI event
  moves `global.selectedTarget` by keyboard nudge with no `place_meeting`,
  no room-bounds clamp, and no check against other placed items — furniture
  can be pushed off-room or stacked infinitely in one spot.
- **40. "Nearest object" selection doesn't actually sort by distance.**
  `ds_list_sort(tempList, true)` sorts the raw ds_list *handles* stored in
  `tempList`, not the `dist` field inside each entry — selection order is
  effectively creation order, not proximity order.
- **41. Leftover copy-paste flavor text.** `obj_dropdown_slots`' furniture
  category rows still carry verbatim vending-machine descriptions (e.g.
  *"A carbonated Cola derived from fruit ingredients"*) instead of
  furniture descriptions.
- **42. Minor leaks:** `obj_custom_waypoint_buruwasu` creates a d3d model in
  Create with no Destroy event to free it; `obj_wall_mounted_oil_lamp_custom`
  creates a child light instance and loads a model in Create with no
  Destroy event to clean either up.
- **43.** The visible placement grid is purely cosmetic — there is no actual
  grid-snapping/world-to-cell math anywhere; movement is a raw per-keypress
  pixel nudge.
- **44. TO DO: no slot-picker UI.** `global.currentSaveSlot` (1-5) exists
  and `scr_SaveHomeFurniture`/`scr_ApplyHomeFurniturePositions` are fully
  slot-aware, but nothing in the game lets the player choose or see which
  slot is active — it always stays at its default of `1` until a picker
  is built (e.g. in the options/save menu).
- **45. TO DO: no way to add or remove furniture, only move the 3
  defaults.** `obj_placerParent` can only select and reposition the
  pre-existing `obj_fridge`/`obj_cabinet`/`obj_bed` instances (it
  iterates `global.movableTypes` via `with`, which only matches
  instances that already exist) — there's no `instance_create` path
  anywhere for spawning a new piece from the dropdown, and no delete
  action either. The `"customN"` save format already supports arbitrary
  additional items (it writes a `count` plus indexed entries, not a
  fixed 3), so once placement/removal exists the save/load side needs no
  changes — only `obj_placerParent` and the dropdown
  (`obj_dropdown_home_customisation`/`obj_dropdown_slots`, see #38/#41)
  need the actual create/destroy logic. Related latent constraint:
  `scr_ApplyHomeFurniturePositions` repositions via
  `with (_objIndex) { x = ...; y = ...; }`, which applies to *every*
  existing instance of that object type — fine while there's exactly one
  of each, but if #45 is ever built and a second instance of the same
  type is added, saved rows and live instances would need a stable
  per-instance identity to stay correctly matched, not just an object
  name.
- **46. Minor: shipped default furniture layout is hardcoded in two
  places.** `scripts/scr_SaveHomeFurniture.gml` and
  `scripts/scr_LoadHomeFurniture.gml` both independently hardcode the same
  three `ini_write_string` lines —
  `"defaults", "item0", "obj_fridge,640,384,0,0"`,
  `"item1", "obj_cabinet,896,640,0,0"`, and
  `"item2", "obj_bed,1376,368,0,180"` — with no shared constant/script
  between them. If the room's default layout is ever changed (or a
  fourth default piece added), both files need updating by hand or
  they'll silently disagree about what "defaults" means.
- **47. Not yet playtested.** The whole slot/home.ini system (moving
  furniture, saving, leaving and returning to `rm_ShinjiHome`, and
  reloading) hasn't been verified in the actual GameMaker editor/runtime.
- **48. TO DO: no rotation support in the placement UI.**
  `obj_placerParent`'s Draw GUI event only reads `vk_up`/`vk_down`/
  `vk_left`/`vk_right` for `move_dx`/`move_dy` — there's no input at all
  for changing a selected piece's rotation. Even if there were,
  `obj_cabinet` and `obj_fridge` have no `zRotation` variable to begin
  with (their Draw events hardcode `d3d_transform_add_rotation_z(0)`) —
  only `obj_bed` supports rotation today, and only via room creation code
  set once at placement time, not interactively.
- **49. TO DO: no controller/joypad support for furniture placement.**
  Confirmed by project-wide grep — there is no `gamepad_button_check`/
  `gamepad_axis_value` call anywhere in the codebase, not just in the
  home customisation objects. Selecting, moving, and (per #48) any future
  rotating of furniture is keyboard/mouse-only
  (`keyboard_check_pressed`, `mouse_wheel_up`/`down`).

No `argument_count`/optional-argument bugs, and no `ds_list`/`ds_map`/
`ds_grid` leaks, were found beyond what's explicitly called out above.

## As designed

Things that look like bugs on first read but are intentional — confirmed by
the person who actually knows the design intent, not something inferable
from the code alone. Recorded so they don't get "fixed" again.

- **`obj_line_of_ladies` having no `spriteName`/`maskName` is intentional,
  not missing.** It draws its own `lineofladies.d3d` model directly via
  `d3d_model_draw` in its Draw event (same pattern as every other 3D-model
  prop), completely independent of the sprite/mask system — it does
  visibly render, contrary to an earlier note in this file. It has no
  sprite because it doesn't need one for collision: it's elevated
  (`z = 223` in Create) and out of the player's reach at ground level, the
  same reasoning that already applies to `obj_fire_escape_three_floors`.

## Update notes

Player-facing patch notes, most recent first — written so they can be
copy-pasted straight into an itch.io devlog/update post. Add a new dated
entry here each time a Known Issue is fixed or a piece of work lands;
keep the technical specifics (scripts, object names) out of this section
and in Architecture notes / Known Issues instead.

### August 2, 2026

**New**
- Furniture you move around in Shinji's Home now actually saves! Move
  your bed, fridge, or cabinet and it'll still be there next time you
  load up.

**Fixes**
- Fixed walking diagonally into a wall or object stopping you dead
  instead of letting you slide along it.
- Fixed a huge number of things around the city you could previously
  walk straight through, including building exteriors, the elevator,
  street lamps, wall lamps, benches, bins, fences, pillars, and the
  dining booths at Chicken Licken.
- Fixed the chain-link fence's collision not matching how it actually
  looks, so it now blocks you where you'd expect instead of letting you
  clip into or through it.
- Fixed being able to get stuck on your own furniture while trying to
  rearrange your room — it's walk-through only while you're actively
  placing it, solid the rest of the time.
- Fixed a small memory leak from repeatedly opening and closing the
  furniture placement menu.
