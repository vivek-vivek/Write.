import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_note/modules/Dashboard/bloc/dashboard_bloc.dart';
import 'package:take_note/modules/Notes/view/create_or_update_note_screen.dart';
import 'package:take_note/utils/colors.dart';
import 'package:take_note/utils/common_widgets.dart';
import 'package:take_note/utils/dates.dart';
import '../model/notes_model.dart';
import '../widgets/statatic_widgets.dart';
import 'search_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _appColor = AppColors();
  final colorsList = [
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];
  List<NoteModel> notesList = [];
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.linear),
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(GetNotesFromDB()),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return BlocListener<DashboardBloc, DashboardState>(
            listener: (context, state) {
              if (state is GetNotesSuccessSate) {
                notesList = state.notesList;
              } else if (state is ErroSatate) {
                CommonWidgets().showDialog(context, state.message);
              }
            },
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: _appColor.white,
              floatingActionButton: animatedFloatingActionButton(),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      appHeader(context),
                      searchBarWidget(),
                      if (state is! LoadingState && notesList.isNotEmpty)
                        state is LoadingState
                            ? const Center(child: CircularProgressIndicator())
                            : buildNotesView(context)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildNotesView(BuildContext parentContext) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 2, right: 2),
        child: notesList.isEmpty
            ? const Center(
                child: Text(
                  "No notes found",
                ),
              )
            : BlocProvider.of<DashboardBloc>(parentContext).ScreenGridView ==
                    false
                ? ListView.separated(
                    itemBuilder: (context, index) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 800),
                        opacity: 1.0,
                        curve: Curves.easeInOut,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(-1.0, 0.0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeInOut,
                          )),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.09,
                            decoration: BoxDecoration(
                              color: colorsList[index % colorsList.length]
                                  .withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                verticalColorMargin(
                                    colorsList[index % colorsList.length]),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        normalDateFormate(
                                            notesList[index].updatedAt ?? ""),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        child: Text(
                                          notesList[index].note ?? "",
                                          style: const TextStyle(fontSize: 17),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: notesList.length,
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: notesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          await Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => CreateOrUpdateNoteScreen(
                              updateNoteData: notesList[index],
                            ),
                          ))
                              .then((value) {
                            BlocProvider.of<DashboardBloc>(
                                    _scaffoldKey.currentContext!)
                                .add(GetNotesFromDB());
                          });
                        },
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 800),
                          opacity: 1.0,
                          curve: Curves.easeInOut,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(-1.0, 0.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _animationController,
                              curve: Curves.easeInOut,
                            )),
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorsList[index % colorsList.length]
                                    .withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  verticalColorMargin(
                                      colorsList[index % colorsList.length]),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            normalDateFormate(
                                                notesList[index].updatedAt ??
                                                    ""),
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                          const Divider(),
                                          Text(
                                            notesList[index].note ?? "",
                                            style:
                                                const TextStyle(fontSize: 17),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget searchBarWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: _appColor.textFieldColors,
        borderRadius: BorderRadius.circular(9),
      ),
      child: TextFormField(
        onTap: () {
          print("hhhhhhhhh");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(
                noteList: notesList,
              ),
            ),
          );
        },
        readOnly: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search for notes...",
          hintStyle: TextStyle(color: _appColor.grey, fontSize: 14),
        ),
      ),
    );
  }

  Widget appHeader(BuildContext parentContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Notes",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 21),
        ),
        IconButton(
            onPressed: () {
              _animationController = AnimationController(
                vsync: this,
                duration: const Duration(milliseconds: 800),
              );
              _animationController.forward();
              parentContext.read<DashboardBloc>().add(
                    ChangeScreenViewEvent(
                      view: BlocProvider.of<DashboardBloc>(parentContext)
                          .ScreenGridView,
                    ),
                  );
            },
            icon: BlocProvider.of<DashboardBloc>(parentContext).ScreenGridView
                ? const Icon(Icons.grid_view_outlined)
                : const Icon(Icons.list))
      ],
    );
  }

  void _onFabPressed() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (context) => const CreateOrUpdateNoteScreen(),
        ))
        .then((value) =>
            BlocProvider.of<DashboardBloc>(_scaffoldKey.currentContext!)
                .add(GetNotesFromDB()));
  }

  Widget animatedFloatingActionButton() {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 800),
      child: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          backgroundColor: _appColor.blue,
          onPressed: _onFabPressed,
          child: Icon(
            Icons.add,
            color: _appColor.white,
          ),
        ),
      ),
    );
  }
}
