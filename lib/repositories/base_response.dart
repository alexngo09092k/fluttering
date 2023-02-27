class BaseResponse<T> {
  final bool status;
  final String? message;
  final T? data;

  BaseResponse({
    this.status = false,
    this.message,
    this.data,
  });
}
