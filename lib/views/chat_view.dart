import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(message);
      });
      _controller.clear();
      // Aquí puedes llamar al controlador para procesar la respuesta
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat de Ansiedad'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Escribe tu respuesta'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
