import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_lab/learning_lab.dart';
import 'package:learning_lab/src/authentication/pin_theme.dart';
import 'package:learning_lab/src/utils/learning_spacing.dart';

import 'cursor_painter.dart';

class LearningPinAuthentication extends StatefulWidget {
  /// The [EdgeInsets] of the application for viewInsets
  /// EX: MediaQuery.of(context).viewInsets
  final EdgeInsets viewInsets;

  /// length of how many cells there should be. 4-6 is recommended.
  final int length;

  /// you already know what it does i guess :P default is false
  final bool obscureText;

  /// Widget used to obscure text
  ///
  /// it overrides the obscuringCharacter
  final Widget? obscuringWidget;

  /// Decides whether typed character should be
  /// briefly shown before being obscured
  final bool blinkWhenObscuring;

  /// Blink Duration if blinkWhenObscuring is set to true
  final Duration blinkDuration;

  /// returns the current typed text in the fields
  final ValueChanged<String>? onChanged;

  /// returns the typed text when all pins are set
  final ValueChanged<String>? onCompleted;

  /// returns the typed text when user presses done/next action on the keyboard
  final ValueChanged<String>? onSubmitted;

  /// The [onEditingComplete] callback also runs when the user finishes editing.
  /// It's different from [onSubmitted] because it has a default value which
  /// updates the text controller and yields the keyboard focus. Applications that
  /// require different behavior can override the default [onEditingComplete]
  /// callback.
  ///
  /// Set this to empty function if you don't want the keyboard to automatically close
  /// when user presses done/next.
  final VoidCallback? onEditingComplete;

  /// If the pin code field should be autofocused or not. Default is [false]
  final bool autoFocus;

  /// Should pass a [FocusNode] to manage it from the parent
  final FocusNode? focusNode;

  /// [TextEditingController] to control the text manually. Sets a default [TextEditingController()] object if none given
  final TextEditingController? controller;

  /// Auto dismiss the keyboard upon inputting the value for the last field. Default is [true]
  final bool autoDismissKeyboard;

  /// Auto dispose the [controller] and [FocusNode] upon the destruction of widget from the widget tree. Default is [true]
  final bool autoDisposeControllers;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  /// Only supports text keyboards, other keyboard types will ignore this configuration. Capitalization is locale-aware.
  /// - Copied from 'https://api.flutter.dev/flutter/services/TextCapitalization-class.html'
  /// Default is [TextCapitalization.none]
  final TextCapitalization textCapitalization;

  /// Method for detecting a pin_code form tap
  /// work with all form windows
  final Function? onTap;

  /// Theme for the pin cells. Read more [PinTheme]
  final PinTheme pinTheme;

  /// Brightness dark or light choices for iOS keyboard.
  final Brightness? keyboardAppearance;

  /// enables auto validation for the [TextFormField]
  /// Default is [AutovalidateMode.onUserInteraction]
  final AutovalidateMode autovalidateMode;

  /// Whether to show cursor or not
  final bool showCursor;

  /// Enable auto unfocus
  final bool autoUnfocus;

  /// Function to hide text
  final ValueChanged<bool>? onTapHideText;

  /// Defines label for the widget
  final String label;

  /// Defines an error message
  final String errorMessage;

  /// Defines a label for the obfuscate button
  final String obfuscateLabel;

  /// Validation error
  final bool isError;

  /// Shows the index on top of each pin
  final bool showIndex;

  const LearningPinAuthentication({
    super.key,
    required this.viewInsets,
    required this.length,
    this.obfuscateLabel = '',
    this.label = '',
    this.errorMessage = '',
    this.onTapHideText,
    this.controller,
    this.obscureText = false,
    this.showIndex = false,
    this.obscuringWidget,
    this.blinkWhenObscuring = false,
    this.blinkDuration = const Duration(milliseconds: 500),
    this.onChanged,
    this.onCompleted,
    this.autoFocus = false,
    this.focusNode,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
    this.autoDismissKeyboard = true,
    this.autoDisposeControllers = true,
    this.onSubmitted,
    this.onEditingComplete,
    this.pinTheme = const PinTheme.defaults(),
    this.keyboardAppearance,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.showCursor = true,
    this.autoUnfocus = true,
    this.isError = false,
  });

  @override
  State<LearningPinAuthentication> createState() => _LearningPinAuthenticationState();
}

class _LearningPinAuthenticationState extends State<LearningPinAuthentication>
    with TickerProviderStateMixin {
  TextEditingController? _internalController;

  late List<String> _inputList;
  late AnimationController _cursorController;
  late Animation<double> _cursorAnimation;
  FocusNode? _internalFocusNode;
  int _selectedIndex = 0;
  bool _hasBlinked = false;
  double _totalFieldWidth = 0.0;
  Timer? _blinkDebounce;

  TextEditingController get _effectiveController =>
      widget.controller ?? (_internalController ??= TextEditingController());
  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_internalFocusNode ??= FocusNode());
  @override
  void initState() {
    super.initState();
    _checkForInvalidValues();
    _initializeFocusNode();
    _initializeCursorController();
    _initializeInputList();
    _totalFieldWidth = (widget.length * widget.pinTheme.fieldWidth + (widget.length) * 8) - 8;
    _initializeTextController();
  }

  @override
  void dispose() {
    _disposeControllers();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _totalFieldWidth,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          AbsorbPointer(
            absorbing: true,
            child: _buildTextField(),
          ),
          GestureDetector(
            onTap: _handleOnTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLabel(),
                _buildPinFields(),
                if (widget.isError) _buildErrorMessage(),
                _buildObfuscateButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _initializeFocusNode() {
    _effectiveFocusNode.addListener(() {
      _setState(() {});
    });
  }

  void _initializeCursorController() {
    _cursorController =
        AnimationController(duration: widget.pinTheme.cursorAnimationDuration, vsync: this);
    _cursorAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _cursorController,
      curve: Curves.easeIn,
    ));

    if (widget.showCursor) {
      _cursorController.repeat();
    }
  }

  void _initializeInputList() {
    _inputList = List<String>.filled(widget.length, "");
    _hasBlinked = true;
  }

  void _initializeTextController() {
    if (_effectiveController.text.isNotEmpty) {
      _setTextToInput(_effectiveController.text);
    }
    _effectiveController.addListener(_textEditingControllerListener);
  }

  void _disposeControllers() {
    _effectiveController.removeListener(_textEditingControllerListener);
    if (widget.autoDisposeControllers) {
      _effectiveController.dispose();
      _internalFocusNode?.dispose();
    }
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: LearningSpacing.s01),
      child: TextFormField(
        controller: _effectiveController,
        focusNode: _effectiveFocusNode,
        autofocus: widget.autoFocus,
        autocorrect: false,
        keyboardAppearance: widget.keyboardAppearance,
        textCapitalization: widget.textCapitalization,
        autovalidateMode: widget.autovalidateMode,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(widget.length),
        ],
        onFieldSubmitted: widget.onSubmitted,
        onEditingComplete: widget.onEditingComplete,
        enableInteractiveSelection: false,
        showCursor: false,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
        style: const TextStyle(
          color: Colors.transparent,
          height: .01,
          fontSize: kIsWeb ? 1 : 0.01,
        ),
        obscureText: widget.obscureText,
      ),
    );
  }

  void _handleOnTap() {
    widget.onTap?.call();
    _onFocus();
  }

  Widget _buildLabel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: LearningSpacing.s02),
      child: Text(
        widget.label,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          height: 24 / 16,
          color: LearningColors.darkerGrey,
        ),
      ),
    );
  }

  Widget _buildPinFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: _generateFields(),
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: LearningSpacing.s01),
      child: Text(
        widget.errorMessage,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
          height: 16 / 12,
          color: widget.pinTheme.errorBorderColor,
        ),
      ),
    );
  }

  Widget _buildObfuscateButton() {
    return Padding(
      padding: const EdgeInsets.only(top: LearningSpacing.s02),
      child: GestureDetector(
        onTap: () => widget.onTapHideText?.call(widget.obscureText),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              color: LearningColors.darkTurquoise,
              size: 16.67,
              widget.obscureText ? Icons.visibility_off : Icons.visibility,
            ),
            const SizedBox(width: LearningSpacing.s02),
            Text(
              widget.obfuscateLabel,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 20 / 14,
                color: LearningColors.darkTurquoise,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _generateFields() {
    return List<Widget>.generate(widget.length, (int index) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.showIndex)
            Padding(
              padding: EdgeInsets.only(
                bottom: LearningSpacing.s01,
                right: (index + 1) == widget.length ? 0 : LearningSpacing.s02,
              ),
              child: Text(
                (index + 1).toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  height: 20 / 14,
                  color: LearningColors.darkGrey,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              right: index != widget.length - 1 ? LearningSpacing.s02 : 0,
            ),
            child: Container(
              width: widget.pinTheme.fieldWidth,
              height: widget.pinTheme.fieldHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _getColorFromIndex(index),
                  width: _getBorderWidthForIndex(index),
                ),
              ),
              child: Center(child: _buildChild(index)),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildChild(int index) {
    bool isSelectedIndex = _selectedIndex == index;
    bool isNextToSelectedIndex = _selectedIndex == index + 1 && index + 1 == widget.length;
    bool showCursor = (isSelectedIndex || isNextToSelectedIndex) &&
        _effectiveFocusNode.hasFocus &&
        widget.showCursor;

    return Stack(
      alignment: Alignment.center,
      children: [
        if (showCursor) _buildCursor(isNextToSelectedIndex),
        _renderPinField(index: index),
      ],
    );
  }

  Widget _buildCursor(bool isNextToSelectedIndex) {
    return Padding(
      padding: EdgeInsets.only(
        left: isNextToSelectedIndex ? 18 / 1.5 : 0,
        right: !isNextToSelectedIndex ? 18 / 1.5 : 0,
      ),
      child: FadeTransition(
        opacity: _cursorAnimation,
        child: CustomPaint(
          size: const Size(0, 22),
          painter: CursorPainter(
            cursorColor: LearningColors.darkerGrey,
            cursorWidth: 1,
          ),
        ),
      ),
    );
  }

  Widget _renderPinField({required int index}) {
    bool showObscured = !widget.blinkWhenObscuring && widget.obscureText ||
        (widget.blinkWhenObscuring && _hasBlinked && widget.obscureText) ||
        (index != _inputList.where((x) => x.isNotEmpty).length - 1 && widget.obscureText);

    if (showObscured && _inputList[index].isNotEmpty) {
      return widget.obscuringWidget ??
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: LearningColors.black,
              shape: BoxShape.circle,
            ),
          );
    }
    return Text(
      _inputList[index],
      key: ValueKey(_inputList[index]),
      style: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 18,
        height: 24 / 18,
        color: LearningColors.darkerGrey,
      ),
    );
  }

  Color _getColorFromIndex(int index) {
    if (_isSelectedIndex(index)) {
      return widget.pinTheme.selectedColor;
    } else if (_selectedIndex > index) {
      return widget.isError ? widget.pinTheme.errorBorderColor : widget.pinTheme.activeColor;
    }
    return widget.isError ? widget.pinTheme.errorBorderColor : widget.pinTheme.inactiveColor;
  }

  double _getBorderWidthForIndex(int index) {
    if (_isSelectedIndex(index)) {
      return widget.pinTheme.selectedBorderWidth;
    } else if (_selectedIndex > index) {
      return widget.isError ? widget.pinTheme.errorBorderWidth : widget.pinTheme.activeBorderWidth;
    }
    return widget.isError ? widget.pinTheme.errorBorderWidth : widget.pinTheme.inactiveBorderWidth;
  }

  bool _isSelectedIndex(int index) {
    return (_selectedIndex == index || _selectedIndex == index + 1 && index + 1 == widget.length) &&
        _effectiveFocusNode.hasFocus;
  }

  void _onFocus() {
    if (widget.autoUnfocus) {
      if (_effectiveFocusNode.hasFocus && widget.viewInsets.bottom == 0) {
        _effectiveFocusNode.unfocus();
        Future.delayed(const Duration(microseconds: 1), () => _effectiveFocusNode.requestFocus());
      } else {
        _effectiveFocusNode.requestFocus();
      }
    } else {
      _effectiveFocusNode.requestFocus();
    }
  }

  void _checkForInvalidValues() {
    assert(widget.length > 0);
    assert(widget.pinTheme.fieldHeight > 0);
    assert(widget.pinTheme.fieldWidth > 0);
    assert(widget.pinTheme.borderWidth >= 0);
  }

  void _textEditingControllerListener() {
    _debounceBlink();
    var currentText = _effectiveController.text;

    if (_inputList.join("") != currentText) {
      if (currentText.length >= widget.length) {
        if (widget.onCompleted != null) {
          if (currentText.length > widget.length) {
            currentText = currentText.substring(0, widget.length);
          }
          Future.delayed(const Duration(milliseconds: 300), () => widget.onCompleted!(currentText));
        }

        if (widget.autoDismissKeyboard) _effectiveFocusNode.unfocus();
      }
      _setTextToInput(currentText);
      widget.onChanged?.call(currentText);
    }
  }

  void _debounceBlink() {
    if (widget.blinkWhenObscuring &&
        _effectiveController.text.length > _inputList.where((x) => x.isNotEmpty).length) {
      _setState(() {
        _hasBlinked = false;
      });

      if (_blinkDebounce?.isActive ?? false) {
        _blinkDebounce!.cancel();
      }

      _blinkDebounce = Timer(widget.blinkDuration, () {
        _setState(() {
          _hasBlinked = true;
        });
      });
    }
  }

  void _setTextToInput(String data) async {
    var replaceInputList = List<String>.filled(widget.length, "");

    for (int i = 0; i < widget.length; i++) {
      replaceInputList[i] = data.length > i ? data[i] : "";
    }

    _setState(() {
      _selectedIndex = data.length;
      _inputList = replaceInputList;
    });
  }

  void _setState(void Function() function) {
    if (mounted) {
      setState(function);
    }
  }
}
