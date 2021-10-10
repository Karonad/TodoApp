import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:todo_app/data/sockets.dart';

class EditTodo extends StatefulWidget {
  final String todo;
  final String username;
  final controller = TextEditingController();

  EditTodo({Key? key, required this.todo, required this.username})
      : super(key: key);
  @override
  _EditTodoState createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  ScrollController controller = ScrollController();
  TextEditingController messageController = TextEditingController();
  late IO.Socket socket;
  late String thetodo;
  late List<Message> messages = [];
  late FocusNode messageNode;

  @override
  void initState() {
    messageNode = FocusNode();
    initSocket();
    super.initState();
  }

  @override
  void dispose() {
    messageNode.dispose();
    return super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      return super.setState(fn);
    }
  }

  void initSocket() {
    try {
      socket = IO.io('ws://localhost:3002', <String, dynamic>{
        'transports': ['websocket'],
      });
      socket.emit("joinRoom", [widget.todo, widget.username]);
      socket.on("sendMessage", (res) {
        Message msg = (res is String)
            ? Message(message: res, username: "Admin")
            : Message(message: res[0], username: res[1]);
        if (msg.username == widget.username) {
          return;
        }
        setState(() {
          messages.add(msg);
          controller.animateTo(controller.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void sendMessage() {
    try {
      socket.emit("sendMessage",
          [messageController.text, widget.todo, widget.username]);
      Message msg =
          Message(message: messageController.text, username: widget.username);
      setState(() {
        messages.add(msg);
        controller.animateTo(controller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
      });
      messageController.clear();
      messageNode.requestFocus();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SelectableText(widget.todo),
      ),
      backgroundColor: Colors.blueGrey[50],
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
              controller: controller,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                if (message.username == widget.username) {
                  return Bubble(
                    margin: const BubbleEdges.only(top: 8),
                    radius: const Radius.circular(12),
                    alignment: Alignment.topRight,
                    nip: BubbleNip.rightTop,
                    elevation: 2,
                    color: const Color.fromRGBO(225, 255, 199, 1.0),
                    child: SelectableText(
                      message.message,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }
                return Bubble(
                  margin: const BubbleEdges.only(top: 8),
                  radius: const Radius.circular(12),
                  alignment: Alignment.topLeft,
                  nip: BubbleNip.leftTop,
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.username,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SelectableText(
                        message.message,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Form(
                    child: TextFormField(
                      focusNode: messageNode,
                      onFieldSubmitted: (val) {
                        sendMessage();
                      },
                      decoration: InputDecoration(
                        labelText: "Message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      controller: messageController,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.11,
                  child: ElevatedButton(
                    child: const Text("Send"),
                    onPressed: () {
                      sendMessage();
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
