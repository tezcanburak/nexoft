class ApiResult<T> {
  final T? data;
  final int? status;
  final List<String>? messages;
  final bool success;

  ApiResult({
    this.data,
    this.status,
    this.messages,
    required this.success,
  });

  factory ApiResult.fromJson(dynamic json, T Function(dynamic) fromJson) {
    final jsonData = json['data'];
    T? parsedData;

    if (jsonData != null) {
      parsedData = fromJson(jsonData);
    }

    return ApiResult<T>(
      data: parsedData,
      status: json['status'] as int?,
      messages: (json['messages'] as List<dynamic>?)?.map((json) => json as String).toList() ?? [],
      success: json['success'] as bool,
    );
  }
}
