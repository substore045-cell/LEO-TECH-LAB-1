# 🚀 HOSTINGER DEPLOYMENT GUIDE — LEO TECH LAB SUBSCRIPTION STORE

This document contains full, comprehensive, step-by-step instructions to deploy the **Leo Tech Lab Subscription Store** to **Hostinger Web Hosting (Cloud / Business Node.js Selector)** or **Hostinger VPS**.

---

## 📋 TABLE OF CONTENTS
1. [Overview & Prerequisites](#1-overview--prerequisites)
2. [Environment Variables (.env)](#2-environment-variables-env)
3. [Method 1: Hostinger Node.js Application Manager (Recommended)](#3-method-1-hostinger-nodejs-application-manager-hpanel)
4. [Method 2: Hostinger VPS Deployment with PM2 & Nginx](#4-method-2-hostinger-vps-deployment-with-pm2--nginx)
5. [Database Setup (Zero-Config SQLite vs Hostinger MySQL)](#5-database-setup)
6. [File Uploads & Media Storage](#6-file-uploads--media-storage)
7. [Admin Panel Access & Default Credentials](#7-admin-panel-access--default-credentials)
8. [WhatsApp Ordering System Verification](#8-whatsapp-ordering-system-verification)
9. [Troubleshooting & Common FAQs](#9-troubleshooting--common-faqs)

---

## 1. OVERVIEW & PREREQUISITES

The **Leo Tech Lab** application is architected as a high-performance, single-port full-stack web application:
- **Frontend**: React 18 SPA compiled into static assets inside `dist/`.
- **Backend**: Express.js REST API in `server/`, which serves `/api/*` routes, `/uploads/*` images, and statically serves the compiled frontend `dist/` on all customer routes.
- **Node.js Requirement**: Node.js 18.x, 20.x, or 22.x+.

---

## 2. ENVIRONMENT VARIABLES (.env)

Create a `.env` file in your root folder on Hostinger:

```env
# Server Port (Hostinger automatically provides PORT or use 5000)
PORT=5000

# Environment Mode
NODE_ENV=production

# JWT Authentication Secret Key (Replace with a random 64-character string)
JWT_SECRET=leo_tech_lab_super_secure_jwt_token_2026_golden_key!

# Database Type: 'sqlite' (Zero-config, works immediately)
DB_TYPE=sqlite
DB_FILE=./server/database.sqlite
```

---

## 3. METHOD 1: HOSTINGER NODE.JS APPLICATION MANAGER (hPanel)

If you are using **Hostinger Business Web Hosting**, **Cloud Hosting**, or any plan with the **Node.js** feature in hPanel:

### Step 1: Build Frontend Locally or in CI
On your development machine:
```bash
cmd /c npm run build
```
This compiles the high-performance production build into the `dist/` folder.

### Step 2: Prepare Files for Upload
You only need to upload these folders and files to your Hostinger file manager (or via FTP):
- `dist/` (Compiled frontend)
- `server/` (Backend Express server, routes, and config)
- `app.js` (Root startup alias)
- `package.json` (Dependencies)
- `.env` (Environment configuration)
- `.htaccess` (Apache rewrite configuration)
- `schema.sql` (MySQL database schema, if using MySQL)

*(Note: Do NOT upload `node_modules` or `src/` — dependencies will be installed directly on Hostinger).*

### Step 3: Configure Node.js in Hostinger hPanel
1. Log in to your **Hostinger hPanel**.
2. Navigate to **Websites** -> Click **Manage** next to your domain.
3. In the search bar, search for **Node.js** and click on it.
4. Fill in the configuration details:
   - **Node.js version**: Choose `20.x` or `18.x`.
   - **Application mode**: `Production`.
   - **Application root**: `/public_html` (or your chosen subfolder).
   - **Application startup file**: `app.js` (or `server/index.js`).
5. Click **Create** or **Save**.

### Step 4: Install Dependencies & Start
1. In the Node.js management screen, click **Run NPM Install** (or access the SSH terminal and run `npm install --production`).
2. Click **Start Application** (or **Restart**).
3. Open your domain (e.g., `https://yourdomain.com`). Your store is now live!

---

## 4. METHOD 2: HOSTINGER VPS DEPLOYMENT WITH PM2 & NGINX

If you are deploying to a Hostinger Ubuntu/Debian VPS:

### Step 1: Clone Repository & Install
```bash
git clone https://github.com/your-username/leo-tech-lab.git /var/www/leotechlab
cd /var/www/leotechlab
npm install
npm run build
```

### Step 2: Start Application with PM2
```bash
# Install PM2 globally
npm install -g pm2

# Start the server with automatic restarts
pm2 start app.js --name "leo-tech-lab"

# Save PM2 process list to start on server reboot
pm2 save
pm2 startup
```

### Step 3: Configure Nginx Reverse Proxy
Edit `/etc/nginx/sites-available/leotechlab`:
```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```
Enable the site and reload Nginx:
```bash
sudo ln -s /etc/nginx/sites-available/leotechlab /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

---

## 5. DATABASE SETUP

### Option A: Zero-Config SQLite (Default — Recommended)
- By default, the app uses an embedded SQLite database (`server/database.sqlite`).
- Upon first launch, the database, tables, and full default inventory (ChatGPT Plus, Canva Pro, Netflix 4K, JetBrains, NordVPN, reviews, offers, settings) are **automatically created and seeded** with zero setup required!

### Option B: Hostinger MySQL Database (Optional)
If you prefer running on Hostinger's managed MySQL database:
1. In Hostinger hPanel, go to **Databases** -> **MySQL Databases**.
2. Create a new database name, username, and password.
3. Click **Enter phpMyAdmin**.
4. Select your new database, click the **Import** tab at the top.
5. Choose the provided `schema.sql` file and click **Go**.
6. All 9 tables with foreign keys and complete initial seed data will be created.

---

## 6. FILE UPLOADS & MEDIA STORAGE

- Admin product images, offer banners, logos, and icons can be uploaded directly from the Admin Panel via `/api/upload`.
- Files are saved in `server/uploads/` and served publicly via `/uploads/<filename>`.
- Make sure the `server/uploads/` directory has write permissions (`chmod 755 server/uploads` on Linux/VPS).

---

## 7. ADMIN PANEL ACCESS & DEFAULT CREDENTIALS

The Admin Dashboard is completely isolated and secured behind bcrypt password hashing and JWT token authentication.

- **Admin Login URL**: `https://yourdomain.com/admin/login`
- **Default Username**: `admin`
- **Default Password**: `admin123`

### Capabilities Available in Admin Panel:
1. **Products & Durations**: Add/edit/delete products, configure unlimited duration options (1 Month, 3 Months, 1 Year, Lifetime, etc.), set individual prices, set discount old prices, toggle "Contact on WhatsApp", set featured/popular status.
2. **Offers**: Create promotional deals with discount badges, countdown expiry dates, and product links.
3. **Reviews**: Manage customer reviews and ratings.
4. **FAQs**: Manage searchable accordions by category.
5. **Store Settings**: Update WhatsApp order number, VIP community link, email, phone, social media links, logo, favicon, and SEO tags.
6. **Section Controls**: Enable or disable any homepage section with a single toggle.
7. **Page Editor**: Edit About Us, Contact Us, Privacy Policy, Terms & Conditions, and Refund Policy.

---

## 8. WHATSAPP ORDERING SYSTEM VERIFICATION

1. Go to `https://yourdomain.com/admin/login` and log in.
2. Go to **Store Settings**.
3. Under **WhatsApp & Contact Channels**, enter your business WhatsApp number with country code (e.g. `+923001234567`).
4. Click **Save Settings**.
5. On the public store, visit any product (e.g. `ChatGPT Plus`), select a duration (e.g. `3 Months`), and click **Order Now on WhatsApp**.
6. Verify that WhatsApp opens with the formatted message:
   ```
   Hello Leo Tech Lab, I want to order ChatGPT Plus (GPT-4o) for 3 Months (Price: $34.99). Please share the payment and order details.
   ```

---

## 9. TROUBLESHOOTING & COMMON FAQS

| Issue | Solution |
|---|---|
| **Port Conflict error (EADDRINUSE)** | In Hostinger Node.js manager, Hostinger assigns the port dynamically. Ensure `const PORT = process.env.PORT || 5000;` is in `server/index.js` (already included). |
| **White page on refresh (404 Not Found)** | Ensure `.htaccess` is uploaded to root so Apache redirects client-side React routes to `index.html`. |
| **Images not loading after upload** | Ensure `server/uploads` exists and has write permissions (`chmod 755 server/uploads`). |
| **Password change** | You can update your password in the database or via SQL: `UPDATE admins SET password_hash = ... WHERE username = 'admin';`. |

---

*Leo Tech Lab — Built for Reliability, Speed, and Maximum WhatsApp Conversion.*
