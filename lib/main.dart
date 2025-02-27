
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensor_recorder/views/logo_animation.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );


  // Enable offline persistence for Firebase Realtime Database
  // FirebaseDatabase.instance.setPersistenceEnabled(true);

//   runApp(const HARRecorderApp());
// }
void main() {
  runApp(HARRecorderApp());
}



class HARRecorderApp extends StatelessWidget {
  const HARRecorderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogoAnimation(),
    );
  }
}

