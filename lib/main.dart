import 'dart:io';
import 'dart:typed_data';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qonvex_signature_pad/qonvex_signature_pad.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-SIGNATURE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<QonvexSignaturePadState> _k =
      GlobalKey<QonvexSignaturePadState>();

  void clear() {
    _k.currentState!.clearPoints();
  }

  void extract() async {
    final Uint8List? ff = await _k.currentState!.toBytes;
    if (ff != null) {
      final String name = "${DateTime.now().microsecondsSinceEpoch}";
      final result = await ImageGallerySaver.saveImage(
        ff,
        name: name,
      );
      if (result['isSuccess']) {
        print("SUCCESS!");
        print(result);
      }
      // final directory = await AndroidPathProvider.downloadsPath;
      // final imagePath =
      //     await File('$directory/${DateTime.now().microsecondsSinceEpoch}.png')
      //         .create();
      // await imagePath.writeAsBytes(ff);

      // await Share
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: QonvexSignaturePad(
        key: _k,
        // signatureColor: Colors.red,
        renderWithBackground: true,
      ),
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),

      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       // const Text(
      //       //   'You have pushed the button this many times:',
      //       // ),
      //       // Text(
      //       //   '$_counter',
      //       //   style: Theme.of(context).textTheme.headline4,
      //       // ),
      //     ],
      //   ),
      // ),
      floatingActionButton: SafeArea(
          child: SizedBox(
        width: double.maxFinite,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                clear();
              },
              tooltip: 'Clear',
              child: const Icon(Icons.clear),
            ),
            const SizedBox(
              width: 20,
            ),
            FloatingActionButton(
              onPressed: () {
                extract();
              },
              tooltip: 'Extract',
              child: const Icon(Icons.save),
            ),
          ],
        ),
      )),
    );
  }
}
