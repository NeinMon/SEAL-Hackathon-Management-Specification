import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

type Role = "judge" | "mentor";

Deno.serve(async (request) => {
  if (request.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (request.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
  if (!supabaseUrl || !serviceRoleKey || !anonKey) {
    return json({ error: "Supabase environment is not configured" }, 500);
  }

  const token = request.headers.get("Authorization")?.replace("Bearer ", "");
  if (!token) return json({ error: "Missing authorization token" }, 401);

  const admin = createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const authClient = createClient(supabaseUrl, anonKey, {
    auth: { persistSession: false, autoRefreshToken: false },
    global: { headers: { Authorization: `Bearer ${token}` } },
  });

  const { data: authData, error: authError } = await authClient.auth.getUser(
    token,
  );
  if (authError || !authData.user) {
    return json({ error: "Invalid authorization token" }, 401);
  }

  const { data: caller, error: callerError } = await admin
    .from("users")
    .select("id, role")
    .eq("id", authData.user.id)
    .maybeSingle();
  if (callerError) return json({ error: callerError.message }, 500);
  if (caller?.role !== "organizer") {
    return json({ error: "Only organizers can create staff accounts" }, 403);
  }

  const body = await request.json().catch(() => ({}));
  const email = clean(body.email).toLowerCase();
  const password = String(body.password ?? "");
  const fullName = clean(body.full_name);
  const university = clean(body.university);
  const role = clean(body.role) as Role;

  if (!fullName || !email || !password) {
    return json({ error: "Missing required fields" }, 400);
  }
  if (role !== "judge" && role !== "mentor") {
    return json({ error: "Role must be judge or mentor" }, 400);
  }

  try {
    const userId = await createOrFindAuthUser(admin, {
      email,
      password,
      fullName,
      role,
    });
    const { data: profile, error: profileError } = await admin
      .from("users")
      .upsert({
        id: userId,
        full_name: fullName,
        email,
        role,
        university,
      })
      .select()
      .single();
    if (profileError) throw profileError;
    return json({ ok: true, user: profile });
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    return json({ error: message }, 500);
  }
});

async function createOrFindAuthUser(
  admin: ReturnType<typeof createClient>,
  input: { email: string; password: string; fullName: string; role: Role },
) {
  const created = await admin.auth.admin.createUser({
    email: input.email,
    password: input.password,
    email_confirm: true,
    user_metadata: { full_name: input.fullName, role: input.role },
  });
  if (!created.error && created.data.user?.id) {
    return created.data.user.id;
  }
  const list = await admin.auth.admin.listUsers({ page: 1, perPage: 1000 });
  if (list.error) throw list.error;
  const existing = list.data.users.find((user) => user.email === input.email);
  if (existing?.id) return existing.id;
  throw created.error ?? new Error("Could not create auth user");
}

function clean(value: unknown) {
  return String(value ?? "").trim();
}

function json(body: Record<string, unknown>, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
