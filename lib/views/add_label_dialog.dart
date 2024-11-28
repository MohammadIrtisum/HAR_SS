import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';

class AddLabelDialog extends StatelessWidget {
  final MainController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final TextEditingController labelController = TextEditingController();

    return AlertDialog(
      title: const Text('Add New Label'),
      content: TextField(
        controller: labelController,
        decoration: const InputDecoration(hintText: 'Enter label name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (labelController.text.trim().isNotEmpty) {
              controller.labels.add(labelController.text.trim());
              Get.back();
            }
          },
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
