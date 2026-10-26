String trimServerUrl(String serverUrl) =>
    serverUrl.replaceFirst(RegExp(r'/+$'), '');

String buildDetailsUrl(String serverUrl, int documentId) =>
    '${trimServerUrl(serverUrl)}/documents/$documentId/';

String buildPreviewUrl(String serverUrl, int documentId) =>
    '${trimServerUrl(serverUrl)}/api/documents/$documentId/preview/';

String buildPublicShareUrl(String serverUrl, String slug) =>
    '${trimServerUrl(serverUrl)}/share/$slug';
