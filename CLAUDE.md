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

- **The unused Mario-style platformer collision engine, a batch of
  leftover scripts from a different game, and an unused display-settings
  persistence pair have all been deleted** — none of it was referenced by
  the project or any object; the real player object uses GameMaker's
  built-in `speed`/`direction`/`friction` instead.
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
- **The bed needed its own dedicated bounds script, not the shared one.**
  Playtesting found the player could walk through the south side of the
  bed. Measuring the bed's `.d3d` model directly showed why: its real Y
  extent is `-53.7` to `+26.3` — offset about `-13.7` from center, unlike
  the fence's near-negligible offset. A tight-fit symmetric box is wrong
  for an off-center model once rotated (GameMaker's simple bounding-box
  collision doesn't rotate with `image_angle`, and the required
  compensation flips direction depending on rotation — a real problem
  now that "add furniture" can spawn a second bed at a different
  rotation than the shipped default). `scripts/scr_GetBedCollisionBounds.gml`
  computes a symmetric-safe size instead — `2 * max(|min|, |max|)` per
  axis — guaranteeing full coverage on both sides after any 90° rotation,
  at the cost of some harmless over-blocking on the side that didn't
  need it. `scripts/scr_ApplyBedCollisionBounds.gml` uses this instead of
  the shared `scr_GetModelBounds`/`scr_ApplyModelCollisionBoundsScaled`
  pipeline, which is unchanged and still correct for the fence/cabinet/
  fridge.
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
  (`"objectName,furnitureId,x,y,z,zRotation"`), parsed by
  `scripts/scr_ParseHomeFurnitureItem.gml`. `scr_save.gml`/`scr_load.gml`
  call `scr_SaveHomeFurniture`/`scr_LoadHomeFurniture`, but the actual
  per-instance repositioning happens in
  `scripts/scr_ApplyHomeFurniturePositions.gml`, called from
  `obj_home_customisation_controller`'s **Room Start** event — Load itself
  can't reposition anything, since the furniture instances (placed
  directly in `rm_ShinjiHome`, non-persistent) don't exist yet at the
  moment `scr_load` runs from the options menu. Saving is the mirror
  problem: pressing Save always happens from inside `rm_options_menu` (a
  real `room_goto`, triggered by `obj_options_menu_trigger`), so by the
  time `scr_SaveHomeFurniture` runs, the furniture instances have already
  been destroyed by leaving `rm_ShinjiHome` — there's nothing left to
  scan directly. Two playtesting rounds found both halves of this: first
  that the code was gating on `room == rm_ShinjiHome` (always false at
  save time) instead of `global.previousLocation`, and after fixing
  that, that even the *right* check couldn't work because the instances
  themselves were already gone. The actual fix is
  `scripts/scr_SnapshotHomeFurniture.gml`, called from
  `obj_home_customisation_controller`'s **Room End** event (fires while
  still in `rm_ShinjiHome`, right before its instances are torn down) —
  it captures every movable instance's current state into
  `global.homeFurnitureSnapshot`, and `scr_SaveHomeFurniture` writes
  *that* to disk rather than trying to read live instances. It still
  checks `global.previousLocation == rm_ShinjiHome` too, so saving from
  somewhere the player never actually took the furniture through this
  session doesn't touch the custom section at all.
  `global.movableTypes` (already populated by `obj_placerParent`, also
  placed in that room) is reused as the list of furniture types to
  save/restore, so this scales automatically if more placeable furniture
  is added later. **Not built**: an actual slot-picker UI — the
  mechanism supports 5 slots, but nothing currently lets the player
  choose one, so `global.currentSaveSlot` always stays at its default of
  `1` in practice.
- **Furniture can now actually be added, not just moved.** Every
  placeable furniture instance (the 3 shipped defaults and any added
  later) carries a `furnitureId` — 0/1/2 for the shipped
  fridge/cabinet/bed, assigned in each object's own Create event, and a
  fresh incrementing value from `global.nextFurnitureId` for anything
  added afterward. This is what lets `scr_SaveHomeFurniture`/
  `scr_ApplyHomeFurniturePositions` tell two instances of the same
  object type apart — the save format is now
  `"objectName,furnitureId,x,y,z,zRotation"`, and applying a save either
  repositions an existing instance with matching `furnitureId` or
  `instance_create`s a new one if none exists yet.
  `scr_ApplyHomeFurniturePositions` also advances `global.nextFurnitureId`
  past every id it sees on load, so newly added pieces never collide
  with restored ones. Three of `obj_dropdown_slots`' nine category rows
  (Bedroom/Kitchen/Living) now have a real `targetObject`
  (`obj_bed`/`obj_fridge`/`obj_cabinet`) and spawn that piece next to the
  player on click — its Pressed event was previously entirely commented
  out, copy-pasted from a vending-machine UI (see the old flavor-text
  bug this leftover code caused, now fixed for these 3 rows).

### Gamepad input

- **GMS1.4's mapped gamepad API does not recognise the DualSense's
  D-pad.** The runtime's bundled controller-mapping database predates the
  DualSense, so on a pad paired over Bluetooth the analog sticks map
  correctly but `gp_padu`/`gp_padd` never fire — the D-pad arrives as a
  DirectInput **POV hat** instead. `scripts/scr_GetGamepadDpadY.gml`
  therefore reads *both* sources (mapped buttons, then `joystick_pov` via
  the legacy API) and returns whichever reports a direction. Verified
  against a real DualSense: GameMaker reported it in **slot 4**, not slot
  0, which is why `scr_GetGamepadDevice.gml` scans every slot instead of
  assuming device 0.
- **Read direction through the `scr_Get*` scripts, never
  `gp_padu`/`gp_padd` directly** — a direct read silently works on an
  Xbox pad and silently fails on a DualSense, which is exactly how this
  bug was introduced the first time.
- The `scr_Get*` scripts return a **level** (`-1`/`0`/`1`, true every
  frame the direction is held). `scripts/scr_GamepadNavPoll.gml` wraps
  them with edge detection for menus — one step per press rather than
  continuous scrolling — publishing `global.gamepadNavUp` /
  `global.gamepadNavDown`. It **must be called once per frame from a
  Begin Step event**: every instance's Begin Step runs before any
  instance's Step, so any number of objects can then read those globals
  in Step without depending on instance order. Calling it twice in one
  frame swallows the press, since the second call sees the direction as
  already engaged. Currently called from
  `obj_main_menu_controller_buruwasu`'s Begin Step; a second menu in the
  same room should *read the globals*, not call the poll again.
- D-pad and stick are deliberately folded into one direction *before*
  the edge check. Keeping them separate meant a pad whose D-pad is seen
  by both detection paths moved the selection two items per press.
- `scripts/scr_DrawGamepadDebugOverlay.gml` draws a diagnostic readout
  (slot count, per-slot connected state and reported name, raw button
  bits, raw axis values, POV angle), gated on `global.debugGamepadOverlay`
  — toggled by "Debug Gamepad" on the main menu options screen
  (`obj_toggle_debug_gamepad_main_menu`, modelled on
  `obj_toggle_fullscreen_main_menu`). It shows what GameMaker *actually*
  detects rather than what it should, which is what identified both the
  slot-4 and POV-hat findings above; reach for it first when a controller
  misbehaves.
- **Not built yet:** any gamepad input outside the main menu — no confirm/
  cancel button (menu selection is still `vk_enter`), no horizontal
  navigation, no in-game or furniture-placement support (see #49).

### HUD (`obj_gui_buruwasu`)

- **"Default" HUD Elements mode now correctly re-shows before fading
  again every time its room is (re-)entered, including backing out of the
  options menu.** The options-menu "HUD Elements" setting's "Default" mode
  (`global.hudGameElements == 1`) is meant to show the
  yen/compass/clock/health/stamina block briefly, then fade it out, armed
  via `doFade = true; alarm[0] = room_speed * 5;` plus resetting the alpha
  it fades (`global.hudGameElementsAlphaControl`, global and normally left
  at `0` once fully faded) back to `1`. Two playtesting rounds found this
  needed fixing twice: first, Create alone wasn't enough to reset the
  alpha (it only armed the timer, so a room revisited with the alpha
  already faded stayed invisible with nothing to fade from) — but even
  after adding the alpha reset to Create, backing out of the options menu
  still didn't show the HUD, because `rm_city_buruwasu`, `rm_city_ichihara`
  and `rm_ShinjiHome` are all **persistent rooms**
  (`obj_gui_buruwasu`'s own rooms) — GameMaker does not re-run Create for
  a persistent room's surviving instances when you return to it, only
  Room Start fires on every re-entry. The same reset logic now also runs
  in `obj_gui_buruwasu`'s Room Start event (previously unused, dead
  commented-out code), which is what actually re-arms the fade after the
  options menu — Create alone only ever mattered for the very first time
  a room is entered.

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
- **41. Leftover copy-paste flavor text (partially fixed).** The
  Bedroom/Kitchen/Living rows now have real furniture descriptions (see
  Architecture notes, Home customisation system), but the other 6
  category rows in `obj_dropdown_slots` still carry verbatim
  vending-machine descriptions (e.g. *"A carbonated Cola derived from
  fruit ingredients"*) — moot until those categories have a matching
  furniture type to describe (see #51).
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
- **46. Minor: shipped default furniture layout is hardcoded in two
  places.** `scripts/scr_SaveHomeFurniture.gml` and
  `scripts/scr_LoadHomeFurniture.gml` both independently hardcode the same
  three `ini_write_string` lines —
  `"defaults", "item0", "obj_fridge,0,640,384,0,0"`,
  `"item1", "obj_cabinet,1,896,640,0,0"`, and
  `"item2", "obj_bed,2,1376,368,0,180"` — with no shared constant/script
  between them. If the room's default layout is ever changed (or a
  fourth default piece added), both files need updating by hand or
  they'll silently disagree about what "defaults" means.
- **48. TO DO: no rotation support in the placement UI.**
  `obj_placerParent`'s Draw GUI event only reads `vk_up`/`vk_down`/
  `vk_left`/`vk_right` for `move_dx`/`move_dy` — there's no input at all
  for changing a selected piece's rotation. Even if there were,
  `obj_cabinet` and `obj_fridge` have no `zRotation` variable to begin
  with (their Draw events hardcode `d3d_transform_add_rotation_z(0)`) —
  only `obj_bed` supports rotation today, and only via room creation code
  set once at placement time, not interactively.
- **49. TO DO: no controller/joypad support for furniture placement.**
  Gamepad support now exists, but only in the main menu — see Architecture
  notes, Gamepad input. Selecting, moving, and (per #48) any future
  rotating of furniture is still keyboard/mouse-only
  (`keyboard_check_pressed`, `mouse_wheel_up`/`down`). The reusable
  scripts to wire this up are already there; `obj_placerParent` just
  doesn't call them yet.
- **50. TO DO: still no way to remove furniture once placed.** Adding is
  now possible (see Architecture notes, Home customisation system), but
  `obj_placerParent` has no delete action at all — only select and
  reposition. A misclicked or unwanted piece can only be nudged
  off-screen, not actually removed.
- **51. Only 3 of the 9 dropdown categories have a matching furniture
  type.** `obj_dropdown_slots` still lists "Structure & Painting",
  "Doors & Windows", "General", "Bathroom", "Office", "Outdoor &
  Farming", and "Decorations" as categories, but no placeable object
  exists for any of them yet — clicking those rows does nothing
  (`targetObject` stays `noone`). Separately, the same object's Step
  event sets names/descriptions via
  `instance_find(obj_dropdown_slots, 0)` through `..., 9)` — but
  `scr_CreateDropdownItems.gml` only ever creates 9 rows (indices 0-8),
  so `instance_find(obj_dropdown_slots, 9)` ("Decorations") always
  resolves to `noone` and that `with` block silently does nothing. Not
  currently harmful (`with (noone)` is a no-op), but worth knowing before
  adding a 10th row expecting it to work.
- **52. TO DO: adding furniture is free.** Each dropdown row already
  carries `price`/`upkeep` fields (left over from the vending-machine
  code this UI was copied from), and `global.yenAmount` already exists
  and is tracked/saved elsewhere, but nothing in the new add-furniture
  flow reads `price` or deducts it — every add is currently instant and
  free, with no funds check at all.

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

## Reviewer's take

A personal, subjective assessment from the AI assistant that did the
in-depth review and fixes recorded above (2026-08-03) — not a design
document, just an honest read of the codebase after spending real time
in nearly every system.

**Overall.** This is an ambitious project for the engine it's built in.
GameMaker Studio 1.4 is not really meant for what's being asked of it
here — a multi-city open-ish world, real-time 3D-model props rendered
inside a 2D top-down game via `d3d_model_draw`, a full save/load system
with per-slot home customisation, a battle system, a dialogue system,
NPC spawning/AI, a day/night clock, taxi fast-travel, and six independent
graphics-quality sliders — and it mostly holds together. That's a genuine
achievement for a solo/small-team GMS1.4 project, and it's clear a lot of
real design thought went into the scope even where the implementation
hasn't caught up yet.

**The good.**
- The pseudo-3D prop rendering (real `.d3d` models drawn in a 2D engine)
  is a clever, unusual technical choice, and the decision to measure
  actual model bounding boxes from the model files instead of guessing
  scale values (once that work started) is the kind of rigor that
  separates "looks right" from "is right."
- The home customisation system — per-save-slot persistence, stable
  furniture identity across multiple instances of the same object,
  build-mode collision gating — is more sophisticated than most small
  GMS1.4 projects attempt, and it's now in a genuinely solid state.
- Consistent naming conventions (`obj_`/`scr_`/camelCase scripts) across
  ~250 objects and ~130 scripts suggests real discipline, not just size.
- The built-in debug overlay (FPS, memory, camera/collision state) shows
  a developer actively instrumenting their own work rather than debugging
  blind — a good habit that made several fixes in this review much faster
  to verify.
- The project responds well to targeted fixes. Nothing found during this
  review needed a rewrite — every issue, including the trickiest ones
  (the bed's asymmetric collision box, the two-stage furniture-save
  problem, the HUD fade's persistent-room blind spot), was fixable with a
  small, scoped change once properly root-caused.

**The bad.**
- **Global state is the single biggest structural risk in the codebase.**
  ~190 `global.*` variables initialized ad-hoc across at least three
  different places with no central entry point. Nearly every subtle "why
  doesn't this work" bug traced back to this during the review — a global
  that's read before it's set, set in two places with different values,
  or (the HUD fade bug) left stale across a room transition because
  nothing owns resetting it. This will keep generating this exact class
  of bug for every new feature until it's consolidated.
- **State-changing logic living in Draw events instead of Step.** The
  battle system's state transitions and combat input both happen in Draw
  GUI events, not Step — Draw isn't guaranteed to run under every
  condition, so gameplay logic shouldn't depend on it firing. This is a
  correctness risk hiding as a rendering concern.
- **Systems are built for the single/happy-path case, not the general
  case.** The battle system only supports one on-screen encounter at a
  time (HUD and dialogue lookups aren't scoped per-encounter); the HUD
  fade only worked the very first time a room was entered until this
  session; the dialogue controller's message-count arrays have already
  desynced once. The pattern is consistent: things work great in the
  scenario the developer was actually testing, and quietly break outside
  it.
- **Copy-paste reuse without follow-through cleanup.** The furniture
  dropdown UI started as a copy-pasted vending-machine UI with its
  Pressed event entirely commented out; six of nine dropdown categories
  still carry vending-machine flavor text. This isn't unique to one
  place — it's a repeated pattern of "copy something similar, get the
  happy path working, move on" without going back to finish the edges.
- **Real leftover/dead code shipped in the project for an extended
  period** (an entire unused platformer collision engine, assets from an
  unrelated earlier game). Harmless at runtime since none of it was
  wired up, but it's a sign nothing was auditing the project tree for
  drift — which is exactly the kind of thing that erodes confidence when
  a new contributor tries to understand what's actually load-bearing.

**What would make the biggest difference from here.** Not more features —
the two structural debts above (global-state sprawl and
logic-in-Draw-events) are the ones that keep resurfacing as "works for
the simple case, breaks for the general case" bugs, and they'll only get
more expensive to unwind the more gets built on top. A single
`scr_globals.gml`-owned initialization pass, and moving battle-system
state changes into Step, would probably prevent more future bugs than
any individual feature fix in this file. Everything else — the TO DO
list, the remaining known issues — is normal, healthy backlog for a game
this size; the systemic stuff is the part worth prioritizing before it
compounds.

**On game design** (inferred from what the systems imply, not from
playing — a real limitation, see below). The premise — a murder-mystery
narrative JRPG with open-ish city exploration — is bolted onto a genuinely
wide spread of other genre elements: a full home-decorating/life-sim
layer (per-slot furniture persistence, a build mode, a furniture shop
UI), real-time single-target combat, taxi fast-travel between five
cities, a day/night/weekday clock, a fog/weather system, and a shrine
collectible layer. That's a lot of different games' worth of systems for
one project to carry at once, and from what I've read, most of them are
currently shallow rather than deep — combat is a single mouse-click
dealing damage to one on-screen enemy with a health bar, no visible
abilities/inventory/combo depth; NPC "AI" is a small handful of states;
dialogue is fixed, non-branching message sequences. Wide-but-shallow
scope is a common trap for ambitious solo/small-team projects — every
system present is a real feature, but none of them (from what's in the
code) is pushed past a first pass, which tends to read to players as "a
lot to do, not much depth to any of it."

The bigger question mark, specifically because the premise is a *murder
mystery*: I did not find anything in the dialogue, battle, or any other
system I reviewed that reads as an investigation/deduction mechanic —
no clue collection, evidence log, suspect tracking, or dialogue choices
that branch based on what the player has learned. The dialogue
controller is sequential fixed text with no player input beyond
advancing lines. If investigation gameplay exists, it's in a system I
didn't touch during this review; but if it doesn't exist yet, that's the
single piece I'd consider most important to a game whose whole framing
is "murder mystery" — right now the narrative delivery mechanism and the
actual "solve the mystery" gameplay loop don't appear to be the same
system, which is usually a bigger design risk than any individual bug.
Two smaller, concrete design smells worth calling out on their own: the
forced intro dialogue currently replaying verbatim on every single visit
to 10+ rooms (Known Issues #31) is exactly the kind of repetition that
playtesting normally catches fast, since it actively undercuts the
narrative focus the genre choice implies; and the amount of engineering
investment visible in rendering/performance tuning (six independent
graphics-quality sliders, a memory/RAM debug overlay) looks
disproportionate next to how shallow the combat and investigation loops
currently are — reasonable if the plan is "get the tech pipeline solid
first, deepen mechanics later," but worth being a deliberate choice
rather than a byproduct of where effort happened to go.

One honest limitation of both takes above: everything comes from reading
code, not playing the game. I have no read on whether the murder-mystery
narrative, the pacing, or the actual moment-to-moment feel of exploring
the cities is any good — that's the part that ultimately decides whether
this is a good game, and it's outside what a code review can tell you.
If there's an investigation mechanic I missed, or the shallow systems
above are early-access placeholders with a deeper pass already planned,
that changes this assessment a fair amount.

## Update notes

Player-facing patch notes, most recent first — written so they can be
copy-pasted straight into an itch.io devlog/update post. Add a new dated
entry here each time a Known Issue is fixed or a piece of work lands;
keep the technical specifics (scripts, object names) out of this section
and in Architecture notes / Known Issues instead.

### August 6, 2026

**New**
- Controller support has started landing! You can now scroll the main
  menu with a controller — either the D-pad or the left stick. Tested
  with a DualSense connected over Bluetooth, with no extra software
  needed.
- Added a "Debug Gamepad" option under Gamepad Settings in the options
  menu. Turn it on to see exactly what the game detects about your
  controller — handy if yours isn't working and you're reporting it.

Note that selecting a menu item still needs Enter for now, and the
controller doesn't do anything outside the main menu yet.

### August 3, 2026

**Fixes**
- Fixed the elevator in Shinji's Home looking like a plain house block at
  every graphics quality setting except the highest — it now shows the
  proper elevator texture at every setting.
- Fixed the HUD (money, compass, clock, health/stamina bars) staying
  invisible after backing out of the options menu when "HUD Elements" is
  set to "Default" — it now reappears and fades out again as intended
  instead of just staying hidden.

**Behind the scenes**
- Removed a large amount of unused leftover code that shipped in the
  project but was never actually part of the game (an old platformer
  collision system and some assets from an unrelated earlier project).
  No gameplay impact, just a cleaner codebase.

### August 2, 2026

**New**
- Furniture you move around in Shinji's Home now actually saves! Move
  your bed, fridge, or cabinet and it'll still be there next time you
  load up.
- You can now add an extra bed, fridge, or cabinet from the furniture
  menu instead of only rearranging the ones you start with.

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
- Fixed being able to walk through part of the bed's south side.
- Fixed being able to get stuck on your own furniture while trying to
  rearrange your room — it's walk-through only while you're actively
  placing it, solid the rest of the time.
- Fixed a small memory leak from repeatedly opening and closing the
  furniture placement menu.
