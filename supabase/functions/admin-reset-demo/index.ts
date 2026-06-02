import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

type DemoUser = {
  email: string;
  password: string;
  full_name: string;
  role: "participant" | "judge" | "mentor" | "organizer";
  university: string;
};

const demoUsers: DemoUser[] = [
  {
    email: "participant@seal.test",
    password: "123456",
    full_name: "Participant Demo",
    role: "participant",
    university: "FPT University",
  },
  {
    email: "judge@seal.test",
    password: "123456",
    full_name: "Judge Demo",
    role: "judge",
    university: "FPT University",
  },
  {
    email: "mentor@seal.test",
    password: "123456",
    full_name: "SEAL Mentor",
    role: "mentor",
    university: "SEAL Lab",
  },
  {
    email: "organizer@seal.test",
    password: "123456",
    full_name: "SEAL Organizer",
    role: "organizer",
    university: "SEAL Lab",
  },
];

const ids = {
  event: "00000000-0000-4000-8000-000000000001",
  team: "11111111-1111-4111-8111-111111111111",
  otherTeam: "11111111-1111-4111-8111-111111111112",
  submission: "22222222-2222-4222-8222-222222222222",
  score: "22222222-2222-4222-8222-222222222223",
  message: "33333333-3333-4333-8333-333333333333",
  question: "33333333-3333-4333-8333-333333333334",
};

const notificationIds = [
  "44444444-4444-4444-8444-444444444444",
  "44444444-4444-4444-8444-444444444445",
  "44444444-4444-4444-8444-444444444446",
  "44444444-4444-4444-8444-444444444447",
];

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
  if (!token) {
    return json({ error: "Missing authorization token" }, 401);
  }

  const admin = createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const authClient = createClient(supabaseUrl, anonKey, {
    auth: { persistSession: false, autoRefreshToken: false },
    global: { headers: { Authorization: `Bearer ${token}` } },
  });

  const { data: authData, error: authError } = await authClient.auth.getUser(token);
  if (authError || !authData.user) {
    return json({ error: "Invalid authorization token" }, 401);
  }

  const { data: profile, error: profileError } = await admin
    .from("users")
    .select("id, role")
    .eq("id", authData.user.id)
    .maybeSingle();
  if (profileError) return json({ error: profileError.message }, 500);
  if (profile?.role !== "organizer") {
    return json({ error: "Only organizers can reset demo data" }, 403);
  }

  try {
    await resetDemoRows(admin);
    const users = await seedDemoRows(admin);
    return json({
      ok: true,
      message: "Clean demo backend ready",
      accounts: demoUsers.map((user) => ({
        email: user.email,
        role: user.role,
        password: user.password,
      })),
      user_ids: users,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    return json({ error: message }, 500);
  }
});

function json(body: Record<string, unknown>, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

async function resetDemoRows(admin: ReturnType<typeof createClient>) {
  await must(admin.from("scores").delete().ilike("feedback", "Smoke score%"));
  await must(
    admin.from("scores").delete().ilike("feedback", "Seeded by service role%"),
  );
  await must(admin.from("scores").delete().eq("submission_id", ids.submission));
  await must(admin.from("notifications").delete().in("id", notificationIds));
  await must(admin.from("notifications").delete().ilike("title", "Smoke%"));
  await must(admin.from("messages").delete().in("id", [ids.message, ids.question]));
  await must(admin.from("messages").delete().ilike("message", "Smoke mentor question%"));
  await must(admin.from("submissions").delete().eq("id", ids.submission));
  await must(admin.from("submissions").delete().ilike("project_name", "Smoke Project%"));
  await must(admin.from("submissions").delete().ilike("project_name", "Negative Project%"));
  await must(admin.from("team_members").delete().in("team_id", [ids.team, ids.otherTeam]));
  await must(admin.from("teams").delete().in("id", [ids.team, ids.otherTeam]));
  await must(admin.from("teams").delete().ilike("name", "Smoke Team%"));
  await must(admin.from("teams").delete().ilike("name", "Negative Team%"));
  await must(admin.from("events").delete().eq("id", ids.event));
}

async function seedDemoRows(admin: ReturnType<typeof createClient>) {
  const users: Record<string, string> = {};
  for (const user of demoUsers) {
    users[user.role] = await ensureDemoUser(admin, user);
  }

  await must(
    admin.from("events").upsert({
      id: ids.event,
      title: "SEAL Innovation Hackathon 2026",
      description:
        "Xây dựng sản phẩm công nghệ thực tế cho giáo dục, cộng đồng và smart campus.",
      start_date: "2026-06-12T08:00:00",
      end_date: "2026-06-14T18:00:00",
      location: "FPT University HCMC",
      banner_url:
        "https://images.unsplash.com/photo-1517048676732-d65bc937f952?w=1200",
      registration_deadline: "2026-06-05T23:59:00",
      max_team_size: 5,
      rules: "Team nộp GitHub repository, video demo và pitch cuối trước deadline.",
      prize: "Giải nhất 20,000,000 VND, gói mentorship và hỗ trợ incubation.",
      latitude: 10.8411,
      longitude: 106.81,
    }),
  );

  await must(
    admin.from("teams").upsert([
      {
        id: ids.team,
        name: "Seal Builders",
        leader_id: users.participant,
        event_id: ids.event,
      },
      {
        id: ids.otherTeam,
        name: "Campus Makers",
        leader_id: users.organizer,
        event_id: ids.event,
      },
    ]),
  );

  await must(
    admin
      .from("team_members")
      .upsert(
        [
          { team_id: ids.team, user_id: users.participant },
          { team_id: ids.team, user_id: users.mentor },
          { team_id: ids.otherTeam, user_id: users.organizer },
        ],
        { onConflict: "team_id,user_id" },
      ),
  );

  await must(
    admin.from("submissions").upsert({
      id: ids.submission,
      team_id: ids.team,
      project_name: "Campus Copilot",
      github_url: "https://github.com/seal-demo/campus-copilot",
      video_url: "https://youtube.com/watch?v=seal-demo",
      description:
        "Mobile assistant hỗ trợ thí sinh, mentor, giám khảo và ban tổ chức trong hackathon.",
      status: "reviewed",
      submitted_at: "2026-06-01T08:30:00",
    }),
  );

  await must(
    admin.from("scores").upsert({
      id: ids.score,
      submission_id: ids.submission,
      judge_id: users.judge,
      technical_score: 8.5,
      ui_score: 8,
      innovation_score: 9,
      feedback:
        "Luồng mobile rõ, tách role tốt và triển khai Supabase RLS thực tế.",
      average_score: 8.5,
    }),
  );

  await must(
    admin.from("messages").upsert([
      {
        id: ids.message,
        sender_id: users.mentor,
        receiver_id: users.participant,
        message:
          "Chào mừng đến với SEAL Hackathon. Bạn có thể gửi câu hỏi về repository hoặc bài nộp tại đây.",
        created_at: "2026-06-01T01:34:00",
      },
      {
        id: ids.question,
        sender_id: users.participant,
        receiver_id: users.mentor,
        message: "Mentor review giúp team em repo và demo flow được không?",
        created_at: "2026-06-01T11:50:00",
      },
    ]),
  );

  await must(
    admin.from("notifications").upsert([
      {
        id: notificationIds[0],
        user_id: users.participant,
        title: "Demo workspace sẵn sàng",
        content: "Seal Builders và Campus Copilot đã sẵn sàng cho demo.",
        notification_type: "system",
        is_read: false,
        created_at: "2026-06-01T01:34:00",
      },
      {
        id: notificationIds[1],
        user_id: users.participant,
        title: "Đã công bố điểm",
        content: "Campus Copilot đã có feedback từ giám khảo.",
        notification_type: "score",
        is_read: false,
        created_at: "2026-06-01T09:15:00",
      },
      {
        id: notificationIds[2],
        user_id: users.participant,
        title: "Lời mời vào team",
        content: "Seal Builders đã sẵn sàng mời thêm thành viên.",
        notification_type: "invitation",
        is_read: true,
        created_at: "2026-05-31T13:43:00",
      },
      {
        id: notificationIds[3],
        user_id: users.judge,
        title: "Hàng chờ chấm đã sẵn sàng",
        content: "Campus Copilot đang có trong queue chấm điểm.",
        notification_type: "announcement",
        is_read: false,
        created_at: "2026-06-01T09:00:00",
      },
    ]),
  );

  return users;
}

async function ensureDemoUser(admin: ReturnType<typeof createClient>, user: DemoUser) {
  const existingProfile = await admin
    .from("users")
    .select("id")
    .eq("email", user.email)
    .maybeSingle();
  if (existingProfile.error) throw existingProfile.error;

  let id = existingProfile.data?.id as string | undefined;
  if (!id) {
    const created = await admin.auth.admin.createUser({
      email: user.email,
      password: user.password,
      email_confirm: true,
      user_metadata: { full_name: user.full_name, role: user.role },
    });

    if (created.error) {
      const list = await admin.auth.admin.listUsers({ page: 1, perPage: 200 });
      if (list.error) throw list.error;
      id = list.data.users.find((item) => item.email === user.email)?.id;
      if (!id) throw created.error;
    } else {
      id = created.data.user?.id;
    }
  }

  if (!id) throw new Error(`Could not create or find demo user ${user.email}.`);

  await must(
    admin.from("users").upsert({
      id,
      full_name: user.full_name,
      email: user.email,
      role: user.role,
      university: user.university,
    }),
  );
  return id;
}

async function must<T>(
  promise: PromiseLike<{ data: T; error: { message: string } | null }>,
) {
  const result = await promise;
  if (result.error) throw new Error(result.error.message);
  return result.data;
}
