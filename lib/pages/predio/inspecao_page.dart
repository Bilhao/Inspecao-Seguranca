import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inspecaosegurancacipa/pages/predio/provider.dart';


class InspecaoPredioPage extends StatefulWidget {
  const InspecaoPredioPage({super.key});

  @override
  State<InspecaoPredioPage> createState() => _InspecaoPredioPageState();
}

class _InspecaoPredioPageState extends State<InspecaoPredioPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, PredioProvider provider, child) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Locais do Prédio Administrativo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                centerTitle: true,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              body: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.grey[350],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: provider.predio, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(text: 'Data: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                        TextSpan(text: provider.data, style: const TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const VerticalDivider(width: 3, color: Colors.transparent),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(text: 'Inspetor 1: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                        TextSpan(text: provider.inspetor1, style: const TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(text: 'Inspetor 2: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                        TextSpan(text: provider.inspetor2, style: const TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(text: 'Inspetor 3: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                        TextSpan(text: provider.inspetor3, style: const TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                        child: const Text("Selecione um local para inspeção: ", style: TextStyle(fontSize: 16)),
                      )
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                        child: SingleChildScrollView(
                          child: Column(
                              children: [
                                for (int i = 0; i < provider.itensId.length; i++)
                                  Container(
                                    width: double.maxFinite,
                                    padding: const EdgeInsets.all(3.0),
                                    child: FilledButton.tonal(
                                      onPressed: () => Navigator.pushNamed(context, "/perguntas-predio", arguments: {"id": i}),
                                      style: ButtonStyle(
                                          backgroundColor: provider.verifyAllFieldsSelected(itemId: i+1)
                                              ? WidgetStateProperty.all(Colors.grey[350])
                                              : null,
                                          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)))
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              provider.itens[i],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          provider.verifyAllFieldsSelected(itemId: i + 1)
                                              ? const Icon(Icons.check)
                                              : const Icon(Icons.chevron_right),
                                        ],
                                      )
                                    ),
                                  ),
                                const Divider(height: 110, color: Colors.transparent),
                              ]
                          ),
                        ),
                      )
                  ),
                ],
              ),
              floatingActionButton: MediaQuery.of(context).viewInsets.bottom != 0.0
                  ? null
                  : FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(context, "/inspecao-predio-resumo");
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                heroTag: "unique_tag_predio",
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                label: const Text("Finalizar"),
                icon: const Icon(Icons.check),
              )
          );
        }
    );
  }
}

