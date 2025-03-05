import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'face_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ID Card Scanner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const FaceScanner(),
    );
  }
}

class IdCardScanner extends StatefulWidget {
  const IdCardScanner({super.key});
  @override
  State<IdCardScanner> createState() => _IdCardScannerState();
}

class _IdCardScannerState extends State<IdCardScanner> {
  String _nid = '';
  String _fullName = '';
  String _dob = '';
  bool _isScanning = false;
  final ImagePicker _picker = ImagePicker();

  /// 1. Request camera and storage permissions.
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

  /// 2. Capture an image using the device camera.
  Future<XFile?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    return image;
  }

  /// 3. Extract text from the image using Google ML Kit.
  Future<String> extractText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textDetector.processImage(
      inputImage,
    );
    textDetector.close();

    // Combine all recognized lines into a single string
    String text = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        text += line.text + '\n';
      }
    }
    return text;
  }

  /// 4. Extract the NID from the OCR text using a regular expression.
  String getNID(String extractedText) {
    // Adjust this pattern to match the expected format of the Jordanian NID.
    RegExp nidRegex = RegExp(r'\d{10}');
    RegExpMatch? match = nidRegex.firstMatch(extractedText);
    if (match != null) {
      return match.group(0)!;
    }
    return "NID not found";
  }

  /// 5. Extract the full name from the OCR text.
  ///    Adjust logic if your ID uses Arabic or a different label (e.g. "اسم:").
  String getFullName(String extractedText) {
    // Simple example: look for a line that starts with "Name:"
    // Then capture everything after "Name:" until the end of that line.
    // This might need to be refined based on actual ID layout.
    RegExp nameRegex = RegExp(r'^Name:\s*(.+)$', multiLine: true);
    RegExpMatch? match = nameRegex.firstMatch(extractedText);
    if (match != null) {
      return match.group(1)?.trim() ?? "Name not found";
    }
    return "Name not found";
  }

  /// 6. Extract the date of birth from the OCR text.
  ///    For example, searching for DD/MM/YYYY. Adjust if your ID uses another format (e.g., YYYY-MM-DD).
  String getDOB(String extractedText) {
    // This regex captures patterns like 02/01/1987
    RegExp dobRegex = RegExp(r'\b\d{2}/\d{2}/\d{4}\b');
    RegExpMatch? match = dobRegex.firstMatch(extractedText);
    if (match != null) {
      return match.group(0)!;
    }
    return "DOB not found";
  }

  /// 7. Main function to scan the ID card.
  Future<void> scanId() async {
    setState(() {
      _isScanning = true;
      _nid = '';
      _fullName = '';
      _dob = '';
    });

    await requestPermissions();
    final XFile? image = await pickImage();
    if (image != null) {
      try {
        String extractedText = await extractText(image);
        String nid = getNID(extractedText);
        String name = getFullName(extractedText);
        String dob = getDOB(extractedText);

        setState(() {
          _nid = nid;
          _fullName = name;
          _dob = dob;
        });
      } catch (e) {
        setState(() {
          _nid = "Error scanning ID";
          _fullName = "Error scanning Name";
          _dob = "Error scanning DOB";
        });
      }
    }
    setState(() {
      _isScanning = false;
    });
  }

  /// 8. Build the UI
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
              const SizedBox(height: 10),
              Text("Name: $_fullName", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text("DOB: $_dob", style: const TextStyle(fontSize: 20)),
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
