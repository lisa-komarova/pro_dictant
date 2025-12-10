import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/s.dart';

///app bar with search
class SearchContainer extends StatefulWidget {
  final void Function(String searchText) searchHandler;
  final TextEditingController controller;

  const SearchContainer({
    super.key,
    required this.searchHandler,
    required this.controller,
  });

  @override
  State<SearchContainer> createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: Stack(fit: StackFit.loose, children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Container(
                height: 50,
                child: TextField(
                  controller: widget.controller,
                  style: GoogleFonts.hachiMaruPop(),
                  cursorHeight: 0,
                  cursorWidth: 0,
                  maxLines: null,
                  expands: true,
                  focusNode: myFocusNode,
                  onChanged: (searchText) {
                    setState(() {});
                    widget.searchHandler(searchText);
                    if (widget.controller.text.isEmpty) {
                      setState(() {
                        myFocusNode.unfocus();
                      });
                    }
                  },
                  onTap: () => myFocusNode.requestFocus(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (widget.controller.text.isNotEmpty) {
                          widget.searchHandler('');
                          widget.controller.text = '';
                          setState(() {
                            myFocusNode.unfocus();
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: widget.controller.text.isEmpty
                            ? Semantics(
                                label: S.of(context).searchButton,
                                child: Image.asset(
                                  'assets/icons/search.png',
                                  width: 24,
                                  height: 24,
                                ),
                              )
                            : Semantics(
                                label: S.of(context).clearButton,
                                child: Image.asset(
                                  'assets/icons/cancel.png',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFFd9c3ac), width: 2),
                        borderRadius: BorderRadius.circular(20)),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xFFd9c3ac), width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )),
          ),
        ]));
  }
}
