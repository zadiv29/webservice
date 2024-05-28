import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webserivce/main.dart';
import 'dart:convert';
import 'package:webserivce/model/to_do.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  Future<List<ToDo>> fetchToDo() async {
    var url = Uri.parse(
        'https://jsonplaceholder.typicode.com/todos?_start=0&_limit=10');
    var response = await http.get(
      url,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      List<ToDo> listToDo = [];
      for (var d in data) {
        if (d != null) {
          listToDo.add(ToDo.fromJson(d));
        }
      }
      return listToDo;
    } else {
      throw Exception('Failed to load to-dos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              title: const Text('Counter'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyApp(title: 'Counter')),
                );
              },
            ),
            ListTile(
              title: const Text('Form'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyFormPage()),
                );
              },
            ),
            ListTile(
              title: const Text('To Do'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ToDoPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<ToDo>>(
        future: fetchToDo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada to do list :('));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var todo = snapshot.data![index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, blurRadius: 2.0),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Completed: ${todo.completed ? "Yes" : "No"}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
