import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class TradeInScreen extends StatefulWidget {
  const TradeInScreen({super.key});

  @override
  State<TradeInScreen> createState() => _TradeInScreenState();
}

class _TradeInScreenState extends State<TradeInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _kmController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _kmController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitEvaluation() {
    if (_formKey.currentState!.validate()) {
      final msg =
          'Olá Gaúcho Veículos! Gostaria de uma avaliação para venda/troca do meu veículo:\n'
          '• Cliente: ${_nameController.text.trim()} (${_phoneController.text.trim()})\n'
          '• Carro: ${_brandController.text.trim()} ${_modelController.text.trim()}\n'
          '• Ano: ${_yearController.text.trim()}\n'
          '• KM Atual: ${_kmController.text.trim()}\n\n'
          'Aguardo a proposta da equipe comercial!';

      AppConstants.openWhatsApp(msg);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Redirecionando para o WhatsApp...'),
          backgroundColor: AppTheme.whatsappGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgBody,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.bgSurfaceElevated, AppTheme.bgSurface],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderGlass),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.handshake,
                          color: AppTheme.primary,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Avaliação Rápida & Justa',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryHover,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Venda ou Troque seu Usado',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Pagamento à vista via Pix e a melhor avaliação do mercado gaúcho sem burocracia.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Dados do Veículo',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _brandController,
                      decoration: const InputDecoration(labelText: 'Marca *', hintText: 'Ex: Toyota'),
                      validator: (v) => v!.isEmpty ? 'Informe a marca' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _modelController,
                      decoration: const InputDecoration(labelText: 'Modelo *', hintText: 'Ex: Corolla Altis'),
                      validator: (v) => v!.isEmpty ? 'Informe o modelo' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Ano *', hintText: 'Ex: 2021'),
                      validator: (v) => v!.isEmpty ? 'Informe o ano' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _kmController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'KM Aprox. *', hintText: 'Ex: 45.000'),
                      validator: (v) => v!.isEmpty ? 'Informe a KM' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                'Seus Dados de Contato',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Seu Nome Completo *'),
                validator: (v) => v!.isEmpty ? 'Informe seu nome' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'WhatsApp com DDD *', hintText: '(51) 99999-9999'),
                validator: (v) => v!.isEmpty ? 'Informe seu telefone' : null,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.bgDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.paperPlane, size: 16),
                  label: const Text(
                    'Solicitar Avaliação no WhatsApp',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _submitEvaluation,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
