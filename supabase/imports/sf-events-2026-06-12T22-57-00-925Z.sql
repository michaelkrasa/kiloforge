insert into public.events (
  id, title, description, source, source_url, start_at, end_at, timezone, venue_name,
  address, neighborhood, lat, lng, categories, tags, price_min, price_max,
  price_label, size_tier, status, image_url, source_confidence
) values
(
  'luma-sf-5ca36f8a88c765', 'Harness Engineering Hack', 'Luma event organized by tokens&, AWS Builder Loft, tokens&.', 'Luma SF', 'https://luma.com/harnesshack',
  '2026-06-12T09:30:00.000-07:00', '2026-06-12T19:30:00.000-07:00', 'America/Los_Angeles', 'San Francisco, CA',
  'San Francisco, California, US', 'San Francisco', 37.78978109716235, -122.39649091015886,
  array['tech']::text[], array['luma', 'tokens', 'aws-builder-loft']::text[], 0, 0,
  'Free', 'medium', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/wo/17dcdf28-bbc8-4dc8-b86d-dcf7e5617c8e.png',
  0.86
),
(
  'luma-sf-47bde9e8ea061e', 'From Prototype to Manufacturing: Stanford Founder Pitch Night', 'Luma event organized by USYoungMaker, USYoungMaker.', 'Luma SF', 'https://luma.com/n26nxv2v',
  '2026-06-12T17:00:00.000-07:00', '2026-06-12T19:00:00.000-07:00', 'America/Los_Angeles', 'EVGR, Building C',
  'EVGR, Building C, Stanford, California, US', 'Stanford', 37.4269787, -122.15710770000001,
  array['tech', 'nightlife']::text[], array['luma', 'usyoungmaker']::text[], 0, 0,
  'Free', 'medium', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/1n/33127459-d2be-4ea8-8ace-8dbde9fbbb5a.png',
  0.86
),
(
  'luma-sf-31686b506eebc6', 'PlanetScale Office Launch Party', 'Luma event organized by Victoria Liao, Victoria Liao, Sam Lambert.', 'Luma SF', 'https://luma.com/svufxqpt',
  '2026-06-12T18:00:00.000-07:00', '2026-06-13T00:00:00.000-07:00', 'America/Los_Angeles', 'PlanetScale',
  'PlanetScale, San Francisco, California, US', 'San Francisco', 37.7871285, -122.39898659999999,
  array['music', 'nightlife']::text[], array['luma', 'victoria-liao', 'sam-lambert']::text[], 0, 0,
  'Free', 'medium', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/event-covers/e4/06442ff9-4bff-4dbf-aa90-5639144b4a1c.png',
  0.86
),
(
  'luma-sf-87fee3e82b251d', 'Bedazzling Workshop', 'Luma event organized by The Love Potion Library, Veena Patel.', 'Luma SF', 'https://luma.com/r5x1m86i',
  '2026-06-12T19:00:00.000-07:00', '2026-06-12T20:30:00.000-07:00', 'America/Los_Angeles', 'The Love Potion Library - Books, Tea, Pastries',
  'The Love Potion Library - Books, Tea, Pastries, San Francisco, California, US', 'San Francisco', 37.7645596, -122.4334143,
  array['art', 'classes', 'community']::text[], array['luma', 'the-love-potion-library', 'veena-patel']::text[], 10, 10,
  '$10.00', 'intimate', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/mp/bf77291d-5f84-4e10-a750-2fdaf056f7d5.jpg',
  0.86
),
(
  'luma-sf-4a5eee8d05d978', 'Maesawa Wagyu Beef & Premium Sake Pairing Seminar and Dinner', 'Luma event organized by Japan Society of Northern California, Japan Society of Northern California, Yuko Suzuki-Bischoff.', 'Luma SF', 'https://luma.com/l352l9ju',
  '2026-06-12T19:00:00.000-07:00', '2026-06-12T21:00:00.000-07:00', 'America/Los_Angeles', 'Bacchus W&S and WINE BAR by Quinton Jay',
  'Bacchus W&S and WINE BAR by Quinton Jay, Millbrae, California, US', 'Millbrae', 37.601591299999995, -122.3921597,
  array['food', 'classes', 'talks', 'nightlife']::text[], array['luma', 'japan-society-of-northern-califo', 'yuko-suzuki-bischoff']::text[], 80, 80,
  '$80.00', 'intimate', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/j8/4e098c1f-66e1-4889-97f3-0af846bba271.png',
  0.86
),
(
  'luma-sf-37169304388f3f', 'Mahjong After Dark', 'Luma event organized by mahjong.mami, Cindy Ding, Samuel Anozie.', 'Luma SF', 'https://luma.com/sg9obctn',
  '2026-06-12T20:00:00.000-07:00', '2026-06-13T00:00:00.000-07:00', 'America/Los_Angeles', 'San Francisco, CA',
  'San Francisco, California, US', 'San Francisco', 37.786231888500986, -122.4216140218804,
  array['nightlife']::text[], array['luma', 'mahjong-mami', 'cindy-ding', 'samuel-anozie']::text[], 0, 0,
  'Free', 'medium', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/event-covers/ud/773bd982-23f3-42bd-8ade-a8a1b2891ce0.png',
  0.86
),
(
  'luma-sf-c5411b1a51a5d4', 'Sunrise Run, Coffee & DJ Set', 'Luma event organized by Lume Health, Vicki Powell, Jonathan Moustakis, MD.', 'Luma SF', 'https://luma.com/sveaqowo',
  '2026-06-13T07:00:00.000-07:00', '2026-06-13T09:30:00.000-07:00', 'America/Los_Angeles', 'Golden Gate Promenade',
  'Golden Gate Promenade, San Francisco, California, US', 'Marina', 37.8066233, -122.4485362,
  array['music', 'food', 'outdoors', 'wellness']::text[], array['luma', 'lume-health', 'vicki-powell', 'jonathan-moustakis-md']::text[], 0, 0,
  'Free', 'intimate', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/zt/afc54194-7a5c-4951-af27-e9026594b0ba.png',
  0.86
),
(
  'luma-sf-d56252d4ac5a33', 'Autonomous Healthcare Hackathon | xAI Cursor Vercel | Legion Health x Atlas', 'Luma event organized by Arthur MacWaters, Arthur MacWaters, Daniel G Wilson.', 'Luma SF', 'https://luma.com/zru7alb6',
  '2026-06-13T09:00:00.000-07:00', '2026-06-13T19:30:00.000-07:00', 'America/Los_Angeles', 'San Francisco, CA',
  'San Francisco, California, US', 'San Francisco', 37.782216632378855, -122.4002526425859,
  array['tech', 'wellness']::text[], array['luma', 'arthur-macwaters', 'daniel-g-wilson']::text[], 0, 0,
  'Free', 'big', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/yh/20da68fc-f05b-46eb-85c3-5379c4b48737.png',
  0.86
),
(
  'luma-sf-ba1b57cc3b65f5', 'Builders who Run — Golden Gate Bridge 4M', 'Luma event organized by ODF Events, ODF Events, Julian Weisser.', 'Luma SF', 'https://luma.com/yktppix9',
  '2026-06-13T09:00:00.000-07:00', '2026-06-13T10:00:00.000-07:00', 'America/Los_Angeles', 'San Francisco, California',
  'San Francisco, California, US', 'Presidio', 37.80914068621773, -122.47531709349488,
  array['outdoors', 'wellness']::text[], array['luma', 'odf-events', 'julian-weisser']::text[], 0, 0,
  'Free', 'intimate', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/event-covers/jr/f7770996-70c4-4a17-829f-a681aac15686.png',
  0.86
),
(
  'luma-sf-b4355d2d91a60b', 'AI Operator Run Club: Embarcadero Loop + Arsicault', 'Luma event organized by InstaLILY AI, Zac Nelson, Polina Belova.', 'Luma SF', 'https://luma.com/instalily-dgxm',
  '2026-06-13T10:00:00.000-07:00', '2026-06-13T11:45:00.000-07:00', 'America/Los_Angeles', 'Studio By Tishman Speyer',
  'Studio By Tishman Speyer, San Francisco, California, US', 'Financial District', 37.775252699999996, -122.38855050000001,
  array['music', 'tech', 'outdoors', 'wellness', 'nightlife']::text[], array['luma', 'instalily-ai', 'zac-nelson', 'polina-belova']::text[], 0, 0,
  'Free', 'intimate', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/1m/2c0c94dd-31f5-4db8-9cce-8fc1c726432c.png',
  0.86
),
(
  'luma-sf-e427a400b910b1', 'RJ Hosts Volleys & Vibes: WEEK 23', 'Luma event organized by Mission Athletic Club, Prince Boucher, Arjay Parhar.', 'Luma SF', 'https://luma.com/ipm7zu1h',
  '2026-06-13T13:00:00.000-07:00', '2026-06-13T15:00:00.000-07:00', 'America/Los_Angeles', 'Crocker Amazon Tennis Courts',
  'Crocker Amazon Tennis Courts, San Francisco, California, US', 'San Francisco', 37.7137716, -122.4327558,
  array['music', 'nightlife']::text[], array['luma', 'mission-athletic-club', 'prince-boucher', 'arjay-parhar']::text[], 0, 0,
  'Free', 'medium', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/7l/8bee2752-f0e3-492a-b9a0-6926244cb16f.png',
  0.86
),
(
  'luma-sf-20233ec20045f1', 'Read in the Park - SF 📚', 'Luma event organized by Read in the park 📚, Sasmini Bandara, Dulitha Wijewantha.', 'Luma SF', 'https://luma.com/uah5gdpg',
  '2026-06-13T14:00:00.000-07:00', '2026-06-13T16:00:00.000-07:00', 'America/Los_Angeles', 'San Francisco, California',
  'San Francisco, California, US', 'San Francisco', 37.7659198197234, -122.47401338770611,
  array['outdoors']::text[], array['luma', 'read-in-the-park', 'sasmini-bandara', 'dulitha-wijewantha']::text[], 0, 0,
  'Free', 'medium', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/xs/2fcef524-566f-41d6-90f8-df1d4ed51cd2.png',
  0.86
),
(
  'luma-sf-c50b1a7455bb0d', 'Aperitif: A Summer Micro Market', 'Luma event organized by Kaleido SF Events, Kaleido SF, Naomi Peña.', 'Luma SF', 'https://luma.com/8t1j5d2t',
  '2026-06-13T15:00:00.000-07:00', '2026-06-13T18:00:00.000-07:00', 'America/Los_Angeles', 'The Pawn Shop',
  'The Pawn Shop, San Francisco, California, US', 'San Francisco', 37.781034600000005, -122.40829029999999,
  array['food', 'community']::text[], array['luma', 'kaleido-sf-events', 'kaleido-sf', 'naomi-pe-a']::text[], 55, 55,
  '$55.00', 'big', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/hi/2823f018-58bc-4d85-a3dd-fa8fe5ac8cdb.png',
  0.86
),
(
  'luma-sf-9ca132cde53b3c', 'Something Grown: 8-week program showcase', 'Luma event organized by Bay Area A Cappella, Robert Lee, Laynee Daniels .', 'Luma SF', 'https://luma.com/grown',
  '2026-06-13T19:00:00.000-07:00', '2026-06-13T21:00:00.000-07:00', 'America/Los_Angeles', 'San Francisco Conservatory of Music',
  'San Francisco Conservatory of Music, San Francisco, California, US', 'San Francisco', 37.7754994, -122.42040019999999,
  array['music']::text[], array['luma', 'bay-area-a-cappella', 'robert-lee', 'laynee-daniels']::text[], 0, 0,
  'Free', 'medium', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/cr/44122b0f-39e4-444e-a23f-b0d1d1e836dc.jpg',
  0.86
),
(
  'luma-sf-86c75bb2025f0e', 'let''s hike across SF!', 'Luma event organized by Climate Action Club, Margaret Li, Climate Action Club SF.', 'Luma SF', 'https://luma.com/bvp77azp',
  '2026-06-14T09:00:00.000-07:00', '2026-06-14T20:00:00.000-07:00', 'America/Los_Angeles', 'Pelican Day-Use Group Picnic Area',
  'Pelican Day-Use Group Picnic Area, San Francisco, California, US', 'San Francisco', 37.7091278, -122.38124189999999,
  array['music', 'outdoors', 'nightlife']::text[], array['luma', 'climate-action-club', 'margaret-li', 'climate-action-club-sf']::text[], 0, 0,
  'Free', 'intimate', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/em/f5e9b915-4a2d-4d2d-86d4-4fccd4ac2034.png',
  0.86
),
(
  'luma-sf-05d1edad093855', 'Kemuri Matsuri 2026 - Kemuri’s 11th Anniversary Event', 'Luma event organized by Kemuri.', 'Luma SF', 'https://luma.com/kemuri26',
  '2026-06-14T11:30:00.000-07:00', '2026-06-14T17:30:00.000-07:00', 'America/Los_Angeles', 'Kemuri Japanese Barú',
  'Kemuri Japanese Barú, Redwood City, California, US', 'Redwood City', 37.4864227, -122.2337074,
  array['nightlife']::text[], array['luma', 'kemuri']::text[], 0, 0,
  'Free', 'medium', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/jr/a4aef447-480f-49e4-9190-1b564bf5a6c7.png',
  0.86
),
(
  'luma-sf-6f6d53c2384849', 'Mural Fest 2026', 'Luma event organized by The Box Shop, Alita, charles gadeken.', 'Luma SF', 'https://luma.com/muralfest',
  '2026-06-14T12:00:00.000-07:00', '2026-06-14T16:00:00.000-07:00', 'America/Los_Angeles', '951 Hudson Ave',
  '951 Hudson Ave, San Francisco, California, US', 'San Francisco', 37.7330371, -122.37658130000001,
  array['art']::text[], array['luma', 'the-box-shop', 'alita', 'charles-gadeken']::text[], 0, 0,
  'Free', 'medium', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/xl/11734a42-a027-4de4-b57d-e6644c788e44.png',
  0.86
),
(
  'luma-sf-f4cc8e8e923be2', 'Taste of Asia 2026 - San Francisco', 'Luma event organized by TOA, nonprofit naafia.', 'Luma SF', 'https://luma.com/38ddve7c',
  '2026-06-15T11:30:00.000-07:00', '2026-06-15T15:30:00.000-07:00', 'America/Los_Angeles', 'Shenzhen Bay Innovation Center',
  'Shenzhen Bay Innovation Center, Santa Clara, California, US', 'Santa Clara', 37.3772468, -121.96349330000001,
  array['community']::text[], array['luma', 'toa', 'nonprofit-naafia']::text[], 36, 36,
  '$36.00', 'medium', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/event-covers/6i/4479432e-823c-4866-bbae-dcd2ba85eb81.jpg',
  0.86
),
(
  'luma-sf-d9c354bc5eb4bf', 'The fast lane', 'Luma event organized by Chalk, Lina T, Alexandra.', 'Luma SF', 'https://luma.com/chalk-data26',
  '2026-06-15T17:00:00.000-07:00', '2026-06-15T20:00:00.000-07:00', 'America/Los_Angeles', 'San Francisco, CA',
  'San Francisco, California, US', 'San Francisco', 37.785309628754064, -122.40474187970489,
  array['community']::text[], array['luma', 'chalk', 'lina-t', 'alexandra']::text[], 0, 0,
  'Free', 'medium', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/cv/7802ff74-d2f4-45a7-906b-5b2bb7fe5267.jpg',
  0.86
),
(
  'luma-sf-37cca2e38a22a1', 'Compile 2026 Opening Party', 'Luma event organized by Cursor, Victoria Liao, PlanetScale.', 'Luma SF', 'https://luma.com/88e4g1zi',
  '2026-06-15T18:00:00.000-07:00', '2026-06-15T21:00:00.000-07:00', 'America/Los_Angeles', 'San Francisco, CA',
  'San Francisco, California, US', 'San Francisco', 37.8071540802489, -122.42223404892063,
  array['music', 'tech', 'nightlife']::text[], array['luma', 'cursor', 'victoria-liao', 'planetscale']::text[], 0, 0,
  'Free', 'medium', 'scheduled', 'https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,anim=false,background=white,quality=75,width=1920,height=1920/uploads/y4/e28840b7-820d-45f8-a605-b5f58b85b3ef.png',
  0.86
),
(
  'funcheap-sf-07e1a49f3fba6f', 'SF''s Huge "Sunset Night Market" (June 12)', 'Friday, June 12 - 5:00 pm - Ends at 10:00 pm | Cost: FREE | Irving & 22nd The long-awaited return of the Sunset Night Market has arrived! Sunset Night Market™ gets ready for summer with The Dragon Boat Festival! Join us for a night of food, culture, music, and community spirit.', 'Funcheap SF', 'https://sf.funcheap.com/sfs-huge-sunset-night-market-june-12/',
  '2026-06-12T17:00:00-07:00', '2026-06-12T22:00:00-07:00', 'America/Los_Angeles', 'Irving & 22nd',
  null, 'Sunset', null, null,
  array['music', 'food', 'nightlife', 'community']::text[], array['funcheap', 'top-pick', 'block-party', 'eating-drinking', 'fairs-festivals', 'in-person']::text[], 0, 0,
  'FREE', 'big', 'scheduled', 'https://cdn.shortpixel.ai/spai/q_lossy+ret_img+to_webp/sf.funcheap.com/wp-content/uploads/2026/06/imgi_43_686523966_18577658560060049_3548785926036962180_n-175x130.jpg',
  0.76
),
(
  'funcheap-sf-e7a09e35552a38', '"Drag Me Downtown" SF Pride Pop-Up Drag Show Series (2026)', '5:00 pm FREE* *RSVP', 'Funcheap SF', 'https://sf.funcheap.com/drag-me-downtown-sf-pride-pop-up-drag-show-series-2026/',
  '2026-06-12T17:00:00-07:00', null, 'America/Los_Angeles', 'San Francisco',
  null, 'Downtown', null, null,
  array['art', 'community']::text[], array['funcheap', 'top-pick', 'select-one-location', 'downtown-san-francisco', 'in-person', 'lgbtq']::text[], 0, 0,
  'FREE*', 'medium', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-0fba5b7cbd6e2f', 'Soccer Watch Parties at PIER 39''s Outdoor Screen (June 12 - July 19)', '6:00 pm FREE', 'Funcheap SF', 'https://sf.funcheap.com/soccer-watch-parties-pier-39-june-12-july-19/',
  '2026-06-12T18:00:00-07:00', null, 'America/Los_Angeles', 'San Francisco',
  null, 'Fisherman''s Wharf', null, null,
  array['outdoors', 'wellness']::text[], array['funcheap', 'top-pick', 'select-one-location', 'eating-drinking', 'fairs-festivals', 'in-person']::text[], 0, 0,
  'FREE', 'medium', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-e5e3c9acad8fbf', 'Morti-Pride 2026: Embarrassing LGBTQ+ Teen Diary Storytelling (SF)', '7:30 pm $21* *Normally $26 in advance, use promo code for $5 off tickets', 'Funcheap SF', 'https://sf.funcheap.com/morti-pride-2026-embarrassing-lgbtq-teen-diary-storytelling-sf/',
  '2026-06-12T19:30:00-07:00', null, 'America/Los_Angeles', 'SF',
  null, 'San Francisco', null, null,
  array['comedy', 'community']::text[], array['funcheap', 'top-pick', 'comedy-event-types-event', 'promo-code', 'in-person', 'literature']::text[], 21, 21,
  '$21*', 'medium', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-2722919d56b80c', '$1 Drink Fridays: "Battle of the Decades" DJ Party (North Beach)', '5:00 pm FREE* *Free admission with RSVP on Eventbrite', 'Funcheap SF', 'https://sf.funcheap.com/1-drink-fridays-battle-of-the-decades-dj-party-north-beach-241/',
  '2026-06-12T17:00:00-07:00', null, 'America/Los_Angeles', 'San Francisco',
  null, 'North Beach', null, null,
  array['music', 'food', 'outdoors', 'nightlife']::text[], array['funcheap', 'top-pick', 'cheap-drinks-eating-drinking', 'club-dj', 'in-person', 'san-francisco']::text[], 0, 0,
  'FREE*', 'medium', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-3aa9d05b601fe2', 'SFVibe Presents: The Yacht Party (Pier 48)', '6:00 pm $150* *4 hours. Access to 3 decks, two dance floors, and the full lineup. Cash bar on board.', 'Funcheap SF', 'https://sf.funcheap.com/sfvibe-presents-yacht-party-pier-48/',
  '2026-06-12T18:00:00-07:00', null, 'America/Los_Angeles', 'San Francisco',
  null, 'Downtown', null, null,
  array['music', 'nightlife']::text[], array['funcheap', 'select-one-location', 'club-dj', 'downtown-san-francisco', 'in-person', 'live-music-event']::text[], 150, 150,
  '$150*', 'medium', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-c337221ea0ceab', 'SF''s 22nd Annual Int''l Queer Women of Color Film Festival (June 12-14)', '6:00 pm FREE* *FREE', 'Funcheap SF', 'https://sf.funcheap.com/sfs-22nd-annual-intl-queer-women-color-film-festival-june-1214/',
  '2026-06-12T18:00:00-07:00', null, 'America/Los_Angeles', 'San Francisco',
  null, 'San Francisco', null, null,
  array['music', 'food', 'art', 'community']::text[], array['funcheap', 'annual-event-2', 'top-pick', 'select-one-location', 'community', 'fairs-festivals']::text[], 0, 0,
  'FREE*', 'big', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-659ae7266abdaf', '"Sundown Cinema" SF''s Outdoor Movie Night in the Park 2026', '6:00 pm FREE', 'Funcheap SF', 'https://sf.funcheap.com/sundown-cinema-sfs-outdoor-movie-night-in-the-park-2026/',
  '2026-06-12T18:00:00-07:00', null, 'America/Los_Angeles', 'San Francisco',
  null, 'San Francisco', null, null,
  array['outdoors', 'nightlife']::text[], array['funcheap', 'top-pick', 'in-person', 'movies', 'outdoor-movie-night', 'outdoors']::text[], 0, 0,
  'FREE', 'medium', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-c7c51786e3ad66', 'Free Comedy Night w/ Danny Dechi & Friends | Outer Richmond', '7:00 pm FREE', 'Funcheap SF', 'https://sf.funcheap.com/free-comedy-night-w-danny-dechi-friends-outer-richmond-82/',
  '2026-06-12T19:00:00-07:00', null, 'America/Los_Angeles', 'San Francisco',
  null, 'Richmond', null, null,
  array['comedy', 'nightlife']::text[], array['funcheap', 'comedy-event-types-event', 'san-francisco']::text[], 0, 0,
  'FREE', 'medium', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-09dc39e5d9e2b5', 'Free Outdoor Movie: “Sister Act” + Popcorn Night at Lafayette Park (SF)', '7:30 pm FREE* *Free for everyone!', 'Funcheap SF', 'https://sf.funcheap.com/free-outdoor-movie-sister-act-popcorn-night-lafayette-park-sf/',
  '2026-06-12T19:30:00-07:00', null, 'America/Los_Angeles', 'SF',
  null, 'San Francisco', null, null,
  array['food', 'outdoors', 'nightlife', 'community']::text[], array['funcheap', 'top-pick', 'select-one-location', 'community', 'free-food', 'in-person']::text[], 0, 0,
  'FREE*', 'medium', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-4d57f7441c7541', 'Feral Friday SF Square Dance', '7:30 pm $20* *Sliding Fee Scale: Kids Free! 12-18 yo: $10, 18+ $200', 'Funcheap SF', 'https://sf.funcheap.com/feral-friday-sf-square-dance-3/',
  '2026-06-12T19:30:00-07:00', null, 'America/Los_Angeles', 'San Francisco',
  null, 'San Francisco', null, null,
  array['music', 'community']::text[], array['funcheap', 'select-one-location', 'community', 'in-person', 'live-music-event']::text[], 0, 0,
  'FREE', 'medium', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-fd628675c6055c', 'SF’s HellaSecret “Crazy Funny Asians” Friday Night Comedy Showcase (7p + 9p)', '9:00 pm FREE* *Free tickets, but RSVP Required. Donations ($5-$10) greatly appreciated. Otherwise, $15 adv / $20 door tickets also available', 'Funcheap SF', 'https://sf.funcheap.com/sfs-hellasecret-crazy-funny-asians-friday-night-comedy-showcase-7p-9p-61/',
  '2026-06-12T21:00:00-07:00', null, 'America/Los_Angeles', 'San Francisco',
  null, 'San Francisco', null, null,
  array['comedy', 'nightlife']::text[], array['funcheap', 'comedy-event-types-event', 'promo-code', 'early-bird-presale', 'in-person']::text[], 0, 0,
  'FREE*', 'medium', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-e8b9a543fe1665', 'Second Saturdays ‘Round the World: Calle 24 Latino Cultural District (Union Square)', 'Saturday, June 13 - 11:00 am - Ends at 2:00 pm | Cost: FREE | Union Square Park Presented by Calle 24 Latino Cultural District. Come celebrate nuestra cultura with live music, dance, and community! Enjoy performances by Bahareque, Sin Fronteras Dreams, and Batuki as we bring the rhythms,', 'Funcheap SF', 'https://sf.funcheap.com/second-saturdays-round-the-world-calle-24-latino-cultural-district-union-square/',
  '2026-06-13T11:00:00-07:00', '2026-06-13T14:00:00-07:00', 'America/Los_Angeles', 'Union Square Park',
  null, 'Downtown', null, null,
  array['community']::text[], array['funcheap', 'top-pick', 'downtown-san-francisco', 'fairs-festivals', 'in-person', 'sponsored']::text[], 0, 0,
  'FREE', 'medium', 'scheduled', 'https://cdn.shortpixel.ai/spai/q_lossy+ret_img+to_webp/sf.funcheap.com/wp-content/uploads/2026/06/Calle-24-Second-Saturday-45-1-175x130.png',
  0.76
),
(
  'funcheap-sf-6e97634b28f275', 'SF’s 2026 Juneteenth Freedom Celebration, Block Party & Free Carnival Rides (Fillmore)', '11:00 am FREE* *RSVP requested', 'Funcheap SF', 'https://sf.funcheap.com/sfs-2026-juneteenth-freedom-celebration-block-party-free-carnival-rides-fillmore/',
  '2026-06-13T11:00:00-07:00', null, 'America/Los_Angeles', 'San Francisco',
  null, 'Fillmore', null, null,
  array['music', 'nightlife', 'community']::text[], array['funcheap', 'annual-event-2', 'top-pick', 'select-one-location', 'community', 'fairs-festivals']::text[], 0, 0,
  'FREE*', 'big', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-d3b2869d8840b2', 'SF''s 2026 Juneteenth Freedom Celebration, Block Party & Free Carnival Rides (Fillmore)', '11:00 am FREE* *RSVP for FREE', 'Funcheap SF', 'https://sf.funcheap.com/sfs-juneteenth-sf-freedom-celebration-block-party-street-fair-fillmore-district-2026/',
  '2026-06-13T11:00:00-07:00', null, 'America/Los_Angeles', 'San Francisco',
  null, 'Fillmore', null, null,
  array['music', 'nightlife', 'community']::text[], array['funcheap', 'annual-event-2', 'top-pick', 'block-party', 'eating-drinking', 'fairs-festivals']::text[], 0, 0,
  'FREE*', 'big', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-2fe167c0d20053', '$5 Off Tix: Darkly Comic “Dracula: A Feminist Revenge Fantasy, Really” Live (May 15-June 27)', '3:00 pm $47* *Normally $52; $5 off with code FUNCHEAP', 'Funcheap SF', 'https://sf.funcheap.com/5-off-tix-darkly-comic-dracula-a-feminist-revenge-fantasy-really-live-may-15-june-27-3/',
  '2026-06-13T15:00:00-07:00', null, 'America/Los_Angeles', 'San Francisco',
  null, 'San Francisco', null, null,
  array['art']::text[], array['funcheap', 'top-pick', 'select-one-location', 'promo-code', 'in-person', 'sponsored']::text[], 47, 47,
  '$47*', 'medium', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-95b772668e3172', 'SF''s Free Art Opening Reception: "Machismosa" w/ Drag Performances (Root Division)', '4:00 pm FREE* *FREE', 'Funcheap SF', 'https://sf.funcheap.com/sfs-free-art-opening-reception-machismosa-drag-performances/',
  '2026-06-13T16:00:00-07:00', null, 'America/Los_Angeles', 'San Francisco',
  null, 'San Francisco', null, null,
  array['art', 'community']::text[], array['funcheap', 'top-pick', 'select-one-location', 'art-museums', 'community', 'in-person']::text[], 0, 0,
  'FREE*', 'medium', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-594fb974c03dfd', '2-for-1 Tix: Wild "Lafs and Slams" Comedy Brawl (SF)', '8:30 pm $10* *Promo code FUNCHEAPCLAN 50% OFF for first 20!', 'Funcheap SF', 'https://sf.funcheap.com/2for1-tix-wild-lafs-slams-comedy-brawl-sf/',
  '2026-06-13T20:30:00-07:00', null, 'America/Los_Angeles', 'SF',
  null, 'San Francisco', null, null,
  array['comedy', 'art']::text[], array['funcheap', 'top-pick', 'select-one-location', 'adults-only', 'comedy-event-types-event', 'in-person']::text[], 10, 10,
  '$10*', 'medium', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-4ac1a40f69a32f', 'Comedy Roast Battles + Luchador Fights: LAFS & SLAMS 2026 (SF)', '8:30 pm $20* *$20 General Admission', 'Funcheap SF', 'https://sf.funcheap.com/lafs-slams/',
  '2026-06-13T20:30:00-07:00', null, 'America/Los_Angeles', 'SF',
  null, 'San Francisco', null, null,
  array['comedy', 'music', 'nightlife']::text[], array['funcheap', 'top-pick', 'adults-only', 'club-dj', 'comedy-event-types-event', 'eating-drinking']::text[], 20, 20,
  '$20*', 'medium', 'scheduled', null,
  0.76
),
(
  'funcheap-sf-38af4cee89e80f', 'Free Tix: HellaSecret "Desi Comedy Night" Live in SF (7p + 9p)', '9:00 pm FREE* *Free with RSVP for first 100 people. $25 at door without RSVP', 'Funcheap SF', 'https://sf.funcheap.com/free-tix-hellasecret-desi-comedy-night-live-in-sf-7p-9p-71/',
  '2026-06-13T21:00:00-07:00', null, 'America/Los_Angeles', 'San Francisco',
  null, 'Downtown', null, null,
  array['comedy', 'nightlife']::text[], array['funcheap', 'top-pick', 'comedy-event-types-event', 'downtown-san-francisco', 'in-person', 'sponsored']::text[], 0, 0,
  'FREE*', 'medium', 'scheduled', null,
  0.76
),
(
  'dothebay-0eb9f7089645c2', 'Sundown Cinema: The Princess Bride', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/sundown-cinema-the-princess-bride-tickets',
  '2026-06-12T18:30-07:00', null, 'America/Los_Angeles', 'Dolores Park',
  null, 'San Francisco', null, null,
  array['outdoors', 'art']::text[], array['dothebay', 'film']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-64041149d6c13c', 'The Devil Wears Prada 2', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/the-devil-wears-prada-2-tickets',
  '2026-06-12T19:00-07:00', null, 'America/Los_Angeles', 'The Castro',
  null, 'Castro', 37.7619917, -122.4347365,
  array['music']::text[], array['dothebay', 'music']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-fb27d403c58948', 'Gryffin', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/gryffin-tickets',
  '2026-06-12T20:00-07:00', null, 'America/Los_Angeles', 'Cow Palace',
  null, 'San Francisco', 37.70676539999999, -122.418738,
  array['music']::text[], array['dothebay', 'music']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-8f017fe45664b8', 'Toadies', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/toadies-the-charmer-tour-tickets',
  '2026-06-12T20:00-07:00', null, 'America/Los_Angeles', 'The Fillmore',
  null, 'Fillmore', 37.7840042, -122.4331332,
  array['music']::text[], array['dothebay', 'music']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-c951c5c78c1d2e', 'Helen Hong', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/helen-hong-tickets-w1oplkx',
  '2026-06-12T21:45-07:00', null, 'America/Los_Angeles', 'Punch Line San Francisco',
  null, 'San Francisco', 37.795486, -122.4001359,
  array['comedy']::text[], array['dothebay', 'comedy']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-de56acd49e3dd6', 'Sidequest', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/sidequest-tickets',
  '2026-06-12T22:00-07:00', null, 'America/Los_Angeles', '1015 Folsom',
  null, 'Mission', 37.7781117, -122.4058001,
  array['music']::text[], array['dothebay', 'music']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-811811dfdda2e0', 'Helen Hong', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/helen-hong-tickets',
  '2026-06-12T19:30-07:00', null, 'America/Los_Angeles', 'Punch Line San Francisco',
  null, 'San Francisco', 37.795486, -122.4001359,
  array['comedy']::text[], array['dothebay', 'comedy']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-e5aebb6e80b6b5', 'Drag Me Downtown 2026: SF Pride Pop-Up Drag Show Series', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/drag-me-downtown-tickets',
  '2026-06-12T17:00-07:00', '2026-06-12T19:00-07:00', 'America/Los_Angeles', 'Ferry Building',
  null, 'Financial District', null, null,
  array['art', 'community']::text[], array['dothebay', 'lgbtq']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-17ef7a8b0a448f', 'Rave Jesus', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/rave-jesus-tickets',
  '2026-06-12T21:00-07:00', null, 'America/Los_Angeles', 'The Independent',
  null, 'San Francisco', 37.7755362, -122.4376556,
  array['music']::text[], array['dothebay', 'music']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-ac4743a52224b9', 'Cobb''s Comedy Allstars featuring Mark Smalls', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/cobb-s-comedy-allstars-featuring-mark-smalls-tickets-lwomwaz',
  '2026-06-12T19:00-07:00', null, 'America/Los_Angeles', 'Cobb''s Comedy Club',
  null, 'San Francisco', 37.802989, -122.4143902,
  array['comedy', 'music', 'nightlife']::text[], array['dothebay', 'comedy']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-3ada45e93bdaa9', 'Cobb''s Comedy Allstars featuring Mark Smalls', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/cobb-s-comedy-allstars-featuring-mark-smalls-tickets',
  '2026-06-12T21:15-07:00', null, 'America/Los_Angeles', 'Cobb''s Comedy Club',
  null, 'San Francisco', 37.802989, -122.4143902,
  array['comedy', 'music', 'nightlife']::text[], array['dothebay', 'comedy']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-e2fcf01a7215ab', 'EARGASM GOD', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/eargasm-god-presented-by-public-works-tickets',
  '2026-06-12T21:00-07:00', null, 'America/Los_Angeles', 'Public Works',
  null, 'San Francisco', 37.7688759, -122.4194268,
  array['music']::text[], array['dothebay', 'music']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-05a84d4e4ea982', 'Good Medicine', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/good-medicine-tickets',
  '2026-06-12T18:30-07:00', null, 'America/Los_Angeles', 'Yerba Buena Gardens',
  null, 'SoMa', 37.7850153, -122.4023464,
  array['music']::text[], array['dothebay', 'music']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-88e4201c95c7a0', 'PIER 39 Soccer Watch Parties', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/pier39-soccer-watch-parties',
  '2026-06-12T18:00-07:00', null, 'America/Los_Angeles', 'PIER 39',
  null, 'Fisherman''s Wharf', 37.8088075, -122.4093401,
  array['community']::text[], array['dothebay', 'variety']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-9fb41f1381246b', 'Distant Matter', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/distant-matter-tickets',
  '2026-06-12T22:00-07:00', '2026-06-13T02:00-07:00', 'America/Los_Angeles', 'Monarch',
  null, 'San Francisco', 37.7809743, -122.4084128,
  array['music']::text[], array['dothebay', 'music']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-dac4ef39c83c29', 'Tiny Desk Contest On the Road 2026', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/tiny-desk-contest-on-the-road-2026-tickets',
  '2026-06-12T20:00-07:00', null, 'America/Los_Angeles', 'Bimbo''s 365 Club',
  null, 'San Francisco', 37.8036989, -122.4156675,
  array['music', 'nightlife']::text[], array['dothebay', 'music']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-6eba6836d8d581', 'Bts Night', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/12/bts-night-tickets',
  '2026-06-12T21:00-07:00', '2026-06-13T01:00-07:00', 'America/Los_Angeles', 'The Great Northern',
  null, 'San Francisco', 37.7674263, -122.4062869,
  array['music', 'nightlife']::text[], array['dothebay', 'music']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-33d5fafa1b7ad6', 'The Crane Wives – ACT II', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/13/the-crane-wives-act-ii-with-special-guest-yasmin-williams-tickets',
  '2026-06-13T19:00-07:00', null, 'America/Los_Angeles', 'The Castro',
  null, 'Castro', 37.7619917, -122.4347365,
  array['music']::text[], array['dothebay', 'music']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-7489e16dc3d2c6', 'Gryffin', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/13/gryffin-cow-palace-tickets',
  '2026-06-13T20:00-07:00', null, 'America/Los_Angeles', 'Cow Palace',
  null, 'San Francisco', 37.70676539999999, -122.418738,
  array['music']::text[], array['dothebay', 'music']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
),
(
  'dothebay-97cdc29145b8c2', 'MEMBA', 'DoTheBay listing for an upcoming Bay Area event.', 'DoTheBay', 'https://dothebay.com/events/2026/6/13/memba-at-public-works-tickets',
  '2026-06-13T21:30-07:00', null, 'America/Los_Angeles', 'Public Works',
  null, 'San Francisco', 37.7688759, -122.4194268,
  array['music']::text[], array['dothebay', 'music']::text[], null, null,
  'Price unknown', 'medium', 'scheduled', null,
  0.8
)
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
