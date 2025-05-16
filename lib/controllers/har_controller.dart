import 'dart:async';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensor_recorder/database/database_helper.dart';
import 'package:sensors_plus/sensors_plus.dart';


class HARController extends GetxController {
  var isRecording = false.obs;
  var selectedLabel = 'Choose label'.obs;
  var accelerometerData = <String>[].obs;
  var gyroscopeData = <String>[].obs;
  var labels = <Map<String, dynamic>>[].obs; // Store as a list of maps
  var status = 'Idle'.obs;
  final DatabaseHelper dbHelper = DatabaseHelper();

  late StreamSubscription accelerometerStream;
  late StreamSubscription gyroscopeStream;

  @override
  void onInit() {
    super.onInit();
    checkPermissions();
    loadLabels();
  }

  Future<void> checkPermissions() async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  Future<void> loadLabels() async {
    List<Map<String, dynamic>> dbLabels = await dbHelper.getLabels();
    labels.assignAll(dbLabels);
  }

  void addLabel(String labelName) async {
    await dbHelper.insertLabel(labelName);
    loadLabels(); // Refresh UI
  }

  void deleteLabel(int id) async {
    await dbHelper.deleteLabel(id);
    loadLabels(); // Refresh UI
  }

  void startRecording() {
    if (selectedLabel.value == 'Choose label') {
      Get.snackbar('Error', 'Please select a label to start recording!');
      return;
    }

    isRecording.value = true;
    status.value = "Recording...";

    accelerometerStream = accelerometerEvents.listen((event) {
      accelerometerData.add('X: ${event.x}, Y: ${event.y}, Z: ${event.z}');
    });

    gyroscopeStream = gyroscopeEvents.listen((event) {
      gyroscopeData.add('X: ${event.x}, Y: ${event.y}, Z: ${event.z}');
    });
  }

  void stopRecording() {
    isRecording.value = false;
    status.value = "Stopped";

    accelerometerStream.cancel();
    gyroscopeStream.cancel();
  }
}
