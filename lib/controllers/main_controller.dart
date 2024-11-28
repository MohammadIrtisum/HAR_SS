import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MainController extends GetxController {
  // State Variables
  var isRecording = false.obs;
  var selectedLabel = 'Choose label'.obs;
  var refreshRate = 'Normal'.obs;
  var status = 'Idle'.obs;

  // Sensor Data
  var accelerometerData = <String>[].obs;
  var gyroscopeData = <String>[].obs;
  var linearAccelerationData = <String>[].obs;

  // Labels
  var labels = ['Running', 'Standing', 'Sitting', 'Walking'].obs;

  late StreamSubscription accelerometerStream;
  late StreamSubscription gyroscopeStream;
  late StreamSubscription userAccelerationStream;

  @override
  void onInit() {
    super.onInit();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  void startRecording() {
    if (selectedLabel.value == 'Choose label') {
      Get.snackbar('Error', 'Please select a label to start recording!');
      return;
    }

    isRecording.value = true;
    status.value = "Recording...";

    accelerometerStream = accelerometerEvents.listen((event) {
      accelerometerData.value = [
        'X: ${event.x.toStringAsFixed(2)}',
        'Y: ${event.y.toStringAsFixed(2)}',
        'Z: ${event.z.toStringAsFixed(2)}'
      ];
    });

    gyroscopeStream = gyroscopeEvents.listen((event) {
      gyroscopeData.value = [
        'X: ${event.x.toStringAsFixed(2)}',
        'Y: ${event.y.toStringAsFixed(2)}',
        'Z: ${event.z.toStringAsFixed(2)}'
      ];
    });

    userAccelerationStream = userAccelerometerEvents.listen((event) {
      linearAccelerationData.value = [
        'X: ${event.x.toStringAsFixed(2)}',
        'Y: ${event.y.toStringAsFixed(2)}',
        'Z: ${event.z.toStringAsFixed(2)}'
      ];
    });
  }

  void stopRecording() {
    isRecording.value = false;
    status.value = "Stopped";

    accelerometerStream.cancel();
    gyroscopeStream.cancel();
    userAccelerationStream.cancel();

    saveDataToStorage();
  }

  Future<void> saveDataToStorage() async {
    print("Accelerometer Data: $accelerometerData");
    print("Gyroscope Data: $gyroscopeData");
    print("Linear Acceleration Data: $linearAccelerationData");
  }

  void adjustRefreshRate(String rate) {
    refreshRate.value = rate;
    // Adjust refresh rate logic if needed
  }
}
