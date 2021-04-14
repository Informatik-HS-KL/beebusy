import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDropDown<T> extends StatelessWidget {
  const MyDropDown({
    @required this.possibleSelections,
    @required this.onChanged,
    @required this.valueBuilder,
    @required this.textBuilder,
    @required this.hintText,
  });

  final void Function(int) onChanged;
  final List<T> possibleSelections;
  final int Function(T) valueBuilder;
  final String Function(T) textBuilder;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      constraints: const BoxConstraints(minHeight: 40),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).hintColor),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: DropdownButtonHideUnderline(
        child: Theme(
          data: Theme.of(context).copyWith(
            focusColor: Theme.of(context).canvasColor,
          ),
          child: DropdownButton<int>(
            dropdownColor: Theme.of(context).canvasColor,
            isDense: true,
            hint: BrownText(hintText),
            icon: Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).primaryColor,
            ),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Theme.of(context).primaryColor),
            onChanged: onChanged,
            items: possibleSelections.map<DropdownMenuItem<int>>(
              (T value) {
                return DropdownMenuItem<int>(
                  value: valueBuilder(value),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 190),
                    child: Text(
                      textBuilder(value),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}

class TeamMemberContainer extends StatelessWidget {
  const TeamMemberContainer({
    @required this.name,
    @required this.onPressed,
    this.removable = true,
  });

  final String name;
  final VoidCallback onPressed;
  final bool removable;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.only(left: 16, right: 8),
      constraints: const BoxConstraints(minHeight: 40, maxWidth: 250),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: BrownText(
              name,
              isBold: true,
            ),
          ),
          const SizedBox(width: 8),
          if (removable)
            IconButton(
              icon: const Icon(
                Icons.cancel,
                size: 16,
              ),
              color: Theme.of(context).primaryColor,
              onPressed: onPressed,
            )
          else
            Container(
              width: 16,
              height: 16,
            ),
        ],
      ),
    );
  }
}
