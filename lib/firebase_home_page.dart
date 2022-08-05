

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/chat_page.dart';
import 'package:flutterchatapp/sign_in_firebase.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'models/firebase_user_model.dart';


enum SourceType { name, email, photo }
 List<FireBaseUserModel> listOfUsers =[];

class FirebaseHomePage extends StatefulWidget {
  const FirebaseHomePage({Key? key}) : super(key: key);

  @override
  _FirebaseHomePageState createState() => _FirebaseHomePageState();
}

class _FirebaseHomePageState extends State<FirebaseHomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;

  DatabaseReference ref = FirebaseDatabase.instance.ref("users");


  String userDetails(source) {
    user = auth.currentUser;
    String name = '';
    String email = '';
    String picture = '';
    if (user != null) {
      if (source == SourceType.name) {
        return (name = user!.displayName ?? name);
      } else if (source == SourceType.email) {
        return (email = user!.email ?? email);
      } else {
        return (picture = user!.photoURL ?? picture);
      }
    }

    return '';
  }

  void _onLogOut() async {
    Navigator.of(context).pushNamedAndRemoveUntil('Login', (route) => false);
    await _googleSignIn.signOut();
    await auth.signOut();
    FacebookService service = FacebookService();
    service.signOutFromFacebook();
  }

  // Widget homeScreen() {
  //   return Container(
  //     child: Column(
  //       children: [
  //         ElevatedButton(onPressed: (){
  //
  //         }, child: Text('ggjgjj')),
  //         ListView.builder(
  //           itemCount: listOfUsers.length,
  //             itemBuilder: (BuildContext context,index){
  //             print("hell0==>${listOfUsers.length}");
  //
  //           return ContactItem(contactImage: '', contactName: listOfUsers[index].firstname!,recieverId: listOfUsers[index].id??'',);}),
  //       ],
  //     ),
  //   );
  // }
  getContactList()async{
    DatabaseEvent event = await ref.once();
    Map data2 = event.snapshot.value as Map;
    data2.forEach((key, value) {
      FireBaseUserModel userModel = FireBaseUserModel.fromSnapshot(data2[key]);
      if(user!.uid != key){
        listOfUsers.add(userModel);

      }


    });

    setState((){});

  }

  Widget drawerHomeScreen() {
    return Drawer(
      backgroundColor: Colors.orange,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.orange,
            ),
            child: Center(
                child: Column(
              children: [
                Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 3, color: Colors.white)),
                    child: ClipOval(
                        child: Image.network(
                      userDetails(SourceType.photo),
                      fit: BoxFit.fill,
                    ))),
                Text(
                  userDetails(SourceType.name),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () {
                        _onLogOut();
                      }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget? appBarHomeScreen() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://cdn4.iconfinder.com/data/icons/google-i-o-2016/512/google_firebase-2-512.png',
            height: 35,
            width: 35,
          ),
          const Text('Firebase App'),
        ],
      ),
      actions: [
        Builder(builder: (BuildContext context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: SizedBox(
                width: 30,
                height: 30,
                child: ClipOval(
                    child: Image.network(
                  userDetails(SourceType.photo),
                  fit: BoxFit.cover,
                ))),
          );
        }),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContactList();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarHomeScreen(),
      drawer: drawerHomeScreen(),
      body: ListView.builder(
          itemCount: listOfUsers.length,
          itemBuilder: (BuildContext context,index){
            return ContactItem(contactImage: '', contactName: listOfUsers[index].firstname??'',recieverId: listOfUsers[index].id??'',);})
    );
  }


  void setObservables() async{

    DatabaseEvent event = await ref.once();
    Map data2 = event.snapshot.value as Map;
    data2.forEach((key, value) {
      FireBaseUserModel userModel = FireBaseUserModel.fromSnapshot(data2[key]);
      listOfUsers.add(userModel);

    });




  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
  }
}


class ContactItem extends StatelessWidget {
  final String contactImage;
  final String contactName;
  final String recieverId;
  const ContactItem({Key? key,required this.contactImage,required this.contactName,required this.recieverId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatPage(recieverId: recieverId,contactName: contactName,contactPhoto: contactImage,)));

        },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children:[
          Container(
              margin: const EdgeInsets.only(top:10,left:20,),

              height: 60,
              width: 60,
              child: ClipOval(
                child: (contactImage =='')? Image.asset('assets/images/img_user.png',fit: BoxFit.cover,):Image.network(contactImage,fit: BoxFit.cover,),)),
          Padding(
            padding:  const EdgeInsets.all(20),
            child: Text(contactName,style: const TextStyle(fontWeight: FontWeight.bold,
                fontSize: 18),),
          ),
          const Spacer(flex: 1,),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                const Text("9:45",style: TextStyle(
                  color: Colors.green,
                ),),
                const SizedBox(
                  height: 5,
                ),

                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  child: const Text('2',style: TextStyle(
                    color: Colors.white,
                  ),),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                )

              ],
            ),
          ),




        ],
      ),
    );
  }
}





