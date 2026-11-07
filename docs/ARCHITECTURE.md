# Architecture direction

## Client
Godot 4 / GDScript. Android client owns presentation, local input sampling, camera, UI, audio and client-side prediction/interpolation.

## Dedicated game server (future phase)
Godot headless server using ENet/UDP. It will authoritatively simulate movement constraints, weapons, damage, pickups, match clock and results.

## Backend API (future phase)
Node.js + TypeScript for authentication, profiles, inventory, matchmaking orchestration, rewards and leaderboards.

## Persistence (future phase)
PostgreSQL for durable player data. Redis for ephemeral sessions, queues and short-lived match coordination.

## Security principles
- Never trust client-reported damage, rewards, inventory ownership or final match results.
- Validate RPC sender identity and rate-limit requests.
- Keep secrets out of the client and Git repository.
- Use TLS for HTTPS API traffic and authenticated server-to-backend calls.
