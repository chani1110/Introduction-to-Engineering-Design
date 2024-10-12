import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudVision {
  static Future<List<String>> analyzeImage(String base64Image) async {
    try {
      final endpoint = Uri.parse(
          'https://vision.googleapis.com/v1/images:annotate?key=API_KEY_ERASED');

      final response = await http.post(
        endpoint,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "requests": [
            {
              "image": {"content": base64Image},
              "features": [
                {"type": "OBJECT_LOCALIZATION", "maxResults": 3}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final objects = decodedResponse['responses'][0]['localizedObjectAnnotations'];
        if (objects != null) {
          final List<String> result = objects.map<String>((object) => object['name'].toString()).toList();
          print("---------------------"+result.toString());
          print(decodedResponse['responses']);
          return result;
        } else {
          // 클라우드 비전에서 결과가 없는 경우
          print('Cloud Vision did not return any results.');
          return []; // 빈 리스트 반환
        }
      } else {
        // HTTP 요청이 실패한 경우
        print('Failed to analyze image. Status Code: ${response.statusCode}');
        print('Error message: ${response.body}');
        return []; // 빈 리스트 반환
      }
    } catch (e) {
      // 분석 중에 예외가 발생한 경우
      print('Error analyzing image: $e');
      return []; // 빈 리스트 반환
    }
  }
}