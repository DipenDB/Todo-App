

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/model/todo.dart';

class EditForm extends StatefulWidget{

  final Todo todo;
  EditForm(this.todo);

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
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
        title: Text('Edit Form'),
      ),
      body: ListView(
        children: [
          Form(
            key: _formid,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [

                    Center(
                      child: InkWell(
                        onTap: ()=>pickImage(),

                        child: Container(
                            height: 100,
                            width: 100,

                            child: widget.todo.imageUrl==null ?
                                Container(
                                  child: Card(
                                    child: Image.network('https://thumbs.dreamstime.com/b/avatar-icon-avatar-flat-symbol-isolated-white-avatar-icon-avatar-flat-symbol-isolated-white-background-avatar-simple-icon-124920496.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                    elevation: 5,
                                    shape: CircleBorder(),
                                    clipBehavior: Clip.antiAlias,
                                  )
                                )
                                : Container(
                              child:Card(child: image!=null?Image.file(File(image.path), fit: BoxFit.cover,) : Image.file(File(widget.todo.imageUrl), fit: BoxFit.cover,),
                                elevation: 5,
                                shape: CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                              ),
                            )




                        ),
                      ),
                    ),

                    SizedBox(height: 10,),

                    TextFormField(
                      controller: titleController..text=widget.todo.title,
                      decoration: InputDecoration(
                          label: Text('Title',style: TextStyle(fontWeight: FontWeight.bold),),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          )
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: descriptionController..text=widget.todo.description,
                      decoration: InputDecoration(
                          label: Text('Description',style: TextStyle(fontWeight: FontWeight.bold),),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          )
                      ),
                    ),
                    SizedBox(height: 15,),
                    ElevatedButton(
                        onPressed: (){
                          //to save current state
                          _formid.currentState.save();

                          //Initializing again with value to update
                          widget.todo.title = titleController.text.trim();
                          widget.todo.description = descriptionController.text.trim();
                          //To update only save no need to pass

                          widget.todo.imageUrl = image.path;

                          widget.todo.save();

                          Navigator.of(context).pop();

                        },
                        child: Text('Save Changes'))
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