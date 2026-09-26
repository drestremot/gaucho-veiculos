import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/vehicle_model.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../screens/vehicle_detail_screen.dart';

class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final installment = (vehicle.price * 0.7 * 1.35) / 48;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VehicleDetailScreen(
                vehicle: vehicle,
                isFavorite: isFavorite,
                onFavoriteToggle: onFavoriteToggle,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem e Badges
            Stack(
              children: [
                SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: Image.network(
                    vehicle.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.bgDark,
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.car,
                          size: 48,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AppTheme.bgDark,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Gradiente escuro para contraste
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                ),

                // Badges Superiores
                Positioned(
                  top: 10,
                  left: 10,
                  child: Row(
                    children: [
                      if (vehicle.isNew)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.bolt,
                                size: 10,
                                color: AppTheme.bgDark,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '0km',
                                style: TextStyle(
                                  color: AppTheme.bgDark,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (vehicle.badges.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppTheme.borderGlass),
                          ),
                          child: Text(
                            vehicle.badges.first,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Botão de Favoritar
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: isFavorite
                          ? AppTheme.primary
                          : Colors.black.withValues(alpha: 0.6),
                      child: FaIcon(
                        isFavorite
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        size: 16,
                        color: isFavorite ? AppTheme.bgDark : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Informações do Carro
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vehicle.brand.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          vehicle.isNew ? 'Novo' : 'Seminovo',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Nome do Veículo
                  Text(
                    vehicle.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Grid de Especificações Rápidas
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.bgDark.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderSubtle),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSpecChip(
                          FontAwesomeIcons.calendar,
                          vehicle.year.split('/')[0].trim(),
                        ),
                        _buildSpecChip(
                          FontAwesomeIcons.road,
                          AppConstants.formatKm(vehicle.mileage),
                        ),
                        _buildSpecChip(
                          FontAwesomeIcons.gasPump,
                          vehicle.fuel,
                        ),
                        _buildSpecChip(
                          FontAwesomeIcons.gears,
                          vehicle.transmission.split(' ')[0],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Preço e Botões
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (vehicle.oldPrice != null)
                            Text(
                              AppConstants.formatBRL(vehicle.oldPrice!),
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            AppConstants.formatBRL(vehicle.price),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            '48x de aprox. ${AppConstants.formatBRL(installment)}',
                            style: const TextStyle(
                              color: AppTheme.accentGold,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      // Botão WhatsApp Rápido
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.whatsappGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const FaIcon(
                          FontAwesomeIcons.whatsapp,
                          size: 15,
                        ),
                        label: const Text(
                          'Negociar',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          AppConstants.openWhatsApp(
                            'Olá! Tenho interesse no ${vehicle.name} (${AppConstants.formatBRL(vehicle.price)}) que vi no App.',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecChip(FaIconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(
          icon,
          size: 11,
          color: AppTheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
