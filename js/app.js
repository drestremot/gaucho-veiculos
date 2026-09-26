/**
 * GAÚCHO VEÍCULOS - APLICAÇÃO PRINCIPAL (JS ES6+)
 * Gerenciamento de Estado, Filtros em Tempo Real, Simulador de Financiamento,
 * Sistema de Favoritos (LocalStorage) e Integração Direta com WhatsApp.
 */

document.addEventListener('DOMContentLoaded', () => {
  // --- ESTADO DA APLICAÇÃO ---
  const state = {
    vehicles: [...VEHICLES_DATA],
    filteredVehicles: [...VEHICLES_DATA],
    filters: {
      condition: 'all', // 'all', 'novo', 'seminovo'
      category: 'all',  // 'all', 'suv', 'pickup', 'sedan', 'hatch', 'eletrico', 'esportivo'
      brand: 'all',
      maxPrice: Infinity,
      search: '',
      sort: 'featured'  // 'featured', 'price-asc', 'price-desc', 'year-desc'
    },
    favorites: JSON.parse(localStorage.getItem('gaucho_favorites')) || [],
    simulator: {
      carPrice: 180000,
      downPayment: 54000, // 30% padrão
      months: 48,
      interestRateMonth: 0.0139 // 1.39% ao mês (média de mercado)
    }
  };

  // --- ELEMENTOS DO DOM ---
  const elements = {
    // Catálogo
    catalogGrid: document.getElementById('catalog-grid'),
    catalogCount: document.getElementById('catalog-count'),
    sortSelect: document.getElementById('sort-select'),
    brandSelect: document.getElementById('quick-brand-select'),
    priceSelect: document.getElementById('quick-price-select'),
    quickSearchForm: document.getElementById('quick-search-form'),
    conditionTabs: document.querySelectorAll('.search-tab-btn'),
    categoryPills: document.querySelectorAll('.category-pill'),
    
    // Favoritos
    favCountBadges: document.querySelectorAll('.favorites-count'),
    btnOpenFavs: document.getElementById('btn-open-favorites'),
    favsModal: document.getElementById('favorites-modal'),
    favsList: document.getElementById('favorites-list'),
    favsModalClose: document.getElementById('favs-modal-close'),

    // Modal de Detalhes
    detailModal: document.getElementById('detail-modal'),
    detailModalClose: document.getElementById('detail-modal-close'),
    detailModalBody: document.getElementById('detail-modal-body'),

    // Simulador
    simPriceInput: document.getElementById('sim-price-input'),
    simPriceDisplay: document.getElementById('sim-price-display'),
    simDownInput: document.getElementById('sim-down-input'),
    simDownDisplay: document.getElementById('sim-down-display'),
    simDownPercent: document.getElementById('sim-down-percent'),
    simTermButtons: document.querySelectorAll('.sim-term-btn'),
    simInstallmentVal: document.getElementById('sim-installment-val'),
    simFinancedVal: document.getElementById('sim-financed-val'),
    simTermDisplay: document.getElementById('sim-term-display'),
    simWhatsappBtn: document.getElementById('sim-whatsapp-btn'),

    // Avaliação (Trade-in)
    tradeinForm: document.getElementById('tradein-form'),

    // Depoimentos
    testimonialsGrid: document.getElementById('testimonials-grid'),

    // Navegação & Mobile
    navbar: document.querySelector('.navbar'),
    mobileToggle: document.getElementById('mobile-toggle'),
    navLinks: document.getElementById('nav-links'),

    // Toast
    toast: document.getElementById('app-toast'),
    toastMsg: document.getElementById('toast-message')
  };

  // --- FORMATADORES ---
  const formatBRL = (val) => {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL',
      maximumFractionDigits: 0
    }).format(val);
  };

  const formatKm = (km) => {
    if (km === 0) return '0 km (Novo)';
    return `${new Intl.NumberFormat('pt-BR').format(km)} km`;
  };

  // --- GERADOR DE LINKS WHATSAPP ---
  const createWhatsAppLink = (message) => {
    const encodedMsg = encodeURIComponent(message);
    return `https://wa.me/${STORE_CONFIG.whatsapp}?text=${encodedMsg}`;
  };

  // --- POPULAR OPÇÕES DINÂMICAS ---
  const populateBrandFilter = () => {
    if (!elements.brandSelect) return;
    const brands = [...new Set(VEHICLES_DATA.map(v => v.brand))].sort();
    
    brands.forEach(brand => {
      const option = document.createElement('option');
      option.value = brand;
      option.textContent = brand;
      elements.brandSelect.appendChild(option);
    });
  };

  // --- RENDERIZAR CATÁLOGO ---
  const renderCatalog = () => {
    if (!elements.catalogGrid) return;

    const cars = state.filteredVehicles;
    elements.catalogCount.textContent = cars.length;

    if (cars.length === 0) {
      elements.catalogGrid.innerHTML = `
        <div class="catalog-empty">
          <i class="fa-solid fa-car-tunnel"></i>
          <h3>Nenhum veículo encontrado</h3>
          <p>Tente ajustar os filtros ou pesquisar por outro modelo/marca.</p>
          <button class="btn btn-outline btn-sm" id="btn-reset-filters">
            <i class="fa-solid fa-rotate-left"></i> Limpar Filtros
          </button>
        </div>
      `;

      const resetBtn = document.getElementById('btn-reset-filters');
      if (resetBtn) {
        resetBtn.addEventListener('click', resetFilters);
      }
      return;
    }

    elements.catalogGrid.innerHTML = cars.map(car => {
      const isFav = state.favorites.includes(car.id);
      const installmentEstimate = Math.round((car.price * 0.7 * 1.35) / 48);

      return `
        <article class="car-card" data-id="${car.id}">
          <div class="car-card-header">
            <img src="${car.images[0]}" alt="${car.name}" loading="lazy" />
            <div class="car-badges">
              ${car.condition === 'novo' ? '<span class="badge-tag highlight"><i class="fa-solid fa-bolt"></i> 0km</span>' : ''}
              ${car.badges.slice(0, 2).map(b => `<span class="badge-tag">${b}</span>`).join('')}
            </div>
            <button class="btn-card-fav ${isFav ? 'active' : ''}" data-id="${car.id}" title="Favoritar">
              <i class="${isFav ? 'fa-solid' : 'fa-regular'} fa-heart"></i>
            </button>
          </div>

          <div class="car-card-body">
            <div class="car-brand-row">
              <span class="car-brand-name">${car.brand}</span>
              <span class="car-condition-pill">${car.condition === 'novo' ? 'Novo 0km' : 'Seminovo'}</span>
            </div>

            <h3 class="car-name">${car.name}</h3>

            <div class="car-specs-grid">
              <div class="spec-item">
                <i class="fa-regular fa-calendar"></i>
                <span>${car.year}</span>
              </div>
              <div class="spec-item">
                <i class="fa-solid fa-road"></i>
                <span>${formatKm(car.mileage)}</span>
              </div>
              <div class="spec-item">
                <i class="fa-solid fa-gas-pump"></i>
                <span>${car.fuel}</span>
              </div>
              <div class="spec-item">
                <i class="fa-solid fa-gear"></i>
                <span>${car.transmission.split(' ')[0]}</span>
              </div>
            </div>

            <div class="car-price-block">
              ${car.oldPrice ? `<div class="car-old-price">${formatBRL(car.oldPrice)}</div>` : ''}
              <div class="car-price">${formatBRL(car.price)}</div>
              <div class="car-installment-estimate">
                <i class="fa-solid fa-calculator"></i> ou 48x de aprox. ${formatBRL(installmentEstimate)}
              </div>
            </div>

            <div class="car-card-actions">
              <button class="btn btn-outline btn-sm btn-open-detail" data-id="${car.id}">
                <i class="fa-regular fa-eye"></i> Detalhes
              </button>
              <a href="${createWhatsAppLink(`Olá! Tenho interesse no ${car.name} (${formatBRL(car.price)}). Poderia me passar mais informações e fotos?`)}" 
                 target="_blank" 
                 class="btn btn-whatsapp btn-sm">
                <i class="fa-brands fa-whatsapp"></i> Negociar
              </a>
            </div>
          </div>
        </article>
      `;
    }).join('');

    // Adiciona listeners para os cards gerados
    attachCardEvents();
  };

  // --- EVENTOS NOS CARDS ---
  const attachCardEvents = () => {
    // Favoritar
    document.querySelectorAll('.btn-card-fav').forEach(btn => {
      btn.addEventListener('click', (e) => {
        e.stopPropagation();
        const carId = btn.dataset.id;
        toggleFavorite(carId);
      });
    });

    // Abrir Modal de Detalhes
    document.querySelectorAll('.btn-open-detail').forEach(btn => {
      btn.addEventListener('click', () => {
        const carId = btn.dataset.id;
        openDetailModal(carId);
      });
    });
  };

  // --- FILTRO E ORDENAÇÃO ---
  const applyFilters = () => {
    let result = [...state.vehicles];

    // Condição (Novo / Seminovo)
    if (state.filters.condition !== 'all') {
      result = result.filter(v => v.condition === state.filters.condition);
    }

    // Categoria (SUV, Pickup, etc)
    if (state.filters.category !== 'all') {
      result = result.filter(v => v.category === state.filters.category);
    }

    // Marca
    if (state.filters.brand !== 'all') {
      result = result.filter(v => v.brand.toLowerCase() === state.filters.brand.toLowerCase());
    }

    // Preço Máximo
    if (state.filters.maxPrice && state.filters.maxPrice !== Infinity) {
      result = result.filter(v => v.price <= state.filters.maxPrice);
    }

    // Busca textual
    if (state.filters.search.trim()) {
      const q = state.filters.search.toLowerCase();
      result = result.filter(v => 
        v.name.toLowerCase().includes(q) || 
        v.brand.toLowerCase().includes(q) ||
        v.model.toLowerCase().includes(q) ||
        v.features.some(f => f.toLowerCase().includes(q))
      );
    }

    // Ordenação
    switch (state.filters.sort) {
      case 'price-asc':
        result.sort((a, b) => a.price - b.price);
        break;
      case 'price-desc':
        result.sort((a, b) => b.price - a.price);
        break;
      case 'year-desc':
        result.sort((a, b) => parseInt(b.year) - parseInt(a.year));
        break;
      case 'featured':
      default:
        result.sort((a, b) => (b.featured ? 1 : 0) - (a.featured ? 1 : 0));
        break;
    }

    state.filteredVehicles = result;
    renderCatalog();
  };

  const resetFilters = () => {
    state.filters = {
      condition: 'all',
      category: 'all',
      brand: 'all',
      maxPrice: Infinity,
      search: '',
      sort: 'featured'
    };

    if (elements.brandSelect) elements.brandSelect.value = 'all';
    if (elements.priceSelect) elements.priceSelect.value = 'all';
    if (elements.sortSelect) elements.sortSelect.value = 'featured';

    elements.conditionTabs.forEach(tab => {
      tab.classList.toggle('active', tab.dataset.condition === 'all');
    });

    elements.categoryPills.forEach(pill => {
      pill.classList.toggle('active', pill.dataset.category === 'all');
    });

    applyFilters();
    showToast('Filtros restaurados!');
  };

  // --- SISTEMA DE FAVORITOS (LOCALSTORAGE) ---
  const updateFavoritesUI = () => {
    const count = state.favorites.length;
    elements.favCountBadges.forEach(badge => {
      badge.textContent = count;
      badge.style.display = count > 0 ? 'flex' : 'none';
    });
    localStorage.setItem('gaucho_favorites', JSON.stringify(state.favorites));
  };

  const toggleFavorite = (carId) => {
    const car = VEHICLES_DATA.find(v => v.id === carId);
    if (!car) return;

    const index = state.favorites.indexOf(carId);
    if (index > -1) {
      state.favorites.splice(index, 1);
      showToast(`${car.name} removido dos favoritos.`);
    } else {
      state.favorites.push(carId);
      showToast(`${car.name} adicionado aos favoritos!`, 'fa-solid fa-heart');
    }

    updateFavoritesUI();
    renderCatalog();
    if (elements.favsModal.classList.contains('active')) {
      renderFavoritesModal();
    }
  };

  const renderFavoritesModal = () => {
    const favCars = VEHICLES_DATA.filter(v => state.favorites.includes(v.id));

    if (favCars.length === 0) {
      elements.favsList.innerHTML = `
        <div style="text-align: center; padding: 3rem 1rem;">
          <i class="fa-regular fa-heart" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 1rem;"></i>
          <h4>Sua lista de favoritos está vazia</h4>
          <p style="color: var(--text-secondary); margin-top: 0.5rem; font-size: 0.9rem;">
            Clique no ícone de coração nos carros para salvá-los e comparar depois.
          </p>
        </div>
      `;
      return;
    }

    elements.favsList.innerHTML = favCars.map(car => `
      <div class="fav-item-card">
        <div class="fav-item-info">
          <img src="${car.images[0]}" alt="${car.name}" class="fav-item-img" />
          <div>
            <div class="fav-item-title">${car.name}</div>
            <div class="fav-item-price">${formatBRL(car.price)}</div>
          </div>
        </div>
        <div style="display: flex; gap: 0.5rem;">
          <a href="${createWhatsAppLink(`Olá! Salvei o ${car.name} (${formatBRL(car.price)}) nos meus favoritos e gostaria de mais informações.`)}" 
             target="_blank" 
             class="btn btn-whatsapp btn-sm">
            <i class="fa-brands fa-whatsapp"></i>
          </a>
          <button class="btn btn-outline btn-sm btn-remove-fav" data-id="${car.id}" title="Remover">
            <i class="fa-solid fa-trash-can"></i>
          </button>
        </div>
      </div>
    `).join('');

    document.querySelectorAll('.btn-remove-fav').forEach(btn => {
      btn.addEventListener('click', () => {
        toggleFavorite(btn.dataset.id);
      });
    });
  };

  // --- MODAL DE DETALHES DO VEÍCULO ---
  const openDetailModal = (carId) => {
    const car = VEHICLES_DATA.find(v => v.id === carId);
    if (!car) return;

    elements.detailModalBody.innerHTML = `
      <div class="modal-detail-grid">
        <div class="modal-gallery-col">
          <div class="modal-gallery-main">
            <img id="modal-main-img" src="${car.images[0]}" alt="${car.name}" />
          </div>
          <div class="modal-gallery-thumbs">
            ${car.images.map((img, idx) => `
              <div class="modal-thumb ${idx === 0 ? 'active' : ''}" data-src="${img}">
                <img src="${img}" alt="Foto ${idx + 1}" />
              </div>
            `).join('')}
          </div>
        </div>

        <div class="modal-info-col">
          <div class="modal-info-brand">${car.brand} • ${car.condition === 'novo' ? '0km Pronta Entrega' : 'Seminovo Certificado'}</div>
          <h2 class="modal-info-title">${car.name}</h2>
          <div class="modal-info-price">${formatBRL(car.price)}</div>

          <div class="modal-info-specs-grid">
            <div class="modal-spec-row">
              <span class="modal-spec-lbl">Ano Fabricação</span>
              <span class="modal-spec-val">${car.year}</span>
            </div>
            <div class="modal-spec-row">
              <span class="modal-spec-lbl">Quilometragem</span>
              <span class="modal-spec-val">${formatKm(car.mileage)}</span>
            </div>
            <div class="modal-spec-row">
              <span class="modal-spec-lbl">Motorização</span>
              <span class="modal-spec-val">${car.engine}</span>
            </div>
            <div class="modal-spec-row">
              <span class="modal-spec-lbl">Câmbio</span>
              <span class="modal-spec-val">${car.transmission}</span>
            </div>
            <div class="modal-spec-row">
              <span class="modal-spec-lbl">Combustível</span>
              <span class="modal-spec-val">${car.fuel}</span>
            </div>
            <div class="modal-spec-row">
              <span class="modal-spec-lbl">Cor</span>
              <span class="modal-spec-val">${car.color}</span>
            </div>
          </div>

          <p style="color: var(--text-secondary); font-size: 0.92rem; margin-bottom: 1.25rem;">
            ${car.description}
          </p>

          <div class="modal-features-list">
            <h5>Destaques & Opcionais:</h5>
            <div class="modal-tags">
              ${car.features.map(f => `<span class="modal-tag"><i class="fa-solid fa-check" style="color: var(--primary); margin-right: 4px;"></i>${f}</span>`).join('')}
            </div>
          </div>

          <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
            <a href="${createWhatsAppLink(`Olá! Estou vendo a ficha técnica do ${car.name} (${formatBRL(car.price)}) no site e gostaria de agendar um Test-Drive ou simular financiamento!`)}" 
               target="_blank" 
               class="btn btn-whatsapp btn-lg" 
               style="flex: 1;">
              <i class="fa-brands fa-whatsapp"></i> Falar com Especialista
            </a>
            <button class="btn btn-outline btn-lg" onclick="navigator.clipboard.writeText(window.location.href); alert('Link do veículo copiado!');" title="Compartilhar">
              <i class="fa-solid fa-share-nodes"></i>
            </button>
          </div>
        </div>
      </div>
    `;

    // Interatividade da Galeria no Modal
    const thumbs = elements.detailModalBody.querySelectorAll('.modal-thumb');
    const mainImg = elements.detailModalBody.querySelector('#modal-main-img');
    thumbs.forEach(thumb => {
      thumb.addEventListener('click', () => {
        thumbs.forEach(t => t.classList.remove('active'));
        thumb.classList.add('active');
        mainImg.src = thumb.dataset.src;
      });
    });

    elements.detailModal.classList.add('active');
    document.body.style.overflow = 'hidden';
  };

  const closeDetailModal = () => {
    elements.detailModal.classList.remove('active');
    document.body.style.overflow = '';
  };

  // --- SIMULADOR DE FINANCIAMENTO ---
  const updateSimulator = () => {
    const { carPrice, downPayment, months, interestRateMonth } = state.simulator;

    // Atualiza Displays
    elements.simPriceDisplay.textContent = formatBRL(carPrice);
    elements.simDownDisplay.textContent = formatBRL(downPayment);
    const downPercent = Math.round((downPayment / carPrice) * 100);
    elements.simDownPercent.textContent = `${downPercent}%`;

    const financedAmount = Math.max(0, carPrice - downPayment);
    elements.simFinancedVal.textContent = formatBRL(financedAmount);
    elements.simTermDisplay.textContent = `${months} meses`;

    // Cálculo Tabela Price: PMT = PV * (i * (1+i)^n) / ((1+i)^n - 1)
    let installment = 0;
    if (financedAmount > 0) {
      const i = interestRateMonth;
      const n = months;
      installment = financedAmount * (i * Math.pow(1 + i, n)) / (Math.pow(1 + i, n) - 1);
    }

    elements.simInstallmentVal.textContent = formatBRL(Math.round(installment));

    // Atualiza Link WhatsApp
    const msg = `Olá Gaúcho Veículos! Fiz uma simulação no site:\n• Valor do Carro: ${formatBRL(carPrice)}\n• Entrada: ${formatBRL(downPayment)} (${downPercent}%)\n• Prazo: ${months}x de aprox. ${formatBRL(Math.round(installment))}\n\nGostaria de avaliar meu crédito com um consultor!`;
    elements.simWhatsappBtn.href = createWhatsAppLink(msg);
  };

  // --- RENDERIZAR DEPOIMENTOS ---
  const renderTestimonials = () => {
    if (!elements.testimonialsGrid) return;
    elements.testimonialsGrid.innerHTML = TESTIMONIALS_DATA.map(t => `
      <div class="test-card">
        <div>
          <div class="test-stars">
            ${'<i class="fa-solid fa-star"></i>'.repeat(t.rating)}
          </div>
          <p class="test-quote">"${t.comment}"</p>
        </div>
        <div class="test-user">
          <img src="${t.avatar}" alt="${t.name}" class="test-avatar" />
          <div class="test-meta">
            <h5>${t.name}</h5>
            <p>${t.city} • <span style="color: var(--accent-gold);">${t.car}</span></p>
          </div>
        </div>
      </div>
    `).join('');
  };

  // --- TOAST NOTIFICATION ---
  let toastTimeout;
  const showToast = (message, icon = 'fa-solid fa-circle-check') => {
    if (!elements.toast) return;
    clearTimeout(toastTimeout);
    elements.toastMsg.innerHTML = `<i class="${icon}"></i> ${message}`;
    elements.toast.classList.add('show');

    toastTimeout = setTimeout(() => {
      elements.toast.classList.remove('show');
    }, 3200);
  };

  // --- EVENT LISTENERS GERAIS ---
  
  // Abas de Condição (Todos / Novos / Seminovos)
  elements.conditionTabs.forEach(tab => {
    tab.addEventListener('click', () => {
      elements.conditionTabs.forEach(t => t.classList.remove('active'));
      tab.classList.add('active');
      state.filters.condition = tab.dataset.condition;
      applyFilters();
    });
  });

  // Pílulas de Categoria
  elements.categoryPills.forEach(pill => {
    pill.addEventListener('click', () => {
      elements.categoryPills.forEach(p => p.classList.remove('active'));
      pill.classList.add('active');
      state.filters.category = pill.dataset.category;
      applyFilters();
    });
  });

  // Form de Busca Rápida
  if (elements.quickSearchForm) {
    elements.quickSearchForm.addEventListener('submit', (e) => {
      e.preventDefault();
      state.filters.brand = elements.brandSelect.value;
      const priceVal = elements.priceSelect.value;
      state.filters.maxPrice = priceVal === 'all' ? Infinity : parseFloat(priceVal);
      applyFilters();

      // Rola suavemente até o catálogo
      document.getElementById('estoque')?.scrollIntoView({ behavior: 'smooth' });
    });
  }

  // Ordenação
  if (elements.sortSelect) {
    elements.sortSelect.addEventListener('change', (e) => {
      state.filters.sort = e.target.value;
      applyFilters();
    });
  }

  // Sliders do Simulador
  if (elements.simPriceInput) {
    elements.simPriceInput.addEventListener('input', (e) => {
      const price = parseFloat(e.target.value);
      state.simulator.carPrice = price;
      // Ajusta entrada máxima
      elements.simDownInput.max = price * 0.8;
      if (state.simulator.downPayment > price * 0.8) {
        state.simulator.downPayment = price * 0.3;
        elements.simDownInput.value = state.simulator.downPayment;
      }
      updateSimulator();
    });
  }

  if (elements.simDownInput) {
    elements.simDownInput.addEventListener('input', (e) => {
      state.simulator.downPayment = parseFloat(e.target.value);
      updateSimulator();
    });
  }

  // Botões de Prazo do Simulador
  elements.simTermButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      elements.simTermButtons.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      state.simulator.months = parseInt(btn.dataset.term);
      updateSimulator();
    });
  });

  // Formulário de Avaliação (Trade-In)
  if (elements.tradeinForm) {
    elements.tradeinForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const brand = document.getElementById('trade-brand').value;
      const model = document.getElementById('trade-model').value;
      const year = document.getElementById('trade-year').value;
      const km = document.getElementById('trade-km').value;
      const name = document.getElementById('trade-name').value;
      const phone = document.getElementById('trade-phone').value;

      const tradeMsg = `Olá! Gostaria de uma avaliação no meu veículo usado:\n• Cliente: ${name} (${phone})\n• Carro: ${brand} ${model}\n• Ano: ${year}\n• KM: ${km} km\n\nAguardo contato da equipe comercial!`;
      
      window.open(createWhatsAppLink(tradeMsg), '_blank');
      showToast('Redirecionando para o WhatsApp...', 'fa-brands fa-whatsapp');
      elements.tradeinForm.reset();
    });
  }

  // Modal Favoritos
  if (elements.btnOpenFavs) {
    elements.btnOpenFavs.addEventListener('click', () => {
      renderFavoritesModal();
      elements.favsModal.classList.add('active');
      document.body.style.overflow = 'hidden';
    });
  }

  if (elements.favsModalClose) {
    elements.favsModalClose.addEventListener('click', () => {
      elements.favsModal.classList.remove('active');
      document.body.style.overflow = '';
    });
  }

  // Modal Detalhes Fechar
  if (elements.detailModalClose) {
    elements.detailModalClose.addEventListener('click', closeDetailModal);
  }

  // Fechar modais ao clicar no overlay
  [elements.detailModal, elements.favsModal].forEach(modal => {
    if (modal) {
      modal.addEventListener('click', (e) => {
        if (e.target === modal) {
          modal.classList.remove('active');
          document.body.style.overflow = '';
        }
      });
    }
  });

  // Fechar modais com tecla ESC
  window.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      elements.detailModal?.classList.remove('active');
      elements.favsModal?.classList.remove('active');
      document.body.style.overflow = '';
    }
  });

  // Mobile Menu Toggle
  if (elements.mobileToggle) {
    elements.mobileToggle.addEventListener('click', () => {
      elements.navLinks.classList.toggle('active');
    });

    elements.navLinks.querySelectorAll('a').forEach(link => {
      link.addEventListener('click', () => {
        elements.navLinks.classList.remove('active');
      });
    });
  }

  // Scroll Navbar Effect
  window.addEventListener('scroll', () => {
    if (window.scrollY > 50) {
      elements.navbar.classList.add('scrolled');
    } else {
      elements.navbar.classList.remove('scrolled');
    }
  });

  // --- INICIALIZAÇÃO ---
  populateBrandFilter();
  updateFavoritesUI();
  applyFilters();
  updateSimulator();
  renderTestimonials();
});
