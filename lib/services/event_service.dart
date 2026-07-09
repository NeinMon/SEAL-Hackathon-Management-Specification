import '../core/app_helpers.dart';
import '../core/supabase_config.dart';
import '../models/hackathon_event.dart';

class EventService {
  const EventService();

  Future<List<HackathonEvent>> fetchEvents() async {
    return AppOperation.run('events.fetch', () async {
      final rows = await SupabaseGateway.client
          .from('events')
          .select()
          .order('start_date');
      return rows
          .whereType<Map<String, dynamic>>()
          .map(HackathonEvent.fromJson)
          .toList();
    });
  }

  Future<void> saveEvent(HackathonEvent event, {String? existingEventId}) {
    final payload = event.toJson();
    AppLogger.action('event.save', {
      'event_id': existingEventId ?? event.id,
      'mode': existingEventId == null ? 'create' : 'update',
    });
    return AppOperation.run('events.save', () {
      if (existingEventId == null) {
        return SupabaseGateway.client.from('events').insert(payload);
      }
      return SupabaseGateway.client
          .from('events')
          .update(payload)
          .eq('id', existingEventId);
    });
  }
}
