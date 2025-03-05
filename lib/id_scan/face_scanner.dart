import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceScanner extends StatefulWidget {
  const FaceScanner({super.key});
  @override
  State<FaceScanner> createState() => _FaceScannerState();
}

class _FaceScannerState extends State<FaceScanner> {
  String _studentName = '';
  String _studentId = '';
  bool _isScanning = false;
  final ImagePicker _picker = ImagePicker();

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
      enableLandmarks: true,
    ),
  );

  String _capturedFeatures = '';

  final List<Map<String, dynamic>> _data = [
    {
      "st_name": "mohamed abdullah",
      "st_id": 1234567890,
      "face_features":
          "[0.31069609507640067, 0.40635451505016723, 0.6706281833616299, 0.3963210702341137, 0.46519524617996605, 0.6304347826086957, 0.11884550084889643, 0.5585284280936454, 0.8607809847198642, 0.5501672240802675, 0.3633276740237691, 0.7959866220735786, 0.6417657045840407, 0.7909698996655519, 0.3600762116551662]",
    },
    {
      "st_name": "hind khalid",
      "st_id": 1234567891,
      "face_features":
          "[0.308300395256917, 0.3908969210174029, 0.6798418972332015, 0.41633199464524767, 0.4598155467720685, 0.6131191432396251, 0.13438735177865613, 0.5394912985274432, 0.927536231884058, 0.6198125836680054, 0.308300395256917, 0.7376171352074966, 0.6284584980237155, 0.7603748326639893, 0.37238385528850626]",
    },
    {
      "st_name": "ahmed helmey",
      "st_id": 1234567892,
      "face_features":
          "[0.31515499425947185, 0.40932944606413996, 0.6538461538461539, 0.39300291545189503, 0.4965556831228473, 0.6256559766763848, 0.11021814006888633, 0.5854227405247814, 0.9138920780711826, 0.519533527696793, 0.3616532721010333, 0.7615160349854228, 0.6727898966704937, 0.7271137026239067, 0.3390723496565607]",
    },
    {
      "st_name": "baraa",
      "st_id": 1234567893,
      "face_features":
          "[0.3064275037369208, 0.4176470588235294, 0.6666666666666666, 0.4235294117647059, 0.4648729446935725, 0.6735294117647059, 0.1375186846038864, 0.5220588235294118, 0.922272047832586, 0.49411764705882355, 0.34379671150971597, 0.8014705882352942, 0.6517189835575485, 0.8058823529411765, 0.3602887783780906]",
    },
  ];

  Future<void> requestPermissions() async {
    var cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission not granted')),
      );
    }
  }

  Future<XFile?> pickImage() async {
    return await _picker.pickImage(source: ImageSource.camera);
  }

  Future<List<double>?> extractFaceFeatures(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final List<Face> faces = await _faceDetector.processImage(inputImage);

    if (faces.isNotEmpty) {
      final Face face = faces.first;
      final Rect boundingBox = face.boundingBox;
      List<double> features = [];

      final List<FaceLandmarkType> landmarkTypes = [
        FaceLandmarkType.leftEye,
        FaceLandmarkType.rightEye,
        FaceLandmarkType.noseBase,
        FaceLandmarkType.leftEar,
        FaceLandmarkType.rightEar,
        FaceLandmarkType.leftMouth,
        FaceLandmarkType.rightMouth,
      ];

      for (var type in landmarkTypes) {
        var landmark = face.landmarks[type];
        if (landmark != null) {
          double normX =
              (landmark.position.x - boundingBox.left) / boundingBox.width;
          double normY =
              (landmark.position.y - boundingBox.top) / boundingBox.height;
          features.add(normX);
          features.add(normY);
        } else {
          features.add(0.0);
          features.add(0.0);
        }
      }

      if (face.landmarks[FaceLandmarkType.leftEye] != null &&
          face.landmarks[FaceLandmarkType.rightEye] != null) {
        var leftEye = face.landmarks[FaceLandmarkType.leftEye]!;
        var rightEye = face.landmarks[FaceLandmarkType.rightEye]!;
        double eyeDistance = sqrt(
          pow(rightEye.position.x - leftEye.position.x, 2) +
              pow(rightEye.position.y - leftEye.position.y, 2),
        );
        double normEyeDistance = eyeDistance / boundingBox.width;
        features.add(normEyeDistance);
      }

      return features;
    }
    return null;
  }

  Future<void> captureMyFeatures() async {
    await requestPermissions();
    final image = await pickImage();
    if (image != null) {
      final features = await extractFaceFeatures(image);
      if (features != null && features.isNotEmpty) {
        setState(() {
          _capturedFeatures = jsonEncode(features);
        });
        print('My features: $features');
      } else {
        setState(() {
          _capturedFeatures = "No face detected";
        });
      }
    }
  }

  double calculateEuclideanDistance(
    List<double> features1,
    List<double> features2,
  ) {
    if (features1.length != features2.length) return double.infinity;
    double sum = 0;
    for (int i = 0; i < features1.length; i++) {
      sum += pow(features1[i] - features2[i], 2);
    }
    return sqrt(sum);
  }

  Map<String, dynamic>? findMatchingStudent(List<double> capturedFeatures) {
    const double threshold = 0.11; // Adjust as needed
    for (var student in _data) {
      List<dynamic> storedFeaturesDynamic = jsonDecode(
        student["face_features"],
      );
      List<double> storedFeatures =
          storedFeaturesDynamic.map((e) => (e as num).toDouble()).toList();
      double distance = calculateEuclideanDistance(
        capturedFeatures,
        storedFeatures,
      );
      print("Comparing with ${student["st_name"]} - distance: $distance");

      // Log the feature vectors for comparison
      print("Captured Features: $capturedFeatures");
      print("Stored Features: $storedFeatures");

      if (distance < threshold) {
        return student;
      }
    }
    return null;
  }

  Future<void> scanFace() async {
    setState(() {
      _isScanning = true;
    });

    await captureMyFeatures();

    if (_capturedFeatures != "No face detected" &&
        _capturedFeatures.isNotEmpty) {
      List<double> captured = [];
      try {
        List<dynamic> decoded = jsonDecode(_capturedFeatures);
        captured = decoded.map((e) => (e as num).toDouble()).toList();
      } catch (e) {
        print("Error decoding features: $e");
      }

      Map<String, dynamic>? student = findMatchingStudent(captured);
      if (student != null) {
        setState(() {
          _studentName = student["st_name"];
          _studentId = student["st_id"].toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No matching student found")),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No face detected")));
    }

    setState(() {
      _isScanning = false;
    });
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Face Scanner")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Name: $_studentName", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text("ID: $_studentId", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text(
                "Captured Features: $_capturedFeatures",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: captureMyFeatures,
                child: const Text("Capture My Features"),
              ),
              const SizedBox(height: 10),
              _isScanning
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: scanFace,
                    child: const Text("Scan Face"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}