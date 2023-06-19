import 'package:flutter/material.dart';
import 'package:loja/common/custom_icon_buttom.dart';
import 'package:loja/models/item_size.dart';
import 'package:loja/models/product.dart';
import 'package:loja/screens/edit_item_size.dart';

class SizesForm extends StatelessWidget {
  const SizesForm(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: product.sizes,
      builder: (state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const Expanded(
                  child: Text(
                    "Produto/Local:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  onTap: () {
                    state.value.add(ItemSize());
                    state.didChange(state.value);
                  },
                )
              ],
            ),
            Column(
              children: state.value.map((size) {
                return EditItemSize(
                  key: ObjectKey(size),
                  size: size,
                  onRemove: () {
                    state.value.remove(size);
                    state.didChange(state.value);
                  },
                  onMoveUp: size != state.value.first ? () {
                    final index = state.value.indexOf(size);
                    state.value.remove(size);
                    state.value.insert(index-1, size);
                    state.didChange(state.value);
                  } : null,
                  onMoveDown: size != state.value.last ? () {
                    final index = state.value.indexOf(size);
                    state.value.remove(size);
                    state.value.insert(index+1, size);
                    state.didChange(state.value);
                  } : null,
                );
              }).toList(),
            ),
            if(state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
            ),
          ],
        );
      },
    );
  }
}
