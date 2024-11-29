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
        event.x.toStringAsFixed(2),
        event.y.toStringAsFixed(2),
        event.z.toStringAsFixed(2),
      ];
    });

    gyroscopeStream = gyroscopeEvents.listen((event) {
      gyroscopeData.value = [
        event.x.toStringAsFixed(2),
        event.y.toStringAsFixed(2),
        event.z.toStringAsFixed(2),
      ];
    });

    userAccelerationStream = userAccelerometerEvents.listen((event) {
      linearAccelerationData.value = [
        event.x.toStringAsFixed(2),
        event.y.toStringAsFixed(2),
        event.z.toStringAsFixed(2),
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
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/sensor_data.csv";

      // Convert the list to CSV format
      String csvData = const ListToCsvConverter().convert(recordedData);

      final file = File(filePath);
      await file.writeAsString(csvData);

      // Notify user of success
      Get.snackbar('Success', 'Data saved to $filePath');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save data: $e');
    } finally {
      // Clear the recorded data after saving
      recordedData.clear();
    }
  }

  void adjustRefreshRate(String rate) {
    refreshRate.value = rate;
    // Add logic here if you want to adjust the refresh rate of the sensor data
    print("Refresh rate adjusted to: $rate");
  }
}
