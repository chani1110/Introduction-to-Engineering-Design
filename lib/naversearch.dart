import 'dart:convert' as convert;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

Future<Map<String, String>> searchNaver(String query, int index) async {
  String clientId = "CLIENTID ERASED";
  String clientSecret = "CLIENTSECRET ERASED";
  String firstTitle = ''; // firstTitle 변수를 블록 외부에서 정의

  final urlencyc = Uri.parse(
      'https://openapi.naver.com/v1/search/encyc?query=$query&display=10&wt=json');

  final headers = {
    'X-Naver-Client-Id': clientId,
    'X-Naver-Client-Secret': clientSecret,
  };

  var response1 = await http.get(urlencyc, headers: headers);

  if (response1.statusCode == 200) {
    // JSON 형식의 응답 데이터 파싱
    final jsonData = convert.jsonDecode(response1.body) as Map<String, dynamic>;

    // 검색 결과 추출 (에러 처리 필요)
    final items = jsonData['items'] as List<dynamic>;
    if (items.isNotEmpty) {
      try {
        firstTitle = items[index]['title']; // firstTitle에 값 할당
      } catch (e) {
        print('Index out of range: $e');
        return {}; // 빈 맵 반환
      }
    } else {
      print('HTTP request failed: ${response1.statusCode}');
      return {}; // 빈 맵 반환
    }

  }
  List<String> A = ['회중시계', '월릿', '한국의 지질노두 용어해설', 'hat', '포스트'];
  List<String> B = ['손목시계', '지갑', '선풍기', '모자', '헤드셋'];
  for (int i = 0; i < A.length; i++) {
    if (firstTitle.contains(A[i]) || firstTitle == A[i]) {
      firstTitle = B[i];
    }
  }

  if ( firstTitle == "사람"){
    Fluttertoast.showToast(
      msg: '사람을 버릴 생각인가요?',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return {};
  }

  print(firstTitle+'asdfasdf');

  String blisgoquery = firstTitle + " site:blisgo.com";
  final urlwebkr =
      Uri.parse('https://openapi.naver.com/v1/search/webkr?query=$blisgoquery');

  var response2 = await http.get(urlwebkr, headers: headers);

  if (response2.statusCode == 200) {
    var data = jsonDecode(response2.body);
    var results = data["items"];

    for (var result in results) {
      print("Title: ${result["title"]}");
      print("Link: ${result["link"]}");
      print(""); // 공백 줄 추가
    }
    if (results.isEmpty && index < 30) {
      // 만약 results가 비어 있다면 다음 아이템을 시도
      return await searchNaver(query, index + 1);
    }

    return {'title': results[0]["title"], 'link': results[0]["link"]};
  } else {
    print("Failed to fetch data: ${response2.statusCode}");
    return {}; // 에러가 발생할 경우 빈 Map을 반환
  }
}
