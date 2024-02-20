import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_note/modules/Dashboard/model/notes_model.dart';
import 'package:take_note/modules/Dashboard/view/dashboard_screen.dart';
import 'package:take_note/modules/Notes/bloc/notes_bloc.dart';
import 'package:take_note/utils/colors.dart';
import 'dart:developer' as dev;

import 'package:take_note/utils/common_widgets.dart';
import 'package:take_note/utils/extentions.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';

class CreateOrUpdateNoteScreen extends StatefulWidget {
  final NoteModel? updateNoteData;
  const CreateOrUpdateNoteScreen({super.key, this.updateNoteData});

  @override
  CreateOrUpdateNoteScreenState createState() =>
      CreateOrUpdateNoteScreenState();
}

class CreateOrUpdateNoteScreenState extends State<CreateOrUpdateNoteScreen> {
  final UndoHistoryController undoTextController = UndoHistoryController();
  final TextEditingController notesController = TextEditingController();
  final _appColor = AppColors();
  final List moods = [
    {"mood": "dissapointed", "color": "purple"},
    {"mood": "annoyed", "color": "blue"},
    {"mood": "happy", "color": "green"},
    {"mood": "delighted", "color": "yellow"},
    {"mood": "irritated", "color": "orange"},
    {"mood": "angry", "color": "red"},
  ];

  selecteColor(mood) {
    switch (mood) {
      case "dissapointed":
        return Colors.purple;

      case "annoyed":
        return Colors.blue;

      case "happy":
        return Colors.green;

      case "delighted":
        return Colors.yellow;

      case "irritated":
        return Colors.orange;

      case "angry":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  final subMoods = ["small", "medium", "high"];

  @override
  void initState() {
    if (widget.updateNoteData != null) {
      notesController.text = widget.updateNoteData!.note ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appColor.black,
      // appBar: buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
          child: Column(
            children: [buldExpandedTextFeild(), buildBottomBar(context)],
          ),
        ),
      ),
    );
  }

  Expanded buldExpandedTextFeild() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: TextFormField(
          autofocus: true,
          controller: notesController,
          undoController: undoTextController,
          maxLines: null,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  buildBottomBar(BuildContext parrentContex) {
    return GestureDetector(
      onTap: () {
        CommonWidgets().closekeyboard(context);
        if (notesController.text.trim().isEmpty) {
          CommonWidgets().showDialog(context, "Please enter a note");
        } else {
          showSelectMoodDialog();
        }
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: _appColor.textFieldColors,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildRainboBubles(context),
              Text(
                "Set mood to proceed",
                style: TextStyle(
                  color: _appColor.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showSelectMoodDialog() {
    String? selectedMood = widget.updateNoteData?.mood;
    String? selectedSubMood = widget.updateNoteData?.subMood;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => NotesBloc(),
          child: BlocListener<NotesBloc, NotesState>(
            listener: (context, state) {
              if (state is SubMoodSelectedState) {
                selectedSubMood = state.mood;
              } else if (state is MoodSelectedState) {
                selectedMood = state.mood;
              } else if (state is ErroSatate) {
                Navigator.pop(context);

                CommonWidgets().showDialog(context, state.message);
              } else if (state is CreateNoteSuccessState) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(),
                    ));
                CommonWidgets().showDialog(context, state.message);
              }
              dev.log(state.toString(), name: "STATE");
            },
            child: BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                return state is LoadingState
                    ? AlertDialog(
                        backgroundColor: _appColor.black,
                        content: const SizedBox(
                          height: 30,
                          width: 20,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : AlertDialog(
                        backgroundColor: _appColor.black,
                        surfaceTintColor: _appColor.black,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(14),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                  border: Border.all(color: _appColor.grey),
                                  color: _appColor.black,
                                  borderRadius: BorderRadius.circular(12)),
                              height: MediaQuery.sizeOf(context).height * 0.48,
                              width: MediaQuery.sizeOf(context).height * 0.4,
                              child: ListView.separated(
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        BlocProvider.of<NotesBloc>(context).add(
                                            SelectMoodEvent(
                                                mood: moods[index]['mood']));
                                      },
                                      child: Center(
                                        child: Row(
                                          children: [
                                            buildDots(
                                                context,
                                                0.03,
                                                0.02,
                                                3.00,
                                                selecteColor(
                                                    moods[index]['mood'])),
                                            buildDots(
                                                context,
                                                0.04,
                                                0.03,
                                                5.00,
                                                selecteColor(
                                                    moods[index]['mood'])),
                                            buildDots(
                                                context,
                                                0.05,
                                                0.04,
                                                7.00,
                                                selecteColor(
                                                    moods[index]['mood'])),
                                            const SizedBox(width: 10),
                                            Text(
                                              moods[index]['mood']
                                                  .toString()
                                                  .capitalize(),
                                              style: TextStyle(
                                                  color: _appColor.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (selectedMood == moods[index]['mood'])
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.08,
                                        child: ListView.separated(
                                            itemBuilder: (context, index) =>
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        BlocProvider.of<
                                                                    NotesBloc>(
                                                                context)
                                                            .add(SelectSubMoodEvent(
                                                                mood: subMoods[
                                                                    index]));
                                                      },
                                                      child: Text(
                                                          subMoods[index]
                                                              .toString()
                                                              .capitalize(),
                                                          style: TextStyle(
                                                              color: _appColor
                                                                  .white,
                                                              fontWeight: selectedSubMood ==
                                                                      subMoods[
                                                                          index]
                                                                  ? FontWeight
                                                                      .w800
                                                                  : null)),
                                                    ),
                                                  ],
                                                ),
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                            itemCount: subMoods.length),
                                      )
                                  ],
                                ),
                                separatorBuilder: (context, index) => SizedBox(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.02),
                                itemCount: moods.length,
                              ),
                            ),
                            if (selectedMood != null &&
                                selectedSubMood != null &&
                                selectedMood!.trim().isNotEmpty)
                              Container(
                                  margin: const EdgeInsets.all(14),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: _appColor.grey),
                                      color: _appColor.black,
                                      borderRadius: BorderRadius.circular(20)),
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.06,
                                  width: MediaQuery.sizeOf(context).width * 0.7,
                                  child: SwipeButton.expand(
                                    thumb: const Icon(
                                      Icons.double_arrow_rounded,
                                      color: Colors.white,
                                    ),
                                    activeThumbColor:
                                        selecteColor(selectedMood),
                                    activeTrackColor: Colors.grey.shade300,
                                    onSwipe: () {
                                      if (selectedMood == null ||
                                          selectedMood!.trim().isEmpty) {
                                        Navigator.pop(context);
                                        CommonWidgets().showDialog(
                                            context, "Please select a mood");
                                      } else {
                                        if (widget.updateNoteData == null) {
                                          /// [CREATE NOTE]
                                          BlocProvider.of<NotesBloc>(context)
                                              .add(CreateNoteEvent(
                                                  note: notesController.text,
                                                  mood: selectedMood ??
                                                      "No mode selected",
                                                  updatedAt: DateTime.now()
                                                      .toString()));
                                        } else {
                                          /// [UPDATE NOTE]
                                          BlocProvider.of<NotesBloc>(context)
                                              .add(
                                            UpdateNoteEvent(
                                              note: notesController.text,
                                              mood: selectedMood ??
                                                  "No mode selected",
                                              updatedAt:
                                                  DateTime.now().toString(),
                                              id: widget.updateNoteData!.id!,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      "Swipe to create",
                                      style: TextStyle(
                                          color: selecteColor(selectedMood)),
                                    ),
                                  ))
                          ],
                        ),
                      );
              },
            ),
          ),
        );
      },
    );
  }

  buildDots(BuildContext context, width, height, radius, color) {
    return Container(
      margin: EdgeInsets.all(radius),
      width: MediaQuery.sizeOf(context).width * width,
      height: MediaQuery.sizeOf(context).height * height,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  /*
  
  
  */

  SizedBox buildRainboBubles(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.32,
      child: Stack(
        children: [
          coloredCircle(Colors.transparent, 0),
          coloredCircle(Colors.purple, 0),
          coloredCircle(Colors.blue, 1),
          coloredCircle(Colors.green, 2),
          coloredCircle(Colors.yellow, 3),
          coloredCircle(Colors.orange, 4),
          coloredCircle(Colors.red, 5),
        ],
      ),
    );
  }

  Widget coloredCircle(Color color, int position) {
    return TweenAnimationBuilder(
      tween: Tween<double>(
          begin: position.toDouble() + 6, end: position.toDouble()),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.bounceOut,
      builder: (BuildContext context, double position, Widget? child) {
        return Positioned(
          right: 17.0 * position,
          child: Container(
            margin: const EdgeInsets.all(7),
            width: MediaQuery.sizeOf(context).width * 0.07,
            height: MediaQuery.sizeOf(context).height * 0.04,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        );
      },
    );
  }

  buildAppBar() {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios)),
      title: Text(
        widget.updateNoteData == null ? 'Create New Note' : 'Update Note',
      ),
      actions: [
        if (widget.updateNoteData != null)
          BlocProvider(
            create: (context) => NotesBloc(),
            child: BlocListener<NotesBloc, NotesState>(
              listener: (context, state) {
                if (state is DeleteNoteSuccessState) {
                  Navigator.of(context).pop();
                } else if (state is ErroSatate) {
                  CommonWidgets().showDialog(context, state.message);
                }
                dev.log(state.toString(), name: "STATE2");
              },
              child: BlocBuilder<NotesBloc, NotesState>(
                builder: (context, state) {
                  return IconButton(
                    onPressed: () {
                      BlocProvider.of<NotesBloc>(context).add(DeleteNoteEvent(
                          id: widget.updateNoteData!.id.toString()));
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ),
          )
      ],
    );
  }
}
