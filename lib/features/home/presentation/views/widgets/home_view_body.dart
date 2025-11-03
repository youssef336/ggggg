import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:test/core/widgets/custom_buttom.dart';
import 'package:test/core/ml/food_quality_model.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final FoodQualityModel _model = FoodQualityModel();
  String _result = "No prediction yet";

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    await _model.loadModel();
  }

  Future<List<double>> _preprocessImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return [];

    // Load image bytes
    final bytes = await picked.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    // Resize to 128x128
    img.Image resized = img.copyResize(image!, width: 128, height: 128);

    // Normalize pixels to [0,1]
    List<double> input = [];
    for (int y = 0; y < 128; y++) {
      for (int x = 0; x < 128; x++) {
        final pixel = resized.getPixel(x, y);
        input.add(pixel.r / 255.0); // Red
        input.add(pixel.g / 255.0); // Green
        input.add(pixel.b / 255.0); // Blue
      }
    }
    return input;
  }

  void _runPrediction() async {
    List<double> input = await _preprocessImage();
    if (input.isEmpty) return;

    var prediction = _model.predict(input);
    setState(() {
      _result = prediction[0] > 0.5 ? "Fresh" : "Spoiled";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButtom(text: 'Add Product', onPressed: _runPrediction),
          const SizedBox(height: 20),
          Text(
            _result,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
