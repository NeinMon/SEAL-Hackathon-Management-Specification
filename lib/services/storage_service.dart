import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_helpers.dart';
import '../core/supabase_config.dart';

class StorageService {
  const StorageService();

  static const String eventBannersBucket = 'event-banners';

  Future<String?> uploadEventBanner(XFile file) async {
    return AppOperation.run('storage.upload_banner', () async {
      final bytes = await file.readAsBytes();
      final fileExt = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = fileName;

      await SupabaseGateway.client.storage
          .from(eventBannersBucket)
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: 'image/$fileExt'),
          );

      final url = SupabaseGateway.client.storage
          .from(eventBannersBucket)
          .getPublicUrl(filePath);

      return url;
    });
  }
}
