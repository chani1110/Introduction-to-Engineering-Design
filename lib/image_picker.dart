import 'dart:convert'; import 'dart:io'; import 'package:flutter/material.dart'; import 'package:connectivity_plus/connectivity_plus.dart'; import 'package:fluttertoast/fluttertoast.dart'; import 'package:image_picker/image_picker.dart'; import 'cloudvision.dart'; import 'naversearch.dart' as ns; import 'blisgosearch.dart' as bs; import 'loadingwidget.dart'; import 'resultwidget.dart';

class MyImagePicker extends StatefulWidget { @override _MyImagePickerState createState() => _MyImagePickerState(); }

class _MyImagePickerState extends State<MyImagePicker> {
  File? _image; String _result = ''; String _headtitle = ''; String _link = ''; String _recyclable = ''; String _type = ''; String _howtoTA = ''; String _notes = ''; String _iscomu = ''; String _comutitle = ''; String _comuQ = ''; String _comuA = ''; String _obimage = ''; final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      _headtitle = ''; _link = ''; _recyclable = ''; _type = ''; _howtoTA = ''; _notes = ''; _iscomu = ''; _comutitle = ''; _comuQ = ''; _comuA = ''; _obimage = '';
      if (pickedFile != null) {
        _image = File(pickedFile.path); Navigator.push(context, MaterialPageRoute(builder: (context) => LoadingScreen())); analyzeImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future analyzeImage() async {
    if (_image == null) return;
    final bytes = await _image!.readAsBytes(); final base64Image = base64Encode(bytes);
    List<String> result = await CloudVision.analyzeImage(base64Image);
    if (result.isNotEmpty) {
      setState(() { _result = result[0]; });
      Map<String, String> searchResult = await ns.searchNaver(_result, 0);
      if (searchResult.isNotEmpty) {
        setState(() { _link = searchResult['link']!; });
        if (_link.isNotEmpty) {
          Map<String, String> blisgoResult = await bs.blisgoData(_link);
          if (blisgoResult.isNotEmpty) {
            setState(() {
              if (blisgoResult.containsKey('iscomu')) {
                _iscomu = blisgoResult['iscomu']!; _comutitle = blisgoResult['comutitle']!; _comuQ = blisgoResult['comuQ']!; _comuA = blisgoResult['comuA']!;
              } else {
                _headtitle = blisgoResult['headtitle']!; _recyclable = blisgoResult['recyclable']!; _type = blisgoResult['type']!; _howtoTA = blisgoResult['howtoTA']!; _notes = blisgoResult['notes']!; _obimage = blisgoResult['obimage']!;
              }
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultWidget(headtitle: _headtitle, link: _link, recyclable: _recyclable, type: _type, howtoTA: _howtoTA, notes: _notes, iscomu: _iscomu, comutitle: _comutitle, comuQ: _comuQ, comuA: _comuA, image: _image, obimage: _obimage, otherobj: result)));
          }
        }
      } else {
        Navigator.pop(context); Fluttertoast.showToast(msg: '검색 결과가 없습니다.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      }
    } else {
      Navigator.pop(context); Fluttertoast.showToast(msg: '이미지에 객체가 없습니다.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    }
  }

  Future _checkInternetAndSelectImage(ImageSource source) async {
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity(); var connectivityResultLast = connectivityResult.last;
    if (connectivityResultLast == ConnectivityResult.wifi || connectivityResultLast == ConnectivityResult.mobile) {
      getImage(source);
    } else {
      Fluttertoast.showToast(msg: '인터넷 연결이 필요합니다.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(255, 76, 196, 134), Colors.white], stops: [0.7, 1.0])),
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color.fromARGB(255, 76, 196, 134), Colors.white], stops: [0.5, 1.0])),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 20),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('이미지 인식', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.05, color: Colors.yellow, fontWeight: FontWeight.bold)),
                          Text('분리배출 어플리케이션', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03, color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          onPressed: () { _checkInternetAndSelectImage(ImageSource.camera); },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 76, 230, 134), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.camera_alt, size: 50, color: Colors.white),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('카메라', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(height: 5),
                                  Text('버릴 물건의 사진을 찍으세요.', style: TextStyle(fontSize: 13, color: Colors.white)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          onPressed: () { _checkInternetAndSelectImage(ImageSource.gallery); },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 76, 230, 134), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.image, size: 50, color: Colors.white),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('갤러리', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(height: 5),
                                  Text('버릴 물건의 사진을 선택하세요.', style: TextStyle(fontSize: 13, color: Colors.white)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
