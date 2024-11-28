import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'har_view_model.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HARViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('HAR Recorder'),
        ),
        body: Consumer<HARViewModel>(
          builder: (context, harViewModel, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    harViewModel.isRecording ? 'Recording...' : 'Press Start',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (harViewModel.isRecording) {
                        harViewModel.stopRecording();
                        harViewModel.saveDataToFile().then((filePath) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Data saved to $filePath')),
                          );
                        });
                      } else {
                        harViewModel.startRecording();
                      }
                    },
                    child: Text(harViewModel.isRecording ? 'Stop' : 'Start'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      harViewModel.addSensorData("Sample Sensor Data");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Mock data added')),
                      );
                    },
                    child: Text('Add Mock Data'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
