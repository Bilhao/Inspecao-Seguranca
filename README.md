# Inspeção de Segurança CIPA

Aplicativo Flutter para inspeções de segurança da CIPA (Comissão Interna de Prevenção de Acidentes), permitindo o registro, acompanhamento e exportação de inspeções em prédios, subestações, usinas e veículos.

## Funcionalidades

- Cadastro e gerenciamento de inspeções por tipo (Prédio, Subestação, Usina, Veículo)
- Registro de respostas e observações para cada item/pergunta da inspeção
- Captura e upload de fotos para cada pergunta, com compressão automática e armazenamento no Firebase Storage
- Exportação dos dados da inspeção em formato XLSX (Excel), com opção de salvar localmente ou enviar por e-mail
- Histórico de inspeções realizadas
- Interface amigável e responsiva
- Suporte a múltiplos inspetores por inspeção
- Autenticação e permissões de acesso (em desenvolvimento)
- Suporte a internacionalização (idioma principal: Português)

## Estrutura do Projeto

```
lib/
  main.dart
  firebase_options.dart
  models/
    data.dart
    firebase_server.dart
    save.dart
  pages/
    home_page.dart
    camera.dart
    predio/
      predio_page.dart
      inspecao_page.dart
      perguntas_page.dart
      provider.dart
      resumo_page.dart
    subestacao/
      subestacao_page.dart
      inspecao_page.dart
      perguntas_page.dart
      provider.dart
      resumo_page.dart
    usina/
      usina_page.dart
      inspecao_page.dart
      perguntas_page.dart
      provider.dart
      resumo_page.dart
    veiculo/
      veiculo_page.dart
      inspecao_page.dart
      perguntas_page.dart
      provider.dart
      resumo_page.dart
  utils/
    permissions.dart
    routes.dart
assets/
  (imagens, ícones, etc)
```

## Instalação

1. **Pré-requisitos**:

   - Flutter SDK instalado ([documentação oficial](https://docs.flutter.dev/get-started/install))
   - Conta no Firebase e projeto configurado (ver abaixo)
   - Android Studio ou VS Code

2. **Clone o repositório**:

   ```sh
   git clone https://github.com/seu-usuario/inspecao-seguranca-cipa.git
   cd inspecao-seguranca-cipa
   ```

3. **Instale as dependências**:

   ```sh
   flutter pub get
   ```

4. **Configuração do Firebase**:

   - Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
   - Ative o Firebase Storage
   - Baixe o arquivo `google-services.json` (Android) e/ou `GoogleService-Info.plist` (iOS) e coloque nas pastas correspondentes (`android/app` e `ios/Runner`)
   - Configure o arquivo `lib/firebase_options.dart` (gerado pelo [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/))

5. **Variáveis de ambiente**:

   - Crie um arquivo `.env` na raiz do projeto para armazenar variáveis sensíveis (exemplo: chaves de API, configurações de e-mail)

6. **Execute o app**:
   ```sh
   flutter run
   ```

## Uso

1. Escolha o tipo de inspeção (Prédio, Subestação, Usina, Veículo)
2. Preencha os dados iniciais (nome do local, data, inspetores)
3. Responda às perguntas de cada item, adicione observações e fotos se necessário
4. Finalize a inspeção e escolha salvar localmente ou enviar por e-mail (arquivo XLSX gerado automaticamente)
5. As fotos são comprimidas e enviadas para o Firebase Storage, com links inseridos no relatório

## Tecnologias Utilizadas

- [Flutter](https://flutter.dev/)
- [Firebase (Storage, Core)](https://firebase.google.com/)
- [Provider](https://pub.dev/packages/provider)
- [Syncfusion Flutter XLSX](https://pub.dev/packages/syncfusion_flutter_xlsio) (para geração de planilhas)
- [flutter_image_compress](https://pub.dev/packages/flutter_image_compress)
- [path_provider](https://pub.dev/packages/path_provider)
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
- [flutter_localizations](https://pub.dev/packages/flutter_localizations)

## Estrutura dos Dados

- Cada inspeção é composta por itens, perguntas, respostas, observações e fotos
- As fotos são armazenadas no Firebase Storage e os links são inseridos na planilha gerada
- Os dados podem ser exportados em XLSX para análise posterior

## Licença

Este projeto é de uso restrito e propriedade da empresa. Não é permitido uso, cópia, distribuição ou modificação sem autorização expressa dos responsáveis legais.

## Contato

Dúvidas, sugestões ou problemas? Abra uma issue ou envie um e-mail para [rafaelr.bilhao@gmail.com](mailto:rafaelr.bilhao@gmail.com).
