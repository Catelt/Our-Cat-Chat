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

  @override
  Future<MResult<XMessage>> sendMessageWithImage(
      {required List<MContent> contents}) async {
    try {
      final body = MGeminiRequest(contents: contents);
      final response = await http.post(
          url: "v1beta/models/gemini-pro-vision:generateContent",
          body: body.toJson());
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

  @override
  Future<MResult<bool>> sendMessageStream(
      {required List<MContent> contents,
      required void Function(String) snapshot}) async {
    try {
      final body = MGeminiRequest(contents: contents);
      final uri = Uri.https(
          ApiConstant.domain,
          "v1beta/models/gemini-pro:streamGenerateContent",
          {'key': ApiConstant.key});
      var request = Request('Post', uri);
      request.body = body.toJson();
      var streamedResponse = await request.send();
      var text = '';

      await for (var chunk in streamedResponse.stream.transform(utf8.decoder)) {
        final index = chunk.indexOf("\"text\":");
        if (index < 0) continue;
        final indexEnd = chunk.substring(index).indexOf("}");
        final start = index + 8;
        final end = index + indexEnd;
        if (start <= end) {
          final split = chunk
              .substring(start, end)
              .trim()
              .replaceAll("\"", "")
              .replaceAll("\\n", "\n");
          text += split;
          snapshot.call(text);
        }
      }

      return MResult.success(true);
    } catch (e) {
      return MResult.error(e.toString());
    }
  }
}
