import 'package:flutter/material.dart';
import 'primary_button.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const CustomDatePicker({
    super.key,
    this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _yearController;

  late int _selectedDay;
  late int _selectedMonth;
  late int _selectedYear;

  List<int> days = [];
  List<int> years = List.generate(100, (index) => DateTime.now().year - index);
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = widget.initialDate?.year ?? now.year - 16;
    _selectedMonth = widget.initialDate?.month ?? now.month;
    _selectedDay = widget.initialDate?.day ?? now.day;

    _dayController = FixedExtentScrollController(initialItem: _selectedDay - 1);
    _monthController = FixedExtentScrollController(
      initialItem: _selectedMonth - 1,
    );
    _yearController = FixedExtentScrollController(
      initialItem: years.indexOf(_selectedYear),
    );

    _updateDaysInMonth();
  }

  void _updateDaysInMonth() {
    final int daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    setState(() {
      days = List.generate(daysInMonth, (index) => index + 1);
      // Adjust day if it's no longer valid for the selected month
      if (_selectedDay > daysInMonth) {
        _selectedDay = daysInMonth;
      }
    });
  }

  Widget _buildDatePickerWheel(
    FixedExtentScrollController controller,
    List items,
    Function(int) onSelectedItemChanged,
  ) {
    return Expanded(
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 40.0,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (BuildContext context, int index) {
            final isSelected =
                (index ==
                (controller.hasClients ? controller.selectedItem : -1));
            return Center(
              child: Text(
                items[index].toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.black : Colors.grey[600],
                ),
              ),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Day wheel
                _buildDatePickerWheel(_dayController, days, (index) {
                  setState(() {
                    _selectedDay = days[index];
                  });
                }),
                // Month wheel
                _buildDatePickerWheel(_monthController, months, (index) {
                  setState(() {
                    _selectedMonth = index + 1;
                    _updateDaysInMonth();
                  });
                }),
                // Year wheel
                _buildDatePickerWheel(_yearController, years, (index) {
                  setState(() {
                    _selectedYear = years[index];
                    _updateDaysInMonth();
                  });
                }),
              ],
            ),
          ),
          PrimaryButton(
            label: 'Done',
            onPressed: () {
              final selectedDate = DateTime(
                _selectedYear,
                _selectedMonth,
                _selectedDay,
              );
              widget.onDateSelected(selectedDate);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
