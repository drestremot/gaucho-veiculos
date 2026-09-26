# 🚗 Gaúcho Veículos - Landing Page de Alta Conversão

Landing page profissional, responsiva e de alta performance para concessionária e revenda de automóveis novos (0km) e seminovos certificados.

Desenvolvida com foco em **alta conversão**, **UI/UX moderna (Automotive Dark Carbon)**, **totalmente client-side** (HTML5, CSS3 e JavaScript Vanilla), sem dependência de banco de dados e com integração direta para captação de leads via WhatsApp.

---

## ✨ Principais Funcionalidades

- 🏎️ **Inventário Dinâmico (0km e Seminovos):** Catálogo interativo com 12 modelos em destaque (Toyota Hilux, BMW 320i, Jeep Compass, BYD Song Plus, Porsche Macan, etc.).
- 🔍 **Mecanismo de Busca e Filtros em Tempo Real:**
  - Filtro por Tipo: *Todos*, *Novos 0km*, *Seminovos Certificados*.
  - Filtro por Categoria: *SUVs*, *Picapes 4x4*, *Sedans*, *Hatches*, *Híbridos/Elétricos*, *Esportivos*.
  - Filtro por Marca e Faixa de Preço.
  - Ordenação por Menor Preço, Maior Preço, Ano mais Novo e Destaques.
- 🧮 **Simulador Interativo de Financiamento:**
  - Sliders em tempo real para Valor do Veículo, Entrada (com cálculo dinâmico de percentual) e Prazo (12x a 60x).
  - Cálculo de parcelas baseado na Tabela Price com taxas médias automotivas.
  - Botão de envio instantâneo com a proposta formatada direto no WhatsApp do consultor.
- 📑 **Modal de Ficha Técnica e Galeria de Fotos:**
  - Visualização com troca de fotos (lightbox de miniaturas).
  - Especificações detalhadas (motor, câmbio, combustível, cor, opcionais e laudo).
- ❤️ **Sistema de Favoritos (LocalStorage):**
  - Permite salvar veículos para comparar depois, sem perder o histórico ao recarregar a página.
  - Contador interativo no cabeçalho e modal exclusivo de favoritos.
- 🔄 **Formulário de Avaliação de Usado (Trade-In / Troca com Troco):**
  - Captura dados do veículo do cliente e gera mensagem personalizada para o time comercial.
- 💬 **Geração de Leads no WhatsApp:**
  - Todos os botões "Negociar" e "Simular" geram mensagens personalizadas com o modelo, preço e dados do cliente.
  - Botão flutuante de WhatsApp com animação de pulso.
- ⭐ **Depoimentos Reais & Diferenciais:**
  - Seções de prova social e diferenciais (Laudo Cautelar 100%, Garantia de até 1 ano, Entrega em todo o Brasil).

---

## 🛠️ Tecnologias Utilizadas

- **HTML5 Semântico:** Estruturação limpa, tags acessíveis (`<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<footer>`).
- **CSS3 Moderno:**
  - Variáveis CSS (Custom Properties) para consistência visual.
  - CSS Grid e Flexbox para layouts fluidos e responsivos.
  - Efeitos de Glassmorphism (`backdrop-filter`) e paleta Carbon/Dark Red/Gold.
  - Tipografia via Google Fonts (*Outfit* e *Plus Jakarta Sans*).
- **JavaScript (ES6+ Vanilla):**
  - Manipulação de DOM limpa e modular.
  - Gerenciamento de estado em memória.
  - LocalStorage para persistência de favoritos.
  - Formatação monetária com `Intl.NumberFormat`.
- **Font Awesome 6:** Biblioteca de ícones vetoriais modernos via CDN.

---

## 📁 Estrutura de Arquivos

```text
c:\Users\Estremote\Desktop\Gaucho Veiculos\
├── index.html        # Estrutura principal da Landing Page
├── css\
│   └── style.css     # Folha de estilos completa e responsiva
├── js\
│   ├── data.js       # Base de dados estruturada de veículos e depoimentos
│   └── app.js        # Lógica de filtros, simulador, modal e eventos
└── README.md         # Documentação do projeto
```

---

## 🚀 Como Executar Localmente

Não requer instalação de pacotes (npm/node) nem servidor de banco de dados.

1. Basta abrir o arquivo `index.html` em qualquer navegador web (Google Chrome, Microsoft Edge, Firefox, Safari).
2. Ou utilize a extensão **Live Server** do VS Code para recarregamento automático durante edições.
