# Signal SF Events

A real-time San Francisco event discovery app, deployed with Vercel.

Production: https://kiloforge-eosin.vercel.app

## What It Does

- Fetches upcoming SF events from Supabase Postgres.
- Ranks events by match score across time, neighborhood, category, price, and size/vibe.
- Lets anonymous visitors save, mark interested, and click through to sources.
- Subscribes to Supabase Realtime updates for live event stats.
- Falls back to `data/events.json` if Supabase is not configured yet.

## Supabase Setup

Supabase project: `vhjhfnhgoldxevjfrrsz`

For a new environment:

1. Create a free Supabase project.
2. Open the Supabase SQL editor.
3. Run `supabase/schema.sql`.
4. In Vercel, add these environment variables:
   - `SUPABASE_URL`
   - `SUPABASE_PUBLISHABLE_KEY`
5. Redeploy the Vercel project.

The current Vercel production project already has these two public env vars configured.

Only use a Supabase publishable/anon key in Vercel for the browser app. Do not expose a service-role key.

## Local Preview

Use a static server from the project root:

```sh
npx serve .
```

Without Vercel's `/api/config` function, local static preview will use the JSON fallback catalog. To test the config function locally, run through Vercel:

```sh
vercel dev
```

## Deployment

Pushes to `main` deploy through the connected Vercel project.
