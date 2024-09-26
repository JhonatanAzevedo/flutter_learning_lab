import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:learning_lab/learning_lab.dart';
import 'package:widgetbook/widgetbook.dart';

class PinAuthenticationUsecase extends WidgetbookUseCase {
  PinAuthenticationUsecase()
      : super(
          name: 'Authentication',
          builder: _child,
        );
  static bool _value = false;
  static int _length = 4;

  static Widget _child(BuildContext context) {
    WidgetbookState.of(context).knobs.remove('Current PIN length (max 6)');

    _length = context.knobs.int.slider(
      label: 'PIN length',
      max: 6,
      min: 4,
      initialValue: 4,
    );

    return Scaffold(
      body: Center(
        child: _PinAuthenticationWidget(
          (bool newValue) {
            _value = newValue;
          },
          _value,
          _length,
        ),
      ),
    );
  }
}

class _PinAuthenticationWidget extends StatefulWidget {
  const _PinAuthenticationWidget(this.onChanged, this.value, this.length);

  final bool value;
  final int length;
  final ValueChanged<bool> onChanged;

  @override
  _PinAuthenticationWidgetState createState() => _PinAuthenticationWidgetState();
}

class _PinAuthenticationWidgetState extends State<_PinAuthenticationWidget> {
  bool value = false;
  int length = 4;

  @override
  void initState() {
    value = widget.value;
    length = widget.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LearningPinAuthentication(
             viewInsets: MediaQuery.of(context).viewInsets,
              length: length,
              obscureText: value,
              label: context.knobs.string(
                label: 'Label',
                initialValue: 'Label',
              ),
              blinkWhenObscuring: context.knobs.boolean(
                label: 'blink When Obscuring',
                initialValue: false,
              )
                  ? true
                  : false,
              errorMessage: 'Error message',
              obfuscateLabel: context.knobs.string(
                label: 'Obfuscate label',
                initialValue: !value ? 'Hide' : 'Show',
              ),
              showIndex: context.knobs.boolean(
                label: 'Show index',
                initialValue: false,
              )
                  ? true
                  : false,
              isError: context.knobs.boolean(
                label: 'Is Error',
                initialValue: false,
              )
                  ? true
                  : false,
              onTapHideText: (_) {
                setState(() {
                  value = !value;
                  widget.onChanged(value);
                });
              },
              onChanged: (value) {
                log(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}