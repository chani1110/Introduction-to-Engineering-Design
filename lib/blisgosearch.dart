import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

Future<Map<String, String>> blisgoData(String link) async {
  Map<String, String> selector = {
    'headtitle':
      'div > div > section.elementor-section.elementor-top-section.elementor-element.elementor-element-93f7171.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-a832380 > div > div > div.elementor-element.elementor-element-ce0593b.elementor-widget.elementor-widget-heading > div > h2',
    'recyclable':
      'div > div > section.elementor-section.elementor-top-section.elementor-element.elementor-element-93f7171.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-a832380 > div > div > div.elementor-element.elementor-element-0f60c2c.elementor-widget.elementor-widget-text-editor > div > div > p:nth-child(1)',
    'type':
      'div > div > section.elementor-section.elementor-top-section.elementor-element.elementor-element-93f7171.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-a832380 > div > div > div.elementor-element.elementor-element-0f60c2c.elementor-widget.elementor-widget-text-editor > div > div > p:nth-child(2)',
    'howtoTA':
      'div > div > section.elementor-section.elementor-top-section.elementor-element.elementor-element-93f7171.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-a832380 > div > div > div.elementor-element.elementor-element-be24fa5.elementor-widget.elementor-widget-text-editor > div > div',
    'notes':
      'div > div > section.elementor-section.elementor-top-section.elementor-element.elementor-element-93f7171.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-a832380 > div > div > div.elementor-element.elementor-element-af31fdd.elementor-widget.elementor-widget-text-editor > div > div',
    'iscomu':
      ' div > div > div > div > section > div > div > div > div > div > div.elementor-element.elementor-element-0d133f1.elementor-widget.elementor-widget-heading > div > h3 > a',
    'comutitle':
      '#kboard-cross-link-document > div.kboard-document-wrap > div.kboard-title > h1',
    'comuQ':
      '#kboard-cross-link-document > div.kboard-document-wrap > div.kboard-content > div',
    'comuA':
      'div > div.comments-list > ul > li > div.comments-list-content > p',
    'obimage':
        'div > div > section.elementor-section.elementor-top-section.elementor-element.elementor-element-93f7171.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-3da76f5 > div > div > div.elementor-element.elementor-element-75055fc.elementor-widget.elementor-widget-image > div > div > img'
  };

  try {
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      final document = parse(response.body);

      // 결과를 저장할 Map 초기화
      Map<String, String> result = {};

      for (var entry in selector.entries) {
        var key = entry.key;
        var cssSelector = entry.value;
        var selectedElement = document.querySelector(cssSelector);
        var selectedText = selectedElement?.text;

        if (key == 'obimage') {
          selectedText = selectedElement?.attributes['src'];
        }

        result[key] = selectedText ?? '';
      }

      // 'iscomu' 값에 따라 다른 데이터 반환
      if (result['iscomu'] == '에코라이프 클럽') {
        return {
          'iscomu': result['iscomu']!,
          'comutitle': result['comutitle']!,
          'comuQ': result['comuQ']!,
          'comuA': result['comuA']!,
        };
      } else {
        return {
          'headtitle' : result['headtitle']!,
          'recyclable': result['recyclable']!,
          'type': result['type']!,
          'howtoTA': result['howtoTA']!,
          'notes': result['notes']!,
          'obimage': result['obimage']!,
        };
      }
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Failed to fetch data: $e');
    return {};
  }
}
