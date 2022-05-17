import 'package:flutter/material.dart';
import 'package:supercab/utils/constants.dart';


enum RadioButtonTextPosition {
  right,
  left,
}

class RadioGroup<T> extends StatefulWidget {

  final T groupValue;
  final List<T> items;
  final RadioButtonBuilder Function(T value) itemBuilder;
  final void Function(T) onChanged;

  const RadioGroup.builder({
    @required this.groupValue,
    @required this.onChanged,
    @required this.items,
    @required this.itemBuilder,
  });

  @override
  _RadioGroupState<T> createState() => _RadioGroupState<T>();
}

class _RadioGroupState<T> extends State<RadioGroup<T>> {

  List<Widget> get _group => this.widget.items.map(
        (item) {
      final radioButtonBuilder = this.widget.itemBuilder(item);

      return Theme(
        data: ThemeData(unselectedWidgetColor: Colors.white,accentColor: Colors.amber),
        child: Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color:radioButtonBuilder.colors),
                borderRadius: BorderRadius.circular(10)
            ),
            height: 70,
            child: Center(
              child: RadioListTile(
                dense: true,
                value: item,
                selected: this.widget.groupValue == radioButtonBuilder,
                title: Transform.translate(offset: Offset(-16,0),child: Text(radioButtonBuilder.title, style: TextStyle(color: Colors.white),)),
                groupValue: this.widget.groupValue,
                onChanged:(v){
                  this.widget.onChanged(v);
                  setState(() {
                   if (item is RadioButtonBuilder){
                     item.colors = yellow;
                     widget.items.where((element) => element!=item).forEach((e) {
                      if (e is RadioButtonBuilder) {
                        e.colors = Colors.white;
                      }
                     });
                   }
                  });
                } ,
                secondary: Container(child: Row(mainAxisSize: MainAxisSize.min,children: radioButtonBuilder.list,)),
              ),
            ),
          ),
        ),
      );
    },
  ).toList();

  @override
  Widget build(BuildContext context) => ListView(
    shrinkWrap: true,
    children: _group,
  );
}

// import 'radio_button_text_position.dart';

class RadioButtonBuilder<T> {
  final String title;
  List<Widget> list;
  final RadioButtonTextPosition textPosition;
  Color colors;

  RadioButtonBuilder(
      {
        this.title,
        this.list,
        this.textPosition,
        this.colors
      });
}