import 'package:download/download.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_core/utils/widget_to_img.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class DownloadRestaurantQR extends StatelessWidget {
  DownloadRestaurantQR({super.key, required this.qrData, required this.restaurantName});

  final String qrData;
  final String restaurantName;
  final _qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        RepaintBoundary(
          key: _qrKey,
          child: Container(
            width: 200,
            decoration: CustomTheme.drawerBoxDecoration.copyWith(
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
            ElevatedButton.icon(
              onPressed: _onDownloadQr,
              icon: const Icon(Icons.download),
              label: const Text('Descargar código QR'),
            ),
          ],
        ),
      ],
    );
  }

  void _onDownloadQr() async {
    final imgBytes = await WidgetToImg.capturePng(_qrKey);
    if (kIsWeb) {
      final stream = Stream.fromIterable(imgBytes);
      await download(stream, 'qr.png');
      return;
    }
    Share.shareXFiles(
      [XFile.fromData(imgBytes)],
      // text: 'Codigo QR de la mesa ${widget.id}',
      // subject: 'Codigo QR de la mesa ${widget.id}',
    );
  }
}
