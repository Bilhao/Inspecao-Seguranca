import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inspecaosegurancacipa/pages/camera.dart';
import 'package:inspecaosegurancacipa/pages/subestacao/provider.dart';

class PerguntasSubestacaoPage extends StatefulWidget {
  const PerguntasSubestacaoPage({super.key, required this.id});

  final int id;

  @override
  State<PerguntasSubestacaoPage> createState() => _PerguntasSubestacaoPageState();
}

class _PerguntasSubestacaoPageState extends State<PerguntasSubestacaoPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubestacaoProvider>(context, listen: false);

    final itemId = provider.itensId[widget.id];
    final item = provider.itens[widget.id];

    return Scaffold(
      appBar: AppBar(
        title: Text("$itemId. $item", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var pergunta in provider.perguntas[itemId]!.entries) ...[
                Text("${pergunta.key}.  ${pergunta.value}", style: const TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Consumer<SubestacaoProvider>(
                      builder: (context, provider, child) {
                        return RadioMenuButton(
                          value: "SIM",
                          groupValue: provider.respostas[itemId]![pergunta.key],
                          style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.transparent)),
                          onChanged: (value) {
                            provider.saveResposta(itemId: itemId, perguntaId: pergunta.key, resposta: value!);
                          },
                          child: const Text("Sim", style: TextStyle(fontSize: 16)),
                        );
                      }
                    ),
                    const SizedBox(width: 20),
                    Consumer<SubestacaoProvider>(
                        builder: (context, provider, child) {
                        return RadioMenuButton(
                          value: "NÃO",
                          groupValue: provider.respostas[itemId]![pergunta.key],
                          style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.transparent)),
                          onChanged: (value) {
                            provider.saveResposta(itemId: itemId, perguntaId: pergunta.key, resposta: value!);
                          },
                          child: const Text("Não", style: TextStyle(fontSize: 16)),
                        );
                      }
                    ),
                    const SizedBox(width: 20),
                    Consumer<SubestacaoProvider>(
                        builder: (context, provider, child) {
                        return RadioMenuButton(
                          value: "N/A",
                          groupValue: provider.respostas[itemId]![pergunta.key],
                          style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.transparent)),
                          onChanged: (value) {
                            provider.saveResposta(itemId: itemId, perguntaId: pergunta.key, resposta: value!);
                          },
                          child: const Text("N/A", style: TextStyle(fontSize: 16)),
                        );
                      }
                    ),
                    const Spacer(),
                    Consumer<SubestacaoProvider>(
                      builder: (context, provider, child) {
                        return provider.fotoExists(itemId: itemId, perguntaId: pergunta.key)
                          ? IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Visualização", style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                                  content: Image(
                                    image: FileImage(File(provider.fotos[itemId]![pergunta.key]!)),
                                    fit: BoxFit.contain,
                                  ),
                                  actionsAlignment: MainAxisAlignment.spaceBetween,
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CameraPage(
                                              provider: provider,
                                              itemId: itemId,
                                              perguntaId: pergunta.key,
                                            );
                                          }
                                        );
                                      },
                                      style: ButtonStyle(
                                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ))
                                      ),
                                      child: const Text("Editar"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        provider.excluirFoto(itemId: itemId, perguntaId: pergunta.key);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Foto excluída com sucesso!', style: TextStyle(fontSize: 15)),
                                            showCloseIcon: true,
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ))
                                      ),
                                      child: const Text("Apagar"),
                                    ),
                                  ]
                                )
                              );
                            },
                            icon: Icon(Icons.image),
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                            ),
                          )
                            : const SizedBox();
                      }
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return CameraPage(
                            provider: provider,
                            itemId: itemId,
                            perguntaId: pergunta.key,
                          );
                        }));
                      },
                      icon: const Icon(Icons.camera_alt),
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 10, color: Colors.transparent),
                TextFormField(
                  initialValue: provider.observacoes[itemId]![pergunta.key],
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: "Observação",
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onChanged: (value) {
                    provider.saveObservacao(itemId: itemId, perguntaId: pergunta.key, observacao: value);
                  },
                ),
                const Divider(height: 30),
              ],
              const Divider(height: 100, color: Colors.transparent),
            ],
          )
        )
      ),
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom != 0.0
        ? null
        : FloatingActionButton.extended(
          onPressed: () {
            bool allFieldsSelected = provider.verifyAllFieldsSelected(itemId: itemId);
            if (allFieldsSelected) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Preencha todos os itens para prosseguir!', style: TextStyle(fontSize: 15)),
                  showCloseIcon: true,
                ),
              );
            }
          },
          backgroundColor: Theme.of(context).primaryColor,
          heroTag: 'unique_tag_${widget.id}',
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          label: const Text("Prosseguir"),
          icon: const Icon(Icons.chevron_right),
      ),
    );
  }
}
