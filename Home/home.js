let paginaAtual = 0;
const PAGE_SIZE = 15;
let allGames = [];
let currentSearch = '';
let favoritos = JSON.parse(localStorage.getItem("favoritos")) || [];
let isLoading = false;

// deixar escurão
function toggleDarkMode() {
  document.body.classList.toggle("darkmode");
}


// criação do card
function criarCard(game) {
  const card = document.createElement("div");
  card.className = "card";
  card.innerHTML = `
    <img src="${game.thumb}" alt="${game.title}">
    <h3>${game.title}</h3>
    <p class="price-old">De: $${game.normalPrice}</p>
    <p class="price-sale">Por: $${game.salePrice}</p>
    <a href="https://www.cheapshark.com/redirect?dealID=${game.dealID}" target="_blank" class="buy-btn">Ir para loja</a>
  `;
  return card;
}
// carregando mais jogos

async function carregarJogos(pagina = 0, search = '', append = false) {
  if (isLoading) return;
  isLoading = true;
 
  try {
    let url = `https://www.cheapshark.com/api/1.0/deals?storeID=1&upperPrice=15&pageNumber=${pagina}&pageSize=${PAGE_SIZE}`;
    if (search) url += `&title=${encodeURIComponent(search)}`;

    const res = await fetch(url);
    const data = await res.json();

     const novosJogos = data.filter(
      novo => !allGames.some(jogoExistente => jogoExistente.dealID === novo.dealID)
    );

     allGames = append ? [...allGames, ...novosJogos] : novosJogos;
    renderJogos();

    const loadMoreContainer = document.getElementById("loadMoreContainer");
    loadMoreContainer.innerHTML = "";

    if (data.length === PAGE_SIZE) {
      const btn = document.createElement("button");
      btn.textContent = "Carregar Mais";
      btn.className = "buy-btn";
      btn.addEventListener("click", () => {
        paginaAtual++;
        carregarJogos(paginaAtual, currentSearch, true);
      });
      loadMoreContainer.appendChild(btn);
    } else {
      const fim = document.createElement("p");
      fim.textContent = "🚀 Fim das ofertas disponíveis.";
      fim.style.textAlign = "center";
      fim.style.marginTop = "10px";
      loadMoreContainer.appendChild(fim);
    }

  } catch (e) {
    console.error("Erro ao carregar jogos:", e);
  } finally {
    isLoading = false;
  }
}

// renderizar jogos

function renderJogos() {
  const gameList = document.getElementById("gameList");
  gameList.innerHTML = "";
  allGames.forEach(game => gameList.appendChild(criarCard(game)));
}

// eventos

document.addEventListener("DOMContentLoaded", () => {
  carregarJogos();

  document.querySelector(".buscar-btn").addEventListener("click", () => {
    currentSearch = document.getElementById("searchInput").value.trim();
    paginaAtual = 0;
    carregarJogos(0, currentSearch, false);
    document.getElementById("ofertasText").innerText = "🎯 Resultados da busca";
  });

  document.querySelector(".voltar-btn").addEventListener("click", () => {
    currentSearch = '';
    paginaAtual = 0;
    document.getElementById("searchInput").value = '';
    document.getElementById("ofertasText").innerText = "🎮 Ofertas em destaque";
    carregarJogos(0, '', false);
  });

  document.querySelector(".darkmode-btn").addEventListener("click", toggleDarkMode);
});

document.querySelector(".favoritos-btn").addEventListener("click", () => {
    const gameList = document.getElementById("gameList");
    gameList.innerHTML = '';
    document.getElementById("ofertasText").innerText = "❤️ Meus Favoritos (visual)";
});
