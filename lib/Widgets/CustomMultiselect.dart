import 'package:flutter/material.dart';

class CustomMultiselect extends StatefulWidget {
  final String labelText;
  final TextStyle labelTextStyle;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final List<String> itemText;
  final List<IconData>? itemIcons;
  final List<String>? initialValues;
  final Function(List<String>)? onValueChange;

  final Color optionListBackgroundColor;
  final Color optionListTextColor;
  final double optionListBorderRadius;

  const CustomMultiselect({
    Key? key,
    this.labelText = 'Wybierz',
    this.labelTextStyle = const TextStyle(color: Colors.black),
    this.backgroundColor = Colors.grey,
    this.borderColor = Colors.grey,
    this.borderRadius = 0.0,
    this.optionListBackgroundColor = Colors.grey,
    this.optionListTextColor = Colors.black,
    this.optionListBorderRadius = 0.0,
    required this.itemText,
    this.itemIcons,
    this.initialValues,
    this.onValueChange,
  }) : super(key: key);

  @override
  _MultiselectState createState() => _MultiselectState();
}

class _MultiselectState extends State<CustomMultiselect> {
  GlobalKey actionKey = GlobalKey();
  bool isDropdownOpened = false;
  late double _height, _width, _xPosition, _yPosition;
  late OverlayEntry floatingDropdown;
  late List<String> selectedValues;

  @override
  void initState() {
    super.initState();
    selectedValues = widget.initialValues ?? [];
  }

  void findDropdownData() {
    final renderBox = actionKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      _height = renderBox.size.height;
      _width = renderBox.size.width;
      final offset = renderBox.localToGlobal(Offset.zero);
      _xPosition = offset.dx;
      _yPosition = offset.dy;
    }
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: _xPosition,
          top: _yPosition + _height,
          width: _width,
          height: 240,
          child: DropDown(
              itemsText: widget.itemText,
              itemIcons: widget.itemIcons,
              borderRadius: widget.optionListBorderRadius,
              backgroundColor: widget.optionListBackgroundColor,
              textColor: widget.optionListTextColor,
              initialValues: selectedValues,
              onSelectionChange: (updatedValues) {
                setState(() {
                  selectedValues = updatedValues;
                });
                widget.onValueChange?.call(selectedValues);
              }
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    Color iconColor = widget.labelTextStyle?.color ?? Colors.black;
    return GestureDetector(
        key: actionKey,
        onTap: (){
          setState(() {
            if (isDropdownOpened) {
              floatingDropdown.remove();
            } else {
              findDropdownData();
              floatingDropdown = _createFloatingDropdown();
              Overlay.of(context).insert(floatingDropdown);
            }
            isDropdownOpened = !isDropdownOpened;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(
              color: widget.borderColor!,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius!),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  selectedValues.isNotEmpty
                      ? selectedValues.join(', ')
                      : widget.labelText,
                  style: widget.labelTextStyle,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              SizedBox(width: 8),
              isDropdownOpened
                  ? Icon(Icons.arrow_drop_up, color: iconColor)
                  : Icon(Icons.arrow_drop_down, color: iconColor),
            ],
          ),
        )
    );
  }
}

class DropDown extends StatelessWidget {
  final double itemHeight;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final List<String> itemsText;
  final List<IconData>? itemIcons;
  final List<String>? initialValues;
  final Function(List<String>)? onSelectionChange;

  const DropDown({
    Key? key,
    this.itemHeight = 20.0,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.black,
    this.borderRadius = 0.0,
    required this.itemsText,
    this.itemIcons,
    this.initialValues,
    this.onSelectionChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> selectedValues = List<String>.from(initialValues as Iterable) ?? [];
    return Material(
      elevation: 30,
      color: backgroundColor!.withOpacity(0.5),
      borderRadius: BorderRadius.circular(borderRadius!),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor!.withOpacity(0.5),
          borderRadius: BorderRadius.circular(borderRadius!),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(itemsText.length, (index) => DropDownItem(
              text: itemsText[index],
              isSelected: selectedValues.contains(itemsText[index]),
              iconData: itemIcons != null ? itemIcons![index] : null,
              color: backgroundColor,
              textColor: textColor,
              onSelected: (isSelected) {
                if (isSelected) {
                  selectedValues.add(itemsText[index]);
                } else {
                  selectedValues.remove(itemsText[index]);
                }
                onSelectionChange?.call(selectedValues);
              },
            ),
            ),
          ),
        ),
      ),
    );
  }
}


class DropDownItem extends StatefulWidget {
  final String text;
  final IconData? iconData;
  bool isSelected;
  final Color color;
  final Color textColor;
  final Function(bool isSelected)? onSelected;

  DropDownItem({
    super.key,
    required this.text,
    this.iconData,
    this.isSelected = false,
    this.color = Colors.grey,
    this.textColor = Colors.black,
    this.onSelected,
  });

  @override
  _DropDownItemState createState() => _DropDownItemState();
}

class _DropDownItemState extends State<DropDownItem> {

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
        widget.onSelected?.call(widget.isSelected);
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: widget.isSelected ? lightenColor(widget.color) : widget.color.withOpacity(0.7),
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Row(
          children: [
            Text(
              widget.text,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Icon(widget.iconData, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

Color lightenColor(Color color, [double amount = 0.2]) {
  assert(amount >= 0.0 && amount <= 1.0);

  int r = (color.red * (1 + amount)).toInt();
  int g = (color.green * (1 + amount)).toInt();
  int b = (color.blue * (1 + amount)).toInt();

  return Color.fromRGBO(r, g, b, color.opacity);
}

