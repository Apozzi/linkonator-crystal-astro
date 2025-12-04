const doc :any = document;
const loginForm: any = document.getElementById('loginForm');
const msg: any = document.getElementById('message');

loginForm.addEventListener('submit', async (e: any) => {
  e.preventDefault();

  const email = doc.getElementById('email').value;
  const password = doc.getElementById('password').value;

  try {
    const res = await fetch('http://localhost:3000/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password })
    });

    const data = await res.json();

    if (!res.ok) {
      msg.innerHTML = `<span class="text-red-600">${data.error || 'Erro ao logar'}</span>`;
      return;
    }

    const callback = await fetch('/auth/callback', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify(data)
    });

    if (callback.redirected) {
      window.location.href = callback.url;
    }

  } catch (e) {
    msg.innerHTML = `<span class="text-red-600">Erro de conexão</span>`;
  }
});
