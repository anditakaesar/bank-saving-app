class CommonResponse {
  String? message;

  CommonResponse({required message});

  factory CommonResponse.fromJson(Map<String, dynamic> json) {
    return CommonResponse(message: json['message']);
  }
}
