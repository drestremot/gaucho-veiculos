# 🚗 Gaúcho Veículos - Solução Web & Mobile (Flutter)

Solução completa para concessionária e revenda de automóveis novos (0km) e seminovos certificados, contendo **Landing Page Web de Alta Conversão** e **Aplicativo Mobile Multiplataforma (Flutter)**.

Desenvolvida com a paleta **Automotive Dark Carbon & Azul Turquesa (Cyber Turquoise)**, sem dependência de banco de dados e com captação direta de leads via WhatsApp.

---

## 📱 1. Aplicativo Mobile (Flutter)

O aplicativo mobile foi desenvolvido em **Flutter** e se encontra na pasta [`mobile_app/`](mobile_app/):

### ✨ Recursos do App Mobile:
- 🏎️ **Catálogo Dinâmico:** Listagem com 12 modelos (Toyota Hilux, BMW 320i, Jeep Compass, BYD Song Plus, Porsche Macan, etc.).
- 🔍 **Busca e Filtros Avançados:** Filtro por 0km/Seminovos, Categorias (SUVs, Picapes, Sedans, Hatches, Elétricos, Esportivos), Marcas e Faixa de Preço.
- 🧮 **Simulador de Financiamento:** Sliders em tempo real para Valor, Entrada e Prazo (12x a 60x), cálculo de parcelas e envio da proposta para o WhatsApp.
- 📑 **Ficha Técnica & Galeria:** Carrossel de fotos, especificações mecânicas detalhadas e lista de opcionais com checkmarks.
- ❤️ **Favoritos:** Salve veículos com botão de coração e visualize-os na aba de favoritos.
- 🔄 **Avaliação de Usado (Trade-In):** Formulário integrado para avaliação do veículo usado direto no WhatsApp do time comercial.
- 🎨 **UI Premium:** Design moderno com Material 3 Dark Theme e fontes *Outfit* e *Plus Jakarta Sans*.

### 🚀 Como Executar o App Mobile:
```bash
cd mobile_app
flutter pub get
flutter run
```

---

## 🌐 2. Landing Page Web (HTML5 / CSS3 / JS)

A versão web é 100% client-side e está na raiz do projeto:

- [`index.html`](index.html): Estrutura semântica e acessível.
- [`css/style.css`](css/style.css): Estilos modernos, responsivos e tema Azul Turquesa.
- [`js/data.js`](js/data.js): Base de dados estruturada de veículos e depoimentos.
- [`js/app.js`](js/app.js): Lógica de filtros, simulador de parcelas, favoritos em LocalStorage e modais.

### 🚀 Como Executar a Web:
Abra o arquivo [`index.html`](index.html) diretamente em qualquer navegador web.

---

## 📁 Estrutura do Repositório

```text
c:\Users\Estremote\Desktop\Gaucho Veiculos\
├── index.html                  # Landing Page Web
├── css/style.css               # Estilos Web (Azul Turquesa & Dark Carbon)
├── js/
│   ├── data.js                 # Dados mockados dos veículos
│   └── app.js                  # Lógica Web
├── mobile_app/                 # 📱 PROJETO FLUTTER COMPLETO
│   ├── pubspec.yaml
│   ├── lib/
│   │   ├── main.dart           # Ponto de entrada do App
│   │   ├── core/
│   │   │   ├── theme.dart      # Tema Escuro & Azul Turquesa
│   │   │   └── constants.dart  # Formatações, WhatsApp e utilitários
│   │   ├── models/             # Modelos de dados
│   │   ├── data/               # Mock data dos carros e depoimentos
│   │   ├── providers/          # Gerenciamento de estado reativo
│   │   ├── widgets/            # Cards, chips, barra de busca e simulador
│   │   └── screens/            # Telas do aplicativo
│   └── test/widget_test.dart   # Testes automatizados
└── README.md
```
