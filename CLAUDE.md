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

Findings from an in-depth review (2026-07-18) covering: player/collision,
save/load & global state, NPC AI/spawning, the battle system (state machine +
draw events), rendering/draw-state hygiene project-wide, the dialogue
controller, the map system, and the home customisation system. File paths
are relative to `Ninkyo Dantai.gmx/`. Ranked most severe first within each
area. Every finding below was independently spot-checked against the actual
source before being recorded here.

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
- **`scripts/scr_BuruwasuDrawMap.gml` and `scripts/DrawArrowWaypoint.gml`**
  are also unreferenced anywhere in the project (confirmed by grep), same as
  `characterDrawEvent.gml` above. Both also contain real bugs that would
  surface immediately if ever wired up — see Map system and Rendering
  sections below — so don't copy them as a starting point without fixing
  those first.

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

### Battle system (deep dive)

- **State transitions live in a Draw event instead of Step.**
  `obj_battle_encounter`'s Step event is an empty `battleStage` skeleton
  (`if battleStage == 0 { }` / `== 1 { }` / `== 2 { }`); the actual side
  effects — spawning `obj_battle_enemy_hud` and binding
  `hud.encounter_id = id` — happen in its **Draw GUI event** instead. Draw
  isn't guaranteed to run under all conditions (e.g. app surface disabled),
  so gameplay state changes shouldn't live there.
- **Combat input and death detection also live in a Draw event.**
  `obj_battle_enemy_hud`'s Draw GUI event applies damage on
  `mouse_check_button_released(mb_left)` and separately re-checks
  `enemyCurrentHealth <= 0` for death — duplicating the Step event's own
  check and coupling "attack" to rendering rather than Step/input handling.
- **"Damage Dealt!" renders every frame, not just on hit.**
  `obj_battle_enemy_hud`: `if enemyCurrentHealth < 90 { draw_text(150,150,
  "Damage Dealt!") }` is a fixed-threshold check, not an edge/hit-timer
  check — once HP first drops below 90 this renders continuously for the
  rest of the fight.
- **`draw_set_colour(c_aqua)` is never reset** in the same event (line
  ~158) — confirmed no matching `draw_set_colour(c_white)` anywhere in that
  object. Any later `draw_text` call anywhere in the project that doesn't
  set its own color renders aqua from that point on (see Rendering section).
- **`obj_battle_hud` is orphaned** — confirmed via grep: it is never
  `instance_create`'d and not placed in any room, so its Draw GUI event
  (meant to draw the HUD background frame) never runs. The enemy HUD's
  text/healthbar currently render with no backing frame.
- **Per-encounter isolation is broken.** `obj_battle_encounter` guards HUD
  and dialogue spawning with `!instance_exists(obj_battle_enemy_hud)` /
  `!instance_exists(obj_battle_start_dialogue)` — these check for *any*
  instance of that object type, not one scoped to `id`, contradicting the
  object's own comment about each encounter tracking only its own IDs. Only
  one global HUD/dialogue can ever exist, so two concurrent encounters will
  misbehave.
- **No HP floor clamp** — `enemyCurrentHealth` can go negative before the
  death check tidies up; the healthbar can render a negative percentage for
  one frame. Minor.

### Rendering / draw-state hygiene (project-wide pattern)

GameMaker's draw state (`draw_set_color`/`colour`, `draw_set_alpha`,
`draw_set_halign`/`valign`, `draw_set_font`, `draw_set_alpha_test`,
`d3d_set_lighting`) persists across instances and frames until something
else changes it. This project has many places that change it and never
change it back, which makes bugs order-dependent and hard to reproduce
consistently:

- `obj_battle_enemy_hud` leaves color set to `c_aqua` (see Battle above).
- `obj_waypoint_controller_buruwasu`'s Draw GUI event sets
  `draw_set_halign(fa_center)` and never restores `fa_left`.
- `obj_car_icon` / `obj_taxi_icon` only call
  `draw_set_alpha_test(false)` in the *out-of-range* branch, leaving alpha
  testing on indefinitely whenever the in-range branch draws instead.
- `obj_bin_ashtray_buruwasu` and `obj_street_lamp_post` toggle
  `d3d_set_lighting` off for their own draw and don't reliably restore it —
  the dev's own code comment on the ashtray ("make sure house lighting is
  false. Somehow lighting works when off lmao") shows this is already known
  to be fragile. Lighting is only re-enabled once per frame centrally by
  `obj_control` (via `scr_lightSource_Controller`, depth 1,000,000, drawn
  first), so any lit object drawn after a lamp/ashtray at a lower depth in
  the same frame renders flat/unlit until the next frame's reset.
- `obj_main_menu_options`, `obj_notification_system_out`,
  `obj_dropdown_home_customisation`, `obj_dropdown_slots`,
  `obj_vending_machine_ui`, `obj_property_management_slots` all set
  font/color in their Draw GUI events and never restore a default.
- Good examples already in the codebase to model fixes on:
  `scr_DrawCollisionBoxModel.gml` (resets alpha/color/transform at the end)
  and `obj_cursor_grab_64` (checks `instance_exists` before dereferencing
  its target).
- Other rendering bugs found:
  - `scripts/DrawArrowWaypoint.gml` line 16 reads `_maxDistance`, which is
    never declared — the actual variable is `_maxLength` (line 13). Dead
    code today (unreferenced), but will throw immediately if ever wired up.
  - `obj_gui_buruwasu`'s Draw GUI event computes
    `global.currentHealthBar = (global.currentHealthCount /
    global.currentHealthMaximum) * 100` (and the same for stamina) with no
    guard against a zero max — a real divide-by-zero risk if either max
    stat is ever zeroed elsewhere.
  - `draw_text_shadow_tooltips.gml` hardcodes its draw position to
    `(20, 1000)` regardless of caller-supplied coordinates, so if two
    interactables (vending machine, shrine, gun shop, mall doors, taxi,
    battle encounter) are ever in range at once, their prompts overwrite
    each other at the same spot.

### Dialogue controller (`obj_masterDialogueControllerBuruwasu`)

- **Hardcoded `message[]`/`message_end` desync risk, already bitten once.**
  Both this object and its near-clone `obj_battle_start_dialogue` define
  only `message[0]` with `message_end = 0`, and advance with
  `if (message_current < message_end) { message_current += 1 } else {
  instance_destroy() }`. The counts match today, but the code's own comment
  — *"if there are more messages left to show (0 -> 6, in our case)"* — is
  leftover from a 7-line template, i.e. this exact desync has already
  happened once before in this object's history. Adding a new line without
  bumping `message_end` will make it silently unreachable.
- **Forced intro dialogue replays every time on 10+ rooms.** The same
  instance (name `inst_4E5F0245`, identical hardcoded text) is placed
  non-persistently in `rm_ShinjiHome`, `rm_chicken_licken`,
  `rm_city_buruwasu`, `rm_city_ichihara`, `rm_city_konan`, `rm_city_nagoya`,
  `rm_city_yokyohama`, and both template rooms. Its Draw GUI event shows
  the box unconditionally on room load with no "already seen" flag, so
  re-entering any of these rooms replays the same line every time — looks
  like a template artifact copy-pasted into real rooms rather than intended
  design.
- Input handling is solid: line-advance correctly uses
  `keyboard_check_pressed`, only the hold-to-speed-up uses the level check
  `keyboard_check` — no held-key multi-line-skip bug.

### Map system

- **`obj_buruwasu_map`'s Room Start event calls
  `room_instance_add(global.newRoomCityBuruwasuMap, 0, 0,
  obj_draw_map_buruwasu)`** — `obj_draw_map_buruwasu` is not a defined
  object anywhere in the project (confirmed by listing `objects/` and
  grepping the whole project). This runs every time the map screen is
  entered. `scr_BuruwasuDrawMap.gml` (unreferenced elsewhere) looks like the
  per-instance icon-draw code this object was meant to run, and it also
  references an undeclared variable `gsc` (the rest of the project uses
  `gui_scale`) — this looks like an abandoned/broken refactor.
- The `room_instance_add(...)` call above also runs **outside** the
  `if global.newRoomCityBuruwasuisGenerated == false` guard that correctly
  wraps the preceding `room_duplicate` — so it re-runs (and re-appends) on
  every map visit even though the room duplication itself is correctly
  gated to happen once.
- **Room-space/GUI-space mismatch for the debug map marker.** The middle
  mouse-press handler in `obj_buruwasu_map` stores room-space
  `mouse_x`/`mouse_y` into `global.targetedX/Y`, but the Draw GUI event then
  draws that value directly with `draw_text` in GUI space — the marker
  lands in the wrong spot whenever the view scrolls/zooms.
  `obj_waypoint_controller_buruwasu` separately rescales the same globals
  with a hardcoded `* 25000 / 3500` — fragile if room dimensions ever
  change.
- **`obj_ichihara_temp_map` is invisible.** Its Create event sets
  `image_alpha = 0` and nothing in the project ever restores it, yet it's
  placed as the (scaled 25x/25x) background in `rm_city_ichihara` — that
  city's backdrop currently renders fully transparent. (Note:
  `obj_yokyohama_temp_map`, despite the similar "temp" name, has no such
  bug and renders fine; `obj_ichihara_map`, a *different* object, is simply
  orphaned/never placed in any room — don't conflate the three.)
- No fast-travel/unlock validation exists to check, positively or
  negatively — the only destination-selection mechanic found is an
  in-city waypoint marker, no cross-city travel code path was located.

### Home customisation system

- **Placed furniture doesn't persist at all.** `obj_fridge`, `obj_cabinet`,
  and `obj_bed` are all non-persistent, and `scr_save.gml`/`scr_load.gml`
  (the game's only save path) never reference furniture position/type —
  moved furniture resets the moment the room is left, not just on reload.
- **Copy-paste bug leaks a grid instance on every build-mode toggle.**
  `obj_home_customisation_controller`'s toggle event does
  `if instance_exists(obj_grid_home_128) { with
  obj_dropdown_home_customisation { instance_destroy(); } }` — the cleanup
  targets the wrong object (the dropdown, already destroyed above) instead
  of `obj_grid_home_128`, so the unconditional
  `instance_create(0,0,obj_grid_home_128)` a few lines earlier leaks a new
  grid instance every time build mode is toggled on.
- **Dropdown menu leaks 9 UI instances per click.**
  `obj_dropdown_home_customisation`'s Pressed event calls
  `scr_CreateDropdownItems()` unconditionally on every click (both open and
  close), which always creates 9 `obj_dropdown_slots` rows with nothing
  anywhere destroying the previous batch first.
- **No placement validation at all.** `obj_placerParent`'s Draw GUI event
  moves `global.selectedTarget` by keyboard nudge with no `place_meeting`,
  no room-bounds clamp, and no check against other placed items — furniture
  can be pushed off-room or stacked infinitely in one spot. (Also worth
  noting the same architectural issue as elsewhere: input handling and
  instance mutation both live in Draw, not Step.)
- **"Nearest object" selection doesn't actually sort by distance.**
  `ds_list_sort(tempList, true)` sorts the raw ds_list *handles* stored in
  `tempList`, not the `dist` field inside each entry — selection order is
  effectively creation order, not proximity order.
- **Leftover copy-paste flavor text.** `obj_dropdown_slots`' furniture
  category rows ("Doors & Windows", "Kitchen", etc.) still carry verbatim
  vending-machine descriptions (e.g. *"A carbonated Cola derived from fruit
  ingredients"*) instead of furniture descriptions.
- **Minor leaks:** `obj_custom_waypoint_buruwasu` creates a d3d model in
  Create with no Destroy event to free it; `obj_wall_mounted_oil_lamp_custom`
  creates a child light instance and loads a model in Create with no
  Destroy event to clean either up.
- The visible placement grid (`obj_grid_home_128`,
  `obj_wooden_floor_home_128`) is purely cosmetic — there is no actual
  grid-snapping/world-to-cell math anywhere; movement is a raw per-keypress
  pixel nudge, so the grid visual currently implies more precision than the
  system delivers.

No `argument_count`/optional-argument bugs, and no `ds_list`/`ds_map`/
`ds_grid` leaks, were found beyond what's explicitly called out above.
