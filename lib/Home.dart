import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  late bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    loadModel().then((value){
      setState(() {

      });
    });
  }

  Future<void> detectImage(File image) async {
    setState(() {
      _loading = true; // Show the progress bar when detection starts
    });

    var output = await Tflite.runModelOnImage(
      path: image.path, // Use the provided image path
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _output = output!;
      _loading = false; // Hide the progress bar after detection is complete
    });
  }
  loadModel() async{
    await Tflite.loadModel(
        model: 'assets/tflite/model_unquant.tflite',
        labels:'assets/tflite/labels.txt' );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  pickImage() async{
    var image  = await picker.pickImage(source: ImageSource.camera);
    if(image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image);
   }
  pickGallleryImage() async{
    var image  = await picker.pickImage(source: ImageSource.gallery);
    if(image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50),
            const Text('Va Mamey',
            style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20),
            ),
            const SizedBox(height: 50),
            const Text('Cats And Dogs Detector',style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 30)
            ),
            const SizedBox(height: 50),
            Center(child: _loading? Container(
              width: 250,
              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/react.png'),
                  const SizedBox(height: 50),
                ],
              ),
            ):Container(
              child: Column(children: <Widget>[
                Container(
                  height: 250,
                  child: Image.file(_image),
                ),
                const SizedBox(height: 20),
                _output != null ?  Text(
                    '${_output[0]['label']}',
                    style: const TextStyle(
                        color: Colors.black, fontSize: 15
                    )
                ):Container(),
                const SizedBox(height: 10),
              ],)

            )),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                GestureDetector(
                  onTap:(){
                    pickGallleryImage();
                  } ,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 200,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Text(
                      'Capture a Photo',
                    style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold)),
                  ),
                ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap:(){
                      pickImage();
                    } ,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 200,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 18),
                      decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Text(
                        'Select a Photo',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
