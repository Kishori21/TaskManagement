import 'package:flutter/material.dart';
import 'package:flutter_task_list/jsonFile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: "Task List:"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late MediaQueryData _mediaQueryData;
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  List<InfoJsonModel> _taskList = [];
  final taskListController = TextEditingController();
  final taskListFocus = FocusNode();

  void _addTask() {
    setState(() {
      _counter++;
      _displayTextInputDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;    //ScreenWidth of device
    screenHeight = _mediaQueryData.size.height;   //ScreenHeight of device

    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: screenWidth * .05,
            fontFamily: "Sofia_Pro_Bold",
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.0),
                child: ListView(
                  children: [
                    getTaskList(screenHeight, screenWidth),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _taskList.isEmpty,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "No Task added yet..",
                  style: TextStyle(
                    fontSize: screenWidth * .02,
                    fontFamily: "Sofia_Pro_Bold",
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: 1.9,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  /* This layout is for task list*/
  Widget getTaskList(double screenHeight, double screenWidth) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: screenHeight * 0.0,
              left: screenWidth * 0.055,
              right: screenWidth * 0.055),
          child: Container(
            alignment: Alignment.topCenter,
            child: ListView.builder(

                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                itemCount: _taskList.length,
                physics:  NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  InfoJsonModel model = _taskList.elementAt(index);
                  return Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          model.name,
                          style: TextStyle(
                              fontSize: screenWidth * .02,
                              fontFamily: "Sofia_Pro_Bold",
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis),
                          textScaleFactor: 1.9,
                          maxLines: 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (mounted)
                              setState(() {
                                _taskList.removeAt(index);  //remove task from list
                              });
                          },
                          onDoubleTap: () {},
                          child: Icon(
                            Icons.delete,
                            size: screenHeight * 0.04,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  /* This layout is for enter task dialog*/
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Enter your task',
              style: TextStyle(
                fontSize: screenWidth * .06,
                fontFamily: "Sofia_Pro_Bold",
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: TextFormField(
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              textAlignVertical: TextAlignVertical.center,
              controller: taskListController,
              textAlign: TextAlign.start,
              onChanged: (String value) {
                // emailUser= emailController.text.trim().toString();
              },
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                isDense: true,
                hintText: "Enter Task",
                hintStyle: TextStyle(
                  fontSize: screenWidth * .04,
                  fontFamily: "Sofia_Pro_Bold",
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: TextStyle(
                fontSize: screenWidth * .04,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
              textInputAction: TextInputAction.done,
              onTap: () {
                // _hasBeenPressed = true;
              },
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text(
                  'ok',
                  style: TextStyle(
                    fontSize: screenWidth * .04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    if (taskListController.text.isNotEmpty) {

                      //adding task in list
                      _taskList.add(new InfoJsonModel(_counter.toString(),
                          taskListController.text.trim().toString()));
                    }

                    taskListController.clear();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}
