
import 'package:cloud_firestore/cloud_firestore.dart' as admin;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/models/message_model.dart';

class ChatPage extends StatefulWidget {
  final String contactPhoto;
  final String contactName;
  final String recieverId;

  const ChatPage(
      {Key? key,
      required this.recieverId,
      required this.contactName,
      required this.contactPhoto})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final scrollController = ScrollController();
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  User? user;
  List<String> listOfKeys = [];
  String finalRoomId = '';
  String roomId = '';
  String roomId2 = '';
  List<Message> listOfMessage = [];
  Query getQuery(){
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('chats/${finalRoomId}');

    return ref;
  }


  void getRoomId() async {
    DatabaseEvent event = await ref.once();

    Map data2 = event.snapshot.value as Map;
    data2.forEach((key, value) {
      String keys = key as String;
      listOfKeys.add(keys);
    });
    if (listOfKeys.contains(roomId2)) {
      finalRoomId = roomId2;
    } else {
      finalRoomId = roomId;
    }
    print('finalRoomId=====>${finalRoomId}');
    setState(() {
      //getMessage();
    });
  }

  void getMessage() async {
    DatabaseReference ref1 =
        FirebaseDatabase.instance.ref("chats/$finalRoomId");
    // Query query = ref1.orderByChild('timestamp');
    // DataSnapshot event1 = await query.get();
    // print('sorted======>${event1.value}');
    DatabaseEvent event = await ref1.once();
    print("event======>${event.snapshot.value}");
    Map data2 = event.snapshot.value as Map;
    data2.forEach((key, value) {
      Message msg = Message.fromSnapshot(data2[key]);
      listOfMessage.add(msg);
    });
    for (Message key in listOfMessage) {
      print('msg====>${key.msg}');
    }
    print('msg====>${listOfMessage.length}');
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    user = auth.currentUser;
    String senderId = user!.uid;
    roomId = senderId + widget.recieverId;
    roomId2 = widget.recieverId + senderId;

    getRoomId();
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ChatPage oldWidget) {
    // TODO: implement didUpdateWidget
    changeWidget();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // TODO: implement initState
    user = auth.currentUser;
    String senderId = user!.uid;
    roomId = senderId + widget.recieverId;
    roomId2 = widget.recieverId + senderId;
    getRoomId();
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    super.initState();
  }

  Widget changeWidget(){
    return Expanded(
      child: FirebaseAnimatedList(
        query: getQuery(),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          if (snapshot.value != null) {
            //
            // Map data2 = snapshot.value as Map<dynamic, dynamic>;
            // data2.forEach((key, value) {
            //   Message message = Message.fromSnapshot(data2[key]);
            //   listOfMessage.add(message);
            //
            // });
            final json = snapshot.value as Map;
            print('json=====>${json}');
            final message = Message.fromJson(json);
            print('message====>${message.msg}');


            // Message message = Message.fromSnapshot(data2);
            // print("fgfjgf======> ${message.timestamp}");

            if (message.id == user!.uid) {
              print('hello');
              print('textmsg===>${message.msg ?? ''}');
              return SenderMessageView(text: message.msg ?? '');
            } else {
              print('textmsghgjhj===> ${message.msg}');
              //print('textmsg===>${ listOfMessage[index].msg}');
              return RecieverMessageView(text: 'scvmnnjlk');
            }
          } else {
            return Text('no data');
          }
        },
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 40, top: 10),
            child: Row(
              children: [
                Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: ClipOval(
                      child: (widget.contactPhoto == '')
                          ? Image.asset(
                              'assets/images/img_user.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              widget.contactPhoto,
                              fit: BoxFit.cover,
                            ),
                    )),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.contactName,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // StreamBuilder<DatabaseEvent>(
            //   stream:ref.onValue,
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return Center(
            //           child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
            //     } else {
            //       List<Message> listMessage = [];
            //       Map data2 = snapshot.data!.snapshot.value as Map;
            //       data2.forEach((key, value) {
            //         String keys= key as String;
            //         listOfKeys.add(keys);
            //       });
            //       listMessage = snapshot.data
            //       return ListView.builder(
            //         padding: EdgeInsets.all(10.0),
            //         itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
            //         itemCount: snapshot.data.documents.length,
            //         reverse: true,
            //         controller: listScrollController,
            //       );
            //     }
            //   },
            // ),

            // ListView.builder(
            //   itemCount: listOfMessage.length,
            //     itemBuilder: (context,index){
            //   if(listOfMessage[index].id == user!.uid){
            //     print('textmsg===>${ listOfMessage?[index].msg}');
            //     return SenderMessageView(text: listOfMessage?[index].msg??'');
            //   }else{
            //     print('textmsg===>${ listOfMessage?[index].msg}');
            //     return RecieverMessageView(text: listOfMessage?[index].msg??'');
            //   }
            // }),
            changeWidget(),
            changeWidget(),


            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                      hintText: 'Type Message Here',
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(right: 8),
                        height: 20,
                        width: 20,
                        child: FloatingActionButton(
                          onPressed: () async {
                            //Message model = Message(messageController.text, admin.Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch), '1', user!.uid);
                            Message model = Message(
                                messageController.text,
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                '1',
                                user!.uid);
                            //await ref.child(roomId).child(DateTime.now().millisecondsSinceEpoch.toString()).set(model.toJson());

                            if (listOfKeys.contains(roomId2)) {
                              finalRoomId = roomId2;
                              await ref
                                  .child(roomId2)
                                  .child(DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString())
                                  .set(model.toJson());
                            } else {
                              finalRoomId = roomId;
                              await ref
                                  .child(roomId)
                                  .child(DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString())
                                  .set(model.toJson());
                            }
                            messageController.clear();
                            setState(() {
                              listOfMessage.clear();
                              getRoomId();
                            });
                          },
                          child: Icon(Icons.send),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }
}

class SenderMessageView extends StatelessWidget {
  final String text;

  const SenderMessageView({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(
          top: 10,
        ),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.orange[200],
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}

class RecieverMessageView extends StatelessWidget {
  final String text;

  const RecieverMessageView({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.yellow,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );
  }
}
