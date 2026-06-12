create extension if not exists postgis;

create table if not exists public.events (
  id text primary key,
  title text not null,
  description text not null,
  source text not null,
  source_url text not null,
  start_at timestamptz not null,
  end_at timestamptz,
  timezone text not null default 'America/Los_Angeles',
  venue_name text not null,
  address text,
  neighborhood text not null,
  lat double precision,
  lng double precision,
  location geography(Point, 4326),
  categories text[] not null default '{}',
  tags text[] not null default '{}',
  price_min numeric(8, 2),
  price_max numeric(8, 2),
  price_label text not null default 'Price unknown',
  size_tier text not null check (size_tier in ('intimate', 'medium', 'big')),
  status text not null default 'scheduled' check (status in ('scheduled', 'cancelled', 'postponed')),
  image_url text,
  source_confidence numeric(3, 2) not null default 0.75,
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table if not exists public.event_interactions (
  id bigint generated always as identity primary key,
  event_id text not null references public.events(id) on delete cascade,
  user_id uuid references auth.users(id) on delete cascade,
  session_id text not null,
  kind text not null check (kind in ('view', 'save', 'hide', 'interested', 'click')),
  created_at timestamptz not null default now()
);

alter table public.event_interactions
add column if not exists user_id uuid references auth.users(id) on delete cascade;

create table if not exists public.event_stats (
  event_id text primary key references public.events(id) on delete cascade,
  views integer not null default 0,
  saves integer not null default 0,
  interested integer not null default 0,
  clicks integer not null default 0,
  updated_at timestamptz not null default now()
);

create index if not exists events_start_at_idx on public.events (start_at);
create index if not exists events_status_start_at_idx on public.events (status, start_at);
create index if not exists events_categories_idx on public.events using gin (categories);
create index if not exists events_location_idx on public.events using gist (location);
create index if not exists event_interactions_event_id_idx on public.event_interactions (event_id);
create index if not exists event_interactions_session_id_idx on public.event_interactions (session_id);
create index if not exists event_interactions_user_id_idx on public.event_interactions (user_id);

delete from public.event_interactions duplicate
using public.event_interactions original
where duplicate.id > original.id
  and duplicate.event_id = original.event_id
  and duplicate.session_id = original.session_id
  and duplicate.kind = original.kind
  and duplicate.kind in ('view', 'save', 'hide', 'interested');

create unique index if not exists event_interactions_once_per_session_idx
on public.event_interactions (event_id, session_id, kind)
where kind in ('view', 'save', 'hide', 'interested');

create unique index if not exists event_interactions_once_per_user_idx
on public.event_interactions (event_id, user_id, kind)
where user_id is not null and kind in ('view', 'save', 'hide', 'interested');

alter table public.events enable row level security;
alter table public.event_interactions enable row level security;
alter table public.event_stats enable row level security;

drop policy if exists "Public can read scheduled events" on public.events;
create policy "Public can read scheduled events"
on public.events for select
using (status = 'scheduled' and start_at >= now() - interval '1 day');

drop policy if exists "Public can read event stats" on public.event_stats;
create policy "Public can read event stats"
on public.event_stats for select
using (true);

drop policy if exists "Anonymous users can insert interactions" on public.event_interactions;
create policy "Anonymous users can insert interactions"
on public.event_interactions for insert
to anon
with check (
  kind in ('view', 'save', 'hide', 'interested', 'click')
  and user_id is null
  and length(session_id) between 12 and 120
);

drop policy if exists "Authenticated users can read their interactions" on public.event_interactions;
create policy "Authenticated users can read their interactions"
on public.event_interactions for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "Authenticated users can insert their interactions" on public.event_interactions;
create policy "Authenticated users can insert their interactions"
on public.event_interactions for insert
to authenticated
with check (
  (select auth.uid()) = user_id
  and kind in ('view', 'save', 'hide', 'interested', 'click')
  and length(session_id) between 12 and 120
);

grant usage on schema public to anon;
grant select on public.events to anon;
grant select on public.event_stats to anon;
grant insert on public.event_interactions to anon;
grant usage, select on sequence public.event_interactions_id_seq to anon;
grant select on public.events to authenticated;
grant select on public.event_stats to authenticated;
grant select, insert on public.event_interactions to authenticated;
grant usage, select on sequence public.event_interactions_id_seq to authenticated;

create or replace function public.set_event_location()
returns trigger
language plpgsql
as $$
begin
  if new.lat is not null and new.lng is not null then
    new.location := st_setsrid(st_makepoint(new.lng, new.lat), 4326)::geography;
  end if;
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists events_set_location on public.events;
create trigger events_set_location
before insert or update on public.events
for each row execute function public.set_event_location();

create or replace function public.ensure_event_stats()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.event_stats (event_id)
  values (new.id)
  on conflict (event_id) do nothing;
  return new;
end;
$$;

drop trigger if exists events_ensure_stats on public.events;
create trigger events_ensure_stats
after insert on public.events
for each row execute function public.ensure_event_stats();

create or replace function public.increment_event_stats()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.event_stats (event_id)
  values (new.event_id)
  on conflict (event_id) do nothing;

  update public.event_stats
  set
    views = views + case when new.kind = 'view' then 1 else 0 end,
    saves = saves + case when new.kind = 'save' then 1 else 0 end,
    interested = interested + case when new.kind = 'interested' then 1 else 0 end,
    clicks = clicks + case when new.kind = 'click' then 1 else 0 end,
    updated_at = now()
  where event_id = new.event_id;

  return new;
end;
$$;

drop trigger if exists event_interactions_increment_stats on public.event_interactions;
create trigger event_interactions_increment_stats
after insert on public.event_interactions
for each row execute function public.increment_event_stats();

do $$
begin
  alter publication supabase_realtime add table public.events;
exception when duplicate_object then null;
end;
$$;

do $$
begin
  alter publication supabase_realtime add table public.event_stats;
exception when duplicate_object then null;
end;
$$;

insert into public.events (
  id, title, description, source, source_url, start_at, end_at, venue_name,
  address, neighborhood, lat, lng, categories, tags, price_min, price_max,
  price_label, size_tier, source_confidence
) values
  ('seed-001', 'Mission Vinyl Night Market', 'DJs, local record sellers, food pop-ups, and a courtyard bar near Valencia.', 'Signal seed', 'https://sf.funcheap.com/', now() + interval '6 hours', now() + interval '10 hours', 'Manny''s', '3092 16th St, San Francisco, CA', 'Mission', 37.7648, -122.4216, array['music','food','nightlife'], array['dj','records','pop-up'], 0, 25, 'Free-$25', 'medium', 0.78),
  ('seed-002', 'AI Builders Salon', 'Small-format demos and discussion for people building AI products in San Francisco.', 'Signal seed', 'https://lu.ma/sf', now() + interval '1 day 2 hours', now() + interval '1 day 5 hours', 'The Commons', '550 15th St, San Francisco, CA', 'Dogpatch', 37.7677, -122.3948, array['tech','talks'], array['ai','startups','demos'], 15, 35, '$15-$35', 'intimate', 0.82),
  ('seed-003', 'Golden Gate Park Roller Disco', 'Outdoor skating session with rentals, music, and a relaxed all-ages crowd.', 'Signal seed', 'https://sfrecpark.org/Calendar.aspx', now() + interval '1 day 5 hours', now() + interval '1 day 8 hours', 'Skatin'' Place', '6th Ave and Fulton St, San Francisco, CA', 'Golden Gate Park', 37.7723, -122.4664, array['outdoors','music','community'], array['skating','free','all-ages'], 0, 0, 'Free', 'big', 0.9),
  ('seed-004', 'North Beach Comedy Crawl', 'A compact multi-room comedy lineup across classic North Beach bars.', 'Signal seed', 'https://sf.funcheap.com/', now() + interval '2 days 3 hours', now() + interval '2 days 7 hours', 'Cobb''s Comedy Club', '915 Columbus Ave, San Francisco, CA', 'North Beach', 37.8023, -122.4158, array['comedy','nightlife'], array['standup','bars'], 20, 45, '$20-$45', 'medium', 0.74),
  ('seed-005', 'Hayes Valley Design Walk', 'Gallery stops, furniture studios, wine pours, and short talks from local makers.', 'Signal seed', 'https://www.eventbrite.com/', now() + interval '2 days 5 hours', now() + interval '2 days 9 hours', 'Proxy SF', '432 Octavia St, San Francisco, CA', 'Hayes Valley', 37.7765, -122.4241, array['art','talks','community'], array['design','gallery','makers'], 0, 0, 'Free RSVP', 'medium', 0.76),
  ('seed-006', 'Sunset Dumpling Workshop', 'Hands-on dumpling folding class with tea, sauces, and a neighborhood dinner vibe.', 'Signal seed', 'https://www.eventbrite.com/', now() + interval '3 days 1 hours', now() + interval '3 days 4 hours', 'Sunset Mercantile Kitchen', '37th Ave, San Francisco, CA', 'Sunset', 37.7539, -122.4979, array['food','classes'], array['hands-on','dinner'], 55, 80, '$55-$80', 'intimate', 0.72),
  ('seed-007', 'SoMa Warehouse Synth Show', 'Four electronic acts in a raw warehouse room with late-night visuals.', 'Signal seed', 'https://www.ticketmaster.com/', now() + interval '3 days 7 hours', now() + interval '3 days 11 hours', 'Public Works', '161 Erie St, San Francisco, CA', 'SoMa', 37.7688, -122.4193, array['music','nightlife'], array['electronic','visuals'], 30, 65, '$30-$65', 'big', 0.79),
  ('seed-008', 'Richmond District Book Swap', 'Bring a book, leave with three, and meet neighbors over coffee.', 'Signal seed', 'https://sfpl.org/events', now() + interval '4 days 2 hours', now() + interval '4 days 4 hours', 'Richmond Branch Library', '351 9th Ave, San Francisco, CA', 'Richmond', 37.7815, -122.4679, array['community','talks'], array['books','free'], 0, 0, 'Free', 'intimate', 0.88),
  ('seed-009', 'Castro Queer Film Shorts', 'A curated night of Bay Area shorts followed by filmmaker Q&A.', 'Signal seed', 'https://www.castrotheatre.com/', now() + interval '4 days 5 hours', now() + interval '4 days 8 hours', 'The Castro Theatre', '429 Castro St, San Francisco, CA', 'Castro', 37.7620, -122.4348, array['art','talks','community'], array['film','q-and-a'], 18, 28, '$18-$28', 'medium', 0.8),
  ('seed-010', 'Marina Bay Trail Morning Run', 'Easy-paced waterfront run with coffee afterward.', 'Signal seed', 'https://www.meetup.com/', now() + interval '5 days 0 hours', now() + interval '5 days 2 hours', 'Marina Green', 'Marina Blvd, San Francisco, CA', 'Marina', 37.8050, -122.4427, array['outdoors','wellness','community'], array['run','coffee','free'], 0, 0, 'Free', 'medium', 0.7),
  ('seed-011', 'Chinatown Night Market Preview', 'Lanterns, snacks, lion dance, and small businesses opening late.', 'Signal seed', 'https://www.eventbrite.com/', now() + interval '5 days 6 hours', now() + interval '5 days 10 hours', 'Portsmouth Square', '745 Kearny St, San Francisco, CA', 'Chinatown', 37.7954, -122.4056, array['food','community','nightlife'], array['market','family-friendly'], 0, 30, 'Free-$30', 'big', 0.77),
  ('seed-012', 'Presidio Picnic and Jazz', 'Bring a blanket for food trucks, lawn games, and a brass trio under the trees.', 'Signal seed', 'https://presidio.gov/events', now() + interval '6 days 4 hours', now() + interval '6 days 8 hours', 'Main Parade Lawn', 'Montgomery St, San Francisco, CA', 'Marina', 37.7989, -122.4662, array['food','music','outdoors'], array['picnic','family-friendly'], 0, 40, 'Free entry', 'big', 0.84),
  ('seed-013', 'Climate Tech Coffee Chats', 'Founder and operator roundtables for climate software, hardware, and financing.', 'Signal seed', 'https://lu.ma/sf', now() + interval '7 days 2 hours', now() + interval '7 days 4 hours', 'Canopy Jackson Square', '595 Pacific Ave, San Francisco, CA', 'North Beach', 37.7974, -122.4035, array['tech','talks','community'], array['climate','founders'], 10, 20, '$10-$20', 'intimate', 0.81),
  ('seed-014', 'Mission Mural Walk', 'Guided walk through Balmy Alley, Precita Eyes, and newer neighborhood murals.', 'Signal seed', 'https://www.eventbrite.com/', now() + interval '8 days 3 hours', now() + interval '8 days 5 hours', 'Precita Eyes Muralists', '2981 24th St, San Francisco, CA', 'Mission', 37.7526, -122.4116, array['art','outdoors','community'], array['walking-tour','murals'], 0, 15, 'Donation', 'medium', 0.86),
  ('seed-015', 'Noise Pop Club Night', 'Indie DJs, surprise guests, and a packed dance floor downtown.', 'Signal seed', 'https://www.ticketmaster.com/', now() + interval '9 days 8 hours', now() + interval '10 days 0 hours', '1015 Folsom', '1015 Folsom St, San Francisco, CA', 'SoMa', 37.7780, -122.4058, array['music','nightlife'], array['dance','indie'], 35, 85, '$35-$85', 'big', 0.76),
  ('seed-016', 'Botanical Sketching Class', 'A quiet outdoor drawing class focused on plants, texture, and observation.', 'Signal seed', 'https://sfrecpark.org/Calendar.aspx', now() + interval '10 days 2 hours', now() + interval '10 days 5 hours', 'SF Botanical Garden', '1199 9th Ave, San Francisco, CA', 'Golden Gate Park', 37.7671, -122.4680, array['art','classes','outdoors'], array['drawing','plants'], 35, 45, '$35-$45', 'intimate', 0.83),
  ('seed-017', 'Ferry Building Fermentation Fair', 'Local makers sampling kimchi, miso, kombucha, cheese, and sourdough.', 'Signal seed', 'https://www.eventbrite.com/', now() + interval '11 days 3 hours', now() + interval '11 days 8 hours', 'Ferry Building', '1 Ferry Building, San Francisco, CA', 'SoMa', 37.7955, -122.3937, array['food','classes','community'], array['samples','makers'], 12, 25, '$12-$25', 'big', 0.8),
  ('seed-018', 'Wellness Sound Bath', 'A restorative evening session with tea, mats, and guided breathwork.', 'Signal seed', 'https://www.eventbrite.com/', now() + interval '12 days 5 hours', now() + interval '12 days 7 hours', 'The Center SF', '548 Fillmore St, San Francisco, CA', 'Hayes Valley', 37.7745, -122.4301, array['wellness','community'], array['sound-bath','tea'], 28, 38, '$28-$38', 'intimate', 0.73)
on conflict (id) do update set
  title = excluded.title,
  description = excluded.description,
  source = excluded.source,
  source_url = excluded.source_url,
  start_at = excluded.start_at,
  end_at = excluded.end_at,
  timezone = excluded.timezone,
  venue_name = excluded.venue_name,
  address = excluded.address,
  neighborhood = excluded.neighborhood,
  lat = excluded.lat,
  lng = excluded.lng,
  categories = excluded.categories,
  tags = excluded.tags,
  price_min = excluded.price_min,
  price_max = excluded.price_max,
  price_label = excluded.price_label,
  size_tier = excluded.size_tier,
  status = excluded.status,
  image_url = excluded.image_url,
  source_confidence = excluded.source_confidence,
  updated_at = now();

insert into public.event_stats (event_id, views, saves, interested, clicks)
select id, 0, 0, 0, 0 from public.events
on conflict (event_id) do nothing;

with counts as (
  select
    event_id,
    count(*) filter (where kind = 'view')::integer as views,
    count(*) filter (where kind = 'save')::integer as saves,
    count(*) filter (where kind = 'interested')::integer as interested,
    count(*) filter (where kind = 'click')::integer as clicks
  from public.event_interactions
  group by event_id
)
update public.event_stats stats
set
  views = coalesce(counts.views, 0),
  saves = coalesce(counts.saves, 0),
  interested = coalesce(counts.interested, 0),
  clicks = coalesce(counts.clicks, 0),
  updated_at = now()
from counts
where stats.event_id = counts.event_id;
