class BaseModel<T> {
  final bool success;
  final String? message;
  final T? data;

  BaseModel({required this.success, this.message, this.data});

  factory BaseModel.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return BaseModel(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': data != null ? toJsonT(data as T) : null,
    };
  }
}
