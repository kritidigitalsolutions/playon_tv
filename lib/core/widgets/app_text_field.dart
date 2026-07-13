// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/static/app_color.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final double radius;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;
  final bool autofocus;
  final bool enabled;
  final void Function(String)? onChanged;
  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.maxLength,
    this.radius = 30,
    this.focusNode,
    this.onSubmitted,
    this.autofocus = false,
    this.enabled = true,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  // The node D-pad traversal lands on. Distinct from the text field's own
  // editing focus node, so arrow keys don't get eaten by the cursor until
  // the person explicitly presses select to "enter" the field.
  late FocusNode _outerNode;
  late FocusNode _innerNode;
  bool _editing = false;
  bool _outerFocused = false;

  @override
  void initState() {
    super.initState();
    _outerNode = FocusNode(debugLabel: 'AppTextField-outer');
    _innerNode =
        widget.focusNode ?? FocusNode(debugLabel: 'AppTextField-inner');
    _outerNode.addListener(_onOuterFocusChange);
    _innerNode.addListener(_onInnerFocusChange);
  }

  void _onOuterFocusChange() {
    setState(() => _outerFocused = _outerNode.hasFocus);
  }

  void _onInnerFocusChange() {
    // If the text field loses focus (e.g. user tapped elsewhere), fall
    // back out of editing mode so arrows work again next time this
    // widget is reached.
    if (!_innerNode.hasFocus && _editing) {
      setState(() => _editing = false);
    }
  }

  KeyEventResult _onOuterKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.select ||
          key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.gameButtonA) {
        setState(() => _editing = true);
        _innerNode.requestFocus();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _onInnerKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      // Back/Escape releases typing mode and returns control to the
      // outer node so arrow-key grid navigation resumes.
      if (key == LogicalKeyboardKey.escape ||
          key == LogicalKeyboardKey.goBack) {
        setState(() => _editing = false);
        _outerNode.requestFocus();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _outerNode.removeListener(_onOuterFocusChange);
    _innerNode.removeListener(_onInnerFocusChange);
    _outerNode.dispose();
    if (widget.focusNode == null) _innerNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _outerNode,
      autofocus: widget.autofocus,
      onKeyEvent: _onOuterKey,
      // While not editing, the inner TextFormField can't steal focus
      // via arrow-key traversal — only the explicit requestFocus() call
      // in _onOuterKey can activate it.
      descendantsAreFocusable: _editing,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(
            color: _outerFocused && !_editing
                ? Colors.white.withOpacity(0.9)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: SizedBox(
          height: 50,
          child: TextFormField(
            onChanged: widget.onChanged,
            controller: widget.controller,
            focusNode: _innerNode,
            enabled: widget.enabled,
            style: text15(fontWeight: FontWeight.bold),
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            validator: widget.validator,
            inputFormatters: widget.inputFormatters,
            maxLength: widget.maxLength,
            cursorColor: AppColors.button,
            textInputAction: TextInputAction.search,

            onFieldSubmitted: (_) {
              widget.onSubmitted?.call();
              setState(() => _editing = false);
              _outerNode.requestFocus();
            },

            // Attach the escape/back handler only on the inner node's
            // own Focus scope — this needs its own Focus wrapper since
            // TextFormField manages its own internally otherwise.
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: AppColors.white12,

              hintText: widget.hintText,
              hintStyle: text14(color: AppColors.textSecondary),

              prefixIcon: widget.prefixIcon,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 44,
                minHeight: 44,
              ),

              suffixIcon: widget.suffixIcon,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 44,
                minHeight: 44,
              ),

              isDense: true,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius),
                borderSide: BorderSide.none,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius),
                borderSide: BorderSide(color: AppColors.white12),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius),
                borderSide: const BorderSide(color: AppColors.button, width: 2),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius),
                borderSide: const BorderSide(color: Colors.red),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int? maxLength;
  final double radius;

  const NumberTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLength,
    this.radius = 30,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      keyboardType: TextInputType.number,
      radius: radius,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: maxLength,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter number";
        }
        return null;
      },
    );
  }
}
