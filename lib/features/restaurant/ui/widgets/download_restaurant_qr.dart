import 'package:download/download.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_core/utils/widget_to_img.dart';
import 'package:oyt_front_widgets/widgets/snackbar/custom_snackbar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class DownloadRestaurantQR extends ConsumerWidget {
  DownloadRestaurantQR({super.key, required this.qrData, required this.restaurantName});

  final String qrData;
  final String restaurantName;
  final _qrKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        RepaintBoundary(
          key: _qrKey,
          child: Container(
            width: 200,
            decoration: ref.watch(themeProvider.notifier).drawerBoxDecoration.copyWith(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12),
                ),
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                QrImage(data: qrData),
                const Text(
                  'Takuma',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
                const SizedBox(height: 2),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Código QR: ', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 15),
            SizedBox(
              width: size.width - 600,
              child: const Text(
                'Si deseas mostrarle a tus clientes el código QR de tu restaurante, puedes descargarlo y compartirlo en tus redes sociales.',
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: size.width - 600,
              child: const Text(
                'Nota: para hacer uso de comunicación en tiempo real, interacción con mesero, cocina y entre otros genera un codigo QR para cada mesa de tu restaurante. Éste QR solo habilita la visualización del menú.',
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: _onDownloadQr,
                  icon: const Icon(Icons.download),
                  label: const Text('Descargar código QR'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _onCopyToClipboard(context),
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar codigo al portapapeles'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _onCopyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: qrData));
    if (context.mounted) CustomSnackbar.showSnackBar(context, 'Código QR copiado al portapapeles');
  }

  void _onDownloadQr() async {
    final imgBytes = await WidgetToImg.capturePng(_qrKey);
    if (kIsWeb) {
      final stream = Stream.fromIterable(imgBytes);
      await download(stream, '${restaurantName}_qr.png');
      return;
    }
    Share.shareXFiles(
      [XFile.fromData(imgBytes)],
      text: '$restaurantName codigo QR de la mesa $qrData',
      subject: '$restaurantName codigo QR de la mesa $qrData',
    );
  }
}
