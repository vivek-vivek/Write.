import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_note/modules/Dashboard/model/notes_model.dart';
import 'package:take_note/modules/Notes/bloc/notes_bloc.dart';
import 'package:take_note/utils/colors.dart';
import 'dart:developer' as dev;

import 'package:take_note/utils/common_widgets.dart';
import 'package:take_note/utils/extentions.dart';

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
  final List moods = ["annoyed", "happy", "delighted", "irritated", "angry"];

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
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
        child: Column(
          children: [buldExpandedTextFeild(), buildBottomBar(context)],
        ),
      ),
    );
  }

  Expanded buldExpandedTextFeild() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: TextFormField(
          controller: notesController,
          undoController: undoTextController,
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Enter your text here...',
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
                  color: _appColor.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
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
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => NotesBloc(),
          child: BlocListener<NotesBloc, NotesState>(
            listener: (context, state) {
              if (state is MoodSelectedState) {
                selectedMood = state.mood;
              } else if (state is ErroSatate) {
                Navigator.pop(context);
                CommonWidgets().showDialog(context, state.message);
              } else if (state is CreateNoteSuccessState) {
                Navigator.pop(context);
                CommonWidgets().showDialog(context, state.message);
              }
              dev.log(state.toString(), name: "STATE");
            },
            child: BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOut,
                  child: state is LoadingState
                      ? const AlertDialog(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          content: SizedBox(
                            height: 30,
                            width: 20,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : AlertDialog(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          content: SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.4,
                            width: MediaQuery.sizeOf(context).height * 0.4,
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  BlocProvider.of<NotesBloc>(context)
                                      .add(SelectMoodEvent(mood: moods[index]));
                                },
                                child: Container(
                                  color: selectedMood == moods[index]
                                      ? Colors.blue.withOpacity(0.2)
                                      : Colors.transparent,
                                  height: 50,
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text(
                                          moods[index].toString().capitalize(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: moods.length,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                if (selectedMood == null ||
                                    selectedMood!.trim().isEmpty) {
                                  Navigator.pop(context);
                                  CommonWidgets().showDialog(
                                      context, "Please select a mood");
                                } else {
                                  if (widget.updateNoteData == null) {
                                    /// [CREATE NOTE]
                                    BlocProvider.of<NotesBloc>(context).add(
                                        CreateNoteEvent(
                                            note: notesController.text,
                                            mood: selectedMood ??
                                                "No mode selected",
                                            updatedAt:
                                                DateTime.now().toString()));
                                  } else {
                                    /// [UPDATE NOTE]
                                    BlocProvider.of<NotesBloc>(context).add(
                                      UpdateNoteEvent(
                                        note: notesController.text,
                                        mood:
                                            selectedMood ?? "No mode selected",
                                        updatedAt: DateTime.now().toString(),
                                        id: widget.updateNoteData!.id!,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text('Done'),
                            ),
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
            margin: const EdgeInsets.all(8),
            width: 30.0,
            height: 30.0,
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
