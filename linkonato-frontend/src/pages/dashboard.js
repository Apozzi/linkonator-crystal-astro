const messageEl = document.getElementById('message');
const listEl = document.getElementById('links-list');

document.getElementById('addLinkForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  const form = e.target;
  const title = form.title.value;
  const url = form.url.value;

  try {
    const res = await fetch('http://localhost:3000/api/links', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify({ title, url })
    });

    if (res.ok) {
      const newLink = await res.json();
      addLinkToList(newLink);
      form.reset();
      messageEl.innerHTML = '<span class="text-green-600">Link adicionado!</span>';
    } else {
      messageEl.innerHTML = '<span class="text-red-600">Erro ao adicionar</span>';
    }
  } catch (err) {
    messageEl.innerHTML = '<span class="text-red-600">Erro de conexão</span>';
  }
});

// Deletar link
window.deleteLink = async (id) => {
  if (!confirm('Tem certeza?')) return;

  try {
    const res = await fetch(`http://localhost:3000/api/links/${id}`, {
      method: 'DELETE',
      headers: { 'Authorization': `Bearer ${token}` }
    });

    if (res.ok) {
      document.querySelector(`[data-id="${id}"]`).remove();
      messageEl.innerHTML = '<span class="text-green-600">Link removido!</span>';
    }
  } catch (err) {
    messageEl.innerHTML = '<span class="text-red-600">Erro ao remover</span>';
  }
};

function addLinkToList(link) {
  const div = document.createElement('div');
  div.className = 'bg-semi-white p-5 rounded-lg flex items-center justify-between group cursor-move select-none transition hover:shadow-md';
  div.dataset.id = link.id;
  div.innerHTML = `
    <div class="flex items-center gap-4">
      <span class="text-2xl text-gray-400 select-none">⋮⋮</span>
      <div>
        <div class="font-semibold">${link.title}</div>
        <a href="${link.url}" target="_blank" class="text-sm text-blue-600 hover:underline break-all">
          ${link.url}
        </a>
      </div>
    </div>
    <button type="button" class="opacity-0 group-hover:opacity-100 text-red-600 hover:text-red-700 font-medium" onclick="deleteLink(${link.id})">
      Remover
    </button>
  `;
  listEl.appendChild(div);
}
