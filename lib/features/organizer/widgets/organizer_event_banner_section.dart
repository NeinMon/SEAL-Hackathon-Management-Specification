import '../../../shared.dart';
import 'organizer_dialog_field.dart';

class OrganizerEventBannerSection extends StatelessWidget {
  const OrganizerEventBannerSection({
    super.key,
    required this.banner,
    required this.previewBytes,
    required this.status,
    required this.isUploading,
    required this.onPickImage,
    required this.onClearBanner,
  });

  final TextEditingController banner;
  final Uint8List? previewBytes;
  final String? status;
  final bool isUploading;
  final VoidCallback onPickImage;
  final VoidCallback onClearBanner;

  @override
  Widget build(BuildContext context) {
    final hasBanner = banner.text.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10nService.strings.eventFieldBannerUrl,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (hasBanner || previewBytes != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (previewBytes != null)
                    Image.memory(previewBytes!, fit: BoxFit.cover)
                  else
                    CachedNetworkImage(
                      imageUrl: banner.text,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 40,
                        ),
                      ),
                    ),
                  if (isUploading)
                    ColoredBox(
                      color: Colors.black.withValues(alpha: 0.36),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          ),
        if (status != null) ...[
          const SizedBox(height: 8),
          StatusBanner(message: status!),
        ],
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.tonalIcon(
              onPressed: isUploading ? null : onPickImage,
              icon: isUploading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.add_photo_alternate_outlined),
              label: Text(
                hasBanner
                    ? L10nService.strings.changeBannerButton
                    : L10nService.strings.uploadBannerButton,
              ),
            ),
            if (hasBanner || previewBytes != null)
              TextButton.icon(
                onPressed: isUploading ? null : onClearBanner,
                icon: Icon(Icons.delete_outline),
                label: Text(context.l10n.removeBannerButton),
              ),
          ],
        ),
        const SizedBox(height: 8),
        OrganizerDialogField(
          controller: banner,
          label: L10nService.strings.eventFieldBannerUrl,
          validator: (value) => AppValidators.optionalWebUrl(
            value,
            label: L10nService.strings.validationBannerUrlLabel,
          ),
        ),
      ],
    );
  }
}
