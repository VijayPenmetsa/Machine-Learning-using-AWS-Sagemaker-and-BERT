import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:liquid_swipe/liquid_swipe.dart';

var myText = "";
var status = "";
var reply = "";


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Testing Bert's deployment on AWS",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("error");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MyHomePage();
          }
          return CircularProgressIndicator();
        }
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  // const MyHomePage({Key? key, required this.title}) : super(key: key);
  // final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}




class _MyHomePageState extends State<MyHomePage> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;


  TextEditingController textEditingController = TextEditingController();





  @override
  Widget build(BuildContext context) {

    CollectionReference tweets = FirebaseFirestore.instance.collection('tweets');
    CollectionReference answers = FirebaseFirestore.instance.collection('answers');

    return Scaffold(
      // backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text("Testing Bert's deployment on AWS"),
      // ),
      body: LiquidSwipe(enableSideReveal:true,fullTransitionValue: 700,slideIconWidget:const Icon(Icons.arrow_back_ios_rounded, color: Colors.green),pages: [
      Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: 'Enter ',
                // style: DefaultTextStyle.of(context).style,
                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 40),
                children: const <TextSpan>[
                  TextSpan(text: 'Tweet!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
            ),
            // const Text(
            //   'Enter tweet!',
            // ),
            Container(
                padding: EdgeInsets.all(20),
                width: 0.9 * MediaQuery.of(context).size.width,
                child: TextField(
                  decoration: InputDecoration(
                      labelText: 'Ask for bed', border: OutlineInputBorder()),
                  controller: textEditingController,
                )),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                ElevatedButton(
                onPressed: () {
                  // GET TEXT
                  setState(() {
                    myText = textEditingController.text;
                    status = "1";
                    // createAndUploadFile();

                    if (textEditingController.text.isNotEmpty){
                      answers.doc("answer").update({'data': ""});
                      tweets.doc("tweet").update({'data': myText});
                      tweets.doc("tweet").update({'status': status});
                    } else {
                      // fail
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("no tweet entered! please give an input."),
                      ));
                    }


                    });
                    //SAVE FILE
                  },
                    child: Text(
                    'Upload to Firebase')), //UPLOAD BUTTON////////////////////////////////////////////////////////////////
                    SizedBox(
                    width: 20,
                    ),
                    ElevatedButton(
                    onPressed: () {
                    setState(() {
                    // downloadFile();
                    // reply = answer;
                      answers
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          reply = doc["data"];
                        });
                      });
                    });
                    },
                    child: Text(
                    'Get Answer')),

                ]),

            SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Text(
                reply,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
      Container(color: Colors.black,
      padding: EdgeInsets.all(15),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: 'Project Motivation: ',

            // style: DefaultTextStyle.of(context).style,
            style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 40),
            children: const <TextSpan>[
              TextSpan(text: "\n\nDuring the second wave of Corona Virus Pandemic India has witnessed a shortage of hospital beds due to high population. We decided to help the people in need of beds by providing them with information regarding available beds in their area. In order to do this we're using Google's NLP model BERT for understanding the type of bed needed (such as ICU, Oxygen, Ventilator) from the provided Tweet data, and recommend available beds near them using available beds dataset that we've acquired online.", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 15)),
              TextSpan(text: "\n\nOriginally we intended to comment on the tweets from twitter, but for the demonstration of model deployment on AWS, and it's usage inside mobile and web apps, we've decided to build these flutter applications.",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 15 )),
              TextSpan(text: "\n\nOur Team:", style: TextStyle(fontSize: 30)),
              TextSpan(text: "\n\nVijay, Akshay, Ghanshyam, Yamini \n\nUnder the guidance of: Vahid Hadavi", style: TextStyle(fontSize: 20))
            ],
          ),
        ),
      ),),
      ]),

    );


  }
}


