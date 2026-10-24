import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paperless_mobile/api/extensions/cached_query_extensions.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/widgets/icon_loading_widget.dart';
import 'package:paperless_mobile/features/document_details/document_share/view/document_link_actions.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

/// Bottom sheet managing public share links for a document.
///
/// Lists existing links (copy/delete) and offers a footer to create
/// new links with expiry + file version options.
class DocumentShareLinksSheet extends StatefulWidget {
  final int documentId;
  const DocumentShareLinksSheet({super.key, required this.documentId});

  @override
  State<DocumentShareLinksSheet> createState() => _DocumentShareLinksSheetState();
}

class _DocumentShareLinksSheetState extends State<DocumentShareLinksSheet> {
  /// Expiry in days; null means never expires. Default 7.
  int? _expiryDays = 7;
  String _fileVersion = 'archive';

  @override
  Widget build(BuildContext context) {
    final serverUrl = context.loggedInUser$.serverUrl;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                S.of(context)!.publicShareLinks,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Flexible(
              child: QueryBuilder(
                query: context.documentRepository.getShareLinksQuery(
                  widget.documentId,
                ),
                builder: (context, state) {
                  if (state.isLoadingInitial) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state.isError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(state.error.toString()),
                      ),
                    );
                  }
                  final links = state.data?.toList() ?? [];
                  if (links.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('No share links yet.'),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: links.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final link = links[index];
                      final url = buildPublicShareUrl(serverUrl, link.slug);
                      final expiry = link.expiration == null
                          ? 'Never'
                          : MaterialLocalizations.of(
                              context,
                            ).formatShortDate(link.expiration!);
                      return ListTile(
                        dense: true,
                        title: Text(
                          url,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '$expiry • ${link.fileVersion?.name ?? _fileVersion}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: S.of(context)!.copyToClipboard,
                              icon: const Icon(Icons.copy),
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: url),
                                );
                                if (context.mounted) {
                                  showSnackBar(
                                    context,
                                    S.of(context)!.linkCopiedToClipboard,
                                  );
                                }
                              },
                            ),
                            MutationBuilder(
                              mutation: context.documentRepository
                                  .deleteShareLinkMutation(widget.documentId),
                              builder: (context, delState, deleteLink) {
                                return IconButton(
                                  tooltip: S.of(context)!.delete,
                                  icon: delState.isLoading
                                      ? IconLoadingWidget()
                                      : const Icon(Icons.delete),
                                  onPressed: () => deleteLink(link.id),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  DropdownButton<int?>(
                    value: _expiryDays,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('1d')),
                      DropdownMenuItem(value: 7, child: Text('7d')),
                      DropdownMenuItem(value: 30, child: Text('30d')),
                      DropdownMenuItem(value: null, child: Text('Never')),
                    ],
                    onChanged: (v) => setState(() => _expiryDays = v),
                  ),
                  const SizedBox(width: 12),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'archive',
                        label: Text('Archive'),
                      ),
                      ButtonSegment(
                        value: 'original',
                        label: Text('Original'),
                      ),
                    ],
                    selected: {_fileVersion},
                    showSelectedIcon: false,
                    onSelectionChanged: (s) =>
                        setState(() => _fileVersion = s.first),
                  ),
                  const Spacer(),
                  MutationBuilder(
                    mutation: context.documentRepository
                        .createShareLinkMutation(widget.documentId),
                    builder: (context, createState, createLink) {
                      return FilledButton.icon(
                        icon: createState.isLoading
                            ? IconLoadingWidget()
                            : const Icon(Icons.add_link),
                        label: Text(S.of(context)!.create),
                        onPressed: createState.isLoading
                            ? null
                            : () async {
                                final expiration = _expiryDays == null
                                    ? null
                                    : DateTime.now().add(
                                        Duration(days: _expiryDays!),
                                      );
                                try {
                                  final result = await createLink({
                                    'fileVersion': _fileVersion,
                                    'expiration': expiration,
                                  });
                                  if (!context.mounted) return;
                                  final slug = result.data?.slug ?? '';
                                  if (slug.isNotEmpty) {
                                    final url = buildPublicShareUrl(
                                      serverUrl,
                                      slug,
                                    );
                                    await Clipboard.setData(
                                      ClipboardData(text: url),
                                    );
                                    if (!context.mounted) return;
                                    showSnackBar(
                                      context,
                                      S.of(context)!.linkCopiedToClipboard,
                                    );
                                  }
                                } catch (error) {
                                  if (context.mounted) {
                                    showGenericError(context, error);
                                  }
                                }
                              },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
