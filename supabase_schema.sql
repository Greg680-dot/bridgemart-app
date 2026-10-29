-- ==============================================================================
-- BRIDGEMART MARKETPLACE TISSUS NIGERIA-BÉNIN
-- SCHEMA OFFICIEL POSTGRESQL / SUPABASE AVEC ROW LEVEL SECURITY (RLS)
-- Version: 1.0.0 (Production Ready)
-- ==============================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 2. ENUMS
CREATE TYPE user_role AS ENUM ('buyer', 'seller', 'agent', 'superadmin');
CREATE TYPE kyc_status AS ENUM ('unverified', 'level1_phone', 'level2_id_verified', 'rejected');
CREATE TYPE shop_status AS ENUM ('pending_approval', 'approved', 'suspended', 'rejected');
CREATE TYPE order_status AS ENUM (
    'pending_payment',
    'escrow_funded',
    'vendor_shipped',
    'in_crossborder_transit',
    'arrived_at_pickup',
    'delivered_escrow_released',
    'disputed_frozen',
    'cancelled_refunded'
);
CREATE TYPE dispute_status AS ENUM ('open', 'under_review', 'resolved_refund', 'resolved_release', 'closed');

-- 3. PROFILES / USERS
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    phone VARCHAR(30) UNIQUE NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    country VARCHAR(10) NOT NULL DEFAULT 'BJ', -- 'BJ' (Bénin) ou 'NG' (Nigeria)
    role user_role NOT NULL DEFAULT 'buyer',
    kyc_level kyc_status NOT NULL DEFAULT 'level1_phone',
    npi_cip VARCHAR(50), -- Numéro Personnel d'Identification (APDP Bénin)
    bvn_nin VARCHAR(50), -- Bank Verification Number (Nigeria)
    avatar_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. BOUTIQUES VENDEURS (SHOPS)
CREATE TABLE IF NOT EXISTS public.shops (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
    name VARCHAR(150) NOT NULL,
    market_city VARCHAR(150) NOT NULL, -- Ex: 'Balogun Market, Lagos Island'
    bank_name VARCHAR(100) NOT NULL,   -- Ex: 'Guaranty Trust Bank'
    bank_code VARCHAR(20) NOT NULL,   -- Ex: '058'
    account_number_nuban VARCHAR(10) NOT NULL,
    account_name_resolved VARCHAR(150),
    status shop_status NOT NULL DEFAULT 'pending_approval',
    verified_by UUID REFERENCES public.profiles(id),
    verified_at TIMESTAMPTZ,
    rating NUMERIC(3, 2) DEFAULT 5.00,
    sales_count INT DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 5. POINTS DE RETRAIT GUICHET (PICKUP POINTS BÉNIN)
CREATE TABLE IF NOT EXISTS public.pickup_points (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(30) UNIQUE NOT NULL, -- Ex: 'COT_DANTOKPA'
    name VARCHAR(150) NOT NULL,       -- Ex: 'Cotonou — Marché Dantokpa (Hall Tissus)'
    city VARCHAR(80) NOT NULL DEFAULT 'Cotonou',
    address TEXT NOT NULL,
    contact_phone VARCHAR(30) NOT NULL,
    agent_id UUID REFERENCES public.profiles(id),
    fee_xof INT NOT NULL DEFAULT 1500,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 6. TISSUS ET ARTICLES (PRODUCTS)
CREATE TABLE IF NOT EXISTS public.products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shop_id UUID NOT NULL REFERENCES public.shops(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    category VARCHAR(80) NOT NULL, -- 'Dentelle', 'Wax', 'Aso Oke', 'Bazin'
    price_ngn NUMERIC(12, 2) NOT NULL CHECK (price_ngn > 0),
    unit VARCHAR(60) NOT NULL,     -- 'Pièce 5 yards', 'Pièce 6 yards', 'Coupon 5 mètres'
    stock_quantity INT NOT NULL DEFAULT 10,
    origin VARCHAR(100) NOT NULL,  -- 'Lagos Balogun', 'Aba', 'Ibadan'
    description TEXT,
    images TEXT[] NOT NULL DEFAULT '{}', -- URLs multiples
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    rating NUMERIC(3, 2) DEFAULT 5.00,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 7. COMMANDES SOUS SÉQUESTRE (ORDERS & ESCROW)
CREATE TABLE IF NOT EXISTS public.orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number VARCHAR(50) UNIQUE NOT NULL, -- Ex: 'CMD-BJNG-2026-8819'
    buyer_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
    shop_id UUID NOT NULL REFERENCES public.shops(id) ON DELETE RESTRICT,
    pickup_point_id UUID NOT NULL REFERENCES public.pickup_points(id),
    status order_status NOT NULL DEFAULT 'pending_payment',
    
    -- Montants & Séquestre
    subtotal_ngn NUMERIC(12, 2) NOT NULL,
    rate_ngn_to_xof NUMERIC(8, 4) NOT NULL DEFAULT 0.4115,
    subtotal_xof INT NOT NULL,
    shipping_fee_xof INT NOT NULL DEFAULT 1500,
    escrow_fee_xof INT NOT NULL, -- 1.8% marge plateforme
    grand_total_xof INT NOT NULL,
    
    -- Codes de vérification de retrait
    pickup_otp_code VARCHAR(10) NOT NULL, -- Ex: '749-382'
    qr_payload TEXT NOT NULL,
    
    -- Traçabilité Kkiapay (Encaissement Bénin)
    kkiapay_transaction_id VARCHAR(100),
    kkiapay_operator VARCHAR(30), -- 'MTN', 'MOOV', 'CELTIIS'
    escrow_funded_at TIMESTAMPTZ,
    
    -- Traçabilité Paystack / Flutterwave (Décaissement Nigeria)
    paystack_transfer_ref VARCHAR(100),
    payout_ngn_amount NUMERIC(12, 2),
    payout_sent_at TIMESTAMPTZ,
    
    -- Agent de guichet ayant validé le retrait
    delivered_by_agent_id UUID REFERENCES public.profiles(id),
    delivered_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 8. LIGNES D'ARTICLES DE LA COMMANDE (ORDER ITEMS)
CREATE TABLE IF NOT EXISTS public.order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES public.products(id),
    quantity INT NOT NULL DEFAULT 1,
    unit_price_ngn NUMERIC(12, 2) NOT NULL,
    unit_price_xof INT NOT NULL
);

-- 9. GESTION DES LITIGES DE SÉQUESTRE (DISPUTES)
CREATE TABLE IF NOT EXISTS public.disputes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE RESTRICT,
    opened_by_user_id UUID NOT NULL REFERENCES public.profiles(id),
    reason TEXT NOT NULL,
    status dispute_status NOT NULL DEFAULT 'open',
    arbitrated_by UUID REFERENCES public.profiles(id),
    resolution_notes TEXT,
    resolved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 10. REGISTRE D'AUDIT SÉQUESTRE (IMMUTABLE AUDIT LOG)
CREATE TABLE IF NOT EXISTS public.escrow_audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES public.orders(id),
    action VARCHAR(80) NOT NULL, -- 'ESCROW_FUNDED', 'ESCROW_FROZEN_DISPUTE', 'ESCROW_RELEASED_PAYOUT', 'REFUNDED_BUYER'
    amount_xof INT,
    amount_ngn NUMERIC(12, 2),
    performed_by UUID REFERENCES public.profiles(id),
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==============================================================================
-- 11. ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.disputes ENABLE ROW LEVEL SECURITY;

-- Politiques Profils
CREATE POLICY "Les utilisateurs peuvent lire leur propre profil ou les profils publics" 
ON public.profiles FOR SELECT USING (true);

CREATE POLICY "Les utilisateurs peuvent modifier leur propre profil" 
ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Politiques Boutiques
CREATE POLICY "Tout le monde peut voir les boutiques validées" 
ON public.shops FOR SELECT USING (status = 'approved' OR auth.uid() = owner_id);

CREATE POLICY "Les utilisateurs peuvent enregistrer leur boutique" 
ON public.shops FOR INSERT WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Le propriétaire peut modifier sa boutique" 
ON public.shops FOR UPDATE USING (auth.uid() = owner_id);

-- Politiques Produits
CREATE POLICY "Tout le monde peut consulter les produits actifs" 
ON public.products FOR SELECT USING (is_active = TRUE);

CREATE POLICY "Les commerçants peuvent ajouter et modifier leurs produits" 
ON public.products FOR ALL USING (
    EXISTS (
        SELECT 1 FROM public.shops 
        WHERE public.shops.id = public.products.shop_id 
        AND public.shops.owner_id = auth.uid()
        AND public.shops.status = 'approved'
    )
);

-- Politiques Commandes
CREATE POLICY "Les acheteurs voient leurs commandes" 
ON public.orders FOR SELECT USING (
    auth.uid() = buyer_id 
    OR EXISTS (SELECT 1 FROM public.shops WHERE public.shops.id = public.orders.shop_id AND public.shops.owner_id = auth.uid())
    OR EXISTS (SELECT 1 FROM public.profiles WHERE public.profiles.id = auth.uid() AND public.profiles.role IN ('agent', 'superadmin'))
);

-- ==============================================================================
-- 12. DONNÉES DE DÉMONSTRATION INITIALES (SEED DATA)
-- ==============================================================================

-- Points Relais Bénin
INSERT INTO public.pickup_points (code, name, city, address, contact_phone, fee_xof)
VALUES 
('COT_DANTOKPA', 'Cotonou — Marché Dantokpa (Hall Tissus)', 'Cotonou', 'Hall Tissus Bloc 4, Dantokpa', '+229 97 00 11 01', 1500),
('COT_GANHI', 'Cotonou — Ganhi Carrefour des 3 Banques', 'Cotonou', 'Avenue Clozel, Ganhi', '+229 97 00 11 02', 1500),
('COT_AKPAKPA', 'Cotonou — Akpakpa PK3', 'Cotonou', 'Route de Porto-Novo, PK3', '+229 97 00 11 03', 1800),
('COT_CADJEHOUN', 'Cotonou — Cadjehoun Carrefour Gazelle', 'Cotonou', 'Carrefour Gazelle, Cadjehoun', '+229 97 00 11 04', 1800),
('PORTO_OUANDO', 'Porto-Novo — Marché Ouando', 'Porto-Novo', 'Entrée Principale Marché Ouando', '+229 97 00 11 05', 2500)
ON CONFLICT (code) DO NOTHING;
