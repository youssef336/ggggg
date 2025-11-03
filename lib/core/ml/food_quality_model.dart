import 'package:tflite_flutter/tflite_flutter.dart';

class FoodQualityModel {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('food_quality_model.tflite');
    print("Model loaded successfully!");
  }

  List<double> predict(List<double> input) {
    // Input shape: [1, 128, 128, 3]
    var inputTensor = [input];
    var output = List.filled(1, 0).reshape([1, 1]);

    _interpreter.run(inputTensor, output);
    return output[0];
  }
}
