import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/vehicle_model.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class VehicleDetailScreen extends StatefulWidget {
  final VehicleModel vehicle;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const VehicleDetailScreen({
    super.key,
    required this.vehicle,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  int _currentImageIndex = 0;
  late bool _favState;

  @override
  void initState() {
    super.initState();
    _favState = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.vehicle;
    final installment = (v.price * 0.7 * 1.35) / 48;

    return Scaffold(
      backgroundColor: AppTheme.bgBody,
      body: CustomScrollView(
        slivers: [
          // AppBar com Galeria de Imagens
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppTheme.bgSurface,
            leading: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.6),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.6),
                child: IconButton(
                  icon: FaIcon(
                    _favState
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: _favState ? AppTheme.primary : Colors.white,
                    size: 18,
                  ),
                  onPressed: () {
                    setState(() {
                      _favState = !_favState;
                    });
                    widget.onFavoriteToggle();
                  },
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.6),
                child: IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.shareNodes,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Link do veículo copiado!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    itemCount: v.images.length,
                    onPageChanged: (idx) {
                      setState(() => _currentImageIndex = idx);
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        v.images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, _, _) => Container(
                          color: AppTheme.bgDark,
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.car,
                              size: 48,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Indicador de Fotos (Pontos)
                  if (v.images.length > 1)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          v.images.length,
                          (index) => Container(
                            width: _currentImageIndex == index ? 20 : 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: _currentImageIndex == index
                                  ? AppTheme.primary
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Conteúdo do Veículo
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Marca e Condição
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${v.brand.toUpperCase()} • ${v.category.toUpperCase()}',
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primarySubtle,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.primary),
                        ),
                        child: Text(
                          v.isNew ? '0km Pronta Entrega' : 'Seminovo Certificado',
                          style: const TextStyle(
                            color: AppTheme.primaryHover,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Nome do Veículo
                  Text(
                    v.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Preço
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        AppConstants.formatBRL(v.price),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      if (v.oldPrice != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          AppConstants.formatBRL(v.oldPrice!),
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    'ou 48x de aproximadamente ${AppConstants.formatBRL(installment)}',
                    style: const TextStyle(
                      color: AppTheme.accentGold,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Grid de Especificações
                  const Text(
                    'Ficha Técnica',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.bgSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.borderSubtle),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('Ano Fabricação / Modelo', v.year),
                        const Divider(color: AppTheme.borderSubtle, height: 16),
                        _buildDetailRow(
                          'Quilometragem',
                          AppConstants.formatKm(v.mileage),
                        ),
                        const Divider(color: AppTheme.borderSubtle, height: 16),
                        _buildDetailRow('Motorização', v.engine),
                        const Divider(color: AppTheme.borderSubtle, height: 16),
                        _buildDetailRow('Câmbio', v.transmission),
                        const Divider(color: AppTheme.borderSubtle, height: 16),
                        _buildDetailRow('Combustível', v.fuel),
                        const Divider(color: AppTheme.borderSubtle, height: 16),
                        _buildDetailRow('Cor', v.color),
                        const Divider(color: AppTheme.borderSubtle, height: 16),
                        _buildDetailRow('Final da Placa', v.plateEnd),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Descrição
                  const Text(
                    'Sobre este Veículo',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    v.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Opcionais / Itens de Série
                  const Text(
                    'Opcionais e Equipamentos',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: v.features.map((feature) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.bgSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.borderSubtle),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.check,
                              size: 11,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              feature,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 100), // Espaço para barra inferior
                ],
              ),
            ),
          ),
        ],
      ),

      // Barra Inferior Fixa de Ação
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.bgSurfaceElevated,
          border: const Border(top: BorderSide(color: AppTheme.borderGlass)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.whatsappGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 20),
                  label: const Text(
                    'Negociar no WhatsApp',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    AppConstants.openWhatsApp(
                      'Olá! Estou vendo o ${v.name} (${AppConstants.formatBRL(v.price)}) no App da Gaúcho Veículos e gostaria de negociar!',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
