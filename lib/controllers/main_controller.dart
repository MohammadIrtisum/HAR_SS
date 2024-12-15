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
  var isPhoneReadyForRecording = false.obs;
  var missingSensors = <String>[].obs;

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
    checkSensors();
  }

  Future<void> checkSensors() async {
    missingSensors.clear();

    // Check Accelerometer
    bool accelerometerAvailable = await _isSensorAvailable(accelerometerEventStream());
    if (!accelerometerAvailable) missingSensors.add('Accelerometer');

    // Check Gyroscope
    bool gyroscopeAvailable = await _isSensorAvailable(gyroscopeEventStream());
    if (!gyroscopeAvailable) missingSensors.add('Gyroscope');

    // Check Linear Acceleration
    bool userAccelerometerAvailable =
    await _isSensorAvailable(userAccelerometerEventStream());
    if (!userAccelerometerAvailable)
      missingSensors.add('Linear Acceleration');

    // Update recording readiness
    isPhoneReadyForRecording.value = missingSensors.isEmpty;
    if (isPhoneReadyForRecording.value) {
      Get.snackbar('Success', 'This phone is ready for recording!');
    } else {
      Get.snackbar(
        'Warning',
        'Missing sensors: ${missingSensors.join(', ')}',
      );
    }
  }

  Future<bool> _isSensorAvailable(Stream<dynamic> sensorStream) async {
    Completer<bool> completer = Completer();
    late StreamSubscription subscription;

    try {
      subscription = sensorStream.listen((event) {
        if (!completer.isCompleted) completer.complete(true);
      });
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      if (!completer.isCompleted) completer.complete(false);
    } finally {
      await subscription.cancel();
    }

    return completer.future;
  }

  Future<void> checkPermissions() async {
    if (await Permission.storage.isDenied ||
        await Permission.manageExternalStorage.isDenied) {
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
      'acc_x',
      'acc_y',
      'acc_z',
      'gyro_x',
      'gyro_y',
      'gyro_z',
      'la_x',
      'la_y',
      'la_z',
      'Activity'
    ]);

    // Start streaming sensor data
    accelerometerStream = accelerometerEventStream().listen((event) {
      accelerometerData.value = [
        event.x.toString(),
        event.y.toString(),
        event.z.toString(),
      ];
    });

    gyroscopeStream = gyroscopeEventStream().listen((event) {
      gyroscopeData.value = [
        event.x.toString(),
        event.y.toString(),
        event.z.toString(),
      ];
    });

    userAccelerationStream = userAccelerometerEventStream().listen((event) {
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

  // Future<void> saveDataToCSV() async {
  //   try {
  //     if (await Permission.storage.isDenied ||
  //         await Permission.manageExternalStorage.isDenied) {
  //       await Permission.storage.request();
  //       await Permission.manageExternalStorage.request();
  //     }
  //
  //     final directory = Directory('/storage/emulated/0/Download');
  //     if (!await directory.exists()) {
  //       throw Exception('Downloads directory does not exist');
  //     }
  //
  //     final filePath =
  //         "${directory.path}/sensor_data_${DateTime.now().millisecondsSinceEpoch}.csv";
  //     String csvData = const ListToCsvConverter().convert(recordedData);
  //
  //     final file = File(filePath);
  //     await file.writeAsString(csvData);
  //
  //     Get.snackbar('Success', 'File saved to: $filePath');
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to save file: $e');
  //   } finally {
  //     recordedData.clear();
  //   }
  // }

  Future<void> saveDataToCSV() async {
    try {
      // Request storage permissions if not already granted
      if (await Permission.storage.isDenied ||
          await Permission.manageExternalStorage.isDenied) {
        await Permission.storage.request();
        await Permission.manageExternalStorage.request();
      }

      // Define the path for the app-specific folder in the Downloads directory
      final appFolder = Directory('/storage/emulated/0/HAR Recorder');

      // Check if the folder exists, if not create it
      if (!await appFolder.exists()) {
        await appFolder.create(recursive: true);
      }

      // Define the CSV file path inside the HAR Recorder folder
      final filePath =
          "${appFolder.path}/sensor_data_${DateTime.now().millisecondsSinceEpoch}.csv";

      // Convert the recorded data to CSV format
      String csvData = const ListToCsvConverter().convert(recordedData);

      // Write the CSV data to the file
      final file = File(filePath);
      await file.writeAsString(csvData);

      // Notify the user of success
      Get.snackbar('Success', 'File saved to: $filePath');
    } catch (e) {
      // Notify the user of any errors
      Get.snackbar('Error', 'Failed to save file: $e');
    } finally {
      // Clear recorded data after saving
      recordedData.clear();
    }
  }


  void adjustRefreshRate(String rate) {
    refreshRate.value = rate;
    print("Refresh rate adjusted to: $rate");
  }
}
