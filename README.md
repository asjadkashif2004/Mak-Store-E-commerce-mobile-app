# 🛒 MAK Store - E-commerce Flutter App

MAK Store is a modern e-commerce mobile application developed using Flutter and Firebase. The app provides a seamless shopping experience where users can register, log in, browse various product categories, add items to the cart, and manage their profiles.

---

## 📌 Project Overview

MAK Store was created as a fully functional Flutter-based e-commerce application. It allows authenticated users to access various product categories, explore items, and manage their cart. The app uses **Firebase Authentication** for secure login/register functionality, and **Cloud Firestore** as the backend database to store product and cart data. A clean UI and modular structure ensure scalability and maintainability.

---

## ✨ Features

- 🔐 **User Authentication**
  - Register and log in using Firebase Auth
  - Persistent login session

- 🏬 **Home Page**
  - Store banner with branding
  - Sidebar/Menu with navigation options

- 📦 **Product Categories**
  - Electronics
  - Kitchen Items
  - Fashion
  - Sports
  - Books

- 🛒 **Cart Functionality**
  - Add items to cart from any category
  - View, update, or remove items
  - Cart state is user-specific and stored in Firestore

- 👤 **Profile Page**
  - View user info
  - Logout functionality

- 📱 **Responsive UI**
  - Works smoothly across Android and iOS

---

## 🧰 Tools and Technologies Used

| Technology      | Purpose                                |
|-----------------|----------------------------------------|
| **Flutter**     | UI development using Dart              |
| **Firebase Auth** | User authentication                   |
| **Cloud Firestore** | Real-time NoSQL database for products and cart |
| **Firebase Storage (optional)** | Hosting product images |
| **Provider / Riverpod (optional)** | State management     |
| **VS Code / Android Studio** | Development environment    |

---

## 🧱 Code Structure

The app follows the **MVVM (Model-View-ViewModel)** design pattern for a clear separation of concerns and easier maintainability.

### 🧠 MVVM Breakdown

- **Model**: Data structures representing products, users, and cart items.
- **View**: Screens and widgets for UI.
- **ViewModel**: Handles app logic, manages state and acts as a bridge between views and models.
- **Service**: Abstracts Firebase logic to keep ViewModels clean and testable.

This architecture ensures:
- Better testability
- Clean separation of logic and UI
- Scalability for future features like payment gateways, order tracking, etc.

---

screen shot
![image](https://github.com/user-attachments/assets/9ac49822-f5ab-485e-a741-fdf0e0e26545)


