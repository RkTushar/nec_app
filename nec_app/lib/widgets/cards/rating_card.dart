import 'package:flutter/material.dart';
import 'dart:async';
import 'package:nec_app/theme/theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Color Definitions ---
// Dark Green color for the filled state
const Color _darkGreen = Color(0xFF006633); 
// A deep teal/cyan for the selected border highlight
const Color _activeBorderColor = Color(0xFF00796B);

class RatingCard extends StatefulWidget {
  // Optional callback to handle when the rating changes
  final ValueChanged<int?>? onRatingChanged;

  const RatingCard({super.key, this.onRatingChanged});

  @override
  State<RatingCard> createState() => _RatingCardState();
}

class _RatingCardState extends State<RatingCard> {
  // 0 represents no rating selected. Valid ratings are 1 through 10.
  int _selectedRating = 0; 
  // Default hidden to avoid a brief flash before preferences load
  bool _dismissed = true;
  bool _locked = false; // once a rating is chosen, further changes are disabled
  Timer? _autoCloseTimer;
  static const String _prefsKeyHasRated = 'has_rated_app';
  static const String _prefsKeyHasShown = 'has_shown_rating_card';

  @override
  void initState() {
    super.initState();
    _restoreState();
  }

  Future<void> _restoreState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool hasRated = prefs.getBool(_prefsKeyHasRated) ?? false;
    final bool hasShown = prefs.getBool(_prefsKeyHasShown) ?? false;
    if (!mounted) return;
    if (hasShown || hasRated) {
      setState(() {
        _dismissed = true; // already shown or rated previously
        _locked = false;
      });
      return;
    }

    // Mark as shown immediately so it never appears again on future launches
    await prefs.setBool(_prefsKeyHasShown, true);
    if (!mounted) return;
    setState(() {
      _dismissed = false; // show now for the first and only time
      _locked = false;
    });
  }

  /// Toggles or sets the selected rating.
  void _handleRatingSelection(int rating) {
    if (_locked) return; // ignore further taps once selected
    setState(() {
      _selectedRating = rating;
      _locked = true;
    });
    widget.onRatingChanged?.call(rating);
    // Persist immediately so navigating away doesn't lose the state
    _persistHasRated();
    _autoCloseTimer?.cancel();
    _autoCloseTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() { _dismissed = true; });
    });
  }

  Future<void> _persistHasRated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKeyHasRated, true);
  }

  /// Builds a single, interactive rating box (1 to 10).
  Widget _buildRatingBox(int rating) {
    // Logic 1: Determine if the box should be "filled" (green background)
    // This is true if the rating is less than or equal to the selected rating.
    final bool isFilled = rating <= _selectedRating && _selectedRating != 0;
    
    // Logic 2: Determine if this is the currently selected box (to show the distinct border)
    final bool isSelected = rating == _selectedRating;

    Color backgroundColor = isFilled ? _darkGreen : Colors.white;
    Color textColor = isFilled ? Colors.white : Colors.black87;

    Border border;
    if (isSelected) {
      // Distinct active border for the selected box
      border = Border.all(color: _activeBorderColor, width: 2.5);
    } else if (!isFilled) {
      // Light border for all unselected boxes (to visually separate them)
      border = Border.all(color: Colors.grey.shade300, width: 1);
    } else {
      // No border for filled (green) boxes other than the selected one
      border = Border.all(color: _darkGreen, width: 0); 
    }

    return Expanded(
      // Use Expanded to ensure all 10 boxes take equal width
      child: GestureDetector(
        onTap: _locked ? null : () => _handleRatingSelection(rating),
        child: Container(
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: border,
          ),
          alignment: Alignment.center,
          child: Text(
            '$rating',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0,
            child: child,
          ),
        );
      },
      child: _dismissed
          ? const SizedBox.shrink(key: ValueKey('rating-card-hidden'))
          : Card(
              key: const ValueKey('rating-card-visible'),
              elevation: 0,
              color: AppColors.card,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Rating Bar Row (1 to 10)
            Row(
              children: List.generate(10, (index) => _buildRatingBox(index + 1)),
            ),

            const SizedBox(height: 8),

            // 2. Not Likely / Very Likely Labels
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Not Likely', style: TextStyle(color: Colors.black54, fontSize: 13)),
                  Text('Very Likely', style: TextStyle(color: Colors.black54, fontSize: 13)),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // 3. Action Button (NOT NOW)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() { _dismissed = true; });
                },
                child: Text(
                  'NOT NOW',
                  style: TextStyle(
                    color: _darkGreen, 
                    fontWeight: FontWeight.w600, // Semi-bold for a clear contrast
                    fontSize: 14
                  ),
                ),
              ),
            ),
          ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
  }
}