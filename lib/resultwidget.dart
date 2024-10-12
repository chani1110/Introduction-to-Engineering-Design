import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'moreimage.dart' as mi;

class ResultWidget extends StatefulWidget {
  String headtitle;
  String link;
  String recyclable;String type;
  String howtoTA;
  String notes;
  String iscomu;
  String comutitle;
  String comuQ;
  String comuA;
  File? image;
  String obimage;
  List<String> otherobj;

  ResultWidget({
    required this.headtitle,
    required this.link,
    required this.recyclable,
    required this.type,
    required this.howtoTA,
    required this.notes,
    required this.iscomu,
    required this.comutitle,
    required this.comuQ,
    required this.comuA,
    required this.image,
    required this.obimage,
    required this.otherobj,
  });

  @override
  _ResultWidgetState createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  bool _showScrollViews = false;
  List<Map<String, String>> _moreinfo = [];

  @override
  void initState() {
    super.initState();
    _sendOtherObjToNaverBlisgo(widget.otherobj.map((obj) => obj.toString()).toList());
  }

  Future<void> _sendOtherObjToNaverBlisgo(List<String> otherObj) async {
    List<Map<String, String>> moreinfo = await mi.NaverBlisgo(widget.otherobj.map((obj) => obj.toString()).toList());;
    setState(() {
      _moreinfo = moreinfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.headtitle.isNotEmpty ? widget.headtitle : widget.comutitle),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._buildChildren(context),
            if (!_showScrollViews)
              TextButton(
                onPressed: () {
                  setState(() {
                    _showScrollViews = true;
                  });
                },
                child: Text('원하는 결과가 없나요?'),
              ),
            if (_showScrollViews) ...[
              _buildHorizontalScrollView(),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    return widget.iscomu.isEmpty
        ? [
      _buildImageCard(),
      _buildInfoRow('물건 이름', widget.headtitle, Icons.label),
      _buildInfoRow('분류', _getValueAfterColon(widget.type), Icons.category),
      _buildInfoRow('재활용 여부', _getValueAfterColon(widget.recyclable), Icons.recycling),
      _buildInfoRow('버리는 방법', _removeLeadingWhitespaceAndSpecialString(widget.howtoTA), Icons.info_outline),
      _buildInfoRow('참고', widget.notes, Icons.note),
      _buildLinkRow(context, '자세한 설명', widget.link),
    ]
        : [
      _buildImageCard(),
      const Text(
        '커뮤니티',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 76, 196, 134),
        ),
      ),
      SizedBox(height: 8),
      _buildInfoRow('제목', _removeLeadingWhitespaceAndSpecialString(widget.comutitle), Icons.title),
      _buildInfoRow('질문', _removeLeadingWhitespaceAndSpecialString(widget.comuQ), Icons.question_answer_outlined),
      _buildInfoRow('답변', _removeLeadingWhitespaceAndSpecialString(widget.comuA), Icons.question_answer_rounded),
      _buildLinkRow(context, '자세한 설명', widget.link),
    ];
  }

  Widget _buildImageCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          widget.image != null
              ? Image.file(widget.image!, width: 130, height: 130, fit: BoxFit.cover)
              : Icon(Icons.image, size: 50, color: Colors.teal),
          SizedBox(width: 16),
          widget.iscomu.isEmpty
              ? Image.network(widget.obimage, width: 130, height: 130, fit: BoxFit.cover)
              : Container(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color.fromARGB(255, 76, 196, 134)),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(255, 76, 196, 134),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkRow(BuildContext context, String label, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.link, color: Color.fromARGB(255, 76, 196, 134)),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(255, 76, 196, 134),
                  ),
                ),
                SizedBox(height: 4),
                InkWell(
                  onTap: () async {
                    try {
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        throw 'Could not launch $url';
                      }
                    } catch (e) {
                      print("Error launching URL: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Could not launch $url'),
                        ),
                      );
                    }
                  },
                  child: Text(
                    url,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalScrollView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _moreinfo.map((info) {
          return GestureDetector(
            onTap: () {
              setState(() {
                // 정보 업데이트 코드 작성
                  widget.headtitle = info['headtitle'] ?? '';
                  widget.comutitle = info['comutitle'] ?? '';
                  widget.comuQ = info['comuQ'] ?? '';
                  widget.comuA = info['comuA'] ?? '';
                  widget.iscomu = info['iscomu']?? '';
                  widget.recyclable = info['recyclable'] ?? '';
                  widget.type = info['type'] ?? '';
                  widget.howtoTA = info['howtoTA'] ?? '';
                  widget.notes = info['notes'] ?? '';
                  widget.obimage = info['obimage'] ?? '';
              });
              // _buildChildren 함수 호출하여 위젯 다시 생성
            },
            child: _buildContainer(info),
          );
        }).toList(),
      ),
    );
  }





  Widget _buildContainer(Map<String, String> info) {
    if (info.containsKey('iscomu')) {
      return _buildCommunityContainer(info);
    } else if (info.containsKey('obimage')) {
      // 이미지 URL이 유효한지 확인
      String? imageUrl = info['obimage'];
      if (imageUrl != null && imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.isAbsolute == true) {
        return _buildImageContainer(info);
      } else {
        // 이미지 URL이 유효하지 않으면 빈 SizedBox 반환
        return SizedBox.shrink();
      }
    } else {
      return SizedBox.shrink();
    }
  }



  Widget _buildCommunityContainer(Map<String, String> info) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '커뮤니티',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            info['comutitle'] ?? '',
            style: TextStyle(
              color: Colors.black,
            ),
            overflow: TextOverflow.fade,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer(Map<String, String> info) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(
          info['obimage'] ?? '',
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }




  String _removeLeadingWhitespaceAndSpecialString(String originalString) {
    String modifiedString = originalString.trim();
    if (modifiedString.startsWith(RegExp(r'\s'))) {
      modifiedString = modifiedString.replaceFirst(RegExp(r'\s+'), '');
    }
    modifiedString = modifiedString.replaceAll(RegExp(r'\([^()]*→[^()]*\)'), '');
    return modifiedString;
  }

  String _getValueAfterColon(String originalInfo) {
    List<String> infoParts = originalInfo.split(':');
    if (infoParts.length > 1) {
      return infoParts[1].trim();
    }
    return '';
  }
}
