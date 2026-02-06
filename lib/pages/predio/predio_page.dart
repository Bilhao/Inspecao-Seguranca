import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inspecaosegurancacipa/pages/predio/provider.dart';

class PredioPage extends StatefulWidget {
  const PredioPage({super.key});

  @override
  State<PredioPage> createState() => _PredioPageState();
}

class _PredioPageState extends State<PredioPage> {
  final predios = ["1", "2", "3"];

  String? dropMenuerrorText;
  String? textFielderrorText;

  @override
  Widget build(BuildContext context) {
    return Consumer<PredioProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Inspeção do Prédio Administrativo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Escolha o Prédio Administrativo: ", style: TextStyle(fontSize: 16)),
                    const Divider(height: 15, color: Colors.transparent),
                    DropdownMenu(
                      width: double.maxFinite,
                      initialSelection: provider.predio,
                      onSelected: (value) {
                        setState(() {
                          dropMenuerrorText = null;
                        });
                        provider.predio = value.toString();
                      },
                      inputDecorationTheme: const InputDecorationTheme(
                        filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(8))),
                        errorStyle: TextStyle(fontSize: 13, color: Colors.red),
                      ),
                      menuStyle: const MenuStyle(
                          alignment: Alignment.bottomLeft,
                          maximumSize: WidgetStatePropertyAll(Size.fromHeight(500))
                      ),
                      errorText: dropMenuerrorText,
                      dropdownMenuEntries: predios
                          .map((predio) => DropdownMenuEntry(value: predio, label: predio))
                          .toList(),
                    ),
                    const Divider(height: 30),
                    Row(
                      children: [
                        const Text("Data da Inspeção: ", style: TextStyle(fontSize: 16)),
                        const VerticalDivider(width: 15, color: Colors.transparent),
                        Text(provider.data, style: const TextStyle(fontSize: 16)),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                                initialDate: DateTime(
                                    int.parse(provider.data.split("/")[2]),
                                    int.parse(provider.data.split("/")[1]),
                                    int.parse(provider.data.split("/")[0])
                                )
                            );
                            if (pickedDate != null) {
                              provider.data = "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                            }
                          },
                          icon: const Icon(Icons.calendar_month),
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          ),
                        )
                      ],
                    ),
                    const Divider(height: 30),
                    const Text("Inspetores: ", style: TextStyle(fontSize: 16)),
                    const Divider(height: 15, color: Colors.transparent),
                    TextFormField(
                      initialValue: provider.inspetor1,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: "Nome (obrigatório)",
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(8))),
                        errorStyle: const TextStyle(fontSize: 13, color: Colors.red),
                        errorText: textFielderrorText,
                      ),
                      onTap: () {
                        setState(() {
                          textFielderrorText = null;
                        });
                      },
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onChanged: (value) {
                        provider.inspetor1 = value;
                      },
                    ),
                    const Divider(height: 15, color: Colors.transparent),
                    TextFormField(
                      initialValue: provider.inspetor2,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: "Nome (opicional)",
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onChanged: (value) {
                        provider.inspetor2 = value;
                      },
                    ),
                    const Divider(height: 15, color: Colors.transparent),
                    TextFormField(
                      initialValue: provider.inspetor3,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: "Nome (opcional)",
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onChanged: (value) {
                        provider.inspetor3 = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: MediaQuery.of(context).viewInsets.bottom != 0.0
              ? null
              : FloatingActionButton.extended(
                onPressed: () {
                  if (provider.predio == "" || provider.inspetor1 == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Preencha todos os itens para prosseguir!', style: TextStyle(fontSize: 15)),
                        showCloseIcon: true,
                      ),
                    );
                    setState(() {
                      if (provider.predio == "") {
                        dropMenuerrorText = "* Campo Obrigatório";
                      }
                      if (provider.inspetor1 == "") {
                        textFielderrorText = "* Campo Obrigatório";
                      }
                    });
                  } else {
                    Navigator.pushNamed(context, "/inspecao-predio", arguments: {"id": 0});
                  }
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                label: const Text("Prosseguir"),
                icon: const Icon(Icons.chevron_right),
              ),
          );
        }
    );
  }
}
