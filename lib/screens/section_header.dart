import 'package:flutter/material.dart';
import 'package:loja/common/custom_icon_buttom.dart';
import 'package:loja/models/home_manager.dart';
import 'package:loja/models/section.dart';
import 'package:provider/provider.dart';

class SectionHeader extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    final section = context.watch<Section>();

    if (homeManager.editing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  initialValue: section.name,
                  decoration: const InputDecoration(
                    hintText: "Título",
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                  onChanged: (text) => section.name = text,
                ),
              ),
              CustomIconButton(
                iconData: Icons.close,
                color: Colors.white,
                onTap: () {
                  showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Excluir"),
                            content: SingleChildScrollView(
                              child: ListBody(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: <Widget>[
                                  const Text("Deseja excluir esta propaganda?")
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              // ignore: deprecated_member_use
                              FlatButton(
                                // ignore: sort_child_properties_last
                                child: const Text(
                                  "Não",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              // ignore: deprecated_member_use
                              FlatButton(
                                onPressed: () {
                                  homeManager.removeSection(section);
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Sim",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          );
                        }
                      );
                },
              ),
            ],
          ),
          if(section.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                section.error,
                style: const TextStyle(
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.w900,
                  fontSize: 17
                ),
              ),
            )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          section.name ?? "",
          textScaleFactor: 1,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
        ),
      );
    }
  }
}
