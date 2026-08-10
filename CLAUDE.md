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
- **Short-circuiting is ON in this project — order conditionals to exploit
  it.** GML stops evaluating a `&&` chain as soon as something is false
  (and a `||` chain as soon as something is true), so the rest is never
  read:

  ```gml
  if (1 + 1 == 3) && (instance_place(x, y, obj_enemy))
  {
      // instance_place never runs - 1 + 1 isn't 3, so the result
      // can't be true no matter what the second half says
  }
  ```

  Two things follow, and both are worth doing deliberately:
  - **Put the cheap checks first.** A variable comparison costs nothing;
    `instance_place`, `collision_*`, `distance_to_object` and anything
    looping over instances cost real time. Guard the expensive call
    behind the cheap one.
  - **Put the most-likely-false check first.** Five conditions that are
    nearly always true followed by one that's nearly always false means
    doing all the work before reaching the one that decides it.

  It also makes a guard and the thing it guards a single expression,
  rather than nested `if`s:

  ```gml
  if (instance_exists(target)) && (target.hp > 0)
  ```

  **The caveat:** this is a per-project setting
  (`<option_shortcircuit>` in `Configs/Default.config.gmx`), not a
  language guarantee. It's currently `True`. If it were ever switched
  off, both halves would evaluate and the guard pattern above would
  crash on a destroyed instance — so if that setting changes, every
  `&&` that guards a dereference has to become a nested `if` again.

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
- **All 54 of the player's solid collision events are now identical:**
  `if global.enablePlayerCollisionsInWorldBuruwasu == true` wrapping a
  single `scr_ResolvePlayerAxisCollision(other)`. `obj_taxi_static` was
  the last holdout on the original `x = xprevious; y = yprevious;` form,
  which both ignored the no-clip toggle and stopped the player dead on
  diagonal contact rather than sliding. Copy an existing event when
  adding a new solid rather than writing the revert by hand.
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
- **A sprite used as a texture on 3D geometry needs its "Used for 3D"
  flag set** (`<For3D>-1</For3D>` in the `.sprite.gmx`). GameMaker packs
  normal sprites onto shared texture pages, which is wrong for a texture
  sampled by `d3d_model_draw` or `d3d_draw_floor`: it needs its own page,
  power-of-two sized, or the UVs address a sub-rectangle of the atlas and
  the texture renders wrong or tiles incorrectly. `spr_coronas` was set to
  `0` and was fixed by hand. Worth checking on any new 3D texture, since
  nothing in the project flags it and the symptom looks like a modelling
  or UV problem rather than a sprite setting.
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

### Vehicle system

- **All 10 drivable vehicles run identical code.** `obj_car`,
  `obj_truck`, `obj_ambulance`, `obj_police_car`, `obj_taxi`,
  `obj_scooter_vehicle` and the four civilian sedans
  (`obj_block_stingray`, `obj_olympics_lemane`, `obj_opera_windsor`,
  `obj_titan_gresely`) each hold nothing but a Create event and one-line
  calls to the shared scripts. Their non-Create event bodies are
  byte-identical — verified by hash — with only the exit icon differing.
  Previously only `obj_car` had the newer physics and the other nine each
  carried their own copy-pasted variant of the old built-in
  `speed`/`friction` model.
  - `scr_VehicleCreateEventBuruwasu(topSpeed, reverse, acc, brake, name)`
    — shared setup plus every handling default.
  - `scr_VehicleStep` — the driving physics.
  - `scr_VehicleDraw` — distance-culled sprite draw.
  - `scr_VehicleDrawGUI` — speedometer, gear, needle, name plate.
  - `scr_VehicleExit(iconObject)` — hands control back and destroys the
    vehicle. Also restores `global.drawOCRange`, which has to happen
    *here*: by the time the player is out, the vehicle instance is gone
    and its own Draw GUI never runs again.
  - `scr_VehicleCollide` — collision response, called from each
    vehicle's Collision events.
- **Vehicle-vs-world collision is per-object Collision events on the
  vehicle**, the same arrangement the player uses. All ten vehicles now
  carry the same **50** of them, derived from the player's own solid list
  rather than assembled by hand — every building type, lamp posts,
  benches, bins, fences, pillars, trees, shop fronts, water. Before this
  the list was three objects on the car and police car, one on most
  others and none on the scooter.
- **Two things the player treats as solid are deliberately excluded from
  vehicles:** the home furniture (`obj_bed`/`obj_cabinet`/`obj_fridge`,
  since no vehicle can reach `rm_ShinjiHome`) and
  `obj_humanNPC_generic_parent`. The NPC one is a design call rather than
  an oversight — making pedestrians solid means a car bounces off a
  person like a wall, which reads worse than driving through them until
  there is something to actually do on impact.
- **If a solid object is added, it needs an event on the player *and* on
  all ten vehicles.** The vehicle set was generated by filtering the
  player's collision events for the ones that revert position, so
  regenerating it that way is easier than editing ten files by hand.
- **The vehicle collision box is sized in code, not by the mask sprite.**
  Every vehicle uses the 128×128 centred `mask_128`, scaled down by
  `scr_VehicleApplyCollisionSize` from a per-vehicle `collisionSize`.
  Left unscaled it gave a 128px-wide box around a car whose visible
  bodywork is ~131 long and only ~64 wide, so the vehicle collided with
  things a clear 32px off either flank — which in play reads as hitting
  nothing at all. `obj_scooter_vehicle` was worse: no mask set, so
  GameMaker fell back to its 623×280 sprite. The call must come **last**
  in Create, after the per-vehicle overrides, or it bakes in the default.
- **`collisionSize` is the vehicle's WIDTH, deliberately not its length.**
  GameMaker's bounding box doesn't rotate with `image_angle`, so a box
  long enough to cover a car pointing north sticks out well past its
  flanks pointing east. Sizing to the width means it never reaches beyond
  the bodywork at any angle; the trade is that the nose enters a wall
  slightly before stopping, which is the better failure for something
  you drive. Note this only became visible when the collision list grew
  from 3 objects to 50 — the oversized box had been there all along.
- `scr_VehicleCollide` damps `yawRate` as well as reverting the position,
  which the old per-object version didn't: under the bicycle model the
  body carries rotation independently of its velocity, so reverting
  position alone left a vehicle spinning on the spot against a wall.
- **A vehicle is only reachable if `obj_player_buruwasu` has a Collision
  event for its icon.** That is the entry point for all of them —
  `instance_create` the vehicle, set `global.inVehicle`, then
  `with (other) instance_destroy()` to remove the icon that was actually
  touched. The icon objects existing and being placed in a room is not
  enough on its own. The four civilian sedans shipped for a long time
  with icons placed in `rm_city_buruwasu` but no matching event, so they
  were completely undrivable; that is now wired up. `obj_taxi_icon` is
  the deliberate exception (see As designed).
- **Per-vehicle character comes from overriding the defaults after the
  create call**, not from separate code. A truck sets `yawInertia = 260`
  and `steerLockTop = 5`; a police car sets `frontGrip = 0.17` and
  `handbrakeGrip = 0.18`. Anything not overridden stays on the sedan
  defaults.
- **The physics is a slip-angle bicycle model**, not the older "rotate
  the heading, then bleed off sideways velocity" approach. Front and rear
  axles each generate lateral grip from their slip angle up to a traction
  limit, so drift, countersteer recovery and weight transfer all fall out
  of the model rather than being special-cased. Rotation is a real yaw
  rate with inertia, and the steering wheel moves at a limited rate —
  those two are what stop it feeling like a turret on ice.
- **`acc` and `forwardspd` are not independent — drag caps the top speed
  reachable from a given `acc`.** Terminal velocity is
  `acc * drag / (1 - drag)`, which at `drag = 0.995` is `acc * 199`, so
  reaching a top speed of V needs **`acc >= V / 199`** with headroom on
  top or it takes forever to get there. Five vehicles failed this after
  the physics rewrite: the taxi and three civilian sedans were on
  `0.05 / 3`, capping them at 3.3 against a `forwardspd` of 6, and the
  scooter on `0.05 / 9`, capping it at 1.1 against a stated 4.65 — a
  quarter of its intended speed. Those values were tuned for the old
  built-in-speed model, where drag behaved differently, and were carried
  over unchanged. All ten now clear it, ranging from 1.9s to top speed
  (Stingray) to 5.1s (taxi). **Raise `acc` alongside `forwardspd`, and
  check the 0-to-top time rather than assuming the number took effect.**
- **Wheelbase has to be large relative to per-step travel.** The original
  numbers had `axleFront`/`axleRear` at 1.1 against a top speed of 6px a
  step, so the car covered 2.7 wheelbases per frame where a real one
  covers about a fifth of one. That made cornering grip-limited rather
  than steering-limited and gave a 67px turn radius at top speed — the
  car could pivot on the spot. It's now a 40px wheelbase with
  `steerLockTop` at 7°, giving ~417px at top speed and forcing you to
  slow for corners. If these are ever retuned, measure rather than guess:
  steady-state radius is `speed / yawRate`, and `yawDamp` is coupled to
  it (lowering it widens *every* corner, because sustained rotation then
  needs more torque).
- `scripts/scr_DrawVehicleDebugOverlay.gml` shows live slip angles, grip
  used per axle as a percentage, lateral velocity and a drifting
  indicator, toggled in game with the `/physics` console command. Its
  header maps symptoms to dials — reach for it before changing numbers.

### Performance: scenery culling

- **`rm_city_buruwasu` holds ~6,800 instances, ~93% of them static
  scenery**, and the per-instance `point_distance` check every object's
  Draw event runs only skips the *drawing* — not the event dispatch,
  which at that count is most of the cost.
  `scripts/scr_CullDistantScenery.gml` deactivates distant scenery
  outright so it runs nothing at all, re-culling only once the player has
  moved `global.cullStep` pixels. Called from `obj_control`'s Begin Step.
- **It only ever touches a fixed allowlist of static geometry** — floors,
  walls, roads, pavements, grass, water. NPCs are deliberately excluded:
  deactivating one freezes it mid-walk and stops its AI alarms, so the
  city beyond the draw distance would quietly stand still and anything
  walking somewhere would never arrive. The player, `obj_control`, the
  GUI, spawners, triggers and pickups are out for the same reason. Check
  a candidate for Step/Alarm events before adding it to that list.
- **`global.cullRange` must stay above the widest `global.drawOCRange`
  ever gets**, because a deactivated instance doesn't draw either — cull
  closer than you draw and the world has visible holes in it.
- **`global.drawOCRange` used to compound.** With camera zoom on,
  entering a vehicle did `drawOCRange = drawOCRange * 2` and nothing put
  it back, because the only reset lived in the vehicle's own Draw GUI,
  which stops running the moment the instance is destroyed. Across a
  session it went 750 → 1500 → 3000 → 6000, and since it's a radius each
  doubling quadruples how much of the world is drawn. There is now a
  `global.drawOCRangeBase` that the current range is always set *from*,
  never multiplied into.
- Toggle culling in game with `/cull` to A/B it.
- **All quality-switched textures are resolved centrally by
  `scripts/scr_UpdateQualityTextureCache.gml`**, called from
  `obj_control`'s Begin Step, into `global.tex*` pointers the drawing
  objects read. 25 objects (~1,700 instances) used to run a
  `switch(global.*Quality)` with a `sprite_get_texture` lookup in their
  Draw every frame; now it is four integer compares per frame, with the
  lookups re-run only when a quality setting changes. **A new
  quality-switched object must be added to that script, not given its own
  switch.** The trackers are forced to `-1` in `obj_control`'s Create so
  the cache rebuilds on the first frame of every room — `cleanmem()` on
  room transitions can unload texture pages, and a texture pointer cached
  in the previous room dies with them. Skipping that reset turns the
  cache into an intermittent white-model bug. (This also retired old
  the house block's dead `TEX1` issue — that and four siblings were
  deleted as part of the sweep.)

### Minimap

- **An always-on panel, separate from the Tab map.** `scr_DrawMinimap`
  draws a bordered box centred on the player;
  `scr_minimap` (Tab, unchanged) still lays the whole 25000×25000 room
  out at once. They share a colour scheme deliberately, so the two read
  as the same map at different zooms: pale blocks are buildings,
  mid-grey is pavement, and roads are simply the dark gaps left between
  them rather than anything drawn.
  - `scr_MinimapMark` — converts one world position to the panel and
    clips it by clamping to the panel bounds (no surface, so no surface
    lifetime handling, and a blip straddling the edge still shows its
    visible half).
  - `scr_DrawMinimapBackdrop` / `scr_DrawMinimapFrame` — these bracket
    the contents. Fill underneath, frame on top; drawing the whole border
    up front let the clipped blips chew its inside edge.
  - `scr_DrawMinimapArrow` — the player marker.
- **Both maps mark the player from `obj_player_buruwasu`, never from the
  vehicle.** `scr_VehicleStep` parks the player instance on top of
  whatever you're driving every step, so its position is already the
  vehicle's — one marker covers all ten vehicles and anything added
  later. The Tab map used to branch per vehicle type and only listed
  `obj_car` and `obj_police_car`, so the other eight left it with no
  marker at all while you drove them.
- **Every scenery variant has to be listed by name, in three places.**
  Ground and structure are separate objects per city and per orientation
  rather than one object with a texture switch, so each needs its own
  `with()` in `scr_DrawMinimap` **and** in `scr_minimap` (the Tab map),
  plus an `instance_deactivate_object` in `scr_CullDistantScenery`. Miss
  one and it is simply absent from the map while rendering perfectly in
  the world, which is what makes it look like a rendering bug. Found this
  way, all at once: Ichihara drew 73 of its 161 pavement tiles (the snow
  variant was missing), Yokyohama drew none of its 91 and only the
  east-west half of its highway (`obj_roadv_highway` was never listed
  while `obj_roadh_highway` was), and every interior was near-blank
  because the mall floor and interior wall blocks were on no list at all.
  **The pattern to watch is paired or per-city objects** — an `h`/`v`
  pair, or a per-city variant, where only one member got added.
- **Minimap colours and what they mean.** Pavement is grey
  `rgb(150,150,150)`; Ichihara's snow pavement a cold `rgb(176,198,219)`,
  deliberately not near-white since exterior buildings are already pure
  white; mall and interior floors the same black/white checker as the
  mall pavement outside, so the surface reads as continuous through the
  entrance; interior walls (`obj_modern_mall_interior_block`, used by the
  mall, Chicken Licken and Shinji's home alike) a slate
  `rgb(96,112,150)`, because white walls would vanish into the pale floor
  they stand on. Interior walls must be drawn **after** the floor.
- **It is only affordable because of the scenery culling**: `with()`
  skips deactivated instances, so its ~25 loops touch what's nearby
  rather than all ~6,800 instances. Turning culling off with `/cull`
  makes the panel walk everything every frame.
- Consequently **`global.minimapRange` must stay inside
  `global.cullRange` — its *diagonal***, or the panel's corners show
  empty ground that has merely been deactivated. 1400 against a 2200 cull
  radius leaves room.
- **The player arrow must not use `obj_control.bearing`.** That is set to
  90 in `obj_control`'s Create and afterwards written *only* by
  `scr_VehicleStep`, so on foot it never leaves north and the arrow sits
  frozen. `obj_player_buruwasu.direction` is what tracks facing on foot;
  `bearing` is right *in* a vehicle, because that's what the vehicle just
  wrote to it.
- **`draw_triangle` needs culling turned off.** This project's standing
  state is `d3d_set_culling(1)` (which is why `obj_bed` and `obj_cabinet`
  turn it off and set it back to 1), and culling silently discards any
  triangle whose vertices are wound the wrong way. GameMaker generates
  `draw_circle`/`draw_rectangle` geometry itself with a winding that
  survives; a hand-specified triangle does not get that courtesy. The
  arrow was being discarded entirely — the circle marker beside it drew
  fine and changing the size changed nothing, which is the signature of
  this rather than of a geometry bug. `scr_DrawMinimapArrow` disables
  culling for the duration, restores it to 1, and draws both windings.
- Toggle with `/minimap`.

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
- **`gp_face1` is not "the bottom face button" — it's just raw index 0
  passed straight through.** The runtime does no per-layout translation
  at all. Proven with the debug overlay: holding Cross on a DualSense
  lights raw index **1** and reports **`gp_face2`**. So `gp_face1` is A
  on an Xbox pad but **Square** on a DualSense, and there is no API that
  reports which layout you have. `scripts/scr_GamepadUsesPlaystationLayout.gml`
  matches on the device name to decide, and
  `scripts/scr_GetGamepadConfirm.gml` picks *either* raw index 1 *or*
  `gp_face1` on that basis — deliberately not OR-ing them, since OR-ing
  makes two different buttons both confirm (on a DualSense, Cross *and*
  Square). Name matching is a guess; a rebindable confirm button in the
  options menu is the real fix, and would delete this whole problem.
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
- The main menu's Enter action lives in `scripts/scr_MainMenuSelect.gml`
  so the keyboard event and the gamepad path run the same code rather
  than two copies. It must be called from
  `obj_main_menu_controller_buruwasu` — it resolves that object's
  `menuChoice`/`hasStartedLoading`/`progress` and sets its `alarm[0]`
  against the calling instance.
- **Not built yet:** any gamepad input outside the main menu — no cancel/
  back button, no horizontal navigation, no in-game or
  furniture-placement support (see #43, no controller support for
  furniture placement), and no rebinding.

### On-screen message boxes

- **`scripts/scr_DrawNotificationBox.gml` draws every fading black message
  box in the top-left**, and both `obj_notification_system_out` and
  `obj_TutorialBoxRotateCamera` call it. They used to hold their own
  copies of the same layout, which is precisely how the tutorial box got
  left drawing underneath the minimap when the notification box was moved
  clear of it. Any new prompt should call this rather than copy it.
- It positions itself from `global.minimapPad` and `global.minimapSize`
  rather than a fixed x, so resizing or moving the minimap doesn't put the
  messages back underneath it, and falls back to the original position in
  rooms with no minimap globals.
- Two things worth knowing if the layout is ever changed: the text wraps
  to the box *interior*, not the full box width (the original wrapped at
  the full width while drawing 30px inside, so long messages ran past
  their own right edge), and the height comes from `string_height_ext`
  measured **after** the font is set, since it measures against whatever
  font is current.

### Curved panels drawn in code

- **`scripts/scr_DrawCurvedPanel.gml`** draws the fast-travel loading
  screen's text panel — dark interior, edge lifting to white — sized to
  the text it wraps. It replaced a full-screen 1920x1080
  `spr_curved_rectangle` that **never existed as a resource** and crashed
  fast travel to every city. Worth remembering the failure mode: GML
  resolves an unknown name as an undefined *variable*, so a missing sprite
  reports as "not set before reading it" rather than naming the sprite,
  and it can't be guarded with `sprite_exists` because the identifier
  itself is what fails.
- **`scripts/scr_DrawCurvedRect.gml`** is the shape primitive underneath
  it, built from `draw_rectangle` and `draw_circle` rather than
  `draw_roundrect`. Two reasons, both worth keeping: those are the shapes
  this project already knows survive its standing `d3d_set_culling(1)`
  (see the `draw_triangle` note under Minimap), and `draw_roundrect` gives
  no control over corner radius while the `_ext` variants that do aren't
  guaranteed across 1.4 builds.
- **It draws opaque deliberately.** Its shapes overlap, so below alpha 1
  the overlaps blend twice and show as darker seams. Avoiding that needs
  arcs, which is exactly the hand-wound geometry the culling state
  discards — so the gradient in `scr_DrawCurvedPanel` is a stack of
  opaque rings rather than anything transparent.
- The panel measures with `string_width_ext`/`string_height_ext` **after**
  setting the font, the same ordering `scr_DrawNotificationBox` needs, and
  takes its width from the text rather than the wrap limit so a short
  description doesn't get a screen-wide box. Two city descriptions
  (`CITY_NAGASEGAI_DESC`, `CITY_BURUWASU_DESC`) are still the placeholder
  `"GG"`, which is what made that matter.

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
before being recorded here. The list is renumbered contiguously when items
are removed, so a number identifies an item only within the version of
this file you are reading — **if you cite one somewhere else, cite the
title too**, or the reference will quietly point at a different issue the
next time the list is compacted. That has already happened once.

### Player & collision (`obj_player_buruwasu.object.gmx`)

- **1. `global.enablePlayerCollisionsInWorldBuruwasu` initialization order.**
  Set in `obj_global_buruwasu`'s Create event but read from player collision
  events; GMS1.4 doesn't guarantee Create-event order across differently
  named objects, so this is a latent "read before set" risk if instance
  order ever changes.
- **2. `obj_land_mask` and `object192` are suspicious but left untouched.**
  Both are placed only in `rm_city_ichihara`, and both have **identical**
  Create-event code loading the same `TERRAIN/hill.d3d` model. `object192`
  is GameMaker's auto-generated default name for a never-renamed object —
  strong evidence it's an accidental leftover duplicate of `obj_land_mask`
  rather than a second intentional hill. Whether either (or both) should be
  solid is a design call, not something to guess at.

### Vehicles & world performance

Found while unifying the vehicles and chasing the spawn-area framerate;
none of these were fixed.

- **3. The water animation is broken, not just idle.**
  `obj_water_anim_buruwasu`'s alarm increments `image_index_animation`,
  and then its Step event immediately does
  `image_index_animation = image_index`, overwriting what the alarm just
  set. 615 instances in the spawn room each run that every frame to
  achieve nothing. (It is in the culling allowlist, which is safe — the
  worst case is off-screen water holding a frame — but the animation
  wouldn't play even if it weren't.)
- **4. `obj_side_walk_buruwasu` calls `randomize()` in its Create
  event** — 2,029 instances in `rm_city_buruwasu`, so 2,029 reseeds of
  the RNG at room load. `randomize()` is meant to be called once at
  startup; doing it per instance is both a load-time cost and a way to
  defeat any deterministic seeding.
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
consistently.

**Lighting has an established convention: each object turns it on for
its own draw and off again afterwards** — `d3d_set_lighting(1)` → draw →
`d3d_set_lighting(0)` — so the resting state between objects is off and
nothing leaks onto whatever draws next. 68 of the drawing objects follow
it. The only per-frame exception was `obj_alleyway_floor`, which turned
lighting on and never turned it back off, lighting everything drawn after
it that frame; that is fixed. **`obj_control` used to set lighting ON in
its Create** — described here previously as harmless because it runs once
as engine setup. It wasn't: running once was exactly the problem, because
nothing was responsible for putting it back. Anywhere the player stood
with no lighting-managing object in draw range, lighting simply stayed on
from room start, and everything drawn after it — models, sprites, text
and the entire Draw GUI including the minimap — rendered against the
ambient light. `obj_weather_controller` sets that ambient to pure white
(255,255,255) at 12:00, so at midday the screen washed out completely
until the player walked near a building, whose own draw turned lighting
off again. That is what made it look positional and self-correcting.
`obj_control`'s Create now sets lighting **off**, so the resting state is
off everywhere and consistently.

The remaining draw-state issues:

- (Same issue as #18) `obj_battle_enemy_hud` leaves color set to `c_aqua`.
- **22.** `obj_waypoint_controller_buruwasu`'s Draw GUI event sets
  `draw_set_halign(fa_center)` and never restores `fa_left`.
- **23.** `obj_car_icon` / `obj_taxi_icon` only call `draw_set_alpha_test(false)`
  in the *out-of-range* branch, leaving alpha testing on indefinitely
  whenever the in-range branch draws instead.
- **24.** Several menu/HUD objects (`obj_main_menu_options`,
  `obj_dropdown_home_customisation`, `obj_dropdown_slots`,
  `obj_vending_machine_ui`, `obj_property_management_slots`) set
  font/color in their Draw GUI events and never restore a default.
  `obj_notification_system_out` and `obj_TutorialBoxRotateCamera` are
  partly off this list now: `scr_DrawNotificationBox` restores colour and
  alpha, but still leaves the font on `ft_map_editor_buruwasu`. Nothing
  in the project defines what the font should be restored *to*, which is
  the actual gap — there is no agreed resting font the way there is an
  agreed resting lighting state.
- Good examples already in the codebase to model fixes on:
  `scr_DrawCollisionBoxModel.gml` (resets alpha/color/transform at the end)
  and `obj_cursor_grab_64` (checks `instance_exists` before dereferencing
  its target).
- **25.** `scripts/DrawArrowWaypoint.gml` line 16 reads `_maxDistance`, which is
  never declared — the actual variable is `_maxLength`. Dead code today,
  but will throw immediately if ever wired up.
- **26.** `obj_gui_buruwasu`'s Draw GUI event computes health/stamina bar
  percentages with no guard against a zero max — a real divide-by-zero
  risk if either max stat is ever zeroed elsewhere.
- **27.** `draw_text_shadow_tooltips.gml` hardcodes its draw position to
  `(20, 1000)` regardless of caller-supplied coordinates, so if two
  interactables are ever in range at once, their prompts overwrite each
  other at the same spot.
### Dialogue controller (`obj_masterDialogueControllerBuruwasu`)

- **28. Hardcoded `message[]`/`message_end` desync risk, already bitten once.**
  Both this object and its near-clone `obj_battle_start_dialogue` define
  only `message[0]` with `message_end = 0`. The counts match today, but the
  code's own comment — *"if there are more messages left to show (0 -> 6,
  in our case)"* — is leftover from a 7-line template, i.e. this exact
  desync has already happened once before. Adding a new line without
  bumping `message_end` will make it silently unreachable.
- **29. Forced intro dialogue replays every time on 10+ rooms.** The same
  instance (identical hardcoded text) is placed non-persistently across
  most city/interior rooms. Its Draw GUI event shows the box unconditionally
  on room load with no "already seen" flag, so re-entering any of these
  rooms replays the same line every time.
- Input handling is solid: line-advance correctly uses
  `keyboard_check_pressed`, only the hold-to-speed-up uses the level check
  `keyboard_check` — no held-key multi-line-skip bug.

### Map system

- **30. `obj_buruwasu_map`'s Room Start event calls
  `room_instance_add(global.newRoomCityBuruwasuMap, 0, 0,
  obj_draw_map_buruwasu)`** — `obj_draw_map_buruwasu` is not a defined
  object anywhere in the project. `scr_BuruwasuDrawMap.gml` (unreferenced
  elsewhere) looks like the per-instance icon-draw code this object was
  meant to run, and it also references an undeclared variable `gsc` (the
  rest of the project uses `gui_scale`) — this looks like an
  abandoned/broken refactor.
- **31.** The `room_instance_add(...)` call above also runs **outside** the
  `if global.newRoomCityBuruwasuisGenerated == false` guard that correctly
  wraps the preceding `room_duplicate` — so it re-runs (and re-appends) on
  every map visit even though the room duplication itself is correctly
  gated to happen once.
- **32. Room-space/GUI-space mismatch for the debug map marker.** The middle
  mouse-press handler in `obj_buruwasu_map` stores room-space
  `mouse_x`/`mouse_y` into `global.targetedX/Y`, but the Draw GUI event then
  draws that value directly in GUI space — the marker lands in the wrong
  spot whenever the view scrolls/zooms.

- **33.** No fast-travel/unlock validation exists to check — the only
  destination-selection mechanic found is an in-city waypoint marker, no
  cross-city travel code path was located.

### Home customisation system

- **34. Dropdown menu leaks 9 UI instances per click.**
  `obj_dropdown_home_customisation`'s Pressed event calls
  `scr_CreateDropdownItems()` unconditionally on every click (both open and
  close), which always creates 9 `obj_dropdown_slots` rows with nothing
  anywhere destroying the previous batch first.
- **35. No placement validation at all.** `obj_placerParent`'s Draw GUI event
  moves `global.selectedTarget` by keyboard nudge with no `place_meeting`,
  no room-bounds clamp, and no check against other placed items — furniture
  can be pushed off-room or stacked infinitely in one spot.
- **36. "Nearest object" selection doesn't actually sort by distance.**
  `ds_list_sort(tempList, true)` sorts the raw ds_list *handles* stored in
  `tempList`, not the `dist` field inside each entry — selection order is
  effectively creation order, not proximity order.
- **37. Leftover copy-paste flavor text (partially fixed).** The
  Bedroom/Kitchen/Living rows now have real furniture descriptions (see
  Architecture notes, Home customisation system), but the other 6
  category rows in `obj_dropdown_slots` still carry verbatim
  vending-machine descriptions (e.g. *"A carbonated Cola derived from
  fruit ingredients"*) — moot until those categories have a matching
  furniture type to describe (see #45).
- **38. Minor leaks:** `obj_custom_waypoint_buruwasu` creates a d3d model in
  Create with no Destroy event to free it; `obj_wall_mounted_oil_lamp_custom`
  creates a child light instance and loads a model in Create with no
  Destroy event to clean either up.
- **39.** The visible placement grid is purely cosmetic — there is no actual
  grid-snapping/world-to-cell math anywhere; movement is a raw per-keypress
  pixel nudge.
- **40. TO DO: no slot-picker UI.** `global.currentSaveSlot` (1-5) exists
  and `scr_SaveHomeFurniture`/`scr_ApplyHomeFurniturePositions` are fully
  slot-aware, but nothing in the game lets the player choose or see which
  slot is active — it always stays at its default of `1` until a picker
  is built (e.g. in the options/save menu).
- **41. Minor: shipped default furniture layout is hardcoded in two
  places.** `scripts/scr_SaveHomeFurniture.gml` and
  `scripts/scr_LoadHomeFurniture.gml` both independently hardcode the same
  three `ini_write_string` lines —
  `"defaults", "item0", "obj_fridge,0,640,384,0,0"`,
  `"item1", "obj_cabinet,1,896,640,0,0"`, and
  `"item2", "obj_bed,2,1376,368,0,180"` — with no shared constant/script
  between them. If the room's default layout is ever changed (or a
  fourth default piece added), both files need updating by hand or
  they'll silently disagree about what "defaults" means.
- **42. TO DO: no rotation support in the placement UI.**
  `obj_placerParent`'s Draw GUI event only reads `vk_up`/`vk_down`/
  `vk_left`/`vk_right` for `move_dx`/`move_dy` — there's no input at all
  for changing a selected piece's rotation. Even if there were,
  `obj_cabinet` and `obj_fridge` have no `zRotation` variable to begin
  with (their Draw events hardcode `d3d_transform_add_rotation_z(0)`) —
  only `obj_bed` supports rotation today, and only via room creation code
  set once at placement time, not interactively.
- **43. TO DO: no controller/joypad support for furniture placement.**
  Gamepad support now exists, but only in the main menu — see Architecture
  notes, Gamepad input. Selecting, moving, and (per #42, no rotation
  support in the placement UI) any future
  rotating of furniture is still keyboard/mouse-only
  (`keyboard_check_pressed`, `mouse_wheel_up`/`down`). The reusable
  scripts to wire this up are already there; `obj_placerParent` just
  doesn't call them yet.
- **44. TO DO: still no way to remove furniture once placed.** Adding is
  now possible (see Architecture notes, Home customisation system), but
  `obj_placerParent` has no delete action at all — only select and
  reposition. A misclicked or unwanted piece can only be nudged
  off-screen, not actually removed.
- **45. Only 3 of the 9 dropdown categories have a matching furniture
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
- **46. TO DO: adding furniture is free.** Each dropdown row already
  carries `price`/`upkeep` fields (left over from the vending-machine
  code this UI was copied from), and `global.yenAmount` already exists
  and is tracked/saved elsewhere, but nothing in the new add-furniture
  flow reads `price` or deducts it — every add is currently instant and
  free, with no funds check at all.

No `argument_count`/optional-argument bugs, and no `ds_list`/`ds_map`/
`ds_grid` leaks, were found beyond what's explicitly called out above.

## Planned features (not built yet)

Design intent recorded so it isn't lost, kept separate from Known Issues
on purpose: those are findings checked against the source and carry stable
reference numbers, these are things that don't exist yet. Nothing below has
any code behind it.

### Expanded JRPG-style equipment and attributes

A real equipment and stat layer. Nothing exists today beyond
`global.weapon` (an integer, set in `obj_global_buruwasu`) and the
health/stamina pair the HUD draws, so this is a system to build rather
than one to extend.

### Introductory story cutscenes

Cutscenes that open the game and deepen the narrative. Worth knowing
before starting: the dialogue controller is fixed, non-branching text with
no "already seen" flag, which is why the intro line currently replays on
every entry to 10+ rooms (#29). Cutscenes that should play once will need
that solved first, since it's the same missing piece.

### Enemy Groups

Randomly spawned around Buruwasu, attackable at any time for rewards.

| Group | Health | Damage | Money | Notes |
|---|---|---|---|---|
| Delinquents | Low | Normal | Normal | Lowest tier, easy to defeat |
| Yakuza | Low | **High** | — | Glass cannon — hits hard, dies fast |
| Thugs | Normal | — | — | Run of the mill |
| Nouveau Riche | High | Medium | **Substantial** | Gold suits. Rare spawn. **Needs a new sprite/model** |
| Homeless People | Low | Low | **None** | Deliberately drops no money |
| Racers | Normal | — | — | A rare 5% chance to drop an accessory item (Racing Helmet) |
| Bikers | Normal | — | — | A rare 5% chance to drop an accessory item (Biker Jacket) |
| Loan Sharks | Normal | High | High | Standard |
| Pickpockets | Normal | Normal | Normal | A rare 5% chance to drop an accessory item |
| Drunkards | Low | Normal | Low | A rare 5% chance to drop a Sake bottle item |
| Scammers | Normal | Medium | Low | Standard |
| Extortionists | Normal | — | — | Standard |
| Corrupt Cops | Normal | — | — | Standard |
| Arsonists | Normal | — | — | Standard |
| Vandals | Normal | — | — | Standard |

Three things worth deciding before building this, all of them recorded
here rather than discovered halfway through:

- **11 of the 15 are specified identically** — standard health, no other
  distinguishing trait. As written they differ only by name and sprite, so
  either they need something mechanical to tell them apart (weapons,
  behaviour, where and when they spawn, what they drop) or the list is
  really four enemy types plus eleven skins. Both are legitimate; it's
  worth being the deliberate choice.
- **The battle system currently supports exactly one encounter at a time.**
  `obj_battle_encounter` resolves its HUD and dialogue with
  `instance_exists` rather than per-encounter ids (#13, #20), so a second
  concurrent fight misbehaves. Enemies spawning freely around a city means
  concurrent encounters by definition, so #13 and #20 are prerequisites,
  not tidy-ups. `obj_battle_hud` is also orphaned (#19).
- **The NPC spawner has two live bugs** (#10, #11) — it tests the spawner's
  own position instead of the candidate point, and its `with createNPC`
  targets the object rather than the new instance, so it can destroy
  unrelated NPCs. Anything reusing that machinery to place enemy groups
  inherits both.

## As Designed (Not Changing)

Things that look like bugs on first read but are intentional — confirmed by
the person who actually knows the design intent, not something inferable
from the code alone. Recorded so they don't get "fixed" again.

- **1. `obj_line_of_ladies` having no `spriteName`/`maskName` is intentional,
  not missing.** It draws its own `lineofladies.d3d` model directly via
  `d3d_model_draw` in its Draw event (same pattern as every other 3D-model
  prop), completely independent of the sprite/mask system — it does
  visibly render, contrary to an earlier note in this file. It has no
  sprite because it doesn't need one for collision: it's elevated
  (`z = 223` in Create) and out of the player's reach at ground level, the
  same reasoning that already applies to `obj_fire_escape_three_floors`.

- **2. The `obj_taxi_icon` collision being a no-op stub is intentional.** Its
  body in `obj_player_buruwasu` is just `x = x` / `y = y`, where every
  other vehicle icon spawns a rideable vehicle and sets
  `global.inVehicle`. That difference is the point: the taxi is fast
  travel, not a car you drive, and the actual fast-travel interaction
  lives on `obj_taxi_corona`. Do not "fix" this by making it spawn
  `obj_taxi`, and **leave the stub body alone** — it reads as dead code
  worth deleting, and that has been considered and declined.

- **3. `obj_taxi` is orphaned, and that is fine.** It carries the full
  shared vehicle setup — create call, physics, draw, exit — and is
  byte-identical to the other nine, but nothing ever `instance_create`s
  it and it is placed in no room, because the taxi is fast travel rather
  than a car you drive (see item 2 above). So all of that code is
  unreachable. Note its exit passes `obj_taxi_icon`, which is the
  fast-travel marker — so if it were ever made drivable, parking it would
  drop a fast-travel icon.

- **4. `obj_ichihara_temp_map` being invisible is intentional.** Its
  Create event sets `image_alpha = 0`, and it is placed in
  `rm_city_ichihara` purely as a reference image for laying the city out
  in the room editor. It is never meant to render in-game.
  

## Reviewer's take

An assessment of the codebase by an AI assistant, revised 2026-08-07. It
makes judgements rather than only listing facts, but every judgement here
should be traceable to something checkable in the project — the previous
version of this section leaned on praise and impressions that weren't.
Where something is inference rather than observation, it says so.

**What it's based on.** Two working passes: an in-depth read of nearly
every system (2026-07-18), and a stretch of implementation work across
vehicles, physics, rendering, performance, input and the map
(2026-08-07). Both were code-only. Nobody writing this has played the
game, which rules out any claim about pacing, narrative or how the cities
feel to move through — which is most of what decides whether a game is
good.

**Measurable characteristics.** ~250 objects, ~130 scripts, ~190
`global.*` variables, and a spawn room holding ~6,800 instances of which
~93% is static scenery. Naming is consistent (`obj_`/`scr_`, camelCase
scripts) across the whole tree. GameMaker Studio 1.4, using its 3D
functions to draw real `.d3d` models inside a top-down 2D game.

**The strongest pattern, and the one I'd act on: systems are built for
the case being tested and break outside it.** The battle system resolves
its HUD and dialogue with `instance_exists` rather than per-encounter
ids, so a second concurrent encounter misbehaves (#13, #20). The HUD fade
worked only on a room's first entry. Nine of ten vehicles carried a copy
of the older physics, and the Tab map only ever marked two of them. This
is the best-supported observation in this file, and it's the one that
predicts where the next bug will be.

**Three other recurring patterns.**

- *Copy-paste reuse without a follow-up pass.* The furniture dropdown
  began as a duplicated vending-machine UI and six of nine rows still
  carry vending-machine text (#37, #45). The vehicles held divergent
  copies of the same event bodies. Both worked; the cost arrived later,
  when one change had to be made in nine places.
- *Draw-state leaking between instances.* Colour, alpha, font,
  alpha-test and lighting get set without being restored in various
  places (#18, #22, #23, #24). `global.drawOCRange` compounded across a
  session because its only reset lived in an object that had already been
  destroyed. Individually minor, collectively expensive, because the
  symptoms are order-dependent and don't reproduce on demand.
- *Gameplay logic in Draw events.* Battle state transitions and combat
  input both live in Draw GUI (#15, #16). Draw isn't guaranteed to run
  under all conditions, so this is a correctness problem wearing a
  rendering costume.

**On global state, including the case against my own criticism.** ~190
globals initialised across `scr_globals.gml`, `obj_global_buruwasu` and
per-object Create events, with no single owner, sits behind more "why
doesn't this work" bugs here than anything else. But the count itself is
a weak complaint: GMS 1.4 has no structs, no static state and no module
scope, so globals are the idiomatic tool and a project this size will
have many. The real, fixable problem is narrower — initialisation is
split across three places with no defined order. That's what turns
read-before-set and stale-value bugs from one-offs into a recurring
class, and it's worth consolidating on its own merits.

**What I'd prioritise, and why it's a judgement call.** I'd put the
global-state consolidation and moving battle logic out of Draw ahead of
any feature work, because both keep producing the same category of bug
and get more expensive to unwind as more is built on them. The honest
counterargument: neither is currently blocking anything a player would
notice, and a game with shallow combat and no investigation mechanic
arguably needs depth more than it needs internal tidiness. If the goal is
shipping something people enjoy rather than something maintainable, that
ordering flips.

**Evidence about how the project responds to change.** Every issue
addressed across both passes was fixable with a scoped change; none
needed a rewrite. That's a real strength and worth stating plainly.
Three cautions from the second pass, though, and they're the most useful
part of this section:

- A scripted rewrite of the ten vehicle objects silently discarded
  collision events nine of them had. The parity checks missed it because
  the events were removed from all ten equally — **consistency checks
  confirm uniformity, not correctness**, and that distinction cost a
  working feature for several commits.
- Two entries in this file were wrong when acted on: the lighting
  draw-state entry had the convention backwards, and the civilian-sedan
  pickup-icon entry described a one-line fix for
  what was actually an unwired feature. This file is load-bearing for
  anyone working here, and it drifts.
- A `draw_triangle` call failed silently for several iterations because
  backface culling is on project-wide — invisible from the drawing code.
  The 3D layer carries global state that isn't discoverable locally.

**On design — inference from the code, not from playing.** The systems
imply a wide scope: murder-mystery narrative, open-ish exploration, home
customisation with per-slot persistence, real-time combat, fast travel, a
day/night clock, weather, collectibles. From the code most sit at
first-pass depth: combat is a click reducing one enemy's health, NPC AI
is a small state machine, dialogue is fixed non-branching text. My
opinion is that this is the project's biggest design risk, and more
specifically: **no investigation or deduction mechanic exists in any
system reviewed** — no clue collection, evidence log, or dialogue
branching on what the player knows. For a game framed as a murder
mystery, the thing the premise promises isn't in the code yet. That may
be sequencing rather than oversight, and it may live in a system not
reviewed, but it's the gap I'd close first on the design side.

**What this can't establish.** Whether the game is enjoyable, whether the
narrative works, whether the scope suits the team. It also can't
reliably separate deliberate placeholders from unfinished work — several
things recorded here as issues turned out on asking to be intentional
(see As designed). Treat the judgements above as arguments to weigh, not
findings to action unread.

## Update notes

Player-facing patch notes, most recent first — written so they can be
copy-pasted straight into an itch.io devlog/update post. Add a new dated
entry here each time a Known Issue is fixed or a piece of work lands;
keep the technical specifics (scripts, object names) out of this section
and in Architecture notes / Known Issues instead.

### August 10, 2026

**Fixes**
- The maps now show what's actually there. Ichihara was drawing only its
  non-snowy pavement, Yokyohama none of its own and only half its
  highway, and indoor areas — the mall, Chicken Licken, your home — were
  nearly blank because floors and interior walls were never drawn at all.
  All fixed on the minimap and the full map alike; the streets and rooms
  were there in the world the whole time, just missing from the map.
  Ichihara's snow pavement now reads as its own cold blue-grey rather
  than ordinary kerb.
- Fast travel no longer crashes the game. Picking any destination from the
  taxi menu and confirming it would drop straight to an error on the next
  frame — every city was affected, not just the one being travelled to.
- The burning barrel now has its own artwork at every graphics quality
  setting. It was wearing the wall lamp's texture on four of the five
  settings, so it only looked right on Medium.
- Moved the taxi rank marker so it lines up with the rank itself.
- New texture for the taxi.
