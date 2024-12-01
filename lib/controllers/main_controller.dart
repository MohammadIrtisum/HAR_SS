import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
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

  var labels = ['Running', 'Standing', 'Sitting', 'Walking'].obs;

  late StreamSubscription accelerometerStream;
  late StreamSubscription gyroscopeStream;
  late StreamSubscription userAccelerationStream;

  List<List<dynamic>> recordedData = []; // Store data for CSV

  @override
  void onInit() {
    super.onInit();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    if (await Permission.storage.isDenied || await Permission.manageExternalStorage.isDenied) {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }
  }

  void startRecording() {
    if (selectedLabel.value == 'Choose label') {
      Get.snackbar('Error', 'Please select a label to start recording!');
      return;
    }

    isRecording.value = true;
    status.value = "Recording...";

    // Add headers to the CSV data
    recordedData.add([
      'acc_x', 'acc_y', 'acc_z',
      'gyro_x', 'gyro_y', 'gyro_z',
      'la_x', 'la_y', 'la_z',
      'Activity'
    ]);

    // Start streaming sensor data
    accelerometerStream = accelerometerEvents.listen((event) {
      accelerometerData.value = [
        event.x.toString(),
        event.y.toString(),
        event.z.toString(),
      ];
    });

    gyroscopeStream = gyroscopeEvents.listen((event) {
      gyroscopeData.value = [
        event.x.toString(),
        event.y.toString(),
        event.z.toString(),
      ];
    });

    userAccelerationStream = userAccelerometerEvents.listen((event) {
      linearAccelerationData.value = [
        event.x.toString(),
        event.y.toString(),
        event.z.toString(),
      ];
    });

    // Periodically collect sensor data
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!isRecording.value) {
        timer.cancel();
        return;
      }

      recordedData.add([
        accelerometerData.value[0],
        accelerometerData.value[1],
        accelerometerData.value[2],
        gyroscopeData.value[0],
        gyroscopeData.value[1],
        gyroscopeData.value[2],
        linearAccelerationData.value[0],
        linearAccelerationData.value[1],
        linearAccelerationData.value[2],
        selectedLabel.value,
      ]);
    });
  }

  void stopRecording() {
    isRecording.value = false;
    status.value = "Stopped";

    // Stop the sensor streams
    accelerometerStream.cancel();
    gyroscopeStream.cancel();
    userAccelerationStream.cancel();

    // Save the recorded data to CSV file
    saveDataToCSV();
  }

  Future<void> saveDataToCSV() async {
    try {
      // Request storage permissions
      if (await Permission.storage.isDenied || await Permission.manageExternalStorage.isDenied) {
        await Permission.storage.request();
        await Permission.manageExternalStorage.request();
      }

      // Use the public Downloads directory
      final directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        throw Exception('Downloads directory does not exist');
      }

      // Create a unique file name
      final filePath = "${directory.path}/sensor_data_${DateTime.now().millisecondsSinceEpoch}.csv";

      // Convert `recordedData` to CSV format
      String csvData = const ListToCsvConverter().convert(recordedData);

      // Write data to the file
      final file = File(filePath);
      await file.writeAsString(csvData);

      // Notify success
      Get.snackbar('Success', 'File saved to: $filePath');
    } catch (e) {
      // Notify error
      Get.snackbar('Error', 'Failed to save file: $e');
    } finally {
      // Clear data after saving (optional)
      recordedData.clear();
    }
  }

  void adjustRefreshRate(String rate) {
    refreshRate.value = rate;
    print("Refresh rate adjusted to: $rate");
  }
}
