import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspeção de Segurança', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Builder(builder: (context) {
          return DrawerButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selecione um ítem para inspeção:', style: TextStyle(fontSize: 16)),
            const Divider(height: 40, color: Colors.transparent),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(20.0),
              child: FilledButton.tonal(
                  onPressed: () => Navigator.pushNamed(context, "/subestacao"),
                  style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)))),
                  child: const Text("Subestação"),
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(20.0),
              child: FilledButton.tonal(
                  onPressed: () => Navigator.pushNamed(context, "/usina"),
                  style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)))),
                  child: const Text("Usina")
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(20.0),
              child: FilledButton.tonal(
                  onPressed: () => Navigator.pushNamed(context, "/predio"),
                  style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)))),
                  child: const Text("Prédio Adm.")
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(20.0),
              child: FilledButton.tonal(
                  onPressed: () => Navigator.pushNamed(context, "/veiculo"),
                  style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)))),
                  child: const Text("Veículo")
              ),
            )
          ],
        ),
      ),
      drawer: const HomeDrawer(),
    );
  }
}

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(thickness: 2),
                const Text.rich(TextSpan(children: [
                  TextSpan(text: "Nome: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextSpan(text: "Bilhão\n", style: TextStyle(fontSize: 16)),
                  TextSpan(text: "Usuário: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextSpan(text: "bilhao", style: TextStyle(fontSize: 16)),
                ])),
                const Divider(thickness: 2),
                ListTile(
                  title: const Text('Mudar senha', style: TextStyle(fontSize: 16)),
                  leading: const Icon(Icons.password),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Criar novo usuário', style: TextStyle(fontSize: 16)),
                  leading: const Icon(Icons.person_add),
                  onTap: () {},
                ),
                const Spacer(),
                ListTile(
                  title: const Text('Sair', style: TextStyle(fontSize: 16)),
                  leading: const Icon(Icons.exit_to_app),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
