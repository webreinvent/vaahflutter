class VaahPushEvent {
  const VaahPushEvent({
    required this.id,
    this.title,
    this.body,
    this.payload,
    this.actionId,
    this.actionUrl,
  });

  final String id;
  final String? title;
  final String? body;
  final Map<String, dynamic>? payload;
  final String? actionId;
  final String? actionUrl;
}
