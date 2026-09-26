import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../widgets/vehicle_card.dart';

class FavoritesScreen extends StatelessWidget {
  final AppState state;
  final Function(int) onNavigateTab;

  const FavoritesScreen({
    super.key,
    required this.state,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final favCars = state.favoriteVehicles;

    return Scaffold(
      backgroundColor: AppTheme.bgBody,
      body: favCars.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.heartCrack,
                      size: 54,
                      color: AppTheme.textMuted,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Nenhum favorito salvo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Toque no ícone de coração nos carros para salvá-los e compará-los facilmente aqui.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: AppTheme.bgDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const FaIcon(FontAwesomeIcons.car, size: 14),
                      label: const Text('Explorar Estoque'),
                      onPressed: () => onNavigateTab(1),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favCars.length,
              itemBuilder: (context, index) {
                final car = favCars[index];
                return VehicleCard(
                  vehicle: car,
                  isFavorite: true,
                  onFavoriteToggle: () => state.toggleFavorite(car.id),
                );
              },
            ),
    );
  }
}
