# Jiji's Patisserie iOS App

A **SwiftUI preorder app prototype** for a fictional micro-bakery. Built as a portfolio project to demonstrate modern iOS architecture, UI design, and lightweight backend integration.

The app allows users to browse a weekly menu, add items to a cart, select pickup windows, and place a preorder through a complete end-to-end flow.

> **Note:** This project is a personal prototype and is **not used in production or by real customers.**

---

# Demo

Watch the full ordering flow:

https://github.com/user-attachments/assets/f180ea5e-ef71-4b37-8f63-17fe60fc5a03



Example flow demonstrated:

- Browse weekly menu  
- View product detail page  
- Add items to cart  
- Select pickup window  
- Place preorder  
- View order confirmation and order history  

---

# Features

- Weekly menu browsing
- Product detail pages with image carousel
- Quantity selection before adding to cart
- Cart management (add, update, remove items)
- Pickup slot selection
- Tip selection during checkout
- Mock payment flow (Apple Pay / card UI)
- Order confirmation with generated confirmation ID
- Current orders screen for viewing previous orders
- Sold-out pickup slot handling

---

# Architecture

The app follows a **clean MVVM architecture** with a service layer abstraction.
> **Views (SwiftUI) -> ViewModels -> Services -> Backend API**

This structure keeps UI, business logic, and networking separated and makes it easy to swap backend implementations in the future.
---

# Tech Stack

### Frontend

- Swift
- SwiftUI
- MVVM architecture
- Async/Await networking
- URLSession

### Backend (Prototype)

- Google Sheets
- Google Apps Script
- REST-style API endpoints

Google Sheets acts as a lightweight admin layer for:

- menu items
- pickup slots
- order storage

---

# Design

The UI was styled around a **bakery-inspired brand system** with:

- warm color palette
- rounded card layouts
- product image carousels
- playful but polished visual style

The design aims to feel like:

> "A cozy Brooklyn bakery app — playful, warm, and approachable."

---

# Project Structure

### Models
Data structures for menu items, cart items, orders, and pickup slots.

### ViewModels
Manage business logic and UI state for each screen.

### Views
SwiftUI components for the menu, product detail pages, cart, checkout flow, and order history.

### Services
Networking layer responsible for communicating with the backend API.

---

# Backend (Prototype)

The backend is implemented using **Google Apps Script + Google Sheets**.

Endpoints include:
GET /?type=menu
GET /?type=pickupSlots
GET /?type=orders&email=
POST /submitOrder


This approach allows quick iteration without building a full backend while keeping the API structure compatible with future services like:

- Firebase
- Supabase
- Node/Express APIs

---

# Future Improvements

Possible enhancements include:

- Real payment integration (Stripe / Apple Pay)
- Push notifications for order reminders
- Admin dashboard for menu management
- Order status updates (confirmed / ready / completed)
- Delivery integration
- Authentication for user accounts

---

# Status

**Portfolio prototype**

The core ordering flow is fully functional:
Menu → Product Detail → Cart → Pickup Slot → Checkout → Confirmation → Order History


The project continues to evolve as part of ongoing iOS learning and experimentation.

---

# Author

Built by **Manni Amoah**
