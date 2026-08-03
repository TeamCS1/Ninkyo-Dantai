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

  **What "one full case" means concretely:**
  - A hook — something the player is told or stumbles into that starts
    the investigation (a body, a report, an NPC asking for help). Keep
    it a single clear premise, not a multi-thread plot yet.
  - A small, closed cast: one incident, 2-3 suspects, 2-4 witness NPCs.
    Closed means every clue and every suspect lives in one city, so the
    slice doesn't depend on cross-city travel working perfectly yet.
  - 5-8 clues, spread across a mix of clue *shapes* so the slice tests
    variety, not just volume: 2-3 pure environmental objects (inspect a
    prop), 1-2 witness-testimony lines (talk to an NPC, gated on an
    earlier clue), 1 time-gated clue (only findable at a specific
    hour), 1 "wrong until you have context" red herring that's meant to
    mislead early and make sense once another clue is found.
  - A resolution moment: accuse a suspect. Decide now, not in Q4,
    whether a wrong accusation is a hard fail (re-investigate, no
    penalty beyond time) or a soft fail (case marked unsolved, story
    moves on anyway) — this affects UI scope (does the accusation
    screen need a "not enough evidence" gate before it's even
    selectable?) and is much cheaper to decide once than to retrofit
    across every later case.
  - Target playtime: 15-30 minutes. Short enough to playtest in one
    sitting and iterate on fast; long enough to prove the loop holds up
    past the first five minutes of novelty.

  **What this slice needs to prove**, specifically in the first
  playtest (see below): can a tester find clues without hand-holding
  (i.e., does exploration feel guided-but-not-obvious, or do testers
  wander aimlessly)? Does the day/night gate read as an interesting
  constraint or as friction? Is the accusation moment satisfying, or
  does it feel arbitrary because the clues didn't build toward it?
  These answers should directly shape how Q3's additional cases are
  written — don't scale a loop that didn't land in Q2.

- Fix the dialogue controller's repeat-every-room-visit bug (#31) and
  message-array desync risk (#30) — non-negotiable once dialogue is
  carrying real case content.
- NPC AI hardening (#10-14) — spawner logic, wrong-instance targeting,
  the dead alarm/telephone-box state — matters more once NPCs are
  witnesses/suspects, not just background dressing.
- **Controller support** — currently entirely absent from the codebase
  (#49, confirmed by project-wide grep for `gamepad_*`). Needed for Steam
  Deck / controller players; cheaper to add now than retrofit later.
- First playtest with friends/family on the vertical slice only. Sit
  behind them, don't explain anything, take notes on where they get
  stuck or where they say out loud "wait, what am I supposed to do."
  Those moments are the actual design document for Q3, more useful than
  any amount of planning done in the abstract now.

## Q3 (Months 7-9) — Scale content, start marketing for real

- Use the clue system to produce 3-5 more cases. If hand-writing case
  content is still a slog by this point, this is the right moment to
  bring in a co-writer for just that piece — better than grinding
  through a year of work that kills motivation.

  **How the additional cases should differ from Q2's slice**, based on
  what the vertical-slice playtest actually showed:
  - Spread cases across the other cities one at a time rather than
    stacking several into one city — this is what makes taxi
    fast-travel feel load-bearing instead of decorative, and it's a
    natural per-case content boundary (one case = one city = one data
    file + one set of placed clue instances).
  - Vary the clue-shape mix on purpose from case to case (a case that's
    mostly witness testimony, a case that leans on the day/night gate
    hard, a case built around a home-customisation-style "wrong object
    in the room" scene) rather than repeating the Q2 template exactly —
    this is cheap variety since it's the same underlying system, just
    different data, and it's what keeps 4-6 cases from feeling like the
    same case reskinned.
  - Consider one case that deliberately fails the player (a correct
    reading of the clues points to an uncomfortable or ambiguous
    answer) — a single more resonant case usually does more for a
    Steam page and trailer than another mechanically-safe one.
  - Keep a running list of "reused NPCs" across cases — a witness in
    one case appearing as background color in another is cheap
    world-building that doesn't cost extra content-authoring time.

- Project-wide rendering/draw-state hygiene pass (#22-28) — more players
  seeing more of the game means small leaks (aqua color bleed, lighting
  not resetting after lamps/ashtrays) get noticed.
- Home customisation loose ends (#44 slot-picker UI, #48 rotation UI, #50
  furniture removal) — cheap polish since the underlying systems already
  exist.
- Cut a free **Steam Next Fest demo** from the Q2 vertical slice (not
  the newer Q3 cases — the slice is the one that's actually been
  playtested and hardened). "Demo-ready" concretely means: no debug
  overlay visible to the public, a save/load path that survives a
  player quitting mid-case, a two-line on-screen prompt at the very
  start telling the player what to do without a full tutorial, and a
  deliberate stopping point at the end of the case rather than trailing
  off into unfinished content.
- Trailer + real marketing push starts. A corkboard/deduction-reveal
  moment (even if it's not the shipped UI yet) makes strong trailer
  material if there's time to prototype it here.
  **Devlog cadence:** reuse the itch.io-style Update Notes section
  already in `CLAUDE.md` as the source text — every entry there is
  already player-facing and dated, so turning it into a Steam devlog
  post is a copy-paste, not new writing. Aim for roughly one post per
  major milestone in this document rather than a fixed weekly schedule,
  which is easier to sustain solo without it becoming its own burden.

## Q4 (Months 10-12) — Harden and ship

- Triage every remaining numbered Known Issue in `CLAUDE.md` — fix or
  explicitly defer, nothing silently forgotten. Go issue-by-issue and
  write one line next to each: fixed, won't-fix-for-v1-and-why, or
  deferred-to-post-launch. A triaged list beats a clean one for
  launch-readiness — the goal is nothing is silently unknown, not that
  the count hits zero.
- Wider external playtest wave (Discord/demo downloaders, not just
  friends). Specifically watch for: does the accusation system ever
  produce a state where the player is stuck with no path forward (a
  case that can't be solved because a clue didn't spawn, a flag that
  didn't set)? This class of bug is the one QA has to catch, because a
  softlocked case is the single worst experience a mystery game can
  ship with.
- Save/load stress test across all 5 slots, corrupted-save handling,
  global-state audit — this is where the Q1 consolidation work pays
  off. Specifically test: quitting mid-case and reloading (does clue
  progress survive?), switching save slots between cities, and an
  intentionally corrupted/truncated `savedata.ini`/`home.ini` (does the
  game degrade gracefully or hard-crash on launch?).
- Achievements, cloud save, controller certification pass finished —
  this is the payoff of the Q1 Steamworks spike; if that spike found
  real friction in GMS1.4's Steam integration, this is where it either
  gets budgeted for or the feature gets cut, not discovered for the
  first time under launch pressure.
- Final store assets: capsule art, trailer v2, screenshots, description
  copy. Decide pricing now, including whether Steam regional pricing
  defaults are being reviewed or left as-is.
- **Launch logistics, worked backward from launch day:** Steam's review
  process typically wants roughly two weeks of lead time after a build
  is submitted — submit before that window, not against it. Hold back
  a known set of low-risk fixes as a day-1 patch rather than cramming
  every last change into the submitted build, so there's a safety
  valve if something's found in the final week. Plan the first week
  post-launch as active community response time (Steam reviews and
  Discord both), not a week to start the next project.

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
