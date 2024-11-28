import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import 'add_label_dialog.dart';

class MainActivity extends StatelessWidget {
  final MainController controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HAR Recorder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.dialog(AddLabelDialog());
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => DropdownButton<String>(
              value: controller.selectedLabel.value,
              items: ['Choose label', ...controller.labels]
                  .map((label) => DropdownMenuItem(
                value: label,
                child: Text(label),
              ))
                  .toList(),
              onChanged: (value) {
                controller.selectedLabel.value = value!;
              },
            )),
            const SizedBox(height: 20),
            Obx(() => DropdownButton<String>(
              value: controller.refreshRate.value,
              items: ['Normal', 'Fast', 'Fastest']
                  .map((rate) => DropdownMenuItem(
                value: rate,
                child: Text(rate),
              ))
                  .toList(),
              onChanged: (value) {
                controller.adjustRefreshRate(value!);
              },
            )),
            const SizedBox(height: 20),
            Obx(() => Text('Status: ${controller.status.value}',
                style: const TextStyle(fontSize: 16))),
            const SizedBox(height: 20),
            Obx(() => ElevatedButton(
              onPressed: controller.isRecording.value
                  ? controller.stopRecording
                  : controller.startRecording,
              child: Text(controller.isRecording.value
                  ? 'Stop Recording'
                  : 'Start Recording'),

            )),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() => ListView(
                children: [
                  const Text('Accelerometer Data:'),
                  Text(controller.accelerometerData.join('  |  ')),
                  const SizedBox(height: 20),
                  const Text('Gyroscope Data:'),
                  Text(controller.gyroscopeData.join('  |  ')),
                  const SizedBox(height: 20),
                  const Text('Linear Acceleration Data:'),
                  Text(controller.linearAccelerationData.join('  |  ')),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
