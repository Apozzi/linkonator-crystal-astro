import type { APIRoute } from 'astro';

export const GET: APIRoute = async ({ redirect, session }) => {
  if (session) {
    try {
      await session.destroy();
    } catch {
      session.delete("user");
    }
  }
  return redirect('/');
};
