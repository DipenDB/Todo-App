

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImageAccess extends StatefulWidget{
  @override
  State<ImageAccess> createState() => _ImageAccessState();
}

class _ImageAccessState extends State<ImageAccess> {

  File image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              image !=null ? Image.file(
                image,
                height: 100,
                  width: 100,
                fit: BoxFit.cover,
              ) :Container(
                height: 100,
                  width: 100,
                color: Colors.black,
              ),
              Spacer(),
              FlatButton.icon(
                  onPressed: ()=>pickImage(),
                  icon: Icon(Icons.photo,color: Colors.white,),
                  label: Text('Gallery' , style: TextStyle(color: Colors.white),),
                color: Colors.blue,
              ),

              FlatButton.icon(
                onPressed: (){},
                icon: Icon(Icons.camera,color: Colors.white,),
                label: Text('Camera' , style: TextStyle(color: Colors.white),),
                color: Colors.blue,
              ),
              Spacer(),

            ],
          ),
        ),
      ),
    );
  }

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
}