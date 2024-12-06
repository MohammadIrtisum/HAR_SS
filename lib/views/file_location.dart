import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/file_location_controller.dart';

class FileLocationView extends StatelessWidget {
  final FileLocationController controller = Get.put(FileLocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Location'),
        backgroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.files.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.files.length,
          itemBuilder: (context, index) {
            final filePath = controller.files[index];
            final fileName = filePath.split('/').last; // Extract the file name

            return ListTile(
              title: Text(fileName),
              leading: Icon(Icons.insert_drive_file),
              onTap: () {
                controller.openFile(filePath); // Open the file when tapped
              },
            );
          },
        );
      }),
    );
  }
}