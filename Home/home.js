let TAXA_CONVERSAO = 5.32; // valor do dólar
let paginaAtual = 0;
const PAGE_SIZE = 15;
let allGames = [];
let currentSearch = '';
let favoritos = JSON.parse(localStorage.getItem("favoritos")) || [];
let isLoading = false;

async function getCotacao() {
  try {
    const res = await fetch("https://api.exchangerate.host/latest?base=USD&symbols=BRL");
    const data = await res.json();
    TAXA_CONVERSAO = data.rates.BRL;
    console.log("Cotação atualizada: 1 USD =", TAXA_CONVERSAO, "BRL");
  } catch (err) {
    console.error("Erro ao buscar cotação", err);
  }
}

function usdToBrl(valorUSD) {
  return (valorUSD * TAXA_CONVERSAO).toLocaleString("pt-BR", {
    style: "currency",
    currency: "BRL"
  });
}

function toggleDarkMode() {
  document.body.classList.toggle("dark-mode");
}

function salvarFavoritos() {
  localStorage.setItem("favoritos", JSON.stringify(favoritos));
}

function criarCard(game) {
  const card = document.createElement("div");
  card.className = "card";
  const isFav = favoritos.some(f => f.dealID === game.dealID);

  card.innerHTML = `
    <button class="fav-btn ${isFav ? 'favorited' : ''}">❤</button>
    <img src="${game.thumb}" alt="${game.title}">
    <h3>${game.title}</h3>
    <p class="price-old">De: ${usdToBrl(game.normalPrice)}</p>
    <p class="price-sale">Por: ${usdToBrl(game.salePrice)}</p>
    <a href="https://www.cheapshark.com/redirect?dealID=${game.dealID}" target="_blank" class="buy-btn">Ir para loja</a>
  `;

  const favBtn = card.querySelector(".fav-btn");
  favBtn.addEventListener("click", () => {
    if (favoritos.some(f => f.dealID === game.dealID)) {
      favoritos = favoritos.filter(f => f.dealID !== game.dealID);
      favBtn.classList.remove("favorited");
    } else {
      favoritos.push(game);
      favBtn.classList.add("favorited");
    }
    salvarFavoritos();
  });

  return card;
}

async function carregarJogos(pagina = 0, search = '', append = false) {
  if (isLoading) return;
  isLoading = true;
  await getCotacao();

  try {
    let url = `https://www.cheapshark.com/api/1.0/deals?storeID=1&upperPrice=15&pageNumber=${pagina}&pageSize=${PAGE_SIZE}`;
    if (search) url += `&title=${encodeURIComponent(search)}`;

    const res = await fetch(url);
    const newData = await res.json();

    if (append) {
      allGames.push(...newData);
    } else {
      allGames = newData;
    }

    renderJogos(append);

    const loadMoreContainer = document.getElementById("loadMoreContainer");
    loadMoreContainer.innerHTML = '';
    if (!search && newData.length === PAGE_SIZE) {
      const loadMoreButton = document.createElement("button");
      loadMoreButton.className = "buy-btn";
      loadMoreButton.textContent = "Carregar Mais";
      loadMoreButton.addEventListener("click", handleLoadMore);
      loadMoreContainer.appendChild(loadMoreButton);
    }

  } catch (err) {
    console.error(err);
    document.getElementById("gameList").innerHTML = "<p>Erro ao carregar jogos.</p>";
  } finally {
    isLoading = false;
  }
}

function renderJogos(append = false) {
  const gameList = document.getElementById("gameList");
  if (!append) gameList.innerHTML = '';
  allGames.forEach(game => gameList.appendChild(criarCard(game)));
}

function handleLoadMore() {
  paginaAtual++;
  carregarJogos(paginaAtual, currentSearch, true);
}

document.addEventListener("DOMContentLoaded", () => {
  carregarJogos();

  document.getElementById("darkModeBtn").addEventListener("click", toggleDarkMode);

  document.getElementById("buscarBtn").addEventListener("click", () => {
    currentSearch = document.getElementById("searchInput").value.trim();
    paginaAtual = 0;
    carregarJogos(0, currentSearch, false);
  });

  document.getElementById("favoritosBtn").addEventListener("click", () => {
    document.getElementById("gameList").innerHTML = '';
    if (favoritos.length === 0) {
      document.getElementById("gameList").innerHTML = "<p>Nenhum favorito salvo.</p>";
    } else {
      favoritos.forEach(game => document.getElementById("gameList").appendChild(criarCard(game)));
    }
    document.getElementById("loadMoreContainer").innerHTML = '';
    document.getElementById("ofertasText").innerText = '❤️ Meus Favoritos';
  });
});
