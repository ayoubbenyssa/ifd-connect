import 'package:flutter/material.dart';
import 'package:ifdconnect/reclamation/models/thematque.dart';
import 'package:ifdconnect/reclamation/provider/reclamation_provider.dart';
import 'package:ifdconnect/reclamation/widgets/drop_down_dynamic.dart';
import 'package:ifdconnect/services/Fonts.dart';

import 'package:provider/provider.dart';

class ThematiqueDropDownMenu extends StatelessWidget {
  const ThematiqueDropDownMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReclamationProvider>();
    context.select<ReclamationProvider, Thematique>((p) => p.selectedThematque);
    context.select<ReclamationProvider, List<Thematique>>(
        (p) => p.listThematiques);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      
      child: DropDownBtnWidgetDynamicList(
        color: Fonts.col_app.withOpacity(0.15),
        width: MediaQuery.of(context).size.width * 0.8,
        listItem: provider.listThematiques
            .map((item) => DropdownMenuItem<dynamic>(
                  value: item,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.72,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.53,
                          child: Text(
                            "${item.name}",
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 13.0, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                ))
            .toList(),
        hint: 'Thematique',
        onChanged: provider.onChangeThematique,
        selectedValue: provider.selectedThematque,
      ),
    );
  }
}
