# Phase 1 — Foundation and driving prototype

## Locked decisions
- Godot 4
- Android only, landscape orientation
- Detailed cartoon 3D direction
- 8-player match capacity target (not implemented in Phase 1)
- 60 FPS target with 30 FPS fallback
- Original game identity and original assets

## Included
- Main menu and scene transition
- Procedurally constructed test arena
- Placeholder kart mesh and collision
- Third-person follow camera
- Keyboard and on-screen touch controls
- Forward/reverse movement, steering and drag
- GL Compatibility renderer for broad Android support

## Not included yet
- Multiplayer, matchmaking, server authority
- Backend API, accounts, PostgreSQL, Redis
- Weapons, pickups, damage, respawn
- Final art, audio, animation, shop or progression
- Android signing credentials or production export template

## Phase 1 acceptance criteria
1. Import `game/project.godot` in Godot 4.x.
2. Run the project and enter the test arena.
3. Drive using WASD / arrow keys.
4. Test touchscreen controls on Android.
5. Confirm stable performance on target low- and mid-range devices.

## Performance strategy
- Start with GL Compatibility.
- Use simple materials and primitive geometry during prototyping.
- Profile on real Android hardware.
- Keep 60 FPS as the target, but provide a 30 FPS mode on slower devices.
- Do not claim the target is achieved until measured on devices.
