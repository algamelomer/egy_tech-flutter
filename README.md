# Handmade Hive - Egy Tech Flutter Project 💡

## 🧾 Project Overview

**Handmade Hive** is a mobile platform designed to connect handmade product creators with buyers in an easy and efficient way. This app solves two major problems:
- **For sellers**: Difficulty in marketing and promoting their handmade work.
- **For buyers**: Struggling to find unique, handcrafted products at affordable prices.

With this application, artisans can showcase their creations, reach a wider audience, and manage sales, while buyers can browse, filter, and purchase personalized handmade items.

🔗 **UI/UX Design Prototype**: [Figma File](https://www.figma.com/design/tS4CHRDGdDVWxxklB7e6aa/Handmade-Hive-Prototype-(Copy)?node-id=1-2117&t=NA1DrAdoZQY826Rc-0)

---

## 🧩 Repository Structure

This repository contains both the **backend (Laravel)** and the **frontend (Flutter)** for the Handmade Hive app.

### Branches Overview:

- `main`: ⚠️ **Do not push directly to this branch!** It's the **protected main branch** used for releases and final merges only.
- `backend`: Contains the **Laravel backend code** (PHP/MySQL).
- `flutter`: Contains the **Flutter frontend code** (Dart).
  
To contribute:
- Make your changes in a new feature branch.
- Merge into either `backend` or `flutter` depending on your changes.
- Final merges into `main` are done by maintainers.

---

## 📦 How to Install & Run the Project

### 🔁 Clone the Repository

```bash
git clone https://github.com/algamelomer/egy_tech-flutter.git
cd egy_tech-flutter
```

Then switch to the correct branch depending on what you're working on:

```bash
# For Backend Developers (Laravel)
git checkout backend

# For Frontend Developers (Flutter)
git checkout flutter
```

---

## ▶️ Running the Backend (Laravel)

Ensure you have:
- PHP >= 8.1
- Composer
- MySQL / MariaDB
- Laravel Sail or Docker (optional)

### Steps:

1. Install dependencies:
   ```bash
   composer install
   ```

2. Create `.env` file:
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

3. Set up database and run migrations:
   ```bash
   php artisan migrate --seed
   ```

4. Start the development server:
   ```bash
   php artisan serve
   ```
   API will be available at: `http://localhost:8000/api`

> ✅ Use Laravel Sail? Check documentation for Docker setup (`sail up`, etc.)

---

## 📱 Running the Frontend (Flutter)

Ensure you have:
- Flutter SDK installed
- Android Studio / Xcode / Emulator set up
- Git and relevant IDE plugins

### Steps:

1. Navigate to the Flutter directory:
   ```bash
   cd handmade_hive_flutter_app # Or the actual folder name
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

> 📌 Don't forget to update the `.env` or API base URL if needed before running.

---

## 🛠️ Contributing Guidelines

### ❗ Never Push Directly to `main`

The `main` branch is protected and should only receive updates through pull requests from `backend` or `flutter` branches.

### ✅ Recommended Contribution Workflow

1. Pull the latest version of the branch you're working on:
   ```bash
   git checkout <branch-name>
   git pull origin <branch-name>
   ```

2. Create a new feature branch:
   ```bash
   git checkout -b feature/new-feature
   ```

3. Make your changes and test them locally.

4. Commit and push your changes:
   ```bash
   git add .
   git commit -m "Add new feature"
   git push origin feature/new-feature
   ```

5. Open a Pull Request (PR) against the correct branch (`backend` or `flutter`).

---

## 👥 Team Members

- **Zeyad Hassan Abaza** – zeyad.h.abaza@gmail.com
- **Omar Gamal** – omeralgamel@gmail.com

---

## 📞 Contact

If you have any questions, issues, or suggestions, feel free to open an issue on GitHub or reach out to us via email.

---

## 📜 License

This project is licensed under the MIT License – see the [LICENSE.md](LICENSE.md) file for details.
```
