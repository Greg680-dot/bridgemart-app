import os

html_content = '''<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
  <meta name="theme-color" content="#008751">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
  <title>BridgeMart — Bénin · Nigeria Marketplace</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- Supabase Cloud Client SDK -->
  <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
  <style>
    :root {
      /* Brand Identity Proposal 2 */
      --bridge-green: #008751;
      --deep-green: #006B3F;
      --market-yellow: #FCD116;
      --signal-red: #E8112D;
      --ink: #10201A;
      --text-muted: #4F5E56;
      --bg: #FAFAF5;
      --surface: #EEF0E6;
      --border: #E2E4DA;
      --green-tint: #E3F2EA;

      /* Aliases */
      --primary: var(--bridge-green);
      --primary-light: var(--deep-green);
      --secondary: var(--market-yellow);
      --accent: var(--signal-red);
      --nigeria-green: var(--bridge-green);
      --benin-green: var(--bridge-green);
      --text: var(--ink);
      --success: var(--deep-green);
      --error: var(--signal-red);
    }
    * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Plus Jakarta Sans', sans-serif; -webkit-tap-highlight-color: transparent; }
    body {
      background: #0B132B;
      color: var(--text);
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      padding: 20px;
    }
    .device-container {
      width: 100%;
      max-width: 412px;
      height: 860px;
      background: #000;
      border-radius: 46px;
      padding: 12px;
      box-shadow: 0 25px 60px rgba(0,0,0,0.6), 0 0 0 2px rgba(255,255,255,0.1);
      position: relative;
    }
    .screen {
      width: 100%;
      height: 100%;
      background: var(--bg);
      border-radius: 36px;
      overflow: hidden;
      display: flex;
      flex-direction: column;
      position: relative;
    }
    @media (max-width: 600px) {
      body {
        padding: 0;
        margin: 0;
        background: var(--bg);
        align-items: stretch;
        min-height: 100vh;
        min-height: 100dvh;
        height: 100vh;
        height: 100dvh;
      }
      .device-container {
        max-width: 100%;
        height: 100%;
        border-radius: 0;
        padding: 0;
        box-shadow: none;
      }
      .screen {
        border-radius: 0;
      }
      .status-bar {
        display: none !important;
      }
      .app-header {
        padding-top: calc(env(safe-area-inset-top, 12px) + 8px);
      }
      .nav-bar {
        padding-bottom: calc(env(safe-area-inset-bottom, 12px) + 6px);
        height: calc(68px + env(safe-area-inset-bottom, 0px));
      }
    }
    /* Status bar */
    .status-bar {
      height: 40px;
      background: #fff;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 0 20px;
      font-size: 12px;
      font-weight: 700;
      color: var(--text);
      z-index: 10;
    }
    .notch {
      width: 120px;
      height: 18px;
      background: #000;
      border-radius: 0 0 12px 12px;
    }
    /* App Header */
    .app-header {
      background: #fff;
      padding: 10px 16px 12px;
      border-bottom: 1px solid var(--border);
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .brand-box {
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .logo-mark {
      width: 38px;
      height: 38px;
      background: var(--bridge-green);
      border-radius: 11px;
      position: relative;
      display: flex;
      justify-content: center;
      align-items: center;
      flex-shrink: 0;
      box-shadow: 0 2px 6px rgba(0, 135, 81, 0.2);
    }
    .logo-mark .diamond {
      position: absolute;
      top: 6px;
      width: 6px;
      height: 6px;
      background: var(--signal-red);
      transform: rotate(45deg);
    }
    .logo-mark .arch {
      position: absolute;
      top: 13px;
      width: 22px;
      height: 13px;
      border: 3.5px solid #FFFFFF;
      border-bottom: none;
      border-radius: 13px 13px 0 0;
    }
    .logo-mark .base-road {
      position: absolute;
      bottom: 9px;
      width: 24px;
      height: 4px;
      background: var(--market-yellow);
      border-radius: 2px;
    }
    .brand-title {
      font-size: 18px;
      font-weight: 900;
      color: var(--ink);
      letter-spacing: -0.4px;
      line-height: 1.05;
    }
    .brand-title span {
      color: var(--deep-green);
    }
    .brand-sub {
      font-size: 8px;
      font-weight: 800;
      color: var(--text-muted);
      letter-spacing: 0.9px;
      margin-top: 2px;
    }
    .cart-btn {
      position: relative;
      background: none;
      border: none;
      font-size: 18px;
      color: var(--primary);
      cursor: pointer;
      padding: 6px;
    }
    .cart-badge {
      position: absolute;
      top: 0;
      right: 0;
      background: var(--accent);
      color: #fff;
      font-size: 10px;
      font-weight: 800;
      width: 17px;
      height: 17px;
      border-radius: 50%;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .user-avatar-btn {
      background: var(--surface);
      border: 1.5px solid var(--border);
      border-radius: 50%;
      width: 34px;
      height: 34px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 11px;
      font-weight: 800;
      color: var(--primary);
      cursor: pointer;
      transition: all 0.2s;
    }
    .user-avatar-btn:hover {
      border-color: var(--primary);
      transform: scale(1.05);
    }
    /* Main Content Area */
    .content-area {
      flex: 1;
      overflow-y: auto;
      padding-bottom: 80px;
    }
    .content-area::-webkit-scrollbar { display: none; }
    /* Bottom Navigation Bar */
    .nav-bar {
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      height: 68px;
      background: #fff;
      border-top: 1px solid var(--border);
      display: flex;
      justify-content: space-around;
      align-items: center;
      padding-bottom: 6px;
      z-index: 20;
    }
    .nav-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 3px;
      font-size: 10px;
      font-weight: 700;
      color: var(--text-muted);
      cursor: pointer;
      transition: color 0.2s;
      width: 25%;
    }
    .nav-item i { font-size: 18px; }
    .nav-item.active { color: var(--bridge-green); }
    /* Views */
    .view { display: none; }
    .view.active { display: block; }
    /* Role Views */
    .role-view {
      display: flex;
      flex-direction: column;
      height: 100%;
      width: 100%;
    }
    /* Banner Escrow */
    .escrow-banner {
      background: linear-gradient(135deg, var(--deep-green), var(--bridge-green));
      color: #fff;
      padding: 12px 14px;
      margin: 12px 14px 10px;
      border-radius: 14px;
      display: flex;
      align-items: center;
      gap: 12px;
      box-shadow: 0 4px 12px rgba(0, 107, 63, 0.2);
    }
    .escrow-icon {
      width: 36px;
      height: 36px;
      background: rgba(255, 255, 255, 0.2);
      border-radius: 50%;
      display: flex;
      justify-content: center;
      align-items: center;
      font-size: 18px;
      flex-shrink: 0;
    }
    .rate-pill {
      background: var(--market-yellow);
      color: var(--ink);
      padding: 2px 8px;
      border-radius: 12px;
      font-size: 10px;
      font-weight: 800;
      display: inline-block;
    }
    /* Search Box */
    .search-box {
      margin: 0 14px 10px;
      background: #fff;
      border-radius: 12px;
      padding: 8px 12px;
      display: flex;
      align-items: center;
      gap: 8px;
      border: 1px solid var(--border);
    }
    .search-box input {
      border: none;
      outline: none;
      width: 100%;
      font-size: 12px;
      background: transparent;
      color: var(--text);
    }
    .search-box i { color: var(--text-muted); font-size: 14px; }
    /* Categories */
    .categories-bar {
      display: flex;
      gap: 8px;
      padding: 0 14px 10px;
      overflow-x: auto;
      scrollbar-width: none;
    }
    .categories-bar::-webkit-scrollbar { display: none; }
    .cat-chip {
      background: #fff;
      border: 1px solid var(--border);
      padding: 6px 12px;
      border-radius: 20px;
      font-size: 11px;
      font-weight: 700;
      white-space: nowrap;
      cursor: pointer;
      color: var(--text-muted);
      transition: all 0.2s;
    }
    .cat-chip.active {
      background: var(--green-tint);
      color: var(--bridge-green);
      border-color: var(--bridge-green);
    }
    /* Products Grid */
    .products-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
      padding: 0 14px 14px;
    }
    .product-card {
      background: #fff;
      border-radius: 14px;
      overflow: hidden;
      border: 1px solid var(--border);
      display: flex;
      flex-direction: column;
      box-shadow: 0 2px 8px rgba(0,0,0,0.03);
      cursor: pointer;
      transition: transform 0.15s ease, box-shadow 0.15s ease;
    }
    .product-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }
    .product-img {
      height: 130px;
      position: relative;
      background: #eee;
      overflow: hidden;
    }
    .product-img img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.3s;
    }
    .product-card:hover .product-img img {
      transform: scale(1.04);
    }
    .origin-badge {
      position: absolute;
      top: 6px;
      left: 6px;
      background: rgba(0,0,0,0.7);
      color: #fff;
      padding: 2px 6px;
      border-radius: 6px;
      font-size: 9px;
      font-weight: 700;
      backdrop-filter: blur(2px);
    }
    .photo-count-badge {
      position: absolute;
      bottom: 6px;
      right: 6px;
      background: rgba(0,0,0,0.75);
      color: #fff;
      padding: 2px 7px;
      border-radius: 6px;
      font-size: 9px;
      font-weight: 800;
      display: flex;
      align-items: center;
      gap: 3px;
    }
    .rating-badge {
      position: absolute;
      top: 6px;
      right: 6px;
      background: #fff;
      color: var(--ink);
      padding: 2px 6px;
      border-radius: 6px;
      font-size: 9px;
      font-weight: 800;
      box-shadow: 0 1px 4px rgba(0,0,0,0.15);
    }
    .product-body {
      padding: 10px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      flex: 1;
    }
    .product-category {
      font-size: 9px;
      color: var(--text-muted);
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .product-name {
      font-size: 12px;
      font-weight: 800;
      color: var(--ink);
      margin: 2px 0 4px;
      line-height: 1.25;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
    .product-unit {
      font-size: 10px;
      color: var(--text-muted);
      margin-bottom: 6px;
    }
    .price-box {
      margin-top: auto;
      border-top: 1px dashed var(--border);
      padding-top: 6px;
    }
    .price-xof {
      font-size: 13px;
      font-weight: 900;
      color: var(--bridge-green);
    }
    .price-ngn {
      font-size: 10px;
      color: var(--text-muted);
      font-weight: 700;
    }
    .btn-add {
      background: var(--surface);
      color: var(--bridge-green);
      border: 1px solid var(--border);
      padding: 5px;
      border-radius: 6px;
      font-size: 11px;
      font-weight: 800;
      width: 100%;
      cursor: pointer;
      margin-top: 6px;
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 4px;
      transition: all 0.2s;
    }
    .btn-add:hover {
      background: var(--bridge-green);
      color: #fff;
    }
    /* Generic Card Box */
    .card-box {
      background: #fff;
      border-radius: 14px;
      padding: 14px;
      margin: 0 14px 14px;
      border: 1px solid var(--border);
      box-shadow: 0 2px 8px rgba(0,0,0,0.03);
    }
    /* Buttons */
    .btn-primary {
      background: var(--bridge-green);
      color: #fff;
      border: none;
      padding: 12px;
      border-radius: 10px;
      font-size: 13px;
      font-weight: 800;
      width: 100%;
      cursor: pointer;
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 6px;
      box-shadow: 0 3px 10px rgba(0, 135, 81, 0.2);
      transition: background 0.2s;
    }
    .btn-primary:active { opacity: 0.9; }
    .btn-success { background: var(--deep-green); }
    .btn-order-now {
      background: var(--market-yellow);
      color: var(--ink);
      border: none;
      border-radius: 10px;
      font-weight: 800;
      cursor: pointer;
    }
    /* Form elements */
    .form-group {
      margin-bottom: 12px;
    }
    .form-label {
      display: block;
      font-size: 11px;
      font-weight: 800;
      margin-bottom: 4px;
      color: var(--ink);
    }
    .form-control {
      width: 100%;
      padding: 10px 12px;
      border-radius: 8px;
      border: 1px solid var(--border);
      font-size: 12px;
      outline: none;
      background: #FAFAF5;
      color: var(--ink);
    }
    .form-control:focus {
      border-color: var(--bridge-green);
      background: #fff;
    }
    /* Quote Breakdown Box */
    .quote-box {
      background: var(--surface);
      border-radius: 10px;
      padding: 10px 12px;
      margin-top: 10px;
      font-size: 11px;
    }
    .quote-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 4px;
      color: var(--text-muted);
    }
    .quote-row.total {
      border-top: 1px solid var(--border);
      padding-top: 6px;
      margin-top: 6px;
      font-size: 13px;
      font-weight: 800;
      color: var(--ink);
    }
    /* Tracking Timeline */
    .timeline {
      padding-left: 10px;
      position: relative;
    }
    .step-item {
      display: flex;
      gap: 12px;
      position: relative;
      padding-bottom: 16px;
    }
    .step-item:last-child { padding-bottom: 0; }
    .step-item::before {
      content: '';
      position: absolute;
      left: 11px;
      top: 24px;
      bottom: 0;
      width: 2px;
      background: var(--border);
    }
    .step-item:last-child::before { display: none; }
    .step-dot {
      width: 24px;
      height: 24px;
      border-radius: 50%;
      background: #fff;
      border: 2px solid var(--border);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 10px;
      font-weight: 800;
      color: var(--text-muted);
      z-index: 2;
      flex-shrink: 0;
    }
    .step-item.done .step-dot {
      background: var(--bridge-green);
      border-color: var(--bridge-green);
      color: #fff;
    }
    .step-item.active .step-dot {
      background: var(--market-yellow);
      border-color: var(--market-yellow);
      color: var(--ink);
      box-shadow: 0 0 0 3px rgba(252, 209, 22, 0.3);
    }
    .step-content h4 {
      font-size: 12px;
      font-weight: 800;
      color: var(--ink);
    }
    .step-content p {
      font-size: 10px;
      color: var(--text-muted);
      margin-top: 2px;
    }
    /* Modals */
    .modal-overlay {
      position: absolute;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(0,0,0,0.65);
      z-index: 100;
      display: none;
      align-items: flex-end;
      backdrop-filter: blur(2px);
    }
    .modal-sheet {
      background: #fff;
      width: 100%;
      border-radius: 24px 24px 0 0;
      padding: 20px 18px;
      max-height: 85%;
      overflow-y: auto;
      box-shadow: 0 -10px 30px rgba(0,0,0,0.2);
      animation: slideUp 0.25s ease-out;
    }
    @keyframes slideUp {
      from { transform: translateY(100%); }
      to { transform: translateY(0); }
    }
    .account-select-card {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 12px;
      border: 1.5px solid var(--border);
      border-radius: 12px;
      margin-bottom: 10px;
      cursor: pointer;
      transition: all 0.2s;
    }
    .account-select-card:hover {
      border-color: var(--bridge-green);
      background: var(--green-tint);
    }
    .avatar-circle {
      width: 42px;
      height: 42px;
      border-radius: 50%;
      background: var(--bridge-green);
      color: #fff;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      font-weight: 900;
      flex-shrink: 0;
    }
    /* KPI Dashboard Cards */
    .kpi-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
      margin-bottom: 12px;
    }
    .kpi-card {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 10px;
    }
    .kpi-card-title {
      font-size: 9px;
      font-weight: 700;
      color: var(--text-muted);
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .kpi-card-val {
      font-size: 15px;
      font-weight: 900;
      color: var(--primary);
      margin-top: 3px;
    }
    .btn-action-sm {
      padding: 6px 10px;
      border-radius: 6px;
      border: none;
      font-size: 11px;
      font-weight: 700;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 4px;
    }
    .btn-green { background: #E8F5E9; color: #2E7D32; }
    .btn-red { background: #FFEBEE; color: #C62828; }
    .btn-blue { background: #E1F5FE; color: #0288D1; }

    /* Thumbnail Gallery */
    .thumb-item {
      width: 58px;
      height: 58px;
      border-radius: 8px;
      overflow: hidden;
      border: 2px solid transparent;
      cursor: pointer;
      flex-shrink: 0;
      opacity: 0.6;
      transition: all 0.2s;
    }
    .thumb-item.active {
      border-color: var(--bridge-green);
      opacity: 1;
      transform: scale(1.05);
    }
    .thumb-item img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
  </style>
</head>
<body>

<div class="device-container">
  <div class="screen">
    <!-- Status Bar -->
    <div class="status-bar">
      <span>16:50</span>
      <div class="notch"></div>
      <div style="display:flex; gap: 4px; align-items:center;">
        <i class="fas fa-signal" style="font-size: 11px;"></i>
        <i class="fas fa-wifi" style="font-size: 11px;"></i>
        <i class="fas fa-battery-full" style="font-size: 13px;"></i>
      </div>
    </div>

    <!-- ========================================== -->
    <!-- ROLE 1: ACHETEUR BÉNIN                      -->
    <!-- ========================================== -->
    <div id="role-view-buyer" class="role-view">
      <!-- App Header -->
      <div class="app-header">
        <div class="brand-box">
          <div class="logo-mark">
            <div class="diamond"></div>
            <div class="arch"></div>
            <div class="base-road"></div>
          </div>
          <div>
            <div class="brand-title">Bridge<span>Mart</span></div>
            <div class="brand-sub">BENIN · NIGERIA MARKETPLACE</div>
          </div>
        </div>
        <div style="display:flex; align-items:center; gap:8px;">
          <button class="cart-btn" onclick="switchTab('cart')">
            <i class="fas fa-shopping-bag"></i>
            <div class="cart-badge" id="cart-badge-count">1</div>
          </button>
          <button class="user-avatar-btn" onclick="openLoginModal()" title="Mon Profil / Changer de compte">
            <span id="header-avatar-buyer">AD</span>
          </button>
        </div>
      </div>

      <!-- Content Area -->
      <div class="content-area">

        <!-- VIEW 1: CATALOGUE -->
        <div id="view-catalog" class="view active">
          <!-- Escrow Guarantee Banner -->
          <div class="escrow-banner">
            <div class="escrow-icon"><i class="fas fa-shield-alt"></i></div>
            <div style="flex:1;">
              <div style="display:flex; justify-content:space-between; align-items:center;">
                <span style="font-size:12px; font-weight:800;">Séquestre Garanti</span>
                <span class="rate-pill">1 XOF = 2.43 NGN</span>
              </div>
              <p style="font-size:10px; color:rgba(255,255,255,0.85); margin-top:2px;">
                Payez en FCFA par Mobile Money. Le commerçant nigérian n'est payé qu'après retrait au Bénin.
              </p>
            </div>
          </div>

          <!-- Search -->
          <div class="search-box">
            <i class="fas fa-search"></i>
            <input type="text" placeholder="Rechercher dentelle, pagne wax, brodé..." oninput="filterProducts(this.value)">
          </div>

          <!-- Categories -->
          <div class="categories-bar">
            <div class="cat-chip active" onclick="selectCat(this, 'all')">Tous les tissus</div>
            <div class="cat-chip" onclick="selectCat(this, 'Dentelle')">Dentelle Suisse & Guipure</div>
            <div class="cat-chip" onclick="selectCat(this, 'Wax')">Pagne Wax & Ankara</div>
            <div class="cat-chip" onclick="selectCat(this, 'Aso Oke')">Tissus Cérémonie (Aso Oke)</div>
            <div class="cat-chip" onclick="selectCat(this, 'Bazin')">Bazin Riche</div>
          </div>

          <!-- Section Title -->
          <div style="padding: 0 14px 8px; display:flex; justify-content:space-between; align-items:center;">
            <span style="font-size:13px; font-weight:800;" id="product-count-label">6 Tissus Disponibles</span>
            <span style="font-size:10px; color:var(--text-muted);"><i class="fas fa-map-marker-alt"></i> Retrait : Cotonou</span>
          </div>

          <!-- Products Grid -->
          <div class="products-grid" id="products-container">
            <!-- Dynamically populated -->
          </div>
        </div>

        <!-- VIEW 2: TRANSFERT EXPRESS / ENVOI NAIRA -->
        <div id="view-transfer" class="view">
          <div style="padding:14px;">
            <div style="display:flex; align-items:center; gap:8px; margin-bottom:12px;">
              <div style="background:var(--market-yellow); width:28px; height:28px; border-radius:8px; display:flex; justify-content:center; align-items:center;">
                <i class="fas fa-paper-plane" style="color:var(--ink); font-size:12px;"></i>
              </div>
              <div>
                <h3 style="font-size:15px; font-weight:900;">Envoi Direct de Nairas (NGN)</h3>
                <p style="font-size:10px; color:var(--text-muted);">Réglez votre fournisseur au Nigeria sans intermédiaire informel</p>
              </div>
            </div>

            <div class="card-box" style="margin:0 0 14px;">
              <div class="form-group">
                <label class="form-label">Banque Nigériane du Bénéficiaire</label>
                <select class="form-control" id="bank-select" onchange="resetResolvedName()">
                  <option value="058">Guaranty Trust Bank (GTBank)</option>
                  <option value="044">Access Bank Plc</option>
                  <option value="057">Zenith Bank Plc</option>
                  <option value="011">First Bank of Nigeria</option>
                  <option value="033">United Bank for Africa (UBA)</option>
                </select>
              </div>
              <div class="form-group">
                <label class="form-label">Numéro de Compte NUBAN (10 chiffres)</label>
                <div style="display:flex; gap:6px;">
                  <input type="text" class="form-control" id="account-num-input" placeholder="0123456789" maxlength="10" value="0123456789">
                  <button type="button" class="btn-action-sm btn-green" onclick="resolveAccount()" style="white-space:nowrap; padding:0 12px;">
                    <i class="fas fa-check-circle"></i> Vérifier
                  </button>
                </div>
              </div>

              <div id="resolved-name-box" style="display:none; background:#E8F5E9; border:1px solid #A5D6A7; border-radius:8px; padding:8px 10px; margin-bottom:12px; align-items:center; gap:8px;">
                <i class="fas fa-user-check" style="color:#2E7D32;"></i>
                <div style="font-size:11px; color:#2E7D32; font-weight:700;" id="resolved-name-text">MAMA FOLAKE FABRICS VENTURES</div>
              </div>

              <div class="form-group">
                <label class="form-label">Montant à transférer en Naira (₦ NGN)</label>
                <input type="number" class="form-control" id="naira-amount-input" value="100000" oninput="updateTransferQuote()" style="font-size:15px; font-weight:800; color:var(--primary);">
              </div>

              <!-- Quote Details -->
              <div class="quote-box">
                <div class="quote-row"><span>Montant NGN :</span><strong id="q-ngn">₦ 100,000 NGN</strong></div>
                <div class="quote-row"><span>Contre-valeur brute (Taux 2.43) :</span><span id="q-raw-xof">41,152 XOF</span></div>
                <div class="quote-row"><span>Marge de change BridgeMart (1.8%) :</span><span id="q-spread">+741 XOF</span></div>
                <div class="quote-row"><span>Frais Mobile Money (1.2%) :</span><span id="q-kkiapay">+494 XOF</span></div>
                <div class="quote-row total"><span>Total à payer au Bénin :</span><strong style="color:var(--bridge-green);" id="q-total-xof">42,387 XOF</strong></div>
              </div>

              <button class="btn-primary" style="margin-top:14px;" onclick="executeDirectPayment()">
                <i class="fas fa-lock"></i> Initier le Virement Sécurisé
              </button>
            </div>
          </div>
        </div>

        <!-- VIEW 3: SUIVI COMMANDES & SÉQUESTRE -->
        <div id="view-orders" class="view">
          <div style="padding:14px;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
              <div>
                <h3 style="font-size:15px; font-weight:900;">Commande Active</h3>
                <p style="font-size:10px; color:var(--text-muted);">Réf: CMD-BJNG-2026-8819</p>
              </div>
              <span class="rate-pill" id="ord-status-pill" style="background:#E3F2FD; color:#1565C0;">En transit transfrontalier</span>
            </div>

            <!-- Escrow Notice Box -->
            <div style="background:#FFF9E6; border:1px solid #FFE082; padding:10px 12px; border-radius:12px; margin-bottom:14px; display:flex; gap:10px; align-items:center;">
              <i class="fas fa-shield-alt" style="color:#D48B16; font-size:20px;"></i>
              <div style="font-size:11px; color:#856404; line-height:1.3;">
                <strong>Fonds en Séquestre Garanti :</strong> Le vendeur à Lagos ne recevra ses <strong>₦85,000 NGN</strong> que lorsque vous aurez validé le colis au Bénin.
              </div>
            </div>

            <!-- Code de retrait Sécurisé -->
            <div class="card-box" style="margin:0 0 14px; text-align:center;">
              <div style="font-size:11px; font-weight:700; color:var(--text-muted); text-transform:uppercase; letter-spacing:0.5px;">Code de Retrait Sécurisé (OTP)</div>
              <div style="font-size:26px; font-weight:900; letter-spacing:4px; color:var(--primary); margin:6px 0;" id="order-pickup-code">749-382</div>
              <p style="font-size:10px; color:var(--text-muted);">Présentez ce code et votre pièce d'identité au point relais :<br><strong>Guichet Marché Dantokpa, Cotonou</strong></p>
              <div style="margin-top:10px;">
                <button class="btn-action-sm btn-green" onclick="advanceOrderStep()"><i class="fas fa-forward"></i> Simuler avancée de l'étape du colis</button>
              </div>
            </div>

            <!-- Suivi des Étapes -->
            <div class="card-box" style="margin:0 0 14px;">
              <div style="font-size:12px; font-weight:800; margin-bottom:12px;"><i class="fas fa-route"></i> Étapes de votre commande</div>
              <div class="timeline" id="ord-timeline">
                <!-- Dynamically generated -->
              </div>
            </div>

            <!-- Actions Litige / Reçu -->
            <div style="display:flex; gap:8px;">
              <button class="btn-action-sm btn-red" style="flex:1; justify-content:center; padding:10px;" onclick="openDisputeModal()">
                <i class="fas fa-exclamation-triangle"></i> Ouvrir un litige
              </button>
              <button class="btn-action-sm btn-blue" style="flex:1; justify-content:center; padding:10px;" onclick="showReceiptModal()">
                <i class="fas fa-file-invoice"></i> Voir le reçu officiel
              </button>
            </div>
          </div>
        </div>

        <!-- VIEW 4: PANIER & CHECKOUT -->
        <div id="view-cart" class="view">
          <div style="padding:14px;">
            <h3 style="font-size:15px; font-weight:900; margin-bottom:10px;">Mon Panier d'Achat</h3>
            <div class="card-box" style="margin:0 0 12px;" id="cart-items-container">
              <!-- Injected by JS -->
            </div>

            <!-- Point de Retrait -->
            <div class="card-box" style="margin:0 0 12px;">
              <div class="form-group" style="margin-bottom:0;">
                <label class="form-label"><i class="fas fa-map-marker-alt" style="color:var(--primary);"></i> Choisissez votre Point Relais au Bénin</label>
                <select class="form-control" id="pickup-select" onchange="updateCartTotal()">
                  <option value="1500">Cotonou — Marché Dantokpa (Hall Tissus) (+1,500 XOF)</option>
                  <option value="1500">Cotonou — Ganhi Carrefour des 3 Banques (+1,500 XOF)</option>
                  <option value="1800">Cotonou — Akpakpa PK3 (+1,800 XOF)</option>
                  <option value="1800">Cotonou — Cadjehoun Carrefour Gazelle (+1,800 XOF)</option>
                  <option value="2500">Porto-Novo — Marché Ouando (+2,500 XOF)</option>
                </select>
              </div>
            </div>

            <!-- Récapitulatif -->
            <div class="card-box" style="margin:0 0 14px;">
              <div style="font-size:12px; font-weight:800; margin-bottom:8px;">Récapitulatif & Taux Garanti</div>
              <div class="quote-row"><span>Sous-total Tissus (NGN) :</span><strong id="cart-total-ngn">₦ 85,000 NGN</strong></div>
              <div class="quote-row"><span>Contre-valeur (XOF) :</span><span id="cart-total-xof">34,978 XOF</span></div>
              <div class="quote-row"><span>Transport Lagos ➔ Cotonou :</span><span id="cart-shipping-fee">+1,500 XOF</span></div>
              <div class="quote-row"><span>Frais Séquestre & Plateforme (1.8%) :</span><span id="cart-escrow-fee">+630 XOF</span></div>
              <div class="quote-row total"><span>Total à Payer :</span><strong style="color:var(--primary); font-size:15px;" id="cart-grand-total">37,108 XOF</strong></div>
            </div>

            <button class="btn-primary btn-success" onclick="openPaymentModal()">
              <i class="fas fa-lock"></i> Payer en FCFA par Mobile Money (Kkiapay)
            </button>
          </div>
        </div>

        <!-- VIEW 5: PROFIL ACHETEUR & OPTION DEVENIR VENDEUR -->
        <div id="view-profile" class="view">
          <div style="padding:14px;">
            <div class="card-box" style="margin:0 0 14px; text-align:center;">
              <div class="avatar-circle" style="margin:0 auto 8px; width:54px; height:54px; font-size:18px;">AD</div>
              <h3 style="font-size:16px; font-weight:900;" id="profile-user-name">Amina Dossou</h3>
              <p style="font-size:11px; color:var(--text-muted);">+229 97 01 23 45 • Cotonou, Bénin 🇧🇯</p>
              <div style="margin-top:8px;">
                <span class="rate-pill" style="background:#E8F5E9; color:#2E7D32; font-size:10px;">
                  <i class="fas fa-check-circle"></i> KYC Niveau 2 Vérifié (CIP APDP)
                </span>
              </div>
            </div>

            <!-- PROMOTION : DEVENIR VENDEUR -->
            <div class="card-box" style="margin:0 0 14px; background:linear-gradient(135deg, #FFFDF0, #FFF9D6); border:1.5px solid #FCD116;" id="become-seller-banner-box">
              <div style="display:flex; gap:10px; align-items:flex-start;">
                <div style="background:var(--market-yellow); width:36px; height:36px; border-radius:10px; display:flex; justify-content:center; align-items:center; flex-shrink:0;">
                  <i class="fas fa-store" style="color:var(--ink); font-size:16px;"></i>
                </div>
                <div style="flex:1;">
                  <div style="display:flex; justify-content:space-between; align-items:center;">
                    <h4 style="font-size:13px; font-weight:900; color:var(--ink);">Devenir Vendeur sur BridgeMart</h4>
                    <span class="rate-pill" style="background:var(--bridge-green); color:#fff; font-size:9px;">Nigeria ➔ Bénin</span>
                  </div>
                  <p style="font-size:10px; color:var(--text-muted); margin:4px 0 8px;">
                    Vous vendez des tissus au Nigeria ? Ouvrez votre boutique. Vos articles seront validés par l'administration avant d'être visibles aux acheteurs.
                  </p>
                  <div id="seller-status-container">
                    <button class="btn-primary" style="background:var(--deep-green); font-size:11px; padding:8px 12px; width:auto;" onclick="openBecomeSellerModal()">
                      <i class="fas fa-plus-circle"></i> Créer ma Boutique de Tissus
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Paramètres / Changement de compte -->
            <div class="card-box" style="margin:0 0 14px;">
              <div style="font-size:12px; font-weight:800; margin-bottom:10px;">Sécurité & Compte</div>
              <div style="display:flex; justify-content:space-between; align-items:center; padding:8px 0; border-bottom:1px solid var(--border); font-size:11px;">
                <span>Langue de l'application</span>
                <strong>Français (FR)</strong>
              </div>
              <div style="display:flex; justify-content:space-between; align-items:center; padding:8px 0; border-bottom:1px solid var(--border); font-size:11px;">
                <span>Devise principale de paiement</span>
                <strong>FCFA (XOF)</strong>
              </div>
              <div style="display:flex; justify-content:space-between; align-items:center; padding:8px 0; font-size:11px;">
                <span>Protection Séquestre</span>
                <strong style="color:var(--success);">Active (100% garanti)</strong>
              </div>
            </div>

            <button class="btn-primary" style="background:#555;" onclick="openLoginModal()">
              <i class="fas fa-user-circle"></i> Changer d'utilisateur / Se reconnecter
            </button>
          </div>
        </div>

      </div>

      <!-- Bottom Nav Bar Acheteur -->
      <div class="nav-bar">
        <div class="nav-item active" onclick="switchTab('catalog')">
          <i class="fas fa-store"></i>
          <span>Catalogue</span>
        </div>
        <div class="nav-item" onclick="switchTab('transfer')">
          <i class="fas fa-paper-plane"></i>
          <span>Envoi Naira</span>
        </div>
        <div class="nav-item" onclick="switchTab('orders')">
          <i class="fas fa-box"></i>
          <span>Commandes</span>
        </div>
        <div class="nav-item" onclick="switchTab('profile')">
          <i class="fas fa-user"></i>
          <span>Profil</span>
        </div>
      </div>
    </div>
    <!-- END ROLE 1: ACHETEUR BÉNIN -->

    <!-- ========================================== -->
    <!-- ROLE 2: BOUTIQUE VENDEUR NIGERIA            -->
    <!-- ========================================== -->
    <div id="role-view-seller" class="role-view" style="display:none;">
      <!-- Seller Header -->
      <div class="app-header" style="background:#1B5E20; color:#fff;">
        <div class="brand-box">
          <div class="logo-mark" style="background:#FCD116;">
            <div class="diamond" style="background:#E8112D;"></div>
            <div class="arch" style="border-color:#008751;"></div>
            <div class="base-road" style="background:#006B3F;"></div>
          </div>
          <div>
            <div class="brand-title" style="color:#fff;">Mama Folake <span>Fabrics</span></div>
            <div class="brand-sub" style="color:rgba(255,255,255,0.8);">ESPACE BOUTIQUE • LAGOS BALOGUN 🇳🇬</div>
          </div>
        </div>
        <div style="display:flex; align-items:center; gap:8px;">
          <button class="user-avatar-btn" style="background:#FCD116; color:#10201A;" onclick="openLoginModal()" title="Changer d'utilisateur">
            MF
          </button>
        </div>
      </div>

      <!-- Seller Content -->
      <div class="content-area" style="padding:14px;">
        <!-- Seller Balance Card -->
        <div class="card-box" style="margin:0 0 14px; background:linear-gradient(135deg, #004D25, #008751); color:#fff;">
          <div style="font-size:11px; color:rgba(255,255,255,0.8);">Solde en Séquestre (Commandes en cours Cotonou) :</div>
          <div style="font-size:24px; font-weight:900; margin:4px 0 8px; color:var(--market-yellow);">₦ 170,000 NGN</div>
          <div style="display:flex; justify-content:space-between; font-size:10px; border-top:1px solid rgba(255,255,255,0.2); padding-top:6px;">
            <span>Versements cumulés (Paystack NGN) : <strong>₦ 2,450,000</strong></span>
            <span>Compte : GTBank **6789</span>
          </div>
        </div>

        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
          <h4 style="font-size:13px; font-weight:800;">Commandes à Expédier</h4>
          <span class="rate-pill" style="background:#E1F5FE; color:#0288D1;">1 Commande en attente</span>
        </div>

        <!-- Pending Order Card -->
        <div class="card-box" style="margin:0 0 14px;">
          <div style="display:flex; justify-content:space-between; font-size:11px; margin-bottom:6px;">
            <strong>CMD-BJNG-2026-9042</strong>
            <span class="rate-pill" style="background:#FFF3CD; color:#856404;" id="seller-status-1">À emballer</span>
          </div>
          <div style="font-size:12px; font-weight:700;">Dentelle Suisse Voile Brodé (5 yards)</div>
          <div style="font-size:10px; color:var(--text-muted); margin:2px 0 8px;">Acheteur : Amina Dossou (Cotonou Dantokpa)</div>
          <div style="display:flex; justify-content:space-between; align-items:center; border-top:1px solid var(--border); padding-top:6px;">
            <div style="font-size:13px; font-weight:900; color:var(--nigeria-green);">₦ 85,000 NGN</div>
            <button class="btn-action-sm btn-green" id="btn-seller-ship-1" onclick="sellerMarkShipped('CMD-BJNG-2026-9042')">
              <i class="fas fa-truck"></i> Confirmer expédition ➔ Cotonou
            </button>
          </div>
        </div>

        <!-- Actions Vendeur -->
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
          <h4 style="font-size:13px; font-weight:800;">Mes Tissus en Vente</h4>
          <button class="btn-action-sm btn-blue" onclick="openAddProductModal()">
            <i class="fas fa-plus"></i> Ajouter un Tissu
          </button>
        </div>

        <!-- Seller Products -->
        <div class="card-box" style="margin:0 0 14px;" id="seller-catalog-list">
          <!-- Populated by JS -->
        </div>

        <button class="btn-primary" style="background:#444;" onclick="openLoginModal()">
          <i class="fas fa-sign-out-alt"></i> Quitter l'espace Boutique
        </button>
      </div>
    </div>
    <!-- END ROLE 2: BOUTIQUE VENDEUR NIGERIA -->

    <!-- ========================================== -->
    <!-- ROLE 3: AGENT DE GUICHET (DANTOKPA RELAIS)  -->
    <!-- ========================================== -->
    <div id="role-view-agent" class="role-view" style="display:none;">
      <!-- Agent Header -->
      <div class="app-header" style="background:#004D25; color:#fff;">
        <div class="brand-box">
          <div class="logo-mark" style="background:#FCD116;">
            <div class="diamond" style="background:#E8112D;"></div>
            <div class="arch" style="border-color:#004D25;"></div>
            <div class="base-road" style="background:#006B3F;"></div>
          </div>
          <div>
            <div class="brand-title" style="color:#fff;">Guichet <span>Dantokpa</span></div>
            <div class="brand-sub" style="color:rgba(255,255,255,0.85);">AGENT: KOFFI DOSSOU • ID: AGT-COT-01 🇧🇯</div>
          </div>
        </div>
        <div style="display:flex; align-items:center; gap:8px;">
          <button class="user-avatar-btn" style="background:#FCD116; color:#004D25; font-weight:900;" onclick="openLoginModal()" title="Changer d'utilisateur">
            KD
          </button>
        </div>
      </div>

      <!-- Agent Content -->
      <div class="content-area" style="padding:14px;">
        <!-- KPI Row Agent -->
        <div style="display:flex; gap:8px; margin-bottom:14px;">
          <div style="flex:1; background:#fff; border:1px solid var(--border); border-radius:12px; padding:10px;">
            <div style="font-size:9px; font-weight:700; color:var(--text-muted); text-transform:uppercase;">En attente</div>
            <div style="font-size:16px; font-weight:900; color:#E65100; margin-top:2px;" id="agent-pending-count">4 Colis</div>
          </div>
          <div style="flex:1; background:#fff; border:1px solid var(--border); border-radius:12px; padding:10px;">
            <div style="font-size:9px; font-weight:700; color:var(--text-muted); text-transform:uppercase;">Retirés ce jour</div>
            <div style="font-size:16px; font-weight:900; color:var(--bridge-green); margin-top:2px;">8 Colis</div>
          </div>
          <div style="flex:1; background:#fff; border:1px solid var(--border); border-radius:12px; padding:10px;">
            <div style="font-size:9px; font-weight:700; color:var(--text-muted); text-transform:uppercase;">Commissions</div>
            <div style="font-size:16px; font-weight:900; color:var(--deep-green); margin-top:2px;">4,000 XOF</div>
          </div>
        </div>

        <!-- ZONE DE VALIDATION CODE OTP & REMISE -->
        <div class="card-box" style="margin:0 0 14px; border:1.5px solid var(--bridge-green);">
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
            <h4 style="font-size:13px; font-weight:900; color:var(--ink);">
              <i class="fas fa-qrcode" style="color:var(--bridge-green);"></i> Remise Colis & Déblocage Séquestre
            </h4>
            <span class="rate-pill" style="background:#E8F5E9; color:#2E7D32; font-size:9px;">Scan Immédiat</span>
          </div>
          <p style="font-size:10px; color:var(--text-muted); margin-bottom:10px;">
            Demandez à l'acheteur le code de retrait à 6 chiffres affiché sur son smartphone.
          </p>

          <div style="display:flex; gap:6px; margin-bottom:8px;">
            <input type="text" id="agent-otp-input" class="form-control" placeholder="Entrez le code OTP (Ex: 749-382)" style="font-size:15px; font-weight:800; letter-spacing:2px; text-align:center;">
            <button class="btn-action-sm btn-green" style="padding:0 14px; font-size:12px;" onclick="agentVerifyOtp()">
              <i class="fas fa-search"></i> Valider
            </button>
          </div>

          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
            <button class="btn-action-sm btn-blue" style="font-size:10px;" onclick="document.getElementById('agent-otp-input').value='749-382'; agentVerifyOtp();">
              <i class="fas fa-magic"></i> Tester avec le code 749-382
            </button>
            <span style="font-size:9px; color:var(--text-muted);">Marché Dantokpa • Bloc 4</span>
          </div>

          <!-- CARTE RÉSULTAT RECHERCHE COMMANDE -->
          <div id="agent-order-result-box" style="display:none; background:var(--surface); border-radius:10px; padding:12px; border:1px solid var(--border); margin-top:8px;">
            <div style="display:flex; justify-content:space-between; font-size:11px; margin-bottom:4px;">
              <strong id="agent-res-order-num">CMD-BJNG-2026-8819</strong>
              <span class="rate-pill" style="background:#E8F5E9; color:#2E7D32; font-size:9px;" id="agent-res-badge">Séquestre Prêt à Libérer</span>
            </div>
            <div style="font-size:11px; color:var(--ink); line-height:1.4;">
              <div><strong>Acheteur :</strong> Amina Dossou (+229 97 01 23 45)</div>
              <div><strong>Pièce Identité :</strong> CIP-BJ-1092837482 (Vérifiée APDP)</div>
              <div><strong>Article :</strong> Dentelle Suisse Voile Brodé (Pièce 5 yards)</div>
              <div><strong>Vendeur Lagos :</strong> Mama Folake Fabrics (GTBank Nigeria)</div>
            </div>
            <div style="margin:8px 0; padding:6px 8px; background:#fff; border-radius:6px; display:flex; justify-content:space-between; font-size:11px; font-weight:800;">
              <span>Séquestre Garanti : 38,108 XOF</span>
              <span style="color:var(--deep-green);">Virement NGN : ₦ 85,000</span>
            </div>

            <button class="btn-primary" style="background:var(--bridge-green); font-size:12px; padding:10px;" id="agent-btn-confirm-delivery" onclick="agentExecuteDelivery()">
              <i class="fas fa-check-circle"></i> Valider la Remise & Débloquer le Virement NGN
            </button>
          </div>
        </div>

        <!-- ARRIAGES TRANSFRONTALIERS (LAGOS ➔ DANTOKPA) -->
        <div class="card-box" style="margin:0 0 14px;">
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
            <div style="font-size:12px; font-weight:800; color:var(--ink);">
              <i class="fas fa-truck-moving" style="color:#0288D1;"></i> Colis en Transit (Frontière Sèmè-Kraké)
            </div>
            <span class="rate-pill" style="background:#E1F5FE; color:#0288D1; font-size:9px;">1 Colis</span>
          </div>
          <div style="border:1px solid var(--border); border-radius:8px; padding:10px; font-size:11px;" id="agent-transit-row">
            <div style="display:flex; justify-content:space-between;">
              <strong>CMD-BJNG-2026-9042</strong>
              <span style="color:#0288D1; font-weight:700;">Arrivé au parking transporteur</span>
            </div>
            <div style="font-size:10px; color:var(--text-muted); margin:3px 0;">
              Lagos Balogun ➔ Dantokpa • Poids: 2.1 kg (5 yards Dentelle)
            </div>
            <button class="btn-action-sm btn-blue" style="margin-top:6px;" onclick="agentScanArrived('CMD-BJNG-2026-9042')">
              <i class="fas fa-inbox"></i> Scanner Réception au Guichet & Alerter Acheteur (SMS)
            </button>
          </div>
        </div>

        <button class="btn-primary" style="background:#444;" onclick="openLoginModal()">
          <i class="fas fa-sign-out-alt"></i> Quitter la session Guichetier
        </button>
      </div>
    </div>
    <!-- END ROLE 3: AGENT DE GUICHET -->

    <!-- ========================================== -->
    <!-- ROLE 4: SUPER ADMIN CONSOLE                -->
    <!-- ========================================== -->
    <div id="role-view-superadmin" class="role-view" style="display:none;">
      <!-- Super Admin Header -->
      <div class="app-header" style="background:#B71C1C; color:#fff;">
        <div class="brand-box">
          <div class="logo-mark" style="background:#fff;">
            <div class="diamond" style="background:#E8112D;"></div>
            <div class="arch" style="border-color:#B71C1C;"></div>
            <div class="base-road" style="background:#FCD116;"></div>
          </div>
          <div>
            <div class="brand-title" style="color:#fff;">Bridge<span>Mart</span></div>
            <div class="brand-sub" style="color:rgba(255,255,255,0.85);">SUPER ADMIN CONSOLE • SURVEILLANCE SÉQUESTRE</div>
          </div>
        </div>
        <div style="display:flex; align-items:center; gap:8px;">
          <button class="user-avatar-btn" style="background:#fff; color:#B71C1C;" onclick="openLoginModal()" title="Changer d'utilisateur">
            SA
          </button>
        </div>
      </div>

      <!-- Super Admin Content -->
      <div class="content-area" style="padding:14px;">
        <!-- KPI Cards -->
        <div class="kpi-grid">
          <div class="kpi-card">
            <div class="kpi-card-title">Volume en Séquestre</div>
            <div class="kpi-card-val">4,892,000 XOF</div>
          </div>
          <div class="kpi-card">
            <div class="kpi-card-title">Colis en Transit</div>
            <div class="kpi-card-val" style="color:#0288D1;">38 Colis</div>
          </div>
          <div class="kpi-card">
            <div class="kpi-card-title">Marge Plateforme (1.8%)</div>
            <div class="kpi-card-val" style="color:var(--deep-green);">88,056 XOF</div>
          </div>
          <div class="kpi-card">
            <div class="kpi-card-title">Litiges en Arbitrage</div>
            <div class="kpi-card-val" style="color:var(--error);" id="admin-dispute-badge">1 Litige</div>
          </div>
        </div>

        <!-- CONFIGURATION BACKEND CLOUD (SUPABASE) -->
        <div class="card-box" style="margin:0 0 14px; border:1.5px solid #2E7D32; background:#F1F8E9;">
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
            <div style="font-size:12px; font-weight:800; color:#1B5E20;">
              <i class="fas fa-database"></i> Connexion Backend Cloud (Supabase)
            </div>
            <span class="rate-pill" id="supabase-status-pill" style="background:#C8E6C9; color:#2E7D32; font-size:9px;">
              Prêt à connecter
            </span>
          </div>
          <p style="font-size:10px; color:var(--text-muted); margin-bottom:8px;">
            Connectez votre projet Supabase pour synchroniser en temps réel les utilisateurs, les stocks et les séquestres.
          </p>
          <div class="form-group" style="margin-bottom:6px;">
            <label class="form-label" style="font-size:10px;">URL du Projet Supabase</label>
            <input type="text" class="form-control" id="supabase-url-input" placeholder="https://votre-projet.supabase.co" style="font-size:11px;">
          </div>
          <div class="form-group" style="margin-bottom:8px;">
            <label class="form-label" style="font-size:10px;">Clé Publique Anon (API Key)</label>
            <input type="password" class="form-control" id="supabase-key-input" placeholder="eyJhbGciOi..." style="font-size:11px;">
          </div>
          <div style="display:flex; gap:6px;">
            <button class="btn-action-sm btn-green" style="flex:1; justify-content:center;" onclick="testSupabaseConnection()">
              <i class="fas fa-plug"></i> Connecter Supabase
            </button>
            <button class="btn-action-sm btn-blue" style="flex:1; justify-content:center;" onclick="showSupabaseSchemaHelp()">
              <i class="fas fa-code"></i> Voir Schéma SQL
            </button>
          </div>
        </div>

        <!-- VALIDATION DES NOUVELLES BOUTIQUES -->
        <div class="card-box" style="margin:0 0 14px; border:1.5px solid #FCD116; background:#FFFDE7;">
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
            <div style="font-size:12px; font-weight:800; color:#856404;">
              <i class="fas fa-store"></i> Boutiques en Attente de Validation Super Admin
            </div>
            <span class="rate-pill" id="pending-shops-counter" style="background:#FCD116; color:#10201A; font-size:9px;">1 en attente</span>
          </div>
          <p style="font-size:10px; color:var(--text-muted); margin-bottom:10px;">
            Les vendeurs ne peuvent publier leurs tissus qu'après validation de leur identité et compte bancaire NUBAN.
          </p>
          <div id="admin-pending-shops-list">
            <!-- Dynamic pending shops -->
          </div>
        </div>

        <!-- Litige Actif à Arbitrer -->
        <div class="card-box" style="margin:0 0 14px; border-left:4px solid var(--error);">
          <div style="font-size:12px; font-weight:800; color:var(--error); margin-bottom:6px;">
            <i class="fas fa-gavel"></i> Litige à arbitrer (Séquestre Gelé)
          </div>
          <div id="admin-dispute-item">
            <div style="display:flex; justify-content:space-between; font-size:11px; margin-bottom:4px;">
              <strong>CMD-BJNG-2026-8819</strong>
              <span style="color:var(--error); font-weight:700;">Séquestre Gelé</span>
            </div>
            <div style="font-size:11px; color:var(--text); margin-bottom:4px;">
              <strong>Acheteur :</strong> Amina Dossou (Cotonou) 🇧🇯<br>
              <strong>Vendeur :</strong> Mama Folake Fabrics (Lagos) 🇳🇬<br>
              <strong>Motif :</strong> <em>« Motif de rosace non conforme à la commande »</em>
            </div>
            <div style="font-size:11px; margin:6px 0; color:var(--primary); font-weight:700;">
              Montant sous séquestre : 38,108 XOF (₦ 85,000 NGN)
            </div>
            <div style="display:flex; gap:6px; margin-top:8px;">
              <button class="btn-action-sm btn-red" style="flex:1;" onclick="adminArbitrate('refund')">
                <i class="fas fa-undo"></i> Rembourser Acheteur (XOF)
              </button>
              <button class="btn-action-sm btn-green" style="flex:1;" onclick="adminArbitrate('release')">
                <i class="fas fa-check"></i> Libérer NGN au Vendeur
              </button>
            </div>
          </div>
        </div>

        <!-- Pilotage du Taux de Change & Marge -->
        <div class="card-box" style="margin:0 0 14px;">
          <div style="font-size:13px; font-weight:800; margin-bottom:8px;"><i class="fas fa-sliders-h"></i> Pilotage Taux & Marge Plateforme</div>
          <div class="form-group">
            <label class="form-label">Taux de Référence XOF / NGN</label>
            <input type="text" class="form-control" id="admin-rate-input" value="2.43" style="font-weight:700;">
          </div>
          <div class="form-group">
            <label class="form-label">Marge Plateforme NaijaBénin (%)</label>
            <input type="number" class="form-control" id="admin-spread-input" value="1.8" step="0.1" style="font-weight:700;">
          </div>
          <button class="btn-primary" style="font-size:12px; padding:10px;" onclick="adminSaveRates()">
            <i class="fas fa-save"></i> Mettre à jour pour toute la Marketplace
          </button>
        </div>

        <button class="btn-primary" style="background:#444;" onclick="openLoginModal()">
          <i class="fas fa-sign-out-alt"></i> Quitter la Console Super Admin
        </button>
      </div>
    </div>
    <!-- END ROLE 4: SUPER ADMIN CONSOLE -->

    <!-- ========================================== -->
    <!-- MODALES DU SYSTÈME                         -->
    <!-- ========================================== -->

    <!-- LOGIN / ACCOUNT SWITCHER MODAL (4 RÔLES) -->
    <div class="modal-overlay" id="login-modal">
      <div class="modal-sheet">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;">
          <div>
            <h3 style="font-size:16px; font-weight:900; color:var(--ink);">Connexion BridgeMart</h3>
            <div style="font-size:10px; color:var(--text-muted);">Choisissez le compte pour ouvrir l'espace correspondant</div>
          </div>
          <i class="fas fa-times" style="font-size:16px; cursor:pointer;" onclick="closeModal('login-modal')"></i>
        </div>

        <!-- 1. Acheteur -->
        <div class="account-select-card" id="acc-card-buyer" onclick="loginAs('buyer')">
          <div class="avatar-circle">AD</div>
          <div style="flex:1;">
            <div style="font-size:13px; font-weight:800;">Amina Dossou</div>
            <div style="font-size:11px; color:var(--text-muted);">Acheteur Bénin • +229 97 01 23 45</div>
            <span class="rate-pill" style="background:var(--green-tint); color:var(--bridge-green); font-size:9px; margin-top:3px;">
              Espace Client (Catalogue, Séquestre & Retrait)
            </span>
          </div>
          <i class="fas fa-chevron-right" style="color:var(--text-muted); font-size:12px;"></i>
        </div>

        <!-- 2. Vendeur Nigeria -->
        <div class="account-select-card" id="acc-card-seller" onclick="loginAs('seller')">
          <div class="avatar-circle" style="background:var(--market-yellow); color:var(--ink);">MF</div>
          <div style="flex:1;">
            <div style="font-size:13px; font-weight:800;">Mama Folake Fabrics Ltd</div>
            <div style="font-size:11px; color:var(--text-muted);">Commerçante Nigeria • Balogun Market, Lagos</div>
            <span class="rate-pill" style="background:#FFF3CD; color:#856404; font-size:9px; margin-top:3px;">
              Espace Boutique Vendeur (Gestion & Versements NGN)
            </span>
          </div>
          <i class="fas fa-chevron-right" style="color:var(--text-muted); font-size:12px;"></i>
        </div>

        <!-- 3. Agent de Guichet Dantokpa -->
        <div class="account-select-card" id="acc-card-agent" onclick="loginAs('agent')">
          <div class="avatar-circle" style="background:#004D25; color:#FCD116;">KD</div>
          <div style="flex:1;">
            <div style="font-size:13px; font-weight:800;">Koffi Dossou (Agent Relais)</div>
            <div style="font-size:11px; color:var(--text-muted);">Guichet Marché Dantokpa, Cotonou • AGT-COT-01</div>
            <span class="rate-pill" style="background:#E1F5FE; color:#0288D1; font-size:9px; margin-top:3px;">
              Interface Guichet (Scanner QR, Remise & Virement)
            </span>
          </div>
          <i class="fas fa-chevron-right" style="color:var(--text-muted); font-size:12px;"></i>
        </div>

        <!-- 4. Super Admin -->
        <div class="account-select-card" id="acc-card-superadmin" onclick="loginAs('superadmin')">
          <div class="avatar-circle" style="background:var(--signal-red); color:#fff;">SA</div>
          <div style="flex:1;">
            <div style="font-size:13px; font-weight:800;">Super Administrateur</div>
            <div style="font-size:11px; color:var(--text-muted);">Direction BridgeMart • Validation & Arbitrage</div>
            <span class="rate-pill" style="background:#FFEBEE; color:var(--signal-red); font-size:9px; margin-top:3px;">
              Console Super Admin (Pilotage & Supabase)
            </span>
          </div>
          <i class="fas fa-chevron-right" style="color:var(--text-muted); font-size:12px;"></i>
        </div>
      </div>
    </div>

    <!-- BECOME SELLER MODAL -->
    <div class="modal-overlay" id="become-seller-modal">
      <div class="modal-sheet">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
          <h3 style="font-size:15px; font-weight:900;">Créer ma Boutique de Tissus (Nigeria)</h3>
          <i class="fas fa-times" style="cursor:pointer;" onclick="closeModal('become-seller-modal')"></i>
        </div>
        <p style="font-size:11px; color:var(--text-muted); margin-bottom:12px;">
          Remplissez les détails de votre boutique. Le Super Administrateur vérifiera vos coordonnées bancaires nigérianes avant d'activer votre boutique et de rendre vos tissus visibles aux acheteurs.
        </p>
        <div class="form-group">
          <label class="form-label">Nom de votre Boutique</label>
          <input type="text" class="form-control" id="reg-shop-name" placeholder="Ex: Dossou Prestige Textiles">
        </div>
        <div class="form-group">
          <label class="form-label">Marché / Ville au Nigeria</label>
          <select class="form-control" id="reg-shop-city">
            <option value="Balogun Market, Lagos Island">Balogun Market, Lagos Island 🇳🇬</option>
            <option value="Aba International Textile Complex">Aba International Textile Complex 🇳🇬</option>
            <option value="Ibadan Traditional Fabrics Center">Ibadan Traditional Fabrics Center 🇳🇬</option>
            <option value="Kano Dyes & Bazin Market">Kano Dyes & Bazin Market 🇳🇬</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Banque Nigériane (pour vos versements NGN)</label>
          <select class="form-control" id="reg-shop-bank">
            <option value="GTBank">Guaranty Trust Bank (GTBank)</option>
            <option value="Access Bank">Access Bank Plc</option>
            <option value="Zenith Bank">Zenith Bank Plc</option>
            <option value="First Bank">First Bank of Nigeria</option>
            <option value="UBA">United Bank for Africa (UBA)</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Numéro de Compte NUBAN (10 chiffres)</label>
          <input type="text" class="form-control" id="reg-shop-account" placeholder="Ex: 0123456789" maxlength="10" value="0987654321">
        </div>
        <button class="btn-primary" style="background:var(--deep-green); margin-top:8px;" onclick="submitBecomeSeller()">
          <i class="fas fa-paper-plane"></i> Soumettre à l'Administrateur
        </button>
      </div>
    </div>

    <!-- PRODUCT DETAIL & MULTI-PHOTO GALLERY MODAL -->
    <div class="modal-overlay" id="product-detail-modal">
      <div class="modal-sheet" style="max-height:92%; padding:16px;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
          <span class="rate-pill" style="background:var(--green-tint); color:var(--bridge-green); font-size:10px;" id="modal-p-cat">Dentelle</span>
          <i class="fas fa-times" style="font-size:16px; cursor:pointer;" onclick="closeModal('product-detail-modal')"></i>
        </div>

        <!-- Grande Photo Active -->
        <div style="position:relative; width:100%; height:230px; border-radius:14px; overflow:hidden; background:#eee; box-shadow:0 3px 10px rgba(0,0,0,0.08);">
          <img id="modal-main-img" src="" style="width:100%; height:100%; object-fit:cover; transition:opacity 0.2s;">
          <div style="position:absolute; bottom:8px; right:8px; background:rgba(0,0,0,0.75); color:#fff; font-size:10px; font-weight:700; padding:3px 8px; border-radius:6px;" id="modal-photo-counter">
            Photo 1 sur 4
          </div>
          <div style="position:absolute; top:8px; left:8px; background:rgba(0,0,0,0.75); color:#fff; font-size:10px; font-weight:700; padding:3px 8px; border-radius:6px;" id="modal-p-origin">
            Lagos Balogun
          </div>
        </div>

        <!-- Galerie Vignettes Multi-photos Cliquables -->
        <div style="margin-top:10px;">
          <div style="font-size:10px; font-weight:800; color:var(--text-muted); margin-bottom:6px;">
            <i class="fas fa-images"></i> PHOTOS DE L'ARTICLE (CLIQUEZ POUR CHANGER DE VUE) :
          </div>
          <div id="modal-thumbnails-container" style="display:flex; gap:8px; overflow-x:auto; padding-bottom:4px;">
            <!-- Injected via JS -->
          </div>
        </div>

        <div style="margin-top:12px;">
          <h3 style="font-size:15px; font-weight:900; color:var(--ink); line-height:1.25;" id="modal-p-title">Titre</h3>
          <div style="font-size:11px; color:var(--text-muted); margin:4px 0 10px;" id="modal-p-unit">Pièce de 5 yards (4.6m)</div>

          <!-- Price Box -->
          <div style="background:var(--surface); border:1px solid var(--border); border-radius:12px; padding:10px 14px; display:flex; justify-content:space-between; align-items:center;">
            <div>
              <div style="font-size:10px; color:var(--text-muted);">Prix Acheteur Bénin :</div>
              <div style="font-size:18px; font-weight:900; color:var(--bridge-green);" id="modal-p-xof">34,978 XOF</div>
            </div>
            <div style="text-align:right;">
              <div style="font-size:10px; color:var(--text-muted);">Prix Vendeur Nigeria :</div>
              <div style="font-size:13px; font-weight:800; color:var(--deep-green);" id="modal-p-ngn">₦ 85,000 NGN</div>
            </div>
          </div>

          <!-- Escrow notice -->
          <div style="margin-top:10px; background:#FFF9E6; border:1px solid #FFE082; padding:8px 10px; border-radius:8px; font-size:10px; color:#856404; display:flex; gap:8px; align-items:center;">
            <i class="fas fa-shield-alt" style="font-size:14px; color:#D48B16;"></i>
            <span><strong>Séquestre Garanti :</strong> Paiement conservé en sécurité jusqu'au retrait de votre colis au Bénin.</span>
          </div>

          <div style="display:flex; gap:8px; margin-top:12px;">
            <button class="btn-primary" style="flex:1; background:var(--bridge-green);" id="modal-btn-add-cart" onclick="addCurrentModalToCart()">
              <i class="fas fa-cart-plus"></i> Ajouter au Panier
            </button>
            <button class="btn-order-now" style="flex:1; padding:10px; font-size:12px;" onclick="orderCurrentModalNow()">
              <i class="fas fa-bolt"></i> Commander Direct
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- ADD PRODUCT MODAL (SELLER) -->
    <div class="modal-overlay" id="add-product-modal">
      <div class="modal-sheet">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
          <h3 style="font-size:15px; font-weight:800;">Publier un Nouveau Tissu (Nigeria)</h3>
          <i class="fas fa-times" style="cursor:pointer;" onclick="closeModal('add-product-modal')"></i>
        </div>
        <div class="form-group">
          <label class="form-label">Nom / Titre du Tissu</label>
          <input type="text" class="form-control" id="new-prod-title" placeholder="Ex: Dentelle Cordonnet Brodé Festonné">
        </div>
        <div class="form-group">
          <label class="form-label">Catégorie</label>
          <select class="form-control" id="new-prod-cat">
            <option value="Dentelle">Dentelle Suisse & Guipure</option>
            <option value="Wax">Pagne Wax & Ankara</option>
            <option value="Aso Oke">Tissus Cérémonie (Aso Oke)</option>
            <option value="Bazin">Bazin Riche & Guinée</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Prix en Naira (₦ NGN)</label>
          <input type="number" class="form-control" id="new-prod-price" placeholder="Ex: 55000">
        </div>
        <div class="form-group">
          <label class="form-label">Unité / Pièce</label>
          <select class="form-control" id="new-prod-unit">
            <option value="Pièce 5 yards">Pièce de 5 yards (4.6m)</option>
            <option value="Pièce 6 yards">Pièce de 6 yards (5.5m)</option>
            <option value="Ensemble complet">Ensemble complet Cérémonie</option>
            <option value="Coupon 5 mètres">Coupon 5 mètres</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Stock Initial (pièces)</label>
          <input type="number" class="form-control" id="new-prod-stock" value="12">
        </div>
        <button class="btn-primary btn-success" onclick="saveNewFabric()">
          <i class="fas fa-check"></i> Publier en Ligne sur la Marketplace
        </button>
      </div>
    </div>

    <!-- PAYMENT MODAL (KKIAPAY SIMULATOR) -->
    <div class="modal-overlay" id="payment-modal">
      <div class="modal-sheet">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
          <h3 style="font-size:15px; font-weight:800;">Paiement Sécurisé Kkiapay</h3>
          <i class="fas fa-times" style="cursor:pointer;" onclick="closeModal('payment-modal')"></i>
        </div>
        <p style="font-size:11px; color:var(--text-muted); margin-bottom:12px;">
          Entrez votre numéro pour recevoir l'invite USSD sur votre téléphone Bénin.
        </p>
        <div class="form-group">
          <label class="form-label">Opérateur Mobile Money</label>
          <select class="form-control" id="kkiapay-operator">
            <option value="MTN">MTN MoMo Bénin (*880#)</option>
            <option value="MOOV">Moov Money Bénin (*155#)</option>
            <option value="CELTIIS">Celtiis Cash (*888#)</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Numéro de Téléphone (+229)</label>
          <input type="text" class="form-control" value="97 01 23 45">
        </div>
        <div style="background:#FFF9E6; border:1px solid #FFE082; padding:10px; border-radius:8px; font-size:11px; margin-bottom:14px; color:#856404;">
          <i class="fas fa-lock"></i> <strong>Fonds en Séquestre :</strong> Le commerçant nigérian n'aura accès à son argent que lorsque vous aurez validé le colis au Bénin.
        </div>
        <button class="btn-primary btn-success" id="btn-confirm-kkiapay" onclick="confirmPaymentAndOrder()">
          Confirmer & Débiter <span id="modal-pay-amount">38,108 XOF</span>
        </button>
      </div>
    </div>

    <!-- RECEIPT MODAL -->
    <div class="modal-overlay" id="receipt-modal">
      <div class="modal-sheet" style="background:#F7F9FC;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
          <h3 style="font-size:14px; font-weight:800;">Reçu de Paiement & Preuve</h3>
          <i class="fas fa-times" style="cursor:pointer;" onclick="closeModal('receipt-modal')"></i>
        </div>
        <div style="background:#fff; border-radius:12px; padding:14px; border:1px solid var(--border);">
          <div style="text-align:center; border-bottom:1px solid var(--border); padding-bottom:10px; margin-bottom:10px;">
            <div style="font-size:12px; font-weight:800; color:var(--primary);">BRIDGEMART TISSUS EXPRESS</div>
            <div style="font-size:9px; color:var(--text-muted);">Reçu officiel agréé Mobile Money / Séquestre</div>
            <div style="font-size:20px; font-weight:900; color:var(--primary); margin-top:6px;" id="rcpt-amount">38,108 FCFA</div>
            <div style="font-size:11px; font-weight:700; color:var(--nigeria-green);" id="rcpt-ngn">≈ ₦85,000 NGN</div>
          </div>
          <div class="quote-row"><span>Réf Transaction :</span><strong id="rcpt-ref">CMD-BJNG-2026-8819</strong></div>
          <div class="quote-row"><span>Date :</span><span id="rcpt-date">28 Oct 2026 à 16:51</span></div>
          <div class="quote-row"><span>Bénéficiaire :</span><strong>Mama Folake Fabrics (Lagos)</strong></div>
          <div class="quote-row"><span>Code de Retrait :</span><strong style="color:var(--accent);" id="rcpt-code">749-382</strong></div>
          <div class="quote-row"><span>Statut :</span><strong style="color:var(--success);">Fonds sous Séquestre Garanti</strong></div>
        </div>
        <button class="btn-primary" style="background:#25D366; margin-top:12px; font-size:12px;" onclick="alert('Preuve de virement copiée pour partage WhatsApp au commerçant !')">
          <i class="fab fa-whatsapp"></i> Envoyer la preuve au commerçant (WhatsApp)
        </button>
      </div>
    </div>

  </div>
</div>

<script>
  // Produits de tissus avec plusieurs photos réelles haute qualité
  const products = [
    {
      id: 'p1',
      title: 'Dentelle Suisse Voile Brodé Perlé — Or Impérial',
      cat: 'Dentelle',
      priceNgn: 85000,
      priceXof: 34978,
      unit: 'Pièce 5 yards',
      origin: 'Lagos Balogun',
      rating: 4.9,
      images: [
        'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=600&auto=format&fit=crop&q=80'
      ]
    },
    {
      id: 'p2',
      title: 'Super Ankara Wax Prestige 100% Coton — Rosace',
      cat: 'Wax',
      priceNgn: 32000,
      priceXof: 13168,
      unit: 'Pièce 6 yards',
      origin: 'Aba Market',
      rating: 4.8,
      images: [
        'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1590736704728-f4730bb30770?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=600&auto=format&fit=crop&q=80'
      ]
    },
    {
      id: 'p3',
      title: 'Aso Oke Royal Cérémonie Tissé Main — Émeraude & Or',
      cat: 'Aso Oke',
      priceNgn: 120000,
      priceXof: 49380,
      unit: 'Ensemble complet',
      origin: 'Ibadan / Lagos',
      rating: 5.0,
      images: [
        'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1566737236500-c8ac43014a67?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1534452203293-494d7ddbf7e0?w=600&auto=format&fit=crop&q=80'
      ]
    },
    {
      id: 'p4',
      title: 'Dentelle Guipure Cordonnetée Bleu Nuit & Argent',
      cat: 'Dentelle',
      priceNgn: 95000,
      priceXof: 39092,
      unit: 'Pièce 5 yards',
      origin: 'Lagos Island',
      rating: 4.9,
      images: [
        'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=600&auto=format&fit=crop&q=80'
      ]
    },
    {
      id: 'p5',
      title: 'Super-Wax Hollandais Authentique — Les Hirondelles',
      cat: 'Wax',
      priceNgn: 140000,
      priceXof: 57610,
      unit: 'Pièce 6 yards',
      origin: 'Lagos Marina',
      rating: 4.95,
      images: [
        'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1590736704728-f4730bb30770?w=600&auto=format&fit=crop&q=80'
      ]
    },
    {
      id: 'p6',
      title: 'Bazin Riche Brodé Teint à la Main — Violet Royal',
      cat: 'Bazin',
      priceNgn: 75000,
      priceXof: 30862,
      unit: 'Coupon 5 mètres',
      origin: 'Kano Dyes',
      rating: 4.7,
      images: [
        'https://images.unsplash.com/photo-1520006403909-838d6b92c22e?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=600&auto=format&fit=crop&q=80'
      ]
    }
  ];

  // État de l'application
  let currentRole = 'buyer';
  let currentUser = {
    name: 'Amina Dossou',
    phone: '+229 97 01 23 45',
    isSeller: false,
    shopStatus: 'none', // 'none' | 'pending' | 'approved'
    shopName: ''
  };

  let pendingShops = [
    {
      id: 'shop_1',
      name: 'Alhaja Kudirat Royal Attires',
      city: 'Ibadan Traditional Fabrics Center',
      bank: 'First Bank of Nigeria',
      account: '2148901234',
      applicant: 'Kudirat Balogun',
      status: 'pending'
    }
  ];

  let currentModalProduct = null;
  let cart = [ { product: products[0], qty: 1 } ];
  let currentStep = 2; // Step in tracking
  const stepsList = [
    { title: 'Paiement Mobile Money validé', desc: 'Fonds placés en séquestre sécurisé.' },
    { title: 'Préparation chez le commerçant', desc: 'Mama Folake Fabrics a emballé vos 5 yards à Lagos.' },
    { title: 'Transport transfrontalier (Nigeria -> Bénin)', desc: 'Colis acheminé par le transporteur partenaire.' },
    { title: 'Arrivé au point de retrait (Dantokpa)', desc: 'Disponible au guichet. Donnez votre code de retrait.' },
    { title: 'Colis retiré & Fonds libérés', desc: 'Code validé. Virement en Nairas versé au vendeur nigérian.' }
  ];

  // Supabase Client instance (dynamique)
  let supabaseClient = null;

  function testSupabaseConnection() {
    const url = document.getElementById('supabase-url-input').value.trim();
    const key = document.getElementById('supabase-key-input').value.trim();
    const pill = document.getElementById('supabase-status-pill');

    if (!url || !key) {
      alert('Veuillez renseigner votre URL Supabase et votre clé Anon Key.\\nExemple:\\nURL: https://xyzcompany.supabase.co\\nClé: eyJhbGci...');
      return;
    }

    try {
      if (window.supabase) {
        supabaseClient = window.supabase.createClient(url, key);
        pill.innerText = 'Connecté à Supabase Cloud';
        pill.style.background = '#C8E6C9';
        pill.style.color = '#1B5E20';
        alert('Connexion Supabase réussie !\\nVotre application est désormais reliée à votre base de données PostgreSQL.');
      } else {
        alert('Client Supabase en cours de chargement... Réessayez dans 3 secondes.');
      }
    } catch (e) {
      alert('Erreur lors de l\'initialisation Supabase: ' + e.message);
    }
  }

  function showSupabaseSchemaHelp() {
    alert('Le fichier "supabase_schema.sql" a été généré à la racine du projet !\\n\\nIl contient :\\n- Les tables public.shops, public.products, public.orders, public.escrow_audit_logs\\n- Les politiques de sécurité RLS (Row Level Security)\\n- Les points relais officiels du Bénin.');
  }

  // --- RENDU CATALOGUE & MULTI-PHOTOS ---
  function renderProducts(items) {
    const cont = document.getElementById('products-container');
    if (!cont) return;
    cont.innerHTML = items.map(p => `
      <div class="product-card" onclick="openProductDetail('${p.id}')">
        <div class="product-img">
          <img src="${p.images[0]}" alt="${p.title}">
          <div class="origin-badge"><i class="fas fa-map-marker-alt" style="color:gold;"></i> ${p.origin}</div>
          <div class="photo-count-badge"><i class="fas fa-images"></i> ${p.images.length} photos</div>
          <div class="rating-badge"><i class="fas fa-star" style="color:gold;"></i> ${p.rating}</div>
        </div>
        <div class="product-body">
          <div>
            <div class="product-category">${p.cat}</div>
            <div class="product-name">${p.title}</div>
            <div class="product-unit">${p.unit}</div>
          </div>
          <div class="price-box">
            <div class="price-xof">${p.priceXof.toLocaleString()} XOF</div>
            <div class="price-ngn">≈ ₦${p.priceNgn.toLocaleString()} NGN</div>
            <button class="btn-add" onclick="event.stopPropagation(); addToCart('${p.id}')">
              <i class="fas fa-cart-plus"></i> Ajouter
            </button>
          </div>
        </div>
      </div>
    `).join('');
    const countLbl = document.getElementById('product-count-label');
    if (countLbl) countLbl.innerText = `${items.length} Tissus Disponibles`;
  }

  function filterProducts(q) {
    const filtered = products.filter(p => p.title.toLowerCase().includes(q.toLowerCase()) || p.cat.toLowerCase().includes(q.toLowerCase()));
    renderProducts(filtered);
  }

  function selectCat(el, cat) {
    document.querySelectorAll('.cat-chip').forEach(c => c.classList.remove('active'));
    el.classList.add('active');
    if (cat === 'all') renderProducts(products);
    else renderProducts(products.filter(p => p.cat === cat));
  }

  // --- MODALE DETAIL PRODUIT & GALERIE MULTI-PHOTOS ---
  function openProductDetail(id) {
    const p = products.find(prod => prod.id === id);
    if (!p) return;
    currentModalProduct = p;

    document.getElementById('modal-p-cat').innerText = p.cat;
    document.getElementById('modal-p-origin').innerText = p.origin;
    document.getElementById('modal-p-title').innerText = p.title;
    document.getElementById('modal-p-unit').innerText = p.unit;
    document.getElementById('modal-p-xof').innerText = p.priceXof.toLocaleString() + ' XOF';
    document.getElementById('modal-p-ngn').innerText = '₦ ' + p.priceNgn.toLocaleString() + ' NGN';

    // Image principale
    const mainImg = document.getElementById('modal-main-img');
    mainImg.src = p.images[0];
    document.getElementById('modal-photo-counter').innerText = `Photo 1 sur ${p.images.length}`;

    // Vignettes
    const thumbCont = document.getElementById('modal-thumbnails-container');
    thumbCont.innerHTML = p.images.map((url, idx) => `
      <div class="thumb-item ${idx === 0 ? 'active' : ''}" onclick="selectModalPhoto('${url}', ${idx}, ${p.images.length}, this)">
        <img src="${url}" alt="Vue ${idx + 1}">
      </div>
    `).join('');

    document.getElementById('product-detail-modal').style.display = 'flex';
  }

  function selectModalPhoto(url, index, total, el) {
    const mainImg = document.getElementById('modal-main-img');
    mainImg.style.opacity = '0.5';
    setTimeout(() => {
      mainImg.src = url;
      mainImg.style.opacity = '1';
    }, 120);

    document.getElementById('modal-photo-counter').innerText = `Photo ${index + 1} sur ${total}`;
    document.querySelectorAll('.thumb-item').forEach(t => t.classList.remove('active'));
    if (el) el.classList.add('active');
  }

  function addCurrentModalToCart() {
    if (!currentModalProduct) return;
    addToCart(currentModalProduct.id);
    closeModal('product-detail-modal');
  }

  function orderCurrentModalNow() {
    if (!currentModalProduct) return;
    addToCart(currentModalProduct.id);
    closeModal('product-detail-modal');
    switchTab('cart');
  }

  // --- PANIER ---
  function addToCart(id) {
    const prod = products.find(p => p.id === id);
    const item = cart.find(i => i.product.id === id);
    if (item) item.qty++;
    else cart.push({ product: prod, qty: 1 });
    updateCartUI();
    alert('✓ "' + prod.title + '" ajouté à votre panier !');
  }

  function updateCartUI() {
    const badge = document.getElementById('cart-badge-count');
    if (badge) badge.innerText = cart.reduce((s, i) => s + i.qty, 0);

    const cont = document.getElementById('cart-items-container');
    if (!cont) return;
    if (cart.length === 0) {
      cont.innerHTML = '<p style="text-align:center; color:var(--text-muted); font-size:12px; padding:12px 0;">Votre panier est vide.</p>';
      return;
    }
    cont.innerHTML = cart.map(item => `
      <div style="display:flex; gap:10px; align-items:center; margin-bottom:10px; border-bottom:1px solid #eee; padding-bottom:8px;">
        <img src="${item.product.images[0]}" style="width:50px; height:50px; object-fit:cover; border-radius:8px;">
        <div style="flex:1;">
          <div style="font-size:11px; font-weight:700;">${item.product.title}</div>
          <div style="font-size:10px; color:var(--primary); font-weight:700;">${(item.product.priceXof * item.qty).toLocaleString()} XOF</div>
        </div>
        <div style="display:flex; align-items:center; gap:6px;">
          <button style="border:1px solid #ccc; background:#fff; width:22px; height:22px; border-radius:4px; font-size:11px;" onclick="changeQty('${item.product.id}', -1)">-</button>
          <span style="font-size:11px; font-weight:700;">${item.qty}</span>
          <button style="border:1px solid #ccc; background:#fff; width:22px; height:22px; border-radius:4px; font-size:11px;" onclick="changeQty('${item.product.id}', 1)">+</button>
        </div>
      </div>
    `).join('');
    updateCartTotal();
  }

  function changeQty(id, delta) {
    const index = cart.findIndex(i => i.product.id === id);
    if (index >= 0) {
      cart[index].qty += delta;
      if (cart[index].qty <= 0) cart.splice(index, 1);
      updateCartUI();
    }
  }

  function updateCartTotal() {
    const subtotalNgn = cart.reduce((s, i) => s + (i.product.priceNgn * i.qty), 0);
    const subtotalXof = cart.reduce((s, i) => s + (i.product.priceXof * i.qty), 0);
    const pickupEl = document.getElementById('pickup-select');
    const shipping = pickupEl ? parseInt(pickupEl.value) : 1500;
    const escrowFee = Math.round(subtotalXof * 0.018);
    const grandTotal = subtotalXof + shipping + escrowFee;

    const tNgn = document.getElementById('cart-total-ngn');
    const tXof = document.getElementById('cart-total-xof');
    const sFee = document.getElementById('cart-shipping-fee');
    const eFee = document.getElementById('cart-escrow-fee');
    const gTot = document.getElementById('cart-grand-total');
    const mPay = document.getElementById('modal-pay-amount');

    if (tNgn) tNgn.innerText = '₦ ' + subtotalNgn.toLocaleString() + ' NGN';
    if (tXof) tXof.innerText = subtotalXof.toLocaleString() + ' XOF';
    if (sFee) sFee.innerText = '+' + shipping.toLocaleString() + ' XOF';
    if (eFee) eFee.innerText = '+' + escrowFee.toLocaleString() + ' XOF';
    if (gTot) gTot.innerText = grandTotal.toLocaleString() + ' XOF';
    if (mPay) mPay.innerText = grandTotal.toLocaleString() + ' XOF';
  }

  // --- NAVIGATION ACHETEUR ---
  function switchTab(tab) {
    document.querySelectorAll('.view').forEach(v => v.classList.remove('active'));
    document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));

    if (tab === 'catalog') {
      document.getElementById('view-catalog').classList.add('active');
      document.querySelectorAll('.nav-item')[0].classList.add('active');
    } else if (tab === 'transfer') {
      document.getElementById('view-transfer').classList.add('active');
      document.querySelectorAll('.nav-item')[1].classList.add('active');
    } else if (tab === 'orders') {
      document.getElementById('view-orders').classList.add('active');
      document.querySelectorAll('.nav-item')[2].classList.add('active');
      renderTimeline();
    } else if (tab === 'profile') {
      document.getElementById('view-profile').classList.add('active');
      document.querySelectorAll('.nav-item')[3].classList.add('active');
      renderProfileSellerStatus();
    } else if (tab === 'cart') {
      document.getElementById('view-cart').classList.add('active');
      updateCartUI();
    }
  }

  // --- TRANSFERT DIRECT NAIRA ---
  function resolveAccount() {
    const box = document.getElementById('resolved-name-box');
    const txt = document.getElementById('resolved-name-text');
    box.style.display = 'flex';
    txt.innerText = 'Interrogation Paystack / NUBAN...';
    setTimeout(() => {
      txt.innerText = 'ADEYEMI BROTHERS NIGERIA LTD';
      updateTransferQuote();
    }, 600);
  }

  function resetResolvedName() {
    const box = document.getElementById('resolved-name-box');
    if (box) box.style.display = 'none';
  }

  function updateTransferQuote() {
    const ngn = parseFloat(document.getElementById('naira-amount-input').value) || 0;
    const rawXof = Math.round(ngn * 0.4115);
    const spread = Math.round(rawXof * 0.018);
    const kkiapay = Math.round(rawXof * 0.012);
    const total = rawXof + spread + kkiapay;

    document.getElementById('q-ngn').innerText = '₦ ' + ngn.toLocaleString() + ' NGN';
    document.getElementById('q-raw-xof').innerText = rawXof.toLocaleString() + ' XOF';
    document.getElementById('q-spread').innerText = '+' + spread.toLocaleString() + ' XOF';
    document.getElementById('q-kkiapay').innerText = '+' + kkiapay.toLocaleString() + ' XOF';
    document.getElementById('q-total-xof').innerText = total.toLocaleString() + ' XOF';
  }

  // --- SUIVI DU SÉQUESTRE ---
  function renderTimeline() {
    const cont = document.getElementById('ord-timeline');
    if (!cont) return;
    cont.innerHTML = stepsList.map((step, idx) => {
      const isDone = idx < currentStep;
      const isActive = idx === currentStep;
      return `
        <div class="step-item ${isDone ? 'done' : ''} ${isActive ? 'active' : ''}">
          <div class="step-dot">${isDone ? '<i class="fas fa-check"></i>' : (isActive ? '<i class="fas fa-sync fa-spin"></i>' : idx + 1)}</div>
          <div class="step-content">
            <h4>${step.title}</h4>
            <p>${step.desc}</p>
          </div>
        </div>
      `;
    }).join('');

    const statusPill = document.getElementById('ord-status-pill');
    if (statusPill) {
      if (currentStep >= 4) {
        statusPill.innerText = 'Colis Retiré & Vendeur Payé';
        statusPill.style.background = '#E8F5E9';
        statusPill.style.color = '#2E7D32';
      } else {
        statusPill.innerText = stepsList[currentStep].title;
      }
    }
  }

  function advanceOrderStep() {
    if (currentStep < 4) {
      currentStep++;
      renderTimeline();
      if (currentStep === 4) {
        alert('Code de retrait validé avec succès au guichet ! Le séquestre est libéré et le virement de ₦85,000 NGN est déclenché vers le compte GTBank du commerçant nigérian.');
      }
    } else {
      alert('La commande est déjà au statut final (Retirée & Vendeur rémunéré).');
    }
  }

  // --- PAIEMENT & MODALES ---
  function openPaymentModal() {
    document.getElementById('payment-modal').style.display = 'flex';
  }
  function closeModal(id) {
    document.getElementById(id).style.display = 'none';
  }
  function confirmPaymentAndOrder() {
    const btn = document.getElementById('btn-confirm-kkiapay');
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Débit Mobile Money via Kkiapay...';
    setTimeout(() => {
      btn.innerHTML = '<i class="fas fa-check"></i> Fonds placés en Séquestre Garanti !';
      setTimeout(() => {
        closeModal('payment-modal');
        btn.innerHTML = 'Confirmer & Débiter';
        cart = [];
        updateCartUI();
        currentStep = 0;
        switchTab('orders');
        showReceiptModal();
      }, 800);
    }, 1400);
  }

  function executeDirectPayment() {
    alert('Débit Mobile Money confirmé par Kkiapay. Ordre de virement bancaire transmis à Paystack pour paiement instantané au fournisseur au Nigeria !');
    showReceiptModal();
  }

  function showReceiptModal() {
    document.getElementById('receipt-modal').style.display = 'flex';
  }

  function openDisputeModal() {
    const reason = prompt('Indiquez le motif de votre litige (Ex: Tissu non conforme, manque de métrage...) :');
    if (reason) {
      alert('Litige enregistré ! Le séquestre a été gelé. Le versement vers le vendeur nigérian est bloqué jusqu\'à décision du Super Administrateur.');
      const pill = document.getElementById('ord-status-pill');
      if (pill) {
        pill.innerText = 'Litige en cours d\'arbitrage';
        pill.style.background = '#FFEBEE';
        pill.style.color = '#C62828';
      }
    }
  }

  // --- CONNEXION & ROUTAGE SELON LE PROFIL (4 RÔLES) ---
  function openLoginModal() {
    document.getElementById('login-modal').style.display = 'flex';
  }

  function loginAs(role) {
    currentRole = role;
    closeModal('login-modal');

    // Masquer toutes les vues de rôle
    document.querySelectorAll('.role-view').forEach(v => v.style.display = 'none');

    if (role === 'buyer') {
      document.getElementById('role-view-buyer').style.display = 'flex';
      switchTab('catalog');
    } else if (role === 'seller') {
      document.getElementById('role-view-seller').style.display = 'flex';
      renderSellerCatalog();
    } else if (role === 'agent') {
      document.getElementById('role-view-agent').style.display = 'flex';
    } else if (role === 'superadmin') {
      document.getElementById('role-view-superadmin').style.display = 'flex';
      renderPendingShopsAdmin();
    }
  }

  // --- LOGIQUE AGENT DE GUICHET (DANTOKPA) ---
  function agentVerifyOtp() {
    const rawVal = document.getElementById('agent-otp-input').value.trim();
    const clean = rawVal.replace(/-/g, '');
    const resBox = document.getElementById('agent-order-result-box');

    if (clean === '749382' || clean.length >= 6) {
      resBox.style.display = 'block';
    } else {
      alert('Code de retrait introuvable ou invalide.\\nVeuillez vérifier les 6 chiffres présentés par l\'acheteur.');
      resBox.style.display = 'none';
    }
  }

  function agentExecuteDelivery() {
    const btn = document.getElementById('agent-btn-confirm-delivery');
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Libération du Séquestre & Payout NGN...';
    btn.disabled = true;

    setTimeout(() => {
      btn.innerHTML = '<i class="fas fa-check"></i> Colis Remis & Fonds Virés au Nigeria !';
      btn.style.background = '#2E7D32';

      // Mettre à jour l'état de la commande globale
      currentStep = 4;
      renderTimeline();

      alert('SUCCÈS GUICHETIER :\\n1. Colis remis à l\'acheteur Amina Dossou.\\n2. Le séquestre de 38,108 XOF a été libéré.\\n3. Virement automatique de ₦85,000 NGN transmis à Mama Folake Fabrics (GTBank Nigeria).\\n4. Commission guichet de 500 XOF créditée sur votre compte agent.');
    }, 1200);
  }

  function agentScanArrived(orderNum) {
    const row = document.getElementById('agent-transit-row');
    if (row) {
      row.innerHTML = `
        <div style="color:var(--success); font-weight:700; font-size:11px;">
          <i class="fas fa-check-circle"></i> Colis ${orderNum} réceptionné et placé en casier Dantokpa !<br>
          <span style="color:var(--text-muted); font-size:10px;">SMS & notification WhatsApp transmis à l'acheteur avec son code de retrait.</span>
        </div>
      `;
    }
    const countEl = document.getElementById('agent-pending-count');
    if (countEl) countEl.innerText = '5 Colis';
  }

  // --- ACHETEUR DEVIENT VENDEUR : CRÉATION DE BOUTIQUE & VALIDATION ADMIN ---
  function openBecomeSellerModal() {
    document.getElementById('become-seller-modal').style.display = 'flex';
  }

  function submitBecomeSeller() {
    const shopName = document.getElementById('reg-shop-name').value.trim();
    const city = document.getElementById('reg-shop-city').value;
    const bank = document.getElementById('reg-shop-bank').value;
    const account = document.getElementById('reg-shop-account').value.trim();

    if (!shopName) {
      alert('Veuillez entrer le nom de votre boutique.');
      return;
    }
    if (!account || account.length < 8) {
      alert('Veuillez entrer un numéro de compte NUBAN valide.');
      return;
    }

    currentUser.shopName = shopName;
    currentUser.shopStatus = 'pending';

    // Ajouter à la liste des boutiques en attente pour le Super Admin
    pendingShops.push({
      id: 'shop_' + Date.now(),
      name: shopName,
      city: city,
      bank: bank,
      account: account,
      applicant: currentUser.name,
      status: 'pending'
    });

    closeModal('become-seller-modal');
    renderProfileSellerStatus();
    renderPendingShopsAdmin();

    alert('Félicitations ' + currentUser.name + ' !\\nVotre demande pour la boutique "' + shopName + '" a été soumise au Super Administrateur.\\nElle sera validée après contrôle de vos coordonnées bancaires nigérianes.');
  }

  function renderProfileSellerStatus() {
    const cont = document.getElementById('seller-status-container');
    if (!cont) return;

    if (currentUser.shopStatus === 'pending') {
      cont.innerHTML = `
        <div style="background:#FFF3CD; border:1px solid #FFEBAA; border-radius:8px; padding:8px 10px; margin-top:6px;">
          <div style="font-size:11px; font-weight:800; color:#856404;">
            <i class="fas fa-clock"></i> Boutique "${currentUser.shopName}" en attente de validation
          </div>
          <p style="font-size:10px; color:#856404; margin-top:3px;">
            Le Super Administrateur BridgeMart examine vos coordonnées bancaires avant d'activer votre boutique et de rendre vos tissus visibles aux acheteurs.
          </p>
        </div>
      `;
    } else if (currentUser.shopStatus === 'approved') {
      cont.innerHTML = `
        <div style="background:#E8F5E9; border:1px solid #C8E6C9; border-radius:8px; padding:8px 10px; margin-top:6px;">
          <div style="font-size:11px; font-weight:800; color:#2E7D32;">
            <i class="fas fa-check-circle"></i> Boutique "${currentUser.shopName}" validée & active !
          </div>
          <button class="btn-primary" style="background:var(--deep-green); font-size:11px; padding:6px 10px; width:auto; margin-top:6px;" onclick="loginAs('seller')">
            <i class="fas fa-tachometer-alt"></i> Accéder à mon Espace Boutique
          </button>
        </div>
      `;
    } else {
      cont.innerHTML = `
        <button class="btn-primary" style="background:var(--deep-green); font-size:11px; padding:8px 12px; width:auto;" onclick="openBecomeSellerModal()">
          <i class="fas fa-plus-circle"></i> Créer ma Boutique de Tissus
        </button>
      `;
    }
  }

  // --- GESTION DU CATALOGUE VENDEUR ---
  function renderSellerCatalog() {
    const cont = document.getElementById('seller-catalog-list');
    if (!cont) return;
    cont.innerHTML = products.map((p) => `
      <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid #eee; padding:8px 0;">
        <div style="display:flex; gap:8px; align-items:center;">
          <img src="${p.images[0]}" style="width:40px; height:40px; object-fit:cover; border-radius:6px;">
          <div>
            <div style="font-size:11px; font-weight:700;">${p.title}</div>
            <div style="font-size:10px; color:var(--nigeria-green); font-weight:700;">₦ ${p.priceNgn.toLocaleString()} NGN (${p.unit})</div>
          </div>
        </div>
        <div style="text-align:right;">
          <span class="rate-pill" style="background:#E8F5E9; color:#2E7D32; font-size:9px;">En stock</span>
        </div>
      </div>
    `).join('');
  }

  function sellerMarkShipped(orderNum) {
    const btn = document.getElementById('btn-seller-ship-1');
    const status = document.getElementById('seller-status-1');
    if (btn) {
      btn.innerHTML = '<i class="fas fa-check"></i> Expédié vers Bénin !';
      btn.disabled = true;
      btn.style.opacity = '0.7';
    }
    if (status) {
      status.innerText = 'En transit transfrontalier';
      status.style.background = '#E1F5FE';
      status.style.color = '#0288D1';
    }
    alert('Commande CMD-BJNG-2026-9042 marquée comme remise au transporteur partenaire Lagos-Cotonou ! L\'acheteur est notifié.');
  }

  function openAddProductModal() {
    document.getElementById('add-product-modal').style.display = 'flex';
  }

  function saveNewFabric() {
    const title = document.getElementById('new-prod-title').value || 'Nouveau Tissu Brodé Nigeria';
    const cat = document.getElementById('new-prod-cat').value;
    const priceNgn = parseInt(document.getElementById('new-prod-price').value) || 50000;
    const unit = document.getElementById('new-prod-unit').value;
    const stock = parseInt(document.getElementById('new-prod-stock').value) || 10;
    const rateNgnToXof = 0.4115;
    const priceXof = Math.round(priceNgn * rateNgnToXof);

    const newFabric = {
      id: 'p' + (products.length + 1),
      title: title,
      cat: cat,
      priceNgn: priceNgn,
      priceXof: priceXof,
      unit: unit,
      origin: 'Lagos Balogun',
      rating: 5.0,
      images: [
        'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?w=600&auto=format&fit=crop&q=80'
      ]
    };

    products.unshift(newFabric);
    renderProducts(products);
    renderSellerCatalog();
    closeModal('add-product-modal');
    alert('Tissu "' + title + '" publié avec succès ! Il est maintenant disponible à la vente pour tous les acheteurs au Bénin.');
  }

  // --- CONSOLE SUPER ADMIN ---
  function renderPendingShopsAdmin() {
    const cont = document.getElementById('admin-pending-shops-list');
    const counter = document.getElementById('pending-shops-counter');
    if (!cont) return;

    const unapproved = pendingShops.filter(s => s.status === 'pending');
    if (counter) counter.innerText = `${unapproved.length} en attente`;

    if (unapproved.length === 0) {
      cont.innerHTML = '<div style="color:var(--text-muted); font-size:11px; text-align:center; padding:8px 0;">Aucune boutique en attente de validation.</div>';
      return;
    }

    cont.innerHTML = unapproved.map(s => `
      <div style="border:1px solid var(--border); border-radius:8px; padding:10px; font-size:11px; margin-bottom:8px; background:#fff;" id="shop-card-${s.id}">
        <div style="display:flex; justify-content:space-between; align-items:center;">
          <strong style="font-size:12px; color:var(--ink);">${s.name}</strong>
          <span class="rate-pill" style="background:#FFF3CD; color:#856404; font-size:9px;">En attente</span>
        </div>
        <div style="color:var(--text); font-size:10px; margin:3px 0;">
          <strong>Demandeur :</strong> ${s.applicant} • ${s.city}
        </div>
        <div style="color:var(--text-muted); font-size:10px; margin-bottom:6px;">
          <strong>Banque NGN :</strong> ${s.bank} • Compte NUBAN ${s.account}
        </div>
        <div style="display:flex; gap:6px;">
          <button class="btn-action-sm btn-green" onclick="adminApproveShop('${s.id}')">
            <i class="fas fa-check-circle"></i> Valider et Activer la Boutique
          </button>
        </div>
      </div>
    `).join('');
  }

  function adminApproveShop(shopId) {
    const shop = pendingShops.find(s => s.id === shopId);
    if (!shop) return;
    shop.status = 'approved';

    if (currentUser.shopName === shop.name) {
      currentUser.shopStatus = 'approved';
      currentUser.isSeller = true;
    }

    renderPendingShopsAdmin();
    renderProfileSellerStatus();

    alert('Boutique "' + shop.name + '" validée avec succès par le Super Administrateur !\\nLe commerçant est notifié et ses tissus peuvent désormais être mis en vente.');
  }

  function adminArbitrate(action) {
    const badge = document.getElementById('admin-dispute-badge');
    const disputeItem = document.getElementById('admin-dispute-item');
    if (action === 'refund') {
      alert('Décision Super Admin enregistrée :\\nLe séquestre de 38,108 XOF a été annulé et recrédité sur le compte Mobile Money de l\'acheteur béninois Amina Dossou. Le virement NGN a été annulé.');
      if (disputeItem) {
        disputeItem.innerHTML = '<div style="color:var(--error); font-weight:700; font-size:11px;"><i class="fas fa-undo"></i> Litige clôturé : Acheteur remboursé intégralement en FCFA.</div>';
      }
    } else {
      alert('Décision Super Admin enregistrée :\\nLe litige est rejeté. Le séquestre est débloqué et le virement de ₦85,000 NGN est déclenché vers le compte GTBank du commerçant nigérian Mama Folake Fabrics.');
      if (disputeItem) {
        disputeItem.innerHTML = '<div style="color:var(--success); font-weight:700; font-size:11px;"><i class="fas fa-check"></i> Litige clôturé : Séquestre débloqué et fonds versés en Naira au commerçant.</div>';
      }
    }
    if (badge) {
      badge.innerText = '0 litige';
      badge.style.background = '#E8F5E9';
      badge.style.color = '#2E7D32';
    }
  }

  function adminSaveRates() {
    const newRate = parseFloat(document.getElementById('admin-rate-input').value) || 2.43;
    const newSpread = parseFloat(document.getElementById('admin-spread-input').value) || 1.8;
    alert('Paramètres globaux mis à jour !\\nTaux XOF/NGN : ' + newRate + '\\nMarge plateforme : ' + newSpread + '%\\nTous les calculs de conversion et les devis de la marketplace sont immédiatement actualisés.');
  }

  // Initialisation au chargement
  renderProducts(products);
  updateCartUI();
  updateTransferQuote();
  renderPendingShopsAdmin();
</script>

</body>
</html>
'''

target_dir = r"C:\Users\Past HOUNGBEDJI Léon\.gemini\antigravity\scratch\naijabenin_tissus_app"
index_path = os.path.join(target_dir, "index.html")
preview_path = os.path.join(target_dir, "preview.html")

with open(index_path, "w", encoding="utf-8") as f:
    f.write(html_content)
print(f"Wrote index.html successfully ({len(html_content)} chars)")

with open(preview_path, "w", encoding="utf-8") as f:
    f.write(html_content)
print(f"Wrote preview.html successfully ({len(html_content)} chars)")
