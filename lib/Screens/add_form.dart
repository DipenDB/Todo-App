
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/model/todo.dart';

class AddForm extends StatefulWidget{


  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final _formid = GlobalKey<FormState>();

  File image;

  Future pickImage() async{
    try{
      final selectedImage = await ImagePicker().pickImage(source:ImageSource.gallery);

      if(selectedImage == null) return;

      final tempImage = File(selectedImage.path);
      setState(() {
        this.image = tempImage;
      });
    } on PlatformException catch(e){
      print('Failed to pick image: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Form'),
      ),
      body: ListView(
        children: [
          Form(
            key: _formid,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Center(
                      child: InkWell(
                        onTap: ()=>pickImage(),

                        child: Container(
                            height: 100,
                            width: 100,

                            child: image==null ? Container(
                                child: Card(
                                  child: Image.network('https://thumbs.dreamstime.com/b/avatar-icon-avatar-flat-symbol-isolated-white-avatar-icon-avatar-flat-symbol-isolated-white-background-avatar-simple-icon-124920496.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                  elevation: 5,
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.antiAlias,
                                )
                            ) : Container(
                              child: Card(
                                child: Image.file(image, fit: BoxFit.cover,),
                                elevation: 5,
                                shape: CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                              ),

                            )

                        ),
                      ),
                    ),
                    SizedBox(height: 15,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                              label: const Text('Title',style: TextStyle(fontWeight: FontWeight.bold),),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)
                              )
                          ),
                        ),
                        const SizedBox(height: 15,),
                        TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                              label: Text('Description',style: const TextStyle(fontWeight: FontWeight.bold),),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)
                              )
                          ),
                        ),
                        const SizedBox(height: 15,),
                        ElevatedButton(
                            onPressed: (){
                              //to save current state
                              _formid.currentState.save();

                              final newTodo = Todo(
                                title: titleController.text.trim(),
                                description: descriptionController.text.trim(),
                                imageUrl: image.path,
                              );

                              Hive.box<Todo>('todos').add(newTodo);
                              Navigator.of(context).pop();

                            },
                            child: const Text('Add Todo'))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],

      ),
    );
  }
}