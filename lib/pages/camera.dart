import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  final dynamic provider;
  final int itemId;
  final int perguntaId;

  const CameraPage({
    super.key,
    required this.provider,
    required this.itemId,
    required this.perguntaId,
  });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late SaveConfig _saveConfig;

  @override
  void initState() {
    super.initState();
    _saveConfig = SaveConfig.photo(
      pathBuilder: (sensors) async {
        final Directory tempDir = await getTemporaryDirectory();
        final String filePath = '${tempDir.path}/${widget.itemId}_${widget.perguntaId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        return SingleCaptureRequest(filePath, sensors.first);
      },
    );
  }

  void _handleMediaCapture(MediaCapture event) {
    if (event.status == MediaCaptureStatus.failure) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao capturar imagem!', style: TextStyle(fontSize: 15)),
          showCloseIcon: true,
        ),
      );
    } else if (event.status == MediaCaptureStatus.success) {
      Navigator.pop(context);
      event.captureRequest.when(
        single: (single) => _showConfirmationDialog(File(single.file!.path)),
      );
    }
  }

  void _showConfirmationDialog(File imageFile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmação", style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
        content: Image(
          image: FileImage(imageFile),
          fit: BoxFit.contain,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraPage(
                    provider: widget.provider,
                    itemId: widget.itemId,
                    perguntaId: widget.perguntaId,
                  ),
                ),
              );
            },
            style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)))),
            child: const Text("Tirar novamente"),
          ),
          TextButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );
              await widget.provider.saveFoto(itemId: widget.itemId, perguntaId: widget.perguntaId, fotoPath: imageFile.path);
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Foto salva com sucesso!', style: TextStyle(fontSize: 15)),
                  showCloseIcon: true,
                ),
              );
              Navigator.pop(context);
            },
            style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)))),
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraAwesomeBuilder.awesome(
        onMediaCaptureEvent: _handleMediaCapture,
        saveConfig: _saveConfig,
        enablePhysicalButton: true,
        previewAlignment: Alignment.center,
        previewFit: CameraPreviewFit.contain,
        progressIndicator: const Center(child: CircularProgressIndicator()),
        theme: AwesomeTheme(
          bottomActionsBackgroundColor: Theme.of(context).colorScheme.primary.withAlpha(128),
        ),
        middleContentBuilder: (state) => const Column(children: []),
        bottomActionsBuilder: (state) => AwesomeBottomActions(
          state: state,
          padding: const EdgeInsets.symmetric(vertical: 15),
          left: AwesomeCameraSwitchButton(
            state: state,
            scale: 1.0,
            onSwitchTap: (state) => state.switchCameraSensor(aspectRatio: state.sensorConfig.aspectRatio),
          ),
          right: const SizedBox(),
        ),
      ),
    );
  }
}
