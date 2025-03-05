import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class IdCardScanner extends StatefulWidget {
  const IdCardScanner({super.key});
  @override
  State<IdCardScanner> createState() => _IdCardScannerState();
}

class _IdCardScannerState extends State<IdCardScanner> {
  String _nid = '';
  bool _isScanning = false;
  final ImagePicker _picker = ImagePicker();

  // Request camera and storage permissions.
  Future<void> requestPermissions() async {
    var cameraStatus = await Permission.camera.request();
    var storageStatus = await Permission.storage.request();

    if (!cameraStatus.isGranted || !storageStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera or Storage permission not granted'),
        ),
      );
    }
  }

  // Capture an image using the device camera.
  Future<XFile?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    return image;
  }

  // Extract text from the image using Google ML Kit.
  Future<String> extractText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textDetector.processImage(
      inputImage,
    );
    String text = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        text += line.text + '\n';
      }
    }
    textDetector.close();
    return text;
  }

  // Extract the NID from the OCR text using a regular expression.
  String getNID(String extractedText) {
    // Adjust this pattern to match the expected format of the Jordanian NID.
    RegExp nidRegex = RegExp(r'\d{10}');
    RegExpMatch? match = nidRegex.firstMatch(extractedText);
    if (match != null) {
      return match.group(0)!;
    }
    return "NID not found";
  }

  // Main function to scan the ID card.
  Future<void> scanId() async {
    setState(() {
      _isScanning = true;
      _nid = '';
    });
    await requestPermissions();
    final XFile? image = await pickImage();
    if (image != null) {
      try {
        String extractedText = await extractText(image);
        String nid = getNID(extractedText);
        setState(() {
          _nid = nid;
        });
      } catch (e) {
        setState(() {
          _nid = "Error scanning ID";
        });
      }
    }
    setState(() {
      _isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jordanian ID Scanner")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("NID: $_nid", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              _isScanning
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: scanId,
                    child: const Text("Scan ID"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}