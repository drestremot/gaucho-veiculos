import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int favoritesCount;
  final VoidCallback? onFavoritesTap;

  const CustomAppBar({
    super.key,
    this.title = 'GAÚCHO VEÍCULOS',
    required this.favoritesCount,
    this.onFavoritesTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.bgSurface,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryDark],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.carRear,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
              children: const [
                TextSpan(text: 'GAÚCHO '),
                TextSpan(
                  text: 'VEÍCULOS',
                  style: TextStyle(color: AppTheme.primary),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.whatsapp,
            color: AppTheme.whatsappGreen,
            size: 22,
          ),
          tooltip: 'Falar no WhatsApp',
          onPressed: () {
            AppConstants.openWhatsApp(
              'Olá! Estou usando o aplicativo da Gaúcho Veículos e gostaria de mais informações.',
            );
          },
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.heart,
                size: 20,
              ),
              onPressed: onFavoritesTap,
            ),
            if (favoritesCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$favoritesCount',
                    style: const TextStyle(
                      color: AppTheme.bgDark,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}
