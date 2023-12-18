part of 'gemini_repository.dart';

class GeminiRepositoryImpl extends GeminiRepository {
  GeminiRepositoryImpl(this.http);
  final XHttp http;

  @override
  Future<MResult<XMessage>> sendMessage(
      {required List<MContent> contents}) async {
    try {
      final body = MGeminiRequest(contents: contents);
      final response = await http.post(body: body.toJson());
      if (response?.body != null) {
        final data = MGeminiResponse.fromJson(response!.body);
        if (data.candidates.isNotEmpty) {
          return MResult.success(
            XMessage(
              msg: data.candidates.first.content.parts.first.text,
              time: DateTime.now(),
              role: MRole.model,
            ),
          );
        }
      }
      return MResult.error(XHttp.unknown);
    } catch (e) {
      return MResult.error(e.toString());
    }
  }
}
