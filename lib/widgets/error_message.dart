import 'package:flutter/material.dart';

class ErrorMessage extends StatefulWidget {
  final String message;
  final Color color;
  final double fontSize;

  const ErrorMessage({
    Key? key,
    required this.message,
    this.color = Colors.red,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  State<ErrorMessage> createState() => _ErrorMessageState();
}

class _ErrorMessageState extends State<ErrorMessage> with SingleTickerProviderStateMixin {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (widget.message.isEmpty || !_visible) return const SizedBox.shrink();
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: widget.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.color),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.message,
                style: TextStyle(
                  color: widget.color,
                  fontSize: widget.fontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: widget.color, size: 20),
              onPressed: () => setState(() => _visible = false),
              tooltip: 'Dismiss',
            ),
          ],
        ),
      ),
    );
  }
}

void showErrorPopup(BuildContext context, String message, {Color color = Colors.red, Duration duration = const Duration(seconds: 3)}) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 40,
      right: 24,
      child: _ErrorPopupContent(
        message: message,
        color: color,
        onClose: () => overlayEntry.remove(),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(duration, () {
    if (overlayEntry.mounted) overlayEntry.remove();
  });
}

class _ErrorPopupContent extends StatefulWidget {
  final String message;
  final Color color;
  final VoidCallback onClose;

  const _ErrorPopupContent({
    Key? key,
    required this.message,
    required this.color,
    required this.onClose,
  }) : super(key: key);

  @override
  State<_ErrorPopupContent> createState() => _ErrorPopupContentState();
}

class _ErrorPopupContentState extends State<_ErrorPopupContent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.message,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: widget.onClose,
                tooltip: 'Dismiss',
              ),
            ],
          ),
        ),
      ),
    );
  }
} 