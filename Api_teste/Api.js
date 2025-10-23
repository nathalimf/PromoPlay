const URL = "https://www.cheapshark.com/api/1.0/"

async function Games(x){
    const urlFinal = `${URL}/games?title=${x}`;
    const resp = await fetch(urlFinal);
    if(resp.status === 200){
        const obj = await resp.json();
        console.log(obj);
    }
}

async function Loockup(x, y){
    const urlFinal = `${URL}/deals?storeID=${x}&upperPrice=${y}`;
    const resp = await fetch(urlFinal);
    if(resp.status === 200){
        const obj = await resp.json();
        console.log(obj);
    }
}

async function ListDaels(x){
    const urlFinal = `${URL}deals?id=${x}`;
    const resp = await fetch(urlFinal);
    if(resp.status === 200){
        const obj = await resp.json();
        console.log(obj);
    }
}

async function SalesInfo(x){
    const urlFinal = `${URL}/stores`;
    const resp = await fetch(urlFinal);
    if(resp.status === 200){
        const obj = await resp.json();
        console.log(obj);
    }
}

//SalesInfo()
//Games('Batman');
//Loockup(2, 15);
//ListDaels('X8sebHhbc1Ga0dTkgg59WgyM506af9oNZZJLU9uSrX8%3D')