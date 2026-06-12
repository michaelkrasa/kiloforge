import crypto from "node:crypto";
import fs from "node:fs/promises";

const USER_AGENT =
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36";
const TZ = "America/Los_Angeles";
const FETCH_OPTIONS = { headers: { "user-agent": USER_AGENT } };
const RUN_ID = new Date().toISOString().replace(/[:.]/g, "-");

const SOURCES = [
  {
    name: "Luma SF",
    url: "https://luma.com/sf",
    scrape: scrapeLuma,
  },
  {
    name: "Funcheap SF",
    url: "https://sf.funcheap.com/events/san-francisco/",
    scrape: scrapeFuncheap,
  },
  {
    name: "DoTheBay",
    url: "https://dothebay.com/events",
    scrape: scrapeDoTheBay,
  },
];

const CATEGORY_RULES = [
  ["comedy", /\b(comedy|standup|stand-up|laugh|roast)\b/i],
  ["music", /\b(music|dj|concert|band|jazz|dance|singer|song|club|party)\b/i],
  ["tech", /\b(ai|hack|founder|startup|builder|software|data|prototype|engineering|cursor|vercel|xai)\b/i],
  ["food", /\b(food|drink|dinner|market|ribs|sake|wine|cocktail|coffee|restaurant)\b/i],
  ["outdoors", /\b(park|run|hike|outdoor|trail|garden|promenade|picnic|beach)\b/i],
  ["art", /\b(art|mural|museum|gallery|film|theatre|theater|performance|drag|workshop)\b/i],
  ["wellness", /\b(wellness|yoga|health|run|breath|fitness)\b/i],
  ["classes", /\b(class|workshop|seminar|lesson|training)\b/i],
  ["talks", /\b(talk|panel|lecture|salon|seminar|q&a|expo)\b/i],
  ["nightlife", /\b(night|bar|club|party|after dark|rooftop)\b/i],
  ["community", /\b(community|festival|fair|juneteenth|pride|library|market|volunteer|family)\b/i],
];

const NEIGHBORHOOD_RULES = [
  ["Mission Bay", /\b(mission bay|thrive city|warriors way|oracle park)\b/i],
  ["Mission", /\b(mission|valencia|el rio|folsom)\b/i],
  ["SoMa", /\b(soma|6th street|f8|endup|1015|yerba buena)\b/i],
  ["Castro", /\b(castro|beaux|market street|midnight sun)\b/i],
  ["Sunset", /\b(sunset|irving|19th ave|outer sunset)\b/i],
  ["Richmond", /\b(richmond|clement|geary|outer richmond)\b/i],
  ["Fillmore", /\b(fillmore|japantown)\b/i],
  ["North Beach", /\b(north beach|columbus|cigar bar)\b/i],
  ["Financial District", /\b(financial|montgomery|embarcadero|ferry building)\b/i],
  ["Downtown", /\b(downtown|union square|ellis|powell)\b/i],
  ["Civic Center", /\b(civic center|van ness|sf playhouse)\b/i],
  ["Hayes Valley", /\b(hayes|octavia)\b/i],
  ["Marina", /\b(marina|golden gate promenade)\b/i],
  ["Golden Gate Park", /\b(golden gate park|de young|legion of honor)\b/i],
  ["Presidio", /\b(presidio|golden gate bridge)\b/i],
  ["Bayview", /\b(bayview|gilman)\b/i],
  ["Fisherman's Wharf", /\b(fisherman|pier 39|wharf)\b/i],
  ["Dogpatch", /\b(dogpatch|potrero)\b/i],
  ["Chinatown", /\b(chinatown)\b/i],
];

async function main() {
  const collected = [];
  const counts = {};

  for (const source of SOURCES) {
    const html = await fetchText(source.url);
    const events = (await source.scrape(html, source)).slice(0, 20);
    counts[source.name] = events.length;
    collected.push(...events);
  }

  const deduped = dedupe(collected);
  const sql = buildSql(deduped);
  const snapshotPath = `data/scrapes/sf-events-${RUN_ID}.json`;
  const sqlPath = `supabase/imports/sf-events-${RUN_ID}.sql`;

  await fs.writeFile(
    snapshotPath,
    JSON.stringify({ run_id: RUN_ID, counts, events: deduped }, null, 2) + "\n",
  );
  await fs.writeFile(sqlPath, sql);

  console.log(JSON.stringify({ counts, total: deduped.length, snapshotPath, sqlPath }, null, 2));
}

async function fetchText(url) {
  const response = await fetch(url, FETCH_OPTIONS);
  if (!response.ok) {
    throw new Error(`Fetch failed for ${url}: ${response.status} ${response.statusText}`);
  }
  return response.text();
}

async function scrapeLuma(html, source) {
  const scripts = [...html.matchAll(/<script[^>]+type="application\/ld\+json"[^>]*>([\s\S]*?)<\/script>/g)];
  const itemList = scripts
    .map((match) => safeJson(match[1]))
    .find((value) => value?.["@type"] === "ItemList" && Array.isArray(value.itemListElement));

  if (!itemList) return [];

  return itemList.itemListElement.map(({ item }) => {
    const place = item.location || {};
    const address = place.address || {};
    const offers = Array.isArray(item.offers) ? item.offers : [];
    const prices = offers.map((offer) => Number(offer.price)).filter(Number.isFinite);
    const organizerNames = arrayify(item.organizer).map((organizer) => organizer.name).filter(Boolean);
    const locationText = [
      place.name,
      address.streetAddress,
      address.addressLocality,
      address.addressRegion,
    ]
      .filter(Boolean)
      .join(", ");

    return normalizeEvent({
      source: source.name,
      title: item.name,
      description: organizerNames.length
        ? `Luma event organized by ${organizerNames.slice(0, 3).join(", ")}.`
        : "Luma event listed on the San Francisco discovery calendar.",
      source_url: item.url,
      start_at: item.startDate,
      end_at: item.endDate,
      venue_name: place.name || address.streetAddress || address.addressLocality || "San Francisco",
      address: formatAddress(address),
      neighborhood: inferNeighborhood(`${item.name} ${locationText}`) || address.addressLocality || "San Francisco",
      lat: numberOrNull(place.geo?.latitude ?? place.latitude),
      lng: numberOrNull(place.geo?.longitude ?? place.longitude),
      categories: inferCategories(`${item.name} ${organizerNames.join(" ")} ${locationText}`),
      tags: ["luma", ...organizerNames.slice(0, 3).map(slugTag)],
      price_min: prices.length ? Math.min(...prices) : null,
      price_max: prices.length ? Math.max(...prices) : null,
      price_label: priceLabel(prices),
      size_tier: inferSize(`${item.name} ${locationText}`),
      image_url: Array.isArray(item.image) ? item.image[0] : item.image,
      source_confidence: 0.86,
    });
  });
}

async function scrapeFuncheap(html, source) {
  const events = [];
  let currentDate = null;
  const eventish =
    /<h2[^>]*>([^<]*,\s+[A-Za-z]+\s+\d{1,2},\s+\d{4})<\/h2>|<div id="post-\d+"[\s\S]*?<\/div>\s*<\/td>\s*<\/tr>|<tr id="post-\d+"[\s\S]*?<\/tr>/g;

  for (const match of html.matchAll(eventish)) {
    if (match[1]) {
      currentDate = parseDateHeader(match[1]);
      continue;
    }

    const block = match[0];
    const link =
      block.match(/entry-title[\s\S]*?<a href="([^"]+)"[^>]*title="([^"]*)"[^>]*>([\s\S]*?)<\/a>/) ||
      block.match(/<a href="([^"]+)"[^>]*title="([^"]+)"[^>]*>([\s\S]*?)<\/a>/);
    if (!link || !currentDate) continue;

    const dataStart = attr(block, "data-event-date");
    const dataEnd = attr(block, "data-event-date-end");
    const rowTime = text(block.match(/<td[^>]*style="width:66px"[^>]*>([\s\S]*?)<\/td>/)?.[1] || "");
    const cost = funcheapPrice(block);
    const title = text(link[3] || link[2]);
    const venue =
      text(block.match(/<span class="cost">[\s\S]*?<\/span>\s*\|\s*<span>([\s\S]*?)<\/span>/)?.[1] || "") ||
      inferVenueFromTitle(title) ||
      "San Francisco";
    const classes = attr(block, "class");
    const plain = text(block);
    const startAt = dataStart ? localDateTime(dataStart) : combineDateAndTime(currentDate, rowTime);
    const endAt = dataEnd ? localDateTime(dataEnd) : null;

    events.push(
      normalizeEvent({
        source: source.name,
        title,
        description: summarize(plain, title) || "Funcheap listing for an upcoming San Francisco event.",
        source_url: link[1],
        start_at: startAt,
        end_at: endAt,
        venue_name: venue,
        address: null,
        neighborhood: inferNeighborhood(`${title} ${venue} ${classes}`) || "San Francisco",
        categories: inferCategories(`${title} ${classes}`),
        tags: ["funcheap", ...classTags(classes).slice(0, 5)],
        price_min: parsePrice(cost).min,
        price_max: parsePrice(cost).max,
        price_label: cost || "Price unknown",
        size_tier: inferSize(`${title} ${classes}`),
        image_url: decode(block.match(/<noscript[\s\S]*?<img[^>]+src="([^"]+)"/)?.[1] || ""),
        source_confidence: 0.76,
      }),
    );
  }

  return dedupe(events);
}

async function scrapeDoTheBay(html, source) {
  const pages = [
    html,
    await fetchText("https://dothebay.com/events/tomorrow"),
    await fetchText("https://dothebay.com/events/2026/6/14"),
    await fetchText("https://dothebay.com/events/2026/6/15"),
  ];

  return dedupe(pages.flatMap((page) => parseDoTheBayPage(page, source)))
    .filter(isProbablySf)
    .slice(0, 20);
}

function parseDoTheBayPage(html, source) {
  const blocks = splitBlocks(html, /<div class="ds-listing event-card[\s\S]*?itemtype="http:\/\/schema.org\/Event">/g);

  return blocks.map((block) => {
    const title = text(block.match(/itemprop="name"[^>]*>([\s\S]*?)<\/span>/)?.[1] || "");
    const pagePath = attr(block.match(/<a[^>]+itemprop="url"[^>]+class="ds-listing-event-title[^"]*"[^>]*>/)?.[0] || "", "href");
    const startAt = attr(block.match(/itemprop="startDate"[^>]*>/)?.[0] || "", "datetime");
    const endAt = attr(block.match(/itemprop="endDate"[^>]*>/)?.[0] || "", "datetime");
    const venue = text(block.match(/itemprop="location"[\s\S]*?itemprop="name"[^>]*>([\s\S]*?)<\/[^>]+>/)?.[1] || "") || "San Francisco";
    const addressBlock = block.match(/itemprop="address"[\s\S]*?<\/span>\s*<\/span>/)?.[0] || "";
    const address = extractMicrodataText(addressBlock, "streetAddress");
    const locality = extractMicrodataText(addressBlock, "addressLocality");
    const region = extractMicrodataText(addressBlock, "addressRegion");
    const postalCode = extractMicrodataText(addressBlock, "postalCode");
    const lat = numberOrNull(block.match(/<span class="value-title" title="(-?\d+\.\d+)"><\/span>/)?.[1]);
    const lng = numberOrNull([...block.matchAll(/<span class="value-title" title="(-?\d+\.\d+)"><\/span>/g)]?.[1]?.[1]);
    const price = numberOrNull(attr(block.match(/itemprop="price"[^>]*>/)?.[0] || "", "content"));
    const categoryClass = block.match(/ds-event-category-([\w-]+)/)?.[1] || "";

    return normalizeEvent({
      source: source.name,
      title,
      description: "DoTheBay listing for an upcoming Bay Area event.",
      source_url: absoluteUrl(pagePath, "https://dothebay.com"),
      start_at: normalizeOffsetDate(startAt),
      end_at: endAt ? normalizeOffsetDate(endAt) : null,
      venue_name: venue,
      address: [address, locality, region, postalCode].filter(Boolean).join(", ") || null,
      neighborhood: inferNeighborhood(`${title} ${venue} ${address}`) || locality || "San Francisco",
      lat,
      lng,
      categories: inferCategories(`${title} ${venue} ${categoryClass}`),
      tags: ["dothebay", slugTag(categoryClass)].filter(Boolean),
      price_min: price,
      price_max: price,
      price_label: price === 0 ? "Free" : price ? `$${price.toFixed(2)}` : "Price unknown",
      size_tier: inferSize(`${title} ${venue} ${categoryClass}`),
      image_url: decode(attr(block.match(/<img[^>]+itemprop="image"[^>]*>/)?.[0] || "", "src")),
      source_confidence: 0.8,
    });
  }).filter((event) => event.title && event.start_at && !isBeforeToday(event.start_at)).slice(0, 20);
}

function normalizeEvent(input) {
  const normalized = {
    id: eventId(input.source, input.source_url, input.start_at),
    title: input.title.trim(),
    description: input.description.trim(),
    source: input.source,
    source_url: input.source_url,
    start_at: input.start_at,
    end_at: input.end_at || null,
    timezone: TZ,
    venue_name: input.venue_name?.trim() || "San Francisco",
    address: input.address || null,
    neighborhood: input.neighborhood || "San Francisco",
    lat: numberOrNull(input.lat),
    lng: numberOrNull(input.lng),
    categories: input.categories?.length ? input.categories : ["community"],
    tags: cleanTags(input.tags || []),
    price_min: numberOrNull(input.price_min),
    price_max: numberOrNull(input.price_max),
    price_label: input.price_label || "Price unknown",
    size_tier: input.size_tier || "medium",
    status: "scheduled",
    image_url: input.image_url || null,
    source_confidence: input.source_confidence || 0.75,
  };

  if (!normalized.description) {
    normalized.description = `Upcoming event listed by ${normalized.source}.`;
  }
  if (normalized.description.length > 450) {
    normalized.description = `${normalized.description.slice(0, 447).trim()}...`;
  }

  return normalized;
}

function buildSql(events) {
  const rows = events.map((event) => `(
  ${sql(event.id)}, ${sql(event.title)}, ${sql(event.description)}, ${sql(event.source)}, ${sql(event.source_url)},
  ${sql(event.start_at)}, ${nullableSql(event.end_at)}, ${sql(event.timezone)}, ${sql(event.venue_name)},
  ${nullableSql(event.address)}, ${sql(event.neighborhood)}, ${numberSql(event.lat)}, ${numberSql(event.lng)},
  ${arraySql(event.categories)}, ${arraySql(event.tags)}, ${numberSql(event.price_min)}, ${numberSql(event.price_max)},
  ${sql(event.price_label)}, ${sql(event.size_tier)}, ${sql(event.status)}, ${nullableSql(event.image_url)},
  ${numberSql(event.source_confidence)}
)`);

  return `insert into public.events (
  id, title, description, source, source_url, start_at, end_at, timezone, venue_name,
  address, neighborhood, lat, lng, categories, tags, price_min, price_max,
  price_label, size_tier, status, image_url, source_confidence
) values
${rows.join(",\n")}
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
`;
}

function splitBlocks(html, startRegex) {
  const starts = [...html.matchAll(startRegex)].map((match) => match.index);
  return starts.map((start, index) => html.slice(start, starts[index + 1] ?? html.length));
}

function extractMicrodataText(block, prop) {
  return text(block.match(new RegExp(`itemprop="${prop}"[^>]*>([\\s\\S]*?)<\\/[^>]+>`))?.[1] || "");
}

function summarize(plain, title) {
  return plain
    .replace(title, "")
    .replace(/\s*more\.\.\..*$/i, "")
    .replace(/\s+/g, " ")
    .trim()
    .slice(0, 420);
}

function inferCategories(textValue) {
  const matches = CATEGORY_RULES.filter(([, rule]) => rule.test(textValue)).map(([category]) => category);
  return [...new Set(matches.length ? matches : ["community"])];
}

function inferNeighborhood(textValue) {
  return NEIGHBORHOOD_RULES.find(([, rule]) => rule.test(textValue))?.[0] || null;
}

function inferSize(textValue) {
  if (/\b(hackathon|festival|fair|market|block party|stadium|watch party|expo)\b/i.test(textValue)) return "big";
  if (/\b(workshop|salon|seminar|class|coffee|run|hike|reading)\b/i.test(textValue)) return "intimate";
  return "medium";
}

function inferVenueFromTitle(title) {
  const match = title.match(/\(([^)]+)\)\s*$/);
  return match?.[1]?.includes("SF") ? match[1] : null;
}

function parsePrice(label) {
  if (!label) return { min: null, max: null };
  if (/free/i.test(label)) return { min: 0, max: 0 };
  const values = [...label.matchAll(/\$(\d+(?:\.\d+)?)/g)].map((match) => Number(match[1]));
  return {
    min: values.length ? Math.min(...values) : null,
    max: values.length ? Math.max(...values) : null,
  };
}

function funcheapPrice(block) {
  const featureCost = text(block.match(/<span class="cost">Cost:\s*([\s\S]*?)<\/span>/i)?.[1] || "");
  if (featureCost) return featureCost;

  const cells = [...block.matchAll(/<td[^>]*>([\s\S]*?)<\/td>/g)];
  const priceCell = text(cells.at(-1)?.[1] || "");
  const free = priceCell.match(/free\*?/i)?.[0];
  if (free) return free.toUpperCase();
  const dollars = priceCell.match(/\$\d+(?:\.\d+)?\*?/);
  return dollars?.[0] || "";
}

function priceLabel(prices) {
  if (!prices.length) return "Price unknown";
  const min = Math.min(...prices);
  const max = Math.max(...prices);
  if (min === 0 && max === 0) return "Free";
  if (min === max) return `$${min.toFixed(2)}`;
  return `$${min.toFixed(2)}-$${max.toFixed(2)}`;
}

function classTags(classes) {
  return [...classes.matchAll(/\bcategory-([\w-]+)/g)]
    .map((match) => slugTag(match[1]))
    .filter(Boolean);
}

function cleanTags(tags) {
  return [...new Set(tags.map(slugTag).filter(Boolean))].slice(0, 10);
}

function slugTag(value) {
  return String(value || "")
    .toLowerCase()
    .replace(/&amp;/g, "and")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "")
    .slice(0, 32);
}

function eventId(source, url, startAt) {
  const digest = crypto.createHash("sha1").update(`${source}|${url}|${startAt}`).digest("hex").slice(0, 14);
  return `${slugTag(source)}-${digest}`;
}

function dedupe(events) {
  const seen = new Set();
  return events.filter((event) => {
    const key = event.source_url || `${event.title}|${event.start_at}`;
    if (seen.has(key)) return false;
    seen.add(key);
    return true;
  });
}

function parseDateHeader(value) {
  const parsed = new Date(`${decode(value)} 12:00:00 GMT-0700`);
  if (Number.isNaN(parsed.valueOf())) return null;
  return parsed.toISOString().slice(0, 10);
}

function combineDateAndTime(date, timeValue) {
  const match = String(timeValue).match(/(\d{1,2})(?::(\d{2}))?\s*(am|pm)/i);
  if (!date || !match) return `${date}T12:00:00-07:00`;
  let hour = Number(match[1]);
  const minute = Number(match[2] || 0);
  const meridian = match[3].toLowerCase();
  if (meridian === "pm" && hour < 12) hour += 12;
  if (meridian === "am" && hour === 12) hour = 0;
  return `${date}T${String(hour).padStart(2, "0")}:${String(minute).padStart(2, "0")}:00-07:00`;
}

function localDateTime(value) {
  return `${value.replace(" ", "T")}:00-07:00`;
}

function normalizeOffsetDate(value) {
  return value ? value.replace(/([+-]\d{2})(\d{2})$/, "$1:$2") : value;
}

function isBeforeToday(value) {
  return String(value).slice(0, 10) < "2026-06-12";
}

function isProbablySf(event) {
  if (!Number.isFinite(event.lat) || !Number.isFinite(event.lng)) return true;
  return event.lat >= 37.69 && event.lat <= 37.84 && event.lng >= -122.53 && event.lng <= -122.35;
}

function formatAddress(address) {
  if (!address || typeof address !== "object") return null;
  return [
    address.streetAddress,
    address.addressLocality,
    address.addressRegion,
    address.postalCode,
    address.addressCountry,
  ]
    .filter(Boolean)
    .join(", ");
}

function arrayify(value) {
  if (!value) return [];
  return Array.isArray(value) ? value : [value];
}

function safeJson(value) {
  try {
    return JSON.parse(decode(value));
  } catch {
    return null;
  }
}

function attr(value, name) {
  return decode(String(value || "").match(new RegExp(`${name}="([^"]*)"`))?.[1] || "");
}

function text(value) {
  return decode(String(value || "").replace(/<[^>]*>/g, " "))
    .replace(/\s+/g, " ")
    .trim();
}

function decode(value) {
  return String(value || "")
    .replace(/&amp;/g, "&")
    .replace(/&quot;/g, '"')
    .replace(/&#039;/g, "'")
    .replace(/&#8217;/g, "'")
    .replace(/&#8220;/g, '"')
    .replace(/&#8221;/g, '"')
    .replace(/&#038;/g, "&")
    .replace(/&#150;/g, "-")
    .replace(/&#8211;/g, "-")
    .replace(/&#8212;/g, "-")
    .replace(/&#x([0-9a-f]+);/gi, (_, hex) => String.fromCodePoint(Number.parseInt(hex, 16)))
    .replace(/&#(\d+);/g, (_, code) => String.fromCodePoint(Number.parseInt(code, 10)))
    .replace(/&nbsp;/g, " ")
    .replace(/&rsquo;/g, "'")
    .replace(/&ldquo;/g, '"')
    .replace(/&rdquo;/g, '"');
}

function numberOrNull(value) {
  if (value === null || value === undefined || value === "") return null;
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : null;
}

function absoluteUrl(url, base) {
  if (!url) return base;
  return new URL(url, base).href;
}

function sql(value) {
  return `'${String(value).replace(/'/g, "''")}'`;
}

function nullableSql(value) {
  return value ? sql(value) : "null";
}

function numberSql(value) {
  return Number.isFinite(value) ? String(value) : "null";
}

function arraySql(values) {
  return `array[${values.map(sql).join(", ")}]::text[]`;
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
