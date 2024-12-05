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
        title: const Text('HAR  Recorder'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Get.dialog(AddLabelDialog());
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.greenAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for labels
            Obx(
                  () => Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.selectedLabel.value,
                    items: ['Choose label', ...controller.labels]
                        .map(
                          (label) => DropdownMenuItem(
                        value: label,
                        child: Text(label),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      controller.selectedLabel.value = value!;
                    },
                  ),
                ),
              ),
            ),
            // Dropdown for refresh rate
            Obx(
                  () => Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.refreshRate.value,
                    items: ['Normal', 'Fast', 'Fastest']
                        .map(
                          (rate) => DropdownMenuItem(
                        value: rate,
                        child: Text(rate),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      controller.adjustRefreshRate(value!);
                    },
                  ),
                ),
              ),
            ),
            // Status Text
            Center(
              child: Obx(
                    () => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Status: ${controller.status.value}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Start/Stop Recording Button
            Center(
              child: Obx(
                    () => ElevatedButton.icon(
                  onPressed: controller.isRecording.value
                      ? controller.stopRecording
                      : controller.startRecording,
                  icon: Icon(controller.isRecording.value
                      ? Icons.stop
                      : Icons.fiber_manual_record),
                  label: Text(
                    controller.isRecording.value ? 'Stop Recording' : 'Start Recording',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isRecording.value
                        ? Colors.red
                        : Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Sensor Data Display
            Expanded(
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.only(top: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(
                        () => ListView(
                      children: [
                        const Text(
                          'Accelerometer Data:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(controller.accelerometerData.join('  |  ')),
                        const SizedBox(height: 10),
                        const Divider(),
                        const Text(
                          'Gyroscope Data:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(controller.gyroscopeData.join('  |  ')),
                        const SizedBox(height: 10),
                        const Divider(),
                        const Text(
                          'Linear Acceleration Data:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(controller.linearAccelerationData.join('  |  ')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
