enum NotificationChannel {
  task("task_channel", "Paperless tasks"),
  documentDownload("document_download_channel", "Document downloads"),
  fileDownload("file_download_channel", "File downloads"),
  status("status_channel", "Status updates");

  final String id;
  final String name;

  const NotificationChannel(this.id, this.name);
}
