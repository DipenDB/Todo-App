

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/Screens/add_form.dart';
import 'package:todo_app/Screens/editForm.dart';
import 'package:todo_app/model/todo.dart';

class TodoScreen extends StatefulWidget{

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        // onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddForm(),)),
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => AddForm(),)),
      ),

      body: ValueListenableBuilder<Box<Todo>>(
        valueListenable: Hive.box<Todo>('todos').listenable(),
        builder: (context, box, child) {
          final todos = box.values.toList().cast<Todo>();
          return todos.length == 0 ? Center(child: Text('Add Some Todo'),) :ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(todos[index].title),
                  leading: Container(
                    height: 40,
                    width: 40,
                    child: Image.file(File(todos[index].imageUrl)),
                    ),


                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(todos[index].description),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width*0.33,
                          // width: 100,
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditForm(todos[index]),));
                                },
                                  child: Icon(Icons.edit),
                              ),
                              TextButton(
                                  onPressed: (){
                                    todos[index].delete();
                                  },
                                  child: Icon(Icons.delete)
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),


                  ],
                );
              },
          );
        },
      ),


    );

  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}