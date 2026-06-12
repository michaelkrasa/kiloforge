const CATEGORIES = [
  "music",
  "art",
  "tech",
  "food",
  "outdoors",
  "comedy",
  "nightlife",
  "talks",
  "wellness",
  "community",
  "classes",
];

const state = {
  events: [],
  stats: new Map(),
  userInteractions: new Map(),
  recordedInteractions: new Set(),
  viewedEvents: new Set(),
  user: null,
  source: "loading",
  filters: {
    search: "",
    time: "next7",
    location: "all",
    price: "any",
    size: "any",
    sort: "match",
    categories: new Set(),
    strict: false,
  },
  supabase: null,
  sessionId: getSessionId(),
};

const els = {
  activeFilters: document.querySelector("#activeFilters"),
  categoryFilters: document.querySelector("#categoryFilters"),
  connectionStatus: document.querySelector("#connectionStatus"),
  dataSource: document.querySelector("#dataSource"),
  authSubtitle: document.querySelector("#authSubtitle"),
  authTitle: document.querySelector("#authTitle"),
  bestNextEvent: document.querySelector("#bestNextEvent"),
  eventGrid: document.querySelector("#eventGrid"),
  googleLoginButton: document.querySelector("#googleLoginButton"),
  hiddenCount: document.querySelector("#hiddenCount"),
  interestedCount: document.querySelector("#interestedCount"),
  locationFilter: document.querySelector("#locationFilter"),
  priceFilter: document.querySelector("#priceFilter"),
  rankSummary: document.querySelector("#rankSummary"),
  resetButton: document.querySelector("#resetButton"),
  resultCount: document.querySelector("#resultCount"),
  searchInput: document.querySelector("#searchInput"),
  savedCount: document.querySelector("#savedCount"),
  signOutButton: document.querySelector("#signOutButton"),
  sizeFilter: document.querySelector("#sizeFilter"),
  sortFilter: document.querySelector("#sortFilter"),
  strictToggle: document.querySelector("#strictToggle"),
  template: document.querySelector("#eventCardTemplate"),
  timeFilter: document.querySelector("#timeFilter"),
};

init();

async function init() {
  renderCategoryFilters();
  bindControls();
  renderState("Loading events", "Connecting to Supabase. If it is not configured yet, the app will switch to the emergency fallback catalog.");

  try {
    const config = await fetchConfig();
    if (config.supabaseUrl && config.supabasePublishableKey && window.supabase) {
      state.supabase = window.supabase.createClient(
        config.supabaseUrl,
        config.supabasePublishableKey,
      );
      await initAuth();
      await loadFromSupabase();
      subscribeToRealtime();
      setConnection("Live", false);
      state.source = "supabase";
    } else {
      throw new Error("Supabase environment variables are not configured.");
    }
  } catch (error) {
    console.info("Using fallback event catalog:", error.message);
    await loadFallbackEvents();
    setConnection("Fallback", true);
    state.source = "fallback";
  }

  render();
}

async function initAuth() {
  const {
    data: { session },
  } = await state.supabase.auth.getSession();
  state.user = session?.user || null;
  updateAuthPanel();

  state.supabase.auth.onAuthStateChange((_event, session) => {
    state.user = session?.user || null;
    state.recordedInteractions = new Set();
    updateAuthPanel();
    loadUserInteractions().then(render).catch(console.warn);
  });
}

async function fetchConfig() {
  const response = await fetch("/api/config", { cache: "no-store" });
  if (!response.ok) {
    throw new Error("Config endpoint unavailable.");
  }
  return response.json();
}

async function loadFromSupabase() {
  const now = new Date().toISOString();
  const { data: events, error } = await state.supabase
    .from("events")
    .select("*")
    .eq("status", "scheduled")
    .gte("start_at", now)
    .order("start_at", { ascending: true })
    .limit(250);

  if (error) throw error;

  state.events = (events || []).map(normalizeEvent);
  await loadStats();
  await loadUserInteractions();
}

async function loadUserInteractions() {
  state.userInteractions = new Map();
  if (!state.supabase || !state.user) return;

  const { data, error } = await state.supabase
    .from("event_interactions")
    .select("event_id, kind, created_at")
    .in("event_id", state.events.map((event) => event.id))
    .in("kind", ["save", "interested", "hide"])
    .order("created_at", { ascending: false });

  if (error) throw error;

  (data || []).forEach((interaction) => {
    const kinds = state.userInteractions.get(interaction.event_id) || new Set();
    kinds.add(interaction.kind);
    state.userInteractions.set(interaction.event_id, kinds);
  });
}

async function loadStats() {
  if (!state.supabase || state.events.length === 0) return;

  const eventIds = state.events.map((event) => event.id);
  const { data, error } = await state.supabase
    .from("event_stats")
    .select("*")
    .in("event_id", eventIds);

  if (error) throw error;
  state.stats = new Map((data || []).map((stat) => [stat.event_id, stat]));
}

async function loadFallbackEvents() {
  const response = await fetch("data/events.json", { cache: "no-store" });
  if (!response.ok) throw new Error("Fallback catalog unavailable.");
  const data = await response.json();
  state.events = data.events.map(normalizeEvent);
  state.stats = new Map(
    data.events.map((event) => [
      event.id,
      {
        event_id: event.id,
        views: event.views || 0,
        saves: event.saves || 0,
        interested: event.interested || 0,
        clicks: event.clicks || 0,
      },
    ]),
  );
}

function subscribeToRealtime() {
  state.supabase
    .channel("event-stats-live")
    .on(
      "postgres_changes",
      { event: "*", schema: "public", table: "event_stats" },
      (payload) => {
        const stat = payload.new || payload.old;
        if (!stat) return;
        state.stats.set(stat.event_id, stat);
        render();
      },
    )
    .on(
      "postgres_changes",
      { event: "*", schema: "public", table: "events" },
      () => loadFromSupabase().then(render).catch(console.warn),
    )
    .subscribe();
}

function renderCategoryFilters() {
  els.categoryFilters.innerHTML = "";
  CATEGORIES.forEach((category) => {
    const button = document.createElement("button");
    button.type = "button";
    button.className = "chip";
    button.dataset.category = category;
    button.textContent = titleCase(category);
    button.addEventListener("click", () => {
      if (state.filters.categories.has(category)) {
        state.filters.categories.delete(category);
      } else {
        state.filters.categories.add(category);
      }
      button.classList.toggle("is-active", state.filters.categories.has(category));
      render();
    });
    els.categoryFilters.append(button);
  });
}

function bindControls() {
  els.searchInput.addEventListener("input", () => {
    state.filters.search = els.searchInput.value.trim().toLowerCase();
    render();
  });
  els.timeFilter.addEventListener("change", () => {
    state.filters.time = els.timeFilter.value;
    render();
  });
  els.locationFilter.addEventListener("change", () => {
    state.filters.location = els.locationFilter.value;
    render();
  });
  els.priceFilter.addEventListener("change", () => {
    state.filters.price = els.priceFilter.value;
    render();
  });
  els.sizeFilter.addEventListener("change", () => {
    state.filters.size = els.sizeFilter.value;
    render();
  });
  els.sortFilter.addEventListener("change", () => {
    state.filters.sort = els.sortFilter.value;
    render();
  });
  els.strictToggle.addEventListener("change", () => {
    state.filters.strict = els.strictToggle.checked;
    render();
  });
  els.resetButton.addEventListener("click", resetFilters);
  els.googleLoginButton.addEventListener("click", () => signInWithGoogle());
  els.signOutButton.addEventListener("click", () => signOut());
}

function render() {
  const ranked = state.events
    .map((event) => ({ event, ranking: scoreEvent(event) }))
    .filter(({ event, ranking }) => passesFilters(event, ranking));

  ranked.sort(sortRankedEvents);

  els.eventGrid.innerHTML = "";
  els.resultCount.textContent = `${ranked.length} ${ranked.length === 1 ? "event" : "events"}`;
  els.dataSource.textContent =
    state.source === "supabase"
      ? "Supabase Postgres + Realtime"
      : "Demo fallback catalog";
  els.rankSummary.textContent =
    state.filters.strict
      ? "Showing exact-filter matches"
      : "Ranking by fit, with broad discovery";
  els.activeFilters.textContent = describeActiveFilters();
  updateDashboard(ranked);

  if (ranked.length === 0) {
    renderState(
      "No matching events",
      "Try widening the time window, removing category preferences, or turning off exact filters.",
    );
    return;
  }

  ranked.forEach(({ event, ranking }) => renderEventCard(event, ranking));
}

function renderEventCard(event, ranking) {
  const node = els.template.content.firstElementChild.cloneNode(true);
  if (!state.viewedEvents.has(event.id)) {
    state.viewedEvents.add(event.id);
    recordInteraction(event.id, "view");
  }
  const stats = state.stats.get(event.id) || {};
  const userKinds = state.userInteractions.get(event.id) || new Set();
  const start = new Date(event.start_at);
  node.classList.toggle("is-saved", userKinds.has("save"));
  node.classList.toggle("is-interested", userKinds.has("interested"));

  node.querySelector(".event-meta").textContent = formatDateTime(start);
  node.querySelector("h2").textContent = event.title;
  node.querySelector(".match-badge strong").textContent = `${ranking.score}%`;
  node.querySelector(".event-description").textContent = event.description;
  node.querySelector(".reason-line").textContent = ranking.reasons.join(" · ");

  const detailGrid = node.querySelector(".detail-grid");
  [
    event.neighborhood,
    event.venue_name,
    event.price_label || "Price unknown",
    `${titleCase(event.size_tier || "unknown")} vibe`,
    ...event.categories.map(titleCase),
  ].forEach((value) => detailGrid.append(createPill(value, "detail-pill")));

  const statRow = node.querySelector(".stat-row");
  [
    `${stats.views || 0} views`,
    `${stats.interested || 0} interested`,
    `${stats.saves || 0} saves`,
    `${stats.clicks || 0} source clicks`,
  ].forEach((value) => statRow.append(createPill(value, "stat-pill")));

  node.querySelector(".interested-button").addEventListener("click", () => {
    recordInteraction(event.id, "interested");
  });
  node.querySelector(".save-button").addEventListener("click", () => {
    recordInteraction(event.id, "save");
  });
  node.querySelector(".hide-button").addEventListener("click", () => {
    recordInteraction(event.id, "hide");
  });

  const sourceLink = node.querySelector(".source-link");
  sourceLink.href = event.source_url || "#";
  sourceLink.textContent = event.source ? `Open ${event.source}` : "Open source";
  sourceLink.addEventListener("click", () => {
    recordInteraction(event.id, "click");
  });

  els.eventGrid.append(node);

}

function renderState(title, body) {
  els.eventGrid.innerHTML = "";
  const card = document.createElement("article");
  card.className = "state-card";
  card.innerHTML = `<h2>${escapeHtml(title)}</h2><p>${escapeHtml(body)}</p>`;
  els.eventGrid.append(card);
}

function scoreEvent(event) {
  const reasons = [];
  const penalties = [];
  const categoryScore = scoreCategory(event, reasons, penalties);
  const timeScore = scoreTime(event, reasons, penalties);
  const locationScore = scoreLocation(event, reasons, penalties);
  const priceScore = scorePrice(event, reasons, penalties);
  const sizeScore = scoreSize(event, reasons, penalties);
  const freshnessScore = Math.round((event.source_confidence || 0.7) * 5);
  const userKinds = state.userInteractions.get(event.id) || new Set();
  const personalizationScore =
    (userKinds.has("save") ? 4 : 0) + (userKinds.has("interested") ? 4 : 0);

  const score = Math.max(
    0,
    Math.min(
      100,
      categoryScore +
        timeScore +
        locationScore +
        priceScore +
        sizeScore +
        freshnessScore +
        personalizationScore,
    ),
  );

  if (reasons.length < 3 && event.tags.length > 0) {
    reasons.push(`Tagged ${event.tags.slice(0, 2).join(", ")}`);
  }
  if (penalties.length > 0) {
    reasons.push(`Tradeoff: ${penalties[0]}`);
  }

  return { score, reasons: reasons.slice(0, 4) };
}

function scoreCategory(event, reasons, penalties) {
  if (state.filters.categories.size === 0) {
    reasons.push("Open category discovery");
    return 18;
  }
  const matches = event.categories.filter((category) =>
    state.filters.categories.has(category),
  );
  if (matches.length > 0) {
    reasons.push(`Matches ${matches.map(titleCase).join(", ")}`);
    return 25;
  }
  penalties.push("different category");
  return state.filters.strict ? 0 : 8;
}

function scoreTime(event, reasons, penalties) {
  const range = getTimeRange(state.filters.time);
  const start = new Date(event.start_at);
  if (start >= range.start && start <= range.end) {
    reasons.push(`Fits ${labelTimeFilter(state.filters.time)}`);
    return 25;
  }
  penalties.push("outside selected time");
  return 0;
}

function scoreLocation(event, reasons, penalties) {
  if (state.filters.location === "all") {
    reasons.push("Anywhere in SF");
    return 16;
  }
  if (event.neighborhood === state.filters.location) {
    reasons.push(`In ${event.neighborhood}`);
    return 20;
  }
  penalties.push(`not in ${state.filters.location}`);
  return state.filters.strict ? 0 : 7;
}

function scorePrice(event, reasons, penalties) {
  if (state.filters.price === "any") {
    return 12;
  }
  const tier = priceTier(event);
  if (tier === state.filters.price) {
    reasons.push(event.price_label || "Preferred price");
    return 15;
  }
  if (state.filters.price === "free" && event.price_min === 0) {
    reasons.push("Has a free option");
    return 12;
  }
  penalties.push("different price tier");
  return state.filters.strict ? 0 : 5;
}

function scoreSize(event, reasons, penalties) {
  if (state.filters.size === "any") {
    return 8;
  }
  if (event.size_tier === state.filters.size) {
    reasons.push(`${titleCase(event.size_tier)} vibe`);
    return 10;
  }
  penalties.push("different crowd size");
  return state.filters.strict ? 0 : 4;
}

function passesFilters(event, ranking) {
  if (new Date(event.start_at) < startOfDay(new Date())) return false;
  if (state.userInteractions.get(event.id)?.has("hide")) return false;
  if (state.filters.search && !matchesSearch(event, state.filters.search)) return false;
  if (scoreTime(event, [], []) === 0) return false;
  if (!state.filters.strict) return true;
  if (state.filters.location !== "all" && event.neighborhood !== state.filters.location) {
    return false;
  }
  if (
    state.filters.categories.size > 0 &&
    !event.categories.some((category) => state.filters.categories.has(category))
  ) {
    return false;
  }
  if (state.filters.price !== "any" && priceTier(event) !== state.filters.price) {
    return false;
  }
  if (state.filters.size !== "any" && event.size_tier !== state.filters.size) {
    return false;
  }
  return ranking.score > 0;
}

function sortRankedEvents(a, b) {
  if (state.filters.sort === "soonest") {
    return new Date(a.event.start_at) - new Date(b.event.start_at);
  }
  if (state.filters.sort === "cheapest") {
    return (a.event.price_min ?? 999) - (b.event.price_min ?? 999);
  }
  return b.ranking.score - a.ranking.score || new Date(a.event.start_at) - new Date(b.event.start_at);
}

async function recordInteraction(eventId, kind) {
  const personalAction = ["save", "hide", "interested"].includes(kind);
  if (personalAction && state.source === "supabase" && !state.user) {
    els.authSubtitle.textContent = "Sign in with Google first so this action lands on your dashboard.";
    return;
  }

  const oncePerSession = ["view", "save", "hide", "interested"].includes(kind);
  const interactionKey = `${eventId}:${kind}`;
  if (oncePerSession && state.recordedInteractions.has(interactionKey)) return;
  if (oncePerSession) state.recordedInteractions.add(interactionKey);

  if (state.source !== "supabase" || !state.supabase) {
    const stat = state.stats.get(eventId) || {
      event_id: eventId,
      views: 0,
      saves: 0,
      interested: 0,
      clicks: 0,
    };
    if (kind === "save") stat.saves += 1;
    if (kind === "interested") stat.interested += 1;
    if (kind === "click") stat.clicks += 1;
    if (kind === "view") stat.views += 1;
    state.stats.set(eventId, stat);
    if (kind !== "view") render();
    return;
  }

  const { error } = await state.supabase.from("event_interactions").insert({
    event_id: eventId,
    session_id: state.sessionId,
    user_id: state.user?.id || null,
    kind,
  });

  if (error) {
    if (error.code === "23505") return;
    if (oncePerSession) state.recordedInteractions.delete(interactionKey);
    console.warn(error);
    return;
  }

  if (["save", "interested", "hide"].includes(kind)) {
    const kinds = state.userInteractions.get(eventId) || new Set();
    kinds.add(kind);
    state.userInteractions.set(eventId, kinds);
    render();
  }
}

async function signInWithGoogle() {
  if (!state.supabase) return;
  await state.supabase.auth.signInWithOAuth({
    provider: "google",
    options: {
      redirectTo: window.location.origin,
    },
  });
}

async function signOut() {
  if (!state.supabase) return;
  await state.supabase.auth.signOut();
}

function updateAuthPanel() {
  if (!state.user) {
    els.authTitle.textContent = "Your event dashboard";
    els.authSubtitle.textContent =
      state.source === "fallback"
        ? "Connect Supabase to enable Google sign-in."
        : "Continue with Google to keep saves and interests across devices.";
    els.googleLoginButton.hidden = state.source === "fallback";
    els.signOutButton.hidden = true;
    return;
  }

  const name =
    state.user.user_metadata?.full_name ||
    state.user.user_metadata?.name ||
    state.user.email ||
    "Signed-in explorer";
  els.authTitle.textContent = name;
  els.authSubtitle.textContent = "Your saved, interested, and hidden events now follow you.";
  els.googleLoginButton.hidden = true;
  els.signOutButton.hidden = false;
}

function updateDashboard(ranked) {
  let saved = 0;
  let interested = 0;
  let hidden = 0;

  state.userInteractions.forEach((kinds) => {
    if (kinds.has("save")) saved += 1;
    if (kinds.has("interested")) interested += 1;
    if (kinds.has("hide")) hidden += 1;
  });

  els.savedCount.textContent = saved;
  els.interestedCount.textContent = interested;
  els.hiddenCount.textContent = hidden;
  els.bestNextEvent.textContent =
    ranked[0]?.event.title || (state.user ? "No match yet" : "Sign in to personalize");
}

function resetFilters() {
  state.filters = {
    search: "",
    time: "next7",
    location: "all",
    price: "any",
    size: "any",
    sort: "match",
    categories: new Set(),
    strict: false,
  };
  els.searchInput.value = "";
  els.timeFilter.value = "next7";
  els.locationFilter.value = "all";
  els.priceFilter.value = "any";
  els.sizeFilter.value = "any";
  els.sortFilter.value = "match";
  els.strictToggle.checked = false;
  document
    .querySelectorAll(".chip.is-active")
    .forEach((chip) => chip.classList.remove("is-active"));
  render();
}

function normalizeEvent(event) {
  return {
    id: event.id,
    title: event.title,
    description: event.description || "",
    source: event.source || "source",
    source_url: event.source_url || event.registration_url || "#",
    start_at: event.start_at || event.startAt,
    end_at: event.end_at || event.endAt,
    timezone: event.timezone || "America/Los_Angeles",
    venue_name: event.venue_name || event.venueName || "Venue TBA",
    address: event.address || "",
    neighborhood: event.neighborhood || "San Francisco",
    lat: event.lat,
    lng: event.lng,
    categories: event.categories || [],
    tags: event.tags || [],
    price_min: event.price_min ?? event.priceMin ?? null,
    price_max: event.price_max ?? event.priceMax ?? null,
    price_label: event.price_label || event.priceLabel || "Price unknown",
    size_tier: event.size_tier || event.sizeTier || "medium",
    status: event.status || "scheduled",
    source_confidence: event.source_confidence ?? event.sourceConfidence ?? 0.7,
    updated_at: event.updated_at || event.updatedAt,
  };
}

function getTimeRange(value) {
  const now = new Date();
  if (value === "today") {
    return { start: startOfDay(now), end: endOfDay(now) };
  }
  if (value === "tomorrow") {
    const tomorrow = addDays(startOfDay(now), 1);
    return { start: tomorrow, end: endOfDay(tomorrow) };
  }
  if (value === "weekend") {
    const day = now.getDay();
    const daysUntilSaturday = (6 - day + 7) % 7;
    const saturday = addDays(startOfDay(now), daysUntilSaturday);
    return { start: saturday, end: endOfDay(addDays(saturday, 1)) };
  }
  if (value === "next30") {
    return { start: startOfDay(now), end: endOfDay(addDays(now, 30)) };
  }
  return { start: startOfDay(now), end: endOfDay(addDays(now, 7)) };
}

function labelTimeFilter(value) {
  return {
    next7: "the next 7 days",
    today: "today",
    tomorrow: "tomorrow",
    weekend: "this weekend",
    next30: "the next 30 days",
  }[value];
}

function describeActiveFilters() {
  const parts = [labelTimeFilter(state.filters.time)];
  if (state.filters.location !== "all") parts.push(state.filters.location);
  if (state.filters.price !== "any") parts.push(labelPriceFilter(state.filters.price));
  if (state.filters.size !== "any") parts.push(`${titleCase(state.filters.size)} vibe`);
  if (state.filters.categories.size > 0) {
    parts.push([...state.filters.categories].map(titleCase).join(", "));
  }
  if (state.filters.strict) parts.push("exact mode");
  return parts.join(" · ");
}

function matchesSearch(event, search) {
  return [
    event.title,
    event.description,
    event.venue_name,
    event.neighborhood,
    event.source,
    ...event.categories,
    ...event.tags,
  ]
    .join(" ")
    .toLowerCase()
    .includes(search);
}

function priceTier(event) {
  const price = event.price_min ?? event.price_max;
  if (price === 0) return "free";
  if (price == null) return "any";
  if (price <= 25) return "low";
  if (price <= 75) return "mid";
  return "high";
}

function labelPriceFilter(value) {
  return {
    any: "any price",
    free: "free",
    low: "$",
    mid: "$$",
    high: "$$$",
  }[value];
}

function formatDateTime(date) {
  return new Intl.DateTimeFormat("en-US", {
    weekday: "short",
    month: "short",
    day: "numeric",
    hour: "numeric",
    minute: "2-digit",
    timeZoneName: "short",
  }).format(date);
}

function createPill(text, className) {
  const pill = document.createElement("span");
  pill.className = className;
  pill.textContent = text;
  return pill;
}

function startOfDay(date) {
  const copy = new Date(date);
  copy.setHours(0, 0, 0, 0);
  return copy;
}

function endOfDay(date) {
  const copy = new Date(date);
  copy.setHours(23, 59, 59, 999);
  return copy;
}

function addDays(date, days) {
  const copy = new Date(date);
  copy.setDate(copy.getDate() + days);
  return copy;
}

function titleCase(value) {
  return String(value)
    .replace(/-/g, " ")
    .replace(/\b\w/g, (letter) => letter.toUpperCase());
}

function getSessionId() {
  const key = "signal_sf_session_id";
  const existing = localStorage.getItem(key);
  if (existing) return existing;
  const next =
    crypto.randomUUID?.() ||
    `session-${Date.now()}-${Math.random().toString(16).slice(2)}`;
  localStorage.setItem(key, next);
  return next;
}

function setConnection(label, offline) {
  els.connectionStatus.textContent = label;
  els.connectionStatus.classList.toggle("is-offline", offline);
}

function escapeHtml(value) {
  return String(value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}
