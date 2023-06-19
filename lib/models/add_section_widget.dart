import 'package:flutter/material.dart';
import 'package:loja/models/home_manager.dart';
import 'package:loja/models/section.dart';

class AddSectionWidget extends StatelessWidget {

  const AddSectionWidget(this.homeManager);

  final HomeManager homeManager;

  @override
  Widget build(BuildContext context) {

    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
            onPressed: () {
              homeManager.addSection(Section(type: "List"));
            }, 
            textColor: Colors.white,
            child: const Text("Adicionar Lista",
            style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w900,
            ),),
          ),
        ),
        Expanded(
          child: FlatButton(
            onPressed: () {
              homeManager.addSection(Section(type: "Staggered"));
            }, 
            textColor: Colors.white,
            child: const Text("Adicionar Grade",
            style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w900
            ),
            ),
          ),
        ),
      ],
    );
  }
}