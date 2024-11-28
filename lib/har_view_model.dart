import 'package:flutter/material.dart';
import 'package:sensor_recorder/sensor_data_model.dart';


class HARViewModel with ChangeNotifier {
  final SensorDataModel _sensorDataModel = SensorDataModel();
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  // Start recording sensor data
  void startRecording() {
    _isRecording = true;
    notifyListeners();
  }

  // Stop recording sensor data
  void stopRecording() {
    _isRecording = false;
    notifyListeners();
  }

  // Add sensor data (mock data in this example)
  void addSensorData(String data) {
    _sensorDataModel.addData(data);
  }

  // Save sensor data to a file and return file path
  Future<String> saveDataToFile() async {
    return await _sensorDataModel.saveToFile();
  }
}
