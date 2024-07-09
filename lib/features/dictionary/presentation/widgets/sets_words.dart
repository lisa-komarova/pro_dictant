import 'package:flutter/material.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';

class SetsWords extends StatefulWidget {
  final List<SetEntity> set;

  const SetsWords({super.key, required List<SetEntity> this.set});

  @override
  State<SetsWords> createState() => _SetsWordsState();
}

class _SetsWordsState extends State<SetsWords> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
