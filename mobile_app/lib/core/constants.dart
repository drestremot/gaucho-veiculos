import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AppConstants {
  static const String appName = 'Gaúcho Veículos';
  static const String slogan = 'Tradição, Confiança e as Melhores Ofertas';
  static const String phone = '(51) 3344-8800';
  static const String whatsappNumber = '5551999998888';
  static const String address = 'Av. das Américas, 4500 - Porto Alegre, RS';
  static const String hours = 'Seg a Sex: 08:30 às 19:00 | Sáb: 09:00 às 17:00';

  static String formatBRL(double value) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  static String formatKm(int km) {
    if (km == 0) return '0 km (Novo)';
    final formatter = NumberFormat.decimalPattern('pt_BR');
    return '${formatter.format(km)} km';
  }

  static Future<void> openWhatsApp(String message) async {
    final encodedMsg = Uri.encodeComponent(message);
    final url = Uri.parse('https://wa.me/$whatsappNumber?text=$encodedMsg');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> callPhone() async {
    final url = Uri.parse('tel:5133448800');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
