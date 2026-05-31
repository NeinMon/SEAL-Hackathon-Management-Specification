drop policy if exists "Judges can update own scores" on scores;
create policy "Judges can update own scores"
on scores for update
to authenticated
using (
  judge_id = auth.uid()
  and public.current_user_role() = 'judge'
)
with check (
  judge_id = auth.uid()
  and public.current_user_role() = 'judge'
);
