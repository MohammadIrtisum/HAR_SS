import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class FileLocationController extends GetxController {
  var files = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFiles();
  }

  Future<void> fetchFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = '${directory.path}/HAR Recorder';
      final folder = Directory(folderPath);

      if (!await folder.exists()) {
        files.value = ['No files found.'];
        return;
      }

      final fileList = folder.listSync().whereType<File>().toList();
      files.value = fileList.map((file) => file.path).toList(); // Store full paths
    } catch (e) {
      files.value = ['Error: Unable to fetch files.'];
    }
  }

  Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        Get.snackbar('Error', 'Could not open file.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to open file: $e');
    }
  }
}
