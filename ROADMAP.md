# Ninkyo Dantai — Road to Steam

A concrete, quarter-by-quarter plan for a Steam release roughly 12 months
out. Written after an in-depth code review of the whole project (see
`CLAUDE.md` — Architecture notes, Known issues, and the Reviewer's take).

**Assumptions baked into this plan** (adjust the pacing if these are
wrong for you):
- Solo or near-solo dev, part-time (~15-20 hrs/week).
- Self-funded, no contractor budget assumed by default.
- PC release, Windows-first (GMS1.4's Mac/Linux export is legacy and
  under-tested compared to Windows — don't assume day-one multi-platform
  without validating this early).
- Target: Steam release ~12 months from the plan's start date.

## Game identity: exploration-driven clue discovery

This is the single most important decision in this document, because it
determines what "content" even means for the rest of the year — and it's
chosen specifically to lean into systems/tech work over hand-authored
narrative content, since that's where your energy actually goes.

**The pitch:** no branching dialogue trees, no deduction-choice menus.
Clues are physical things in the world that the player finds by
exploring — a dropped item, a note, a broken window, tire tracks, a
light on in a window at the wrong hour. The city is the puzzle, not a
conversation tree.

Genre-wise, this reads as a small-scale **Yakuza/Persona-style hybrid**:
live in a city, work a case by exploring and talking to people, go home
and decorate between outings. That's a coherent, marketable identity —
and it's already ~70% built. The remaining work is content-shaped, not
system-shaped.

### Core interaction loop

- **Clues are interactable world objects.** Proximity prompt (the
  project already has this pattern via
  `scripts/draw_text_shadow_tooltips.gml`-style interactables) → interact
  → logs to an evidence journal.
- **NPC dialogue stays mostly fixed**, matching the existing sequential
  message-box system — the only "branching" is a flag check (`has the
  player found clue X yet?`) that swaps which line plays. Cheap to build,
  cheap to write for — not a dialogue-tree engine.
- **The day/night/weekday clock becomes a real gameplay tool**, not just
  ambience: a shop's clue is only visible during business hours, a
  suspect's window only shows a light at night. This is free — the clock
  system (`global.timeHour`/`timeMinutes`/day tracking) already exists.
- **Taxi travel between cities becomes load-bearing.** Clues split across
  cities gives fast-travel an actual purpose beyond convenience.
- **Crime scenes reuse the furniture-placement system.** A "moved" or
  "wrong" object in a room is just an instance placed differently — the
  exact mechanism already built for home customisation
  (`scr_ApplyHomeFurniturePositions` and friends). No new placement
  tooling needed to author a scene.

### The content pipeline

Each case is a data file, not a hand-coded feature:

```
clueId, propObject/location, room, requiredClues, unlockCondition, shortText
```

Adding a case = placing a few objects in a room, writing one or two
sentences per clue, deciding what flags gate what. That's data entry
adjacent to systems work, not narrative-feature design — deliberately
chosen to match where your energy actually goes.

Case completion: enough clue flags set → a simple "who did it" pick
(reuse the dropdown-selection pattern already used in the options menu /
furniture UI) → resolve. No complex new UI required for v1.

### Defaults chosen (revisit if they stop feeling right)

- **Nonlinear discovery within a case** — clues found in any order, not a
  strict sequence, to keep it feeling like exploration.
- **Cases are self-contained per city** — simpler to scope, and gives
  each city a reason to visit.
- **No dedicated deduction-board UI for v1.** Ship with a plain evidence
  log; a visual corkboard (Obra Dinn / Golden Idol-style, connect the
  clues) is a strong stretch goal for a later case or a trailer moment,
  not a Q1 requirement.

## Phase 0 — Lock the decision (Weeks 1-2)

- Confirm the identity above (or adjust the defaults) before touching
  Q1 work — everything downstream assumes this is settled.
- Rough out the evidence/clue data format on paper before building it.

## Q1 (Months 1-3) — Pay down debt, build the content engine

- **Global state consolidation.** ~190 `global.*` variables initialized
  ad-hoc across 3+ places (`scr_globals.gml`, `obj_splash_screen_buruwasu`,
  scattered per-object Create events) is the thing that will keep
  breaking every system built this year — it already caused the HUD fade
  bug and the `daysOfWeekIndex` double-init bug. Give `scr_globals.gml`
  sole ownership. Highest-leverage tech task on this whole roadmap.
- **Battle system rework:** move state transitions out of Draw GUI into
  Step; scope HUD/dialogue lookups per-`encounter_id` (the pattern
  `obj_battle_enemy_hud` already uses correctly) so multiple encounters
  don't collide.
- **Map system fixes** (Known Issues #32-36) — city map/fast-travel is
  core to an exploration-driven game and is currently broken (undefined
  object reference, room/GUI-space mismatch, invisible Ichihara
  backdrop).
- **Build the clue/evidence system** described above: interactable clue
  objects, proximity prompt + log-on-interact, the evidence journal UI,
  the per-case data format, and flag-gated NPC dialogue lines.
- **Steamworks spike — validate early, not in Q4.** GMS1.4 is legacy
  (YoYo Games has moved on to newer unified GameMaker versions), and
  Steam SDK / achievements / cloud-save / controller extensions in 1.4
  can be finicky. Confirm this works before a year of content gets built
  on top of an assumption that might not hold.
- **Steam store page goes up.** Doesn't need finished art — wishlists
  compound the longer the page is live.

## Q2 (Months 4-6) — One complete vertical slice

- Build **one full case, start to finish**, in one city, using the new
  clue system. This is the proof that the exploration loop is actually
  fun before scaling it to more cases.
- Fix the dialogue controller's repeat-every-room-visit bug (#31) and
  message-array desync risk (#30) — non-negotiable once dialogue is
  carrying real case content.
- NPC AI hardening (#10-14) — spawner logic, wrong-instance targeting,
  the dead alarm/telephone-box state — matters more once NPCs are
  witnesses/suspects, not just background dressing.
- **Controller support** — currently entirely absent from the codebase
  (#49, confirmed by project-wide grep for `gamepad_*`). Needed for Steam
  Deck / controller players; cheaper to add now than retrofit later.
- First playtest with friends/family on the vertical slice only.

## Q3 (Months 7-9) — Scale content, start marketing for real

- Use the clue system to produce 3-5 more cases. If hand-writing case
  content is still a slog by this point, this is the right moment to
  bring in a co-writer for just that piece — better than grinding
  through a year of work that kills motivation.
- Project-wide rendering/draw-state hygiene pass (#22-28) — more players
  seeing more of the game means small leaks (aqua color bleed, lighting
  not resetting after lamps/ashtrays) get noticed.
- Home customisation loose ends (#44 slot-picker UI, #48 rotation UI, #50
  furniture removal) — cheap polish since the underlying systems already
  exist.
- Cut a free **Steam Next Fest demo** from the Q2 vertical slice; target
  a fest window ~2-3 months before launch.
- Trailer + real marketing push starts. A corkboard/deduction-reveal
  moment (even if it's not the shipped UI yet) makes strong trailer
  material if there's time to prototype it here.

## Q4 (Months 10-12) — Harden and ship

- Triage every remaining numbered Known Issue in `CLAUDE.md` — fix or
  explicitly defer, nothing silently forgotten.
- Wider external playtest wave (Discord/demo downloaders, not just
  friends).
- Save/load stress test across all 5 slots, corrupted-save handling,
  global-state audit — this is where the Q1 consolidation work pays off.
- Achievements, cloud save, controller certification pass finished.
- Final store assets: capsule art, trailer v2, screenshots, description
  copy.
- Set launch date, buffer for a day-1 patch.

## Running rule for the whole year

**No new systems after Q2.** The project's own history — wide scope,
shallow depth across many systems, copy-paste UIs never finished — shows
a real pull toward starting new things instead of finishing them. A
solo 1-year Steam ship lives or dies on scope discipline more than raw
hours.

## Two things to check now, not discover later

- **"Chicken Licken"** reads close to real-world fast-food branding —
  cheap to sanity-check/rename now, expensive if it gets flagged after
  a Steam submission.
- If 12 months feels tight once underway, the lever to pull is **cutting
  city count or side-system depth**, not working more hours — this plan
  already assumes real scope control, not heroics.
