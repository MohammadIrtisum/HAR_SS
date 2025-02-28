import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/har_controller.dart';

class SavedActivitiesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HARController controller = Get.put(HARController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Activities',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              _showAddLabelDialog(context, controller);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search labels...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                // Implement search functionality if needed
              },
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.labels.length,
                itemBuilder: (context, index) {
                  final label = controller.labels[index]; // label is now a Map

                  return AnimatedCard(
                    child: ListTile(
                      title: Text(
                        label['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          controller.deleteLabel(label['id']); // Delete from DB
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddLabelDialog(BuildContext context, HARController controller) {
    final TextEditingController labelController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Label'),
          content: TextField(
            controller: labelController,
            decoration: InputDecoration(hintText: 'Enter label name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (labelController.text.trim().isNotEmpty) {
                  controller.addLabel(labelController.text.trim());
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class AnimatedCard extends StatelessWidget {
  final Widget child;

  const AnimatedCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
