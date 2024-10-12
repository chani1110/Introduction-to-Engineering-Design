import 'dart:convert' as convert; import 'dart:convert'; import 'package:http/http.dart' as http; import 'package:html/parser.dart' show parse;

Future<List<Map<String, String>>> NaverBlisgo(List<String> objects) async {
  String clientId = "CLIENTID ERASED"; String clientSecret = "CLIENTSECRET ERASED"; String firstTitle = ''; print(objects);

  final headers = {'X-Naver-Client-Id': clientId, 'X-Naver-Client-Secret': clientSecret};
  List<String> links = []; int index = 0;

  for (String query in objects) {
    final urlencyc = Uri.parse('https://openapi.naver.com/v1/search/encyc?query=$query&display=10&wt=json');
    var response1 = await http.get(urlencyc, headers: headers);

    while (true) {
      if (response1.statusCode == 200) {
        final jsonData = convert.jsonDecode(response1.body) as Map<String, dynamic>;
        final items = jsonData['items'] as List<dynamic>;
        if (items.isNotEmpty) {
          try {
            print(items); firstTitle = items[index]['title']; print(firstTitle + '132');
          } catch (e) {
            print('Index out of range: $e'); break;
          }
        } else {
          print('HTTP request failed: ${response1.statusCode}'); return [];
        }
      }
      List<String> A = ['회중시계', '월릿', '한국의 지질노두 용어해설', 'hat', '포스트']; List<String> B = ['손목시계', '지갑', '선풍기', '모자', '헤드셋'];
      for (int i = 0; i < A.length; i++) {
        if (firstTitle.contains(A[i]) || firstTitle == A[i]) {
          firstTitle = B[i];
        }
      }

      String blisgoquery = firstTitle + " site:blisgo.com";
      final urlwebkr = Uri.parse('https://openapi.naver.com/v1/search/webkr?query=$blisgoquery');
      var response2 = await http.get(urlwebkr, headers: headers);

      if (response2.statusCode == 200) {
        var data = jsonDecode(response2.body); var results = data["items"];

        for (var result in results) {
          print(result); links.add(result["link"]);
        }
        if (results.isEmpty && index < 30) {
          index += 1; print(results.isEmpty); print(index);
        } else {
          index = 0; break;
        }
      } else {
        print("Failed to fetch data: ${response2.statusCode}"); return [];
      }
    }
  }
  if (links.isNotEmpty) {
    print(links); return await blisgoData_(links);
  } else {
    return [];
  }
}

Future<List<Map<String, String>>> blisgoData_(List<String> links) async {
  Map<String, String> selector = {
    'headtitle': 'div > div > section.elementor-section.elementor-top-section.elementor-element.elementor-element-93f7171.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-a832380 > div > div > div.elementor-element.elementor-element-ce0593b.elementor-widget.elementor-widget-heading > div > h2',
    'recyclable': 'div > div > section.elementor-section.elementor-top-section.elementor-element.elementor-element-93f7171.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-a832380 > div > div > div.elementor-element.elementor-element-0f60c2c.elementor-widget.elementor-widget-text-editor > div > div > p:nth-child(1)',
    'type': 'div > div > section.elementor-section.elementor-top-section.elementor-element.elementor-element-93f7171.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-a832380 > div > div > div.elementor-element.elementor-element-0f60c2c.elementor-widget.elementor-widget-text-editor > div > div > p:nth-child(2)',
    'howtoTA': 'div > div > section.elementor-section.elementor-top-section.elementor-element.elementor-element-93f7171.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-a832380 > div > div > div.elementor-element.elementor-element-be24fa5.elementor-widget.elementor-widget-text-editor > div > div',
    'notes': 'div > div > section.elementor-section.elementor-top-section.elementor-element.elementor-element-93f7171.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-a832380 > div > div > div.elementor-element.elementor-element-af31fdd.elementor-widget.elementor-widget-text-editor > div > div',
    'iscomu': ' div > div > div > div > section > div > div > div > div > div > div.elementor-element.elementor-element-0d133f1.elementor-widget.elementor-widget-heading > div > h3 > a',
    'comutitle': '#kboard-cross-link-document > div.kboard-document-wrap > div.kboard-title > h1',
    'comuQ': '#kboard-cross-link-document > div.kboard-document-wrap > div.kboard-content > div',
    'comuA': 'div > div.comments-list > ul > li > div.comments-list-content > p',
    'obimage': 'div > div > section.elementor-section.elementor-top-section.elementor-element.elementor-element-93f7171.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-3da76f5 > div > div > div.elementor-element.elementor-element-75055fc.elementor-widget.elementor-widget-image > div > div > img'
  };
  List<Map<String, String>> resultList = [];
  for (String link in links) {
    try {
      final response = await http.get(Uri.parse(link));
      if (response.statusCode == 200) {
        final document = parse(response.body);

        Map<String, String> result = {};
        for (var entry in selector.entries) {
          var key = entry.key; var cssSelector = entry.value; var selectedElement = document.querySelector(cssSelector); var selectedText = selectedElement?.text;
          if (key == 'obimage') {
            selectedText = selectedElement?.attributes['src'];
          }
          result[key] = selectedText ?? '';
        }

        if (result['iscomu'] == '에코라이프 클럽') {
          resultList.add({'iscomu': result['iscomu']!, 'comutitle': result['comutitle']!, 'comuQ': result['comuQ']!, 'comuA': result['comuA']!});
        } else {
          resultList.add({'headtitle': result['headtitle']!, 'recyclable': result['recyclable']!, 'type': result['type']!, 'howtoTA': result['howtoTA']!, 'notes': result['notes']!, 'obimage': result['obimage']!});
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Failed to fetch data: $e'); return [];
    }
  }
  print(resultList);
  return resultList;
}
