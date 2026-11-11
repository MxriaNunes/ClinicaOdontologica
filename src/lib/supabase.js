import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { isSupabaseConfigured, supabaseConfig } from '../config.js';

export const supabase = isSupabaseConfigured()
    ? createClient(supabaseConfig.url, supabaseConfig.anonKey, {
        auth: {
            persistSession: true,
            autoRefreshToken: true,
            detectSessionInUrl: true
        }
    })
    : null;

export async function testSupabaseConnection() {
    if (!supabase) {
        return { ok: false, error: 'Supabase não configurado. Confira SUPABASE_URL e SUPABASE_ANON_KEY no arquivo .env.' };
    }

    const { error } = await supabase.from('services').select('id').limit(1);

    if (error) {
        return { ok: false, error: error.message };
    }

    return { ok: true, message: 'Conexão com Supabase funcionando.' };
}
