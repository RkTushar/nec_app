import 'package:flutter/material.dart';
import 'package:nec_app/theme/theme_data.dart';

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

  /// Toggles or sets the selected rating.
  void _handleRatingSelection(int rating) {
    setState(() {
      // If the same rating is tapped, unselect it by setting to 0, otherwise set the new rating.
      _selectedRating = (_selectedRating == rating) ? 0 : rating;
    });
    // Call the external callback with the new rating (or null if unselected)
    widget.onRatingChanged?.call(_selectedRating == 0 ? null : _selectedRating);
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
        onTap: () => _handleRatingSelection(rating),
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
    return Card(
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
                  // Placeholder for 'NOT NOW' action
                  print('NOT NOW pressed. Current rating: $_selectedRating');
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
    );
  }
}