import 'package:flutter/material.dart';
import 'package:nec_app/widgets/fields/custom_text_field.dart';
import 'package:nec_app/widgets/buttons/primary_button.dart';

class TrackTransactionWidget extends StatefulWidget {
  final String initialText;
  final void Function(String transactionNumber)? onTrack;

  const TrackTransactionWidget({super.key, this.initialText = '', this.onTrack});

  @override
  State<TrackTransactionWidget> createState() => _TrackTransactionWidgetState();
}

class _TrackTransactionWidgetState extends State<TrackTransactionWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _controller,
          labelText: 'Example: GB00000000/000000',
          prefixIcon: Icons.qr_code_scanner_rounded,
          suffixIcon: Icons.cancel_outlined,
          onSuffixTap: () {
            _controller.clear();
            setState(() {});
          },
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Track transaction',
          onPressed: _controller.text.trim().isEmpty
              ? null
              : () {
                  final value = _controller.text.trim();
                  if (value.isEmpty) return;
                  widget.onTrack?.call(value);
                },
          enabled: _controller.text.trim().isNotEmpty,
        ),
      ],
    );
  }
}


