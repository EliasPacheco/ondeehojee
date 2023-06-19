import 'package:flutter/material.dart';
import 'package:loja/common/custom_icon_buttom.dart';
import 'package:loja/models/item_size.dart';

class EditItemSize extends StatelessWidget {
  const EditItemSize({Key key, this.size, this.onRemove, 
  this.onMoveUp, this.onMoveDown}) : super (key: key);

  final ItemSize size;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.name,
            decoration: const InputDecoration(
              labelText: "Produto/Local:",
              labelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 16
              ),
              isDense: true,
            ),
            onChanged: (name) => size.name = name,
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: size.price?.toStringAsFixed(2),
            decoration: const InputDecoration(
              labelText: "Preço:",
              labelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 16
              ),
              isDense: true,
              prefixText: "R\$:",
              prefixStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,

              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (price) => size.price = num.tryParse(price),
          ),
        ),
        CustomIconButton(
          iconData: Icons.remove,
          color: Colors.red,
          onTap: onRemove,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
          onTap: onMoveUp,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          onTap: onMoveDown,
        ),
      ],
    );
  }
}
