import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Keyra/features/dictionary/presentation/bloc/jisho_meanings_bloc.dart';

@immutable
class JishoMeaningsProvider extends StatelessWidget {
  final Widget child;

  const JishoMeaningsProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JishoMeaningsBloc>(
      create: (_) => JishoMeaningsBloc(),
      child: child,
    );
  }
}
