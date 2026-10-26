import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paperless_mobile/features/document_details/document_share/view/document_link_actions.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

enum ShareOption { shareFile, copyDetails, copyPreview, publicShare }

class DocumentShareOptionsSheet extends StatelessWidget {
  final int documentId;
  final String serverUrl;
  final void Function(ShareOption) onSelected;
  const DocumentShareOptionsSheet({
    super.key,
    required this.documentId,
    required this.serverUrl,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.share),
            title: Text(S.of(context)!.shareFile),
            onTap: () => onSelected(ShareOption.shareFile),
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: Text(S.of(context)!.copyDetailsLink),
            subtitle: Text(buildDetailsUrl(serverUrl, documentId)),
            onTap: () => onSelected(ShareOption.copyDetails),
          ),
          ListTile(
            leading: const Icon(Icons.preview),
            title: Text(S.of(context)!.copyPreviewLink),
            subtitle: Text(buildPreviewUrl(serverUrl, documentId)),
            onTap: () => onSelected(ShareOption.copyPreview),
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: Text(S.of(context)!.publicShareLinks),
            onTap: () => onSelected(ShareOption.publicShare),
          ),
        ],
      ),
    );
  }
}
