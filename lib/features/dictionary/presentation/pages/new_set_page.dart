import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_state.dart';
import 'package:uuid/uuid.dart';

class NewSetPage extends StatefulWidget {
  final SetEntity? set;

  const NewSetPage({this.set, super.key});

  @override
  State<NewSetPage> createState() => _NewSetPageState();
}

class _NewSetPageState extends State<NewSetPage> {
  final _nameController = TextEditingController();
  final _searchController = TextEditingController();
  final FocusNode myFocusNode = FocusNode();
  final List<WordEntity> wordsInSet = [];
  bool isSearchShown = false;

  @override
  void initState() {
    if (widget.set != null) {
      wordsInSet.addAll(widget.set!.wordsInSet);
      _nameController.text = widget.set!.name;
    }

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.set != null
              ? S.of(context).editSet
              : S.of(context).newSetTitle,
          style: GoogleFonts.hachiMaruPop(),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset('assets/icons/cancel.png')),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 50,
            child: TextField(
              controller: _nameController,
              maxLines: null,
              keyboardType: TextInputType.text,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  left: 30,
                ),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: Color(0xFFd9c3ac),
                      width: 3,
                    )),
                hintText: S.of(context).enterSetName,
                hintStyle: TextStyle(fontSize: 11),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 50,
            child: TextField(
              controller: _searchController,
              maxLines: null,
              style: GoogleFonts.hachiMaruPop(),
              cursorHeight: 0,
              cursorWidth: 0,
              focusNode: myFocusNode,
              onChanged: (searchText) {
                if (searchText == '') {
                  isSearchShown = false;
                } else {
                  BlocProvider.of<WordsBloc>(context)
                      .add(SearchWordsForASet(searchText));
                  setState(() {
                    isSearchShown = true;
                  });
                }
              },
              onTap: () {
                if (_searchController.text.isEmpty) {
                  myFocusNode.requestFocus();
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _searchController.text.isEmpty
                      ? Image.asset(
                          'assets/icons/search.png',
                          width: 24,
                          height: 24,
                        )
                      : GestureDetector(
                          onTap: () {
                            _searchController.text = '';
                            myFocusNode.unfocus();
                            setState(() {
                              isSearchShown = false;
                            });
                          },
                          child: Image.asset(
                            'assets/icons/cancel.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                ),
                contentPadding: const EdgeInsets.only(
                  left: 30,
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFFd9c3ac), width: 2),
                    borderRadius: BorderRadius.circular(35)),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFd9c3ac), width: 2),
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(children: [
            buildWordsList(),
            isSearchShown
                ? SingleChildScrollView(
                    child: SizedBox(
                      height: 170,
                      child: BlocBuilder<WordsBloc, WordsState>(
                          builder: (context, state) {
                        if (state is SearchedWordsLoaded) {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: state.words.length,
                              itemBuilder: (ctx, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 5, right: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (wordsInSet
                                                .contains(state.words[index]) !=
                                            true) {
                                          wordsInSet.insert(
                                              0, state.words[index]);
                                        }
                                        isSearchShown = false;
                                        _searchController.text = '';
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: const Color(0xFFffffff)),
                                      height: 50,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0,
                                              bottom: 5.0,
                                              right: 5.0,
                                              left: 10),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${state.words[index].source} - ${state.words[index].translationList.first.translation}',
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else if (state is SearchedWordsLoading) {
                          return _loadingIndicator();
                        } else if (state is SearchedWordsEmpty) {
                          return Center(
                            child: Text(
                              S.of(context).noSuchWords,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                    ),
                  )
                : const SizedBox(),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              if (_nameController.text == '') {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).enterSetName)));
              } else {
                if (widget.set != null) {
                  SetEntity set = SetEntity(
                    id: widget.set!.id,
                    name: _nameController.text,
                    isAddedToDictionary: widget.set!.isAddedToDictionary,
                  );
                  final List<WordEntity> wordsInSetToAdd = [];
                  final List<WordEntity> wordsInSetToDelete = [];
                  if (wordsInSet.length > widget.set!.wordsInSet.length) {
                    for (int i = 0; i < wordsInSet.length; i++) {
                      if (widget.set!.wordsInSet.contains(wordsInSet[i]) &&
                          !wordsInSet.contains(wordsInSet[i])) {
                        wordsInSetToDelete.add(wordsInSet[i]);
                      }
                      if (!widget.set!.wordsInSet.contains(wordsInSet[i]) &&
                          wordsInSet.contains(wordsInSet[i])) {
                        wordsInSetToAdd.add(wordsInSet[i]);
                      }
                    }
                  } else {
                    for (int i = 0; i < widget.set!.wordsInSet.length; i++) {
                      if (widget.set!.wordsInSet
                              .contains(widget.set!.wordsInSet[i]) &&
                          !wordsInSet.contains(widget.set!.wordsInSet[i])) {
                        wordsInSetToDelete.add(widget.set!.wordsInSet[i]);
                      }
                      if (!widget.set!.wordsInSet
                              .contains(widget.set!.wordsInSet[i]) &&
                          wordsInSet.contains(widget.set!.wordsInSet[i])) {
                        wordsInSetToAdd.add(widget.set!.wordsInSet[i]);
                      }
                    }
                  }
                  set.wordsInSet.addAll(wordsInSet);
                  BlocProvider.of<SetBloc>(context).add(UpdateSet(
                      set: set,
                      toAdd: wordsInSetToAdd,
                      toDelete: wordsInSetToDelete));
                  Navigator.of(context).pop();
                } else {
                  SetEntity set = SetEntity(
                      id: const Uuid().v4(),
                      name: _nameController.text,
                      isAddedToDictionary: 0);
                  set.wordsInSet.addAll(wordsInSet);
                  BlocProvider.of<SetBloc>(context).add(AddSet(set: set));
                  Navigator.of(context).pop();
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _nameController.text == ''
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFF85977f)),
              height: 50,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      widget.set != null
                          ? S.of(context).update
                          : S.of(context).save,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.hachiMaruPop(
                          color: _nameController.text == ''
                              ? const Color(0xFF7A7A7A)
                              : const Color(0xFFFFFFFF)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _loadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget buildWordsList() {
    return Container(
      color: isSearchShown ? const Color(0xFF0E3311).withOpacity(0.4) : null,
      height: double.infinity,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: wordsInSet.length,
          itemBuilder: (context, index) {
            return Dismissible(
              direction: DismissDirection.endToStart,
              key: ValueKey(wordsInSet[index]),
              background: Row(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/icons/delete.png',
                      width: 35,
                      height: 35,
                      color: const Color(0xFFB70E0E),
                    ),
                  ),
                ],
              ),
              onDismissed: (DismissDirection direction) {
                wordsInSet.remove(wordsInSet[index]);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "${wordsInSet[index].source} - ${wordsInSet[index].translationList.first.translation}",
                          ),
                        ),
                        Image.asset(
                          'assets/icons/divider.png',
                          width: 15,
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
