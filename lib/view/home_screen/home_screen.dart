import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:taskmanagementsystem/controller/home_screen_controller.dart';
import 'package:taskmanagementsystem/utils/color_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isTaskCompleted = false;
  var docDate = DateTime.now();
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await HomeScreenController.getAllNote();
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        // floatingactionbutton
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorConstants.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: ColorConstants.TextWhite, width: 2),
          ),
          onPressed: () {
            _CustomBottomSheet(context);
          },
          child: Icon(
            Icons.add,
            color: ColorConstants.TextWhite,
            size: 25,
          ),
        ),
      
        // body
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                EasyDateTimeLine(
                  initialDate: DateTime.now(),
                  onDateChange: (selectedDate) {
                    setState(() {
                      docDate = selectedDate;
                      
                    });
                    print("Selected Date: ${selectedDate}");
                  },
                  // Month style
                  headerProps: const EasyHeaderProps(
                    monthPickerType: MonthPickerType.switcher,
                    dateFormatter: DateFormatter.fullDateDMY(),
                    monthStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Day style
                  dayProps: EasyDayProps(
                    dayStructure: DayStructure.dayStrDayNum,
                    // Active day style
                    activeDayStyle: DayStyle(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF0448E6),
                            Color(0xff8426D6),
                          ],
                        ),
                      ),
                    ),
                    // Inactive day style
                    inactiveDayStyle: DayStyle(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xffFFBF9B),
                          ],
                        ),
                      ),
                    ),
                    // today style color
                    todayStyle: DayStyle(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xffFFBF9B),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: HomeScreenController.NoteDataList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: ColorConstants.TextWhite)),
                      child: Stack(
                        children: [
                          ListTile(
                            onTap: () {
                              _CustomBottomSheet(
                                context,
                                isedit: true,
                                currentTitle: HomeScreenController
                                    .NoteDataList[index]["Title"],
                                currentText: HomeScreenController
                                    .NoteDataList[index]['Text'],
                                Noteid: HomeScreenController.NoteDataList[index]
                                    ["id"],
                              );
                            },
                            title: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                    child: Text(
                                      HomeScreenController.NoteDataList[index]
                                              ["Title"]
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Text(
                                    HomeScreenController.NoteDataList[index]
                                            ['Text']
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                  Text(
                                    
                                    HomeScreenController.NoteDataList[index]
                                            ['date']
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () async {
                                await HomeScreenController.removeNote(
                                  HomeScreenController.NoteDataList[index]["id"],
                                );
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.delete_outline,
                                color: ColorConstants.TextWhite,
                              ),
                            ),
                          ),
                          Positioned(
                              top: 0,
                              left: 0,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isTaskCompleted = !_isTaskCompleted;
                                  });
                                },
                                icon: Icon(
                                  _isTaskCompleted
                                      ? Icons.task_alt
                                      : Icons.remove_circle_outline,
                                  color: _isTaskCompleted
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              )),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: ColorConstants.primaryColor,
      title: Text(
        "Personal Note",
        style: TextStyle(
          color: ColorConstants.TextWhite,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.search,
            color: ColorConstants.TextWhite,
            size: 30,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.info_outline,
            color: ColorConstants.TextWhite,
            size: 30,
          ),
        ),
      ],
    );
  }

  Future<dynamic> _CustomBottomSheet(BuildContext context,
      {bool isedit = false,
      String? currentTitle,
      String? currentText,
      int? Noteid}) {
    TextEditingController titleController =
        TextEditingController(text: isedit ? currentTitle : "");
    TextEditingController textController =
        TextEditingController(text: isedit ? currentText : "");

    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          color: ColorConstants.primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConstants.TextWhite),
                    ),
                    labelStyle: TextStyle(color: ColorConstants.TextWhite),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConstants.TextWhite),
                    ),
                    labelStyle: TextStyle(color: ColorConstants.TextWhite),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: ColorConstants.primaryColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            if (isedit) {
                              await HomeScreenController.updateNote(
                                titleController.text,
                                textController.text,
                                Noteid!,
                              );
                            } else {
                              await HomeScreenController.addNote(
                                  Title: titleController.text,
                                  Text: textController.text,
                                  Datestring: docDate.toString()
                                  );
                            }
                            setState(() {});
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                        child: Text("Save Note",
                            style: TextStyle(
                                color: ColorConstants.primaryColor,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
