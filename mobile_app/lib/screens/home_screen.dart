import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../data/mock_data.dart';
import '../widgets/category_chip.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/search_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  final AppState state;
  final Function(int) onNavigateTab;

  const HomeScreen({
    super.key,
    required this.state,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController(text: state.searchQuery);

    return Scaffold(
      backgroundColor: AppTheme.bgBody,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar no Topo
            SearchBarWidget(
              controller: searchController,
              onChanged: (val) {
                state.setSearchQuery(val);
                onNavigateTab(1); // Vai para a aba Estoque
              },
              onFilterTap: () => onNavigateTab(1),
            ),

            // Hero Banner com Destaque
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppTheme.bgSurfaceElevated,
                      AppTheme.bgSurface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.borderGlass),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primarySubtle,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.primary),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.solidStar,
                            size: 10,
                            color: AppTheme.accentGold,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '15 Anos de Tradição no RS',
                            style: TextStyle(
                              color: AppTheme.primaryHover,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(text: 'Encontre o Carro dos seus Sonhos com '),
                          TextSpan(
                            text: 'Garantia Total',
                            style: TextStyle(color: AppTheme.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Novos 0km a pronta entrega e seminovos com laudo cautelar 100% aprovado.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: AppTheme.bgDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const FaIcon(FontAwesomeIcons.car, size: 14),
                          label: const Text(
                            'Ver Estoque',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => onNavigateTab(1),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: AppTheme.borderGlass),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Simular'),
                          onPressed: () => onNavigateTab(2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Carrossel de Categorias
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Categorias',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            SizedBox(
              height: 46,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  CategoryChip(
                    label: 'Todos',
                    categoryKey: 'all',
                    icon: FontAwesomeIcons.borderAll,
                    isSelected: state.category == 'all',
                    onTap: () {
                      state.setCategory('all');
                      onNavigateTab(1);
                    },
                  ),
                  const SizedBox(width: 8),
                  CategoryChip(
                    label: 'SUVs',
                    categoryKey: 'suv',
                    icon: FontAwesomeIcons.carSide,
                    isSelected: state.category == 'suv',
                    onTap: () {
                      state.setCategory('suv');
                      onNavigateTab(1);
                    },
                  ),
                  const SizedBox(width: 8),
                  CategoryChip(
                    label: 'Picapes 4x4',
                    categoryKey: 'pickup',
                    icon: FontAwesomeIcons.truckPickup,
                    isSelected: state.category == 'pickup',
                    onTap: () {
                      state.setCategory('pickup');
                      onNavigateTab(1);
                    },
                  ),
                  const SizedBox(width: 8),
                  CategoryChip(
                    label: 'Sedans',
                    categoryKey: 'sedan',
                    icon: FontAwesomeIcons.car,
                    isSelected: state.category == 'sedan',
                    onTap: () {
                      state.setCategory('sedan');
                      onNavigateTab(1);
                    },
                  ),
                  const SizedBox(width: 8),
                  CategoryChip(
                    label: 'Hatches',
                    categoryKey: 'hatch',
                    icon: FontAwesomeIcons.carRear,
                    isSelected: state.category == 'hatch',
                    onTap: () {
                      state.setCategory('hatch');
                      onNavigateTab(1);
                    },
                  ),
                  const SizedBox(width: 8),
                  CategoryChip(
                    label: 'Elétricos & Híbridos',
                    categoryKey: 'eletrico',
                    icon: FontAwesomeIcons.chargingStation,
                    isSelected: state.category == 'eletrico',
                    onTap: () {
                      state.setCategory('eletrico');
                      onNavigateTab(1);
                    },
                  ),
                  const SizedBox(width: 8),
                  CategoryChip(
                    label: 'Esportivos',
                    categoryKey: 'esportivo',
                    icon: FontAwesomeIcons.gaugeHigh,
                    isSelected: state.category == 'esportivo',
                    onTap: () {
                      state.setCategory('esportivo');
                      onNavigateTab(1);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Destaques da Semana
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Destaques da Loja',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigateTab(1),
                    child: const Text(
                      'Ver Todos',
                      style: TextStyle(color: AppTheme.primary),
                    ),
                  ),
                ],
              ),
            ),

            // Lista de Carros em Destaque
            ...state.featuredVehicles.take(4).map((car) {
              return VehicleCard(
                vehicle: car,
                isFavorite: state.isFavorite(car.id),
                onFavoriteToggle: () => state.toggleFavorite(car.id),
              );
            }),

            // Banner de Estatísticas
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.bgSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('2.500+', 'Carros Entregues'),
                  _buildStatItem('99%', 'Aprovação de Crédito'),
                  _buildStatItem('4.9★', 'Avaliações Google'),
                ],
              ),
            ),

            // Depoimentos
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Text(
                'O que dizem nossos clientes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            SizedBox(
              height: 175,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: MockData.testimonials.length,
                itemBuilder: (context, index) {
                  final t = MockData.testimonials[index];
                  return Container(
                    width: 290,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.bgSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(
                            t.rating,
                            (i) => const FaIcon(
                              FontAwesomeIcons.solidStar,
                              size: 12,
                              color: AppTheme.accentGold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            '"${t.comment}"',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 14,
                              backgroundColor: AppTheme.bgSurfaceElevated,
                              child: FaIcon(
                                FontAwesomeIcons.userCheck,
                                size: 12,
                                color: AppTheme.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.name,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    t.city,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppTheme.textMuted,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppTheme.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
