setInterval(() => {
  if (Math.random() > 0.95) {
    const doc : any = document;
    doc.querySelector('.crt').style.transform = 'translate(3px, -3px)';
    setTimeout(() => {
      doc.querySelector('.crt').style.transform = '';
    }, 80);
  }
}, 2000);

document.addEventListener("DOMContentLoaded", () => {
  const count = window.innerWidth < 768 ? 50 : 100; // menos em mobile

  for (let i = 0; i < count; i++) {
    const star = document.createElement("div");
    star.className = "twinkle";

    const size = Math.random() * 3 + 1;
    star.style.width = `${size}px`;
    star.style.height = `${size}px`;
    star.style.left = `${Math.random() * 100}vw`;
    star.style.top = `${Math.random() * 100}vh`;

    const duration = Math.random() * 5 + 3;
    const delay = Math.random() * 5;
    star.style.animation = `twinkle ${duration}s infinite ${delay}s`;

    document.body.appendChild(star);
  }

    const matrix = document.getElementById("matrix");
    const fakeLinks = [
      "http://192.168.0.666/admin",
      "https://deepnet.onion/linkonator_v9",
      "ftp://anon:pass@darkserver.ru/secret",
      "http://localhost:1337/debug",
      "https://neuralink.gov.br/experiment/07",
      "file:///C:/Windows/System32/linkonator.exe",
      "http://intranet.corpo.gov/employees/007",
      "https://mega.nz/folder/XxXxXxXx#linkonator2025",
      "http://10.0.0.13:8080/root",
      "ssh root@45.77.21.99 -p 2222",
      "https://vault.linkonator.zer0/day9",
      "http://satelite-7.mil.br/transmissao",
      "telnet bbs.oldnet.org 23",
      "gopher://gopher.linkonator.club/1",
      "http://127.0.0.1:3000/devtools",
      "https://pastebin.com/raw/h4x0r2025",
      "http://torproject.org/download/linkonator",
      "steam://connect/45.32.123.88:27015",
      "magnet:?xt=urn:btih:linkonator1337",
      "http://nsa.gov/monitor/usuario/brasil-42",
      "https://github.com/x/linkonator-private",
      "discord.gg/linkonator-underground",
      "http://matrix.hasYou.neo"
    ];

    const createChar = () => {
      const el = document.createElement("div");
      el.className = "char2";
      el.textContent = fakeLinks[Math.floor(Math.random() * fakeLinks.length)];

      el.style.left = (Math.random() * 100 - 20)  + "vw";
      el.style.top  = Math.random() * 100 + "vh";
      el.style.position = "fixed"
      el.style.color = "rgba(255, 255, 255, 0.044)";

      const duration = Math.random() * 6 + 3;
      const delay = Math.random() * 5;
      el.style.animation = `appear ${duration}s linear ${delay}s infinite`;

      if (matrix) matrix.appendChild(el);

      setTimeout(() => el.remove(), 15000);
    };

    const total = window.innerWidth < 768 ? 10 : 20;
    for (let i = 0; i < total; i++) {
      setTimeout(createChar, i * 120);
    }

    setInterval(() => {
      if (document.hidden) return;
      createChar();
    }, 800);
});
