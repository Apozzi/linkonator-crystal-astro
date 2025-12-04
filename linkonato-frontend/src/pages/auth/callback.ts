import type { APIRoute } from 'astro';

export const POST: APIRoute = async ({ request, redirect, session }) => {
  const { token, user } = await request.json();

  if (!user || !token) {
    return new Response("Invalid login", { status: 400 });
  } 

  if (!session) {
    throw new Error("Session não configurada");
  }

  await session.set("user", {
    id: user.id,
    username: user.username,
    email: user.email,
    token: token
  });

  return redirect('/dashboard');
};
