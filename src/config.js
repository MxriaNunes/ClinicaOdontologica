const runtimeConfig = typeof window !== 'undefined' ? {
    url: window.SUPABASE_URL || window.supabaseConfig?.url || '',
    anonKey: window.SUPABASE_ANON_KEY || window.supabaseConfig?.anonKey || ''
} : {};

const envConfig = {
    url: typeof __SUPABASE_URL__ !== 'undefined' ? __SUPABASE_URL__ : '',
    anonKey: typeof __SUPABASE_ANON_KEY__ !== 'undefined' ? __SUPABASE_ANON_KEY__ : ''
};

// Preencha com os valores do projeto do Supabase.
// Exemplo:
// url: 'https://abcd1234.supabase.co',
// anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
export const supabaseConfig = {
    url: runtimeConfig.url || envConfig.url,
    anonKey: runtimeConfig.anonKey || envConfig.anonKey
};

export const isSupabaseConfigured = () => Boolean(
    supabaseConfig.url && supabaseConfig.anonKey
);
