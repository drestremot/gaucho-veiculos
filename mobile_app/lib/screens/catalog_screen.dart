import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/search_bar_widget.dart';

class CatalogScreen extends StatefulWidget {
  final AppState state;

  const CatalogScreen({
    super.key,
    required this.state,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.state.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final cars = state.filteredVehicles;

    return Scaffold(
      backgroundColor: AppTheme.bgBody,
      body: Column(
        children: [
          // Campo de Busca e Botão de Filtros
          SearchBarWidget(
            controller: _searchController,
            onChanged: (val) {
              state.setSearchQuery(val);
            },
            onFilterTap: () => _openFilterModal(context, state),
          ),

          // Abas de Condição (Todos / Novos 0km / Seminovos)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _buildConditionTab('Todos', 'all', state),
                const SizedBox(width: 8),
                _buildConditionTab('Novos 0km', 'novo', state),
                const SizedBox(width: 8),
                _buildConditionTab('Seminovos', 'seminovo', state),
              ],
            ),
          ),

          // Barra com Contador de Resultados e Ordenação
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${cars.length} ${cars.length == 1 ? 'veículo encontrado' : 'veículos encontrados'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: () => _openSortBottomSheet(context, state),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.arrowDownWideShort,
                        size: 12,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getSortLabel(state.sort),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Lista de Veículos ou Estado Vazio
          Expanded(
            child: cars.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.carTunnel,
                          size: 48,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Nenhum veículo encontrado',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tente alterar os termos da busca ou filtros.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () {
                            _searchController.clear();
                            state.resetFilters();
                          },
                          child: const Text('Limpar Filtros'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      return VehicleCard(
                        vehicle: car,
                        isFavorite: state.isFavorite(car.id),
                        onFavoriteToggle: () => state.toggleFavorite(car.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionTab(String label, String key, AppState state) {
    final isSelected = state.condition == key;
    return Expanded(
      child: GestureDetector(
        onTap: () => state.setCondition(key),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : AppTheme.bgSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.borderSubtle,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.bgDark : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getSortLabel(String sortKey) {
    switch (sortKey) {
      case 'price-asc':
        return 'Menor Preço';
      case 'price-desc':
        return 'Maior Preço';
      case 'year-desc':
        return 'Ano Mais Novo';
      case 'featured':
      default:
        return 'Destaques';
    }
  }

  void _openSortBottomSheet(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ordenar Veículos Por:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSortOption(context, state, 'Destaques da Loja', 'featured'),
                _buildSortOption(context, state, 'Menor Preço', 'price-asc'),
                _buildSortOption(context, state, 'Maior Preço', 'price-desc'),
                _buildSortOption(context, state, 'Ano mais Novo', 'year-desc'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    AppState state,
    String label,
    String key,
  ) {
    final isSelected = state.sort == key;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const FaIcon(FontAwesomeIcons.check, color: AppTheme.primary, size: 16)
          : null,
      onTap: () {
        state.setSort(key);
        Navigator.pop(context);
      },
    );
  }

  void _openFilterModal(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgSurfaceElevated,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(18),
              child: ListView(
                controller: scrollController,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filtros Avançados',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          state.resetFilters();
                          Navigator.pop(context);
                        },
                        child: const Text('Limpar', style: TextStyle(color: AppTheme.primary)),
                      ),
                    ],
                  ),
                  const Divider(color: AppTheme.borderSubtle),
                  const SizedBox(height: 10),

                  // Filtro de Marca
                  const Text('Marca', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: state.availableBrands.map((brand) {
                      final isSelected = state.brand == brand;
                      return ChoiceChip(
                        label: Text(brand == 'all' ? 'Todas' : brand),
                        selected: isSelected,
                        selectedColor: AppTheme.primary,
                        backgroundColor: AppTheme.bgDark,
                        labelStyle: TextStyle(
                          color: isSelected ? AppTheme.bgDark : AppTheme.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (_) => state.setBrand(brand),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Faixa de Preço Máximo
                  const Text('Preço Máximo', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildPriceChip(state, 'Qualquer Valor', double.infinity),
                      _buildPriceChip(state, 'Até R\$ 120.000', 120000),
                      _buildPriceChip(state, 'Até R\$ 200.000', 200000),
                      _buildPriceChip(state, 'Até R\$ 350.000', 350000),
                    ],
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: AppTheme.bgDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Aplicar Filtros',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPriceChip(AppState state, String label, double price) {
    final isSelected = state.maxPrice == price;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppTheme.primary,
      backgroundColor: AppTheme.bgDark,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.bgDark : AppTheme.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (_) => state.setMaxPrice(price),
    );
  }
}
