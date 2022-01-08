import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/Screens/TodoScreen.dart';
import 'package:todo_app/galary_camera/image.dart';
import 'package:todo_app/model/todo.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');

  //Directory for storing data
  // final appDocumentDirectory =await path_provider.getApplicationDocumentsDirectory();
  // Hive.init(appDocumentDirectory.path);

  runApp(MyApp());
}

class MyApp  extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoScreen(),
    );
  }

}
