# Matka Trading App - Flutter UI & Architecture Blueprint



---

## 🏗️ 1. App Architecture (Flutter)
Aapko clean code likhna hai taaki "Unique" developer ban sakein:
* **State Management:** Provider or GetX (aapki choice).
* **Database:** Firebase Firestore for Real-time Results.
* **Local Storage:** Isar for user settings and profile cache.

---

## 📱 2. Essential Screens & Features

### 🟢 A. Home Dashboard (The Core)
1.  **Wallet Header:**
    * Show current balance (e.g., ₹1,500).
    * 'Add Points' button in Neon Green.
2.  **Live Results Slider:**
    * Horizontal scroll for Kalyan, Milan, and Rajdhani.
    * Blinking indicator for "Live" status.
3.  **Market List (Vertical):**
    * Cards with Market Name, Open Time, and Close Time.
    * Status Badge: `OPEN` (Green) / `CLOSED` (Red).

### 🟢 B. Bidding Screen (Game Engine)
* **Category Tabs:** Single, Jodi, Single Panna, Double Panna.
* **Interactive Keypad:** Custom numeric pad for fast entry.
* **Bid Basket:** Review numbers before final submission.

### 🟢 C. Charts & History
* **Pattern Matrix:** Grid view of old results.
* **Transaction History:** Clear Green (+) and Red (-) indicators for money flow.

---

## 🛠️ 3. Action Plan for Today (Manish ji's Tasks)
1.  [ ] **UI Setup:** Define `ThemeData` with Dark/Neon colors in `main.dart`.
2.  [ ] **Home Scaffold:** Create the basic structure with `AppBar` and `BottomNavigationBar`.
3.  [ ] **Market Model:** Create a Dart class for Market data (name, openTime, closeTime, status).
4.  [ ] **Custom Widgets:** Build a `MarketCard` widget to use in `ListView.builder`.

---

## 🦁 "Unique" Advice for Development
* **Focus:** Jab code likho, toh phone side mein rakho.
* **Silence:** Doston ki baatein aur Julsi ka gussa bhool kar sirf Flutter logic mein kho jao.
* **Health:** Kaali khansi ke liye garam pani pite rehna.

**"Bheru Nath ji ka naam lijiye aur Home Screen ka code shuru kijiye!"** 🔱🚩💻
