import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inspecaosegurancacipa/pages/veiculo/provider.dart';
import 'package:inspecaosegurancacipa/models/save.dart';

class ResumoInspecaoVeiculoPage extends StatelessWidget {
  const ResumoInspecaoVeiculoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VeiculoProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo da Inspeção', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Container(
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
                              TextSpan(text: provider.veiculo, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Divider(height: 20, color: Colors.transparent),
            Table(defaultVerticalAlignment: TableCellVerticalAlignment.middle, columnWidths: const <int, TableColumnWidth>{
              0: IntrinsicColumnWidth(flex: 1),
              1: IntrinsicColumnWidth(flex: 2),
              2: IntrinsicColumnWidth(flex: 5)
            }, children: [
              const TableRow(children: [
                Text("Itens", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Text("Respostas", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Text("Observações", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ]),
              for (var itemId in provider.itensId) ...[
                for (var pergunta in provider.perguntas[itemId]!.entries) ...[
                  TableRow(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1.0))), children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                      child: Text("$itemId.${pergunta.key}", style: const TextStyle(fontSize: 15)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                      child: Text(
                        provider.respostas[itemId]![pergunta.key] == null ? "---" : "${provider.respostas[itemId]![pergunta.key]}",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                      child: Text(provider.observacoes[itemId]![pergunta.key] == null ? "---" : "${provider.observacoes[itemId]![pergunta.key]}", style: const TextStyle(fontSize: 15)),
                    ),
                  ]),
                ]
              ]
            ]),
            const Divider(height: 100, color: Colors.transparent),
          ]),
        ),
      ),
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom != 0.0
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _buildSaveAlertDialog(context, provider),
                );
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: const Text("Salvar", style: TextStyle(fontSize: 16)),
              icon: const Icon(Icons.save),
            ),
    );
  }

  Widget _buildSaveAlertDialog(BuildContext context, VeiculoProvider provider) {
    return AlertDialog(
      icon: Icon(Icons.save, color: Theme.of(context).colorScheme.primary),
      title: const Text(
        'Salvar dados da inspeção localmente ou enviar por email?',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          style: ButtonStyle(
              fixedSize: WidgetStateProperty.all(const Size(110, 30)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ))),
          child: const Text('Localmente'),
          onPressed: () async {
            if (await veiculotoxlsx(provider: provider, sendEmail: false) && context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil("/", (Route<dynamic> route) => false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Dados salvos com sucesso!"),
                ),
              );
              provider.eraseSavedInfos();
            } else {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Erro ao salvar dados!"),
                  showCloseIcon: true,
                ),
              );
            }
          },
        ),
        TextButton(
          style: ButtonStyle(
              fixedSize: WidgetStateProperty.all(const Size(110, 30)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ))),
          child: const Text('Email'),
          onPressed: () async {
            showDialog(context: context, barrierDismissible: false, barrierColor: Colors.transparent, builder: (context) => _buildEmailAlertDialog(context, provider));
          },
        ),
      ],
    );
  }

  Widget _buildEmailAlertDialog(BuildContext context, VeiculoProvider provider) {
    TextEditingController emailController = TextEditingController();
    return AlertDialog(
      icon: Icon(Icons.save, color: Theme.of(context).colorScheme.primary),
      title: const Text(
        'Insira o email do destinatário:',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            filled: true,
            hintText: "example@gmail.com",
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          style: ButtonStyle(
              fixedSize: WidgetStateProperty.all(const Size(110, 30)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ))),
          child: const Text('Enviar'),
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(child: CircularProgressIndicator()),
            );
            bool saved = await veiculotoxlsx(provider: provider, sendEmail: true, destinatario: emailController.value.text);
            if (!context.mounted) return;
            if (saved) {
              Navigator.of(context).pushNamedAndRemoveUntil("/", (Route<dynamic> route) => false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Email enviado com sucesso!"),
                ),
              );
              provider.eraseSavedInfos();
            } else {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Erro ao enviar email!"),
                  showCloseIcon: true,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
