# NaijaBénin Tissus — Application Mobile (Flutter)

Application mobile e-commerce transfrontalière Nigeria–Bénin conforme au **Cahier des charges (Octobre 2026)** :
- **Acheteurs au Bénin** : Parcourent les tissus nigérians (Dentelle, Pagne Wax/Ankara, Aso Oke, Bazin), commandent et paient en **Francs CFA (XOF)** par **Mobile Money** (MTN MoMo, Moov Money, Celtiis Cash via Kkiapay).
- **Vendeurs au Nigeria** : Publiés avec leurs prix en **Nairas (NGN)**, reçoivent le virement directement sur leur compte bancaire nigérian (Access Bank, GTBank, Zenith, etc. via Paystack/Flutterwave).
- **Séquestre Sécurisé & Retrait Garanti** : Les fonds de l'acheteur sont bloqués en séquestre. Le virement vers le vendeur nigérian n'est débloqué qu'au moment où l'acheteur retire et vérifie son colis au point relais (Cotonou Marché Dantokpa, Ganhi, Akpakpa, Porto-Novo) à l'aide de son **Code de Retrait secret à 6 chiffres**.
- **Mode Virement Direct Commerçant** : Saisie d'un compte bancaire nigérian NUBAN avec détection automatique du titulaire, calcul de cotation XOF/NGN verrouillée (5 minutes), et reçu officiel PDF/WhatsApp.

---

## 🚀 Tester Immédiatement (Simulateur Web Interactif)

Un simulateur interactif complet est inclus pour tester toutes les fonctionnalités sans avoir besoin d'attendre l'installation du SDK Flutter :
- **Double-cliquez** sur `launch_preview.bat` ou ouvrez directement `preview.html` dans Chrome / Edge.
- Vous pourrez :
  1. Parcourir le catalogue et filtrer les tissus par catégorie (Dentelle, Wax, Aso Oke, Bazin).
  2. Ajouter au panier, choisir votre point de retrait au Bénin et voir le détail des frais.
  3. Simuler le paiement Kkiapay avec Mobile Money et le placement immédiat en séquestre.
  4. Tester la calculatrice NGN/XOF avec verrouillage de cotation et vérification NUBAN.
  5. Suivre la commande en direct et simuler la chaîne logistique jusqu'au code de retrait et à la libération des fonds.
  6. Générer et exporter le reçu officiel de paiement.

---

## 📱 Structure du Code Flutter (`lib/`)

```
lib/
├── main.dart                                    # Point d'entrée MultiProvider & MaterialApp
├── config/
│   ├── constants.dart                           # Banques nigérianes, points relais Bénin, taux & plafonds KYC
│   └── theme.dart                               # Charte graphique (Bleu Marine, Or Wax, Vert Nigérian/Béninois)
├── models/
│   ├── fabric_product_model.dart                # Tissus, prix NGN/XOF, unités, vendeur, provenance
│   ├── order_model.dart                         # Commande, timeline séquestre, code de retrait
│   ├── quote_model.dart                         # Cotation verrouillée 5 min, spread change, frais Kkiapay
│   ├── pickup_point_model.dart                  # Points de retrait (Dantokpa, Ganhi, Akpakpa, Ouando...)
│   └── user_model.dart                          # Utilisateur, conformité APDP, KYC Niveau 1 (CIP/CNI)
├── services/
│   ├── auth_service.dart                        # Authentification téléphone + SMS OTP + KYC
│   ├── currency_service.dart                    # Moteur de cotation, taux XOF/NGN, résolution compte NUBAN
│   ├── marketplace_service.dart                 # Gestion du catalogue, filtres, panier, point de retrait
│   └── escrow_order_service.dart                # Orchestration du séquestre, libération des fonds, litiges
├── screens/
│   ├── auth/                                    # Écrans Connexion SMS & Code OTP
│   ├── home/
│   │   ├── main_navigation_screen.dart          # Barre de navigation 4 onglets
│   │   └── catalog_feed_screen.dart             # Flux produits & bannière séquestre
│   ├── product/
│   │   └── product_detail_screen.dart           # Fiche produit, provenance Lagos/Aba, sélecteur quantité
│   ├── cart_checkout/
│   │   ├── cart_screen.dart                     # Panier, choix point relais, calcul transparent des coûts
│   │   └── kkiapay_payment_screen.dart          # Simulation paiement Kkiapay (MTN, Moov, Celtiis)
│   ├── direct_payment/
│   │   └── send_naira_screen.dart               # Virement bancaire direct Nigeria + minuteur 5 min
│   ├── orders/
│   │   ├── orders_list_screen.dart              # Historique des transactions & séquestres
│   │   ├── order_detail_tracking_screen.dart    # Suivi logistique en 5 étapes & Code de retrait OTP
│   │   └── open_dispute_screen.dart             # Déclaration de litige sous 48h (gel des fonds)
│   ├── receipts/
│   │   └── transaction_receipt_screen.dart      # Reçu officiel, partage WhatsApp & téléchargement PDF
│   └── profile/
│       ├── profile_screen.dart                  # Profil acheteur, plafonds de paiement
│       └── kyc_status_screen.dart               # Soumission CNI/CIP + Selfie pour niveau 1
└── widgets/
    ├── fabric_card.dart                         # Carte produit avec double prix XOF / NGN
    ├── countdown_timer_badge.dart               # Badge minuteur de cours garanti
    ├── verified_badge.dart                      # Badge vendeur certifié Nigeria
    └── escrow_status_stepper.dart               # Stepper vertical du cycle de vie du séquestre
```

---

## 🛠️ Lancer l'Application sur Mobile / Émulateur (Flutter)

Lorsque Flutter est installé sur votre poste :

```bash
# 1. Se placer dans le dossier
cd "C:\Users\Past HOUNGBEDJI Léon\.gemini\antigravity\scratch\naijabenin_tissus_app"

# 2. Récupérer les dépendances
flutter pub get

# 3. Lancer sur appareil Android ou émulateur
flutter run
```
