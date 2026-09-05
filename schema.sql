-- ============================================================
-- LEO TECH LAB SUBSCRIPTION STORE — MYSQL DATABASE SCHEMA
-- For Hostinger phpMyAdmin / MySQL Database Import
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `pages`;
DROP TABLE IF EXISTS `settings`;
DROP TABLE IF EXISTS `faqs`;
DROP TABLE IF EXISTS `reviews`;
DROP TABLE IF EXISTS `offers`;
DROP TABLE IF EXISTS `product_durations`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `admins`;

SET FOREIGN_KEY_CHECKS = 1;

-- 1. Admins Table
CREATE TABLE `admins` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(100) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Categories Table
CREATE TABLE `categories` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(150) NOT NULL,
  `slug` VARCHAR(150) NOT NULL UNIQUE,
  `icon` VARCHAR(50) DEFAULT 'Sparkles',
  `description` TEXT,
  `active` TINYINT(1) DEFAULT 1,
  `sort_order` INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Products Table
CREATE TABLE `products` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `slug` VARCHAR(255) NOT NULL UNIQUE,
  `category_id` INT DEFAULT NULL,
  `image_url` TEXT,
  `short_desc` TEXT,
  `full_desc` TEXT,
  `features_json` LONGTEXT,
  `is_featured` TINYINT(1) DEFAULT 0,
  `is_popular` TINYINT(1) DEFAULT 0,
  `is_active` TINYINT(1) DEFAULT 1,
  `offer_badge` VARCHAR(100) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Product Durations & Pricing Table
CREATE TABLE `product_durations` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `product_id` INT NOT NULL,
  `duration_label` VARCHAR(100) NOT NULL,
  `price` DECIMAL(10,2) DEFAULT NULL,
  `old_price` DECIMAL(10,2) DEFAULT NULL,
  `is_contact_on_whatsapp` TINYINT(1) DEFAULT 0,
  `sort_order` INT DEFAULT 0,
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Offers Table
CREATE TABLE `offers` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(255) NOT NULL,
  `product_id` INT DEFAULT NULL,
  `discount_percentage` INT DEFAULT NULL,
  `old_price` DECIMAL(10,2) DEFAULT NULL,
  `new_price` DECIMAL(10,2) DEFAULT NULL,
  `image_url` TEXT,
  `expires_at` DATETIME DEFAULT NULL,
  `is_active` TINYINT(1) DEFAULT 1,
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Reviews Table
CREATE TABLE `reviews` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `customer_name` VARCHAR(150) NOT NULL,
  `avatar_url` TEXT,
  `rating` INT DEFAULT 5,
  `review_text` TEXT NOT NULL,
  `review_date` VARCHAR(100) DEFAULT NULL,
  `is_active` TINYINT(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. FAQs Table
CREATE TABLE `faqs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `question` TEXT NOT NULL,
  `answer` TEXT NOT NULL,
  `category` VARCHAR(100) DEFAULT 'General',
  `sort_order` INT DEFAULT 0,
  `is_active` TINYINT(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. Website Settings Table
CREATE TABLE `settings` (
  `key` VARCHAR(100) PRIMARY KEY,
  `value` TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9. Editable Pages Table
CREATE TABLE `pages` (
  `slug` VARCHAR(100) PRIMARY KEY,
  `title` VARCHAR(255) NOT NULL,
  `content` LONGTEXT NOT NULL,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- DEFAULT SEED DATA
-- ============================================================

-- Seed Default Admin: admin / admin123
INSERT INTO `admins` (`id`, `username`, `password_hash`) VALUES
(1, 'admin', '$2a$10$tZ2RfgM8Jg8dFknxG.G8ceE3g0c8r6wUqR8b9zV7wDk7L9a2jXpC2')
ON DUPLICATE KEY UPDATE `username`=`username`;

-- Seed Website Settings
INSERT INTO `settings` (`key`, `value`) VALUES
('site_name', 'Leo Tech Lab'),
('logo_text', 'Leo Tech Lab'),
('whatsapp_number', '+923001234567'),
('whatsapp_community', 'https://chat.whatsapp.com/sample-community-link'),
('contact_email', 'support@leotechlab.com'),
('contact_phone', '+92 300 1234567'),
('footer_text', 'Leo Tech Lab provides premium digital tools and genuine subscription licenses at unbeatable wholesale prices. Fast delivery and 24/7 dedicated support.'),
('seo_title', 'Leo Tech Lab — Premium Subscription Store'),
('seo_description', 'Buy affordable premium subscriptions for ChatGPT Plus, Canva Pro, Netflix 4K, JetBrains, NordVPN and more.'),
('social_whatsapp', 'https://wa.me/923001234567'),
('social_facebook', 'https://facebook.com/leotechlab'),
('social_instagram', 'https://instagram.com/leotechlab'),
('social_tiktok', 'https://tiktok.com/@leotechlab'),
('social_youtube', 'https://youtube.com/@leotechlab'),
('social_telegram', 'https://t.me/leotechlab'),
('section_hero', 'true'),
('section_categories', 'true'),
('section_featured', 'true'),
('section_offers', 'true'),
('section_popular', 'true'),
('section_why_us', 'true'),
('section_reviews', 'true'),
('section_faq', 'true'),
('section_community', 'true'),
('section_whatsapp_banner', 'true')
ON DUPLICATE KEY UPDATE `value`=VALUES(`value`);

-- Seed Categories
INSERT INTO `categories` (`id`, `name`, `slug`, `icon`, `description`, `sort_order`) VALUES
(1, 'AI & Productivity', 'ai-productivity', 'Bot', 'ChatGPT Plus, Claude, Midjourney & AI Suite', 1),
(2, 'Streaming & Media', 'streaming-media', 'Tv', 'Netflix, Spotify, YouTube Premium & IPTV', 2),
(3, 'Design & Creative', 'design-creative', 'Palette', 'Canva Pro, Adobe CC, Figma & Motion graphics', 3),
(4, 'Developer Tools', 'developer-tools', 'Code', 'JetBrains, GitHub Copilot, VPS & Hosting', 4),
(5, 'Security & VPN', 'security-vpn', 'ShieldCheck', 'NordVPN, ExpressVPN, Antivirus & Passwords', 5)
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- Seed Products
INSERT INTO `products` (`id`, `name`, `slug`, `category_id`, `image_url`, `short_desc`, `full_desc`, `features_json`, `is_featured`, `is_popular`, `is_active`, `offer_badge`) VALUES
(1, 'ChatGPT Plus (GPT-4o)', 'chatgpt-plus', 1, 'https://images.unsplash.com/photo-1677442136019-21780efad99a?w=800&auto=format&fit=crop&q=80', 'Access GPT-4o, DALL-E 3, Web Browsing & Custom GPTs with zero rate limits.', 'ChatGPT Plus subscription gives you priority access to OpenAIs flagship GPT-4o model, instant response times, voice mode, DALL-E 3 image generation, and custom AI agents.', '["GPT-4o & GPT-4 Turbo Access", "DALL-E 3 Image Generation", "Advanced Data Analysis", "Custom GPTs Access", "Priority response times", "Personal Private Account"]', 1, 1, 1, 'HOT DEAL'),
(2, 'Canva Pro Lifetime / Yearly', 'canva-pro', 3, 'https://images.unsplash.com/photo-1626785774573-4b799315345d?w=800&auto=format&fit=crop&q=80', 'Unlock 100M+ premium stock photos, magic resize, background remover & brand kit.', 'Upgrade your own email to Canva Pro. Enjoy premium graphics, videos, audio, premium fonts, one-click background remover, and unlimited cloud storage.', '["100M+ Premium Stock Photos & Videos", "1-Click Background Remover", "Brand Kit with Unlimited Fonts", "Magic Resize for Social Media", "100GB Cloud Storage", "Upgraded on your own email"]', 1, 1, 1, '50% OFF'),
(3, 'Netflix Premium 4K Ultra HD', 'netflix-premium-4k', 2, 'https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=800&auto=format&fit=crop&q=80', 'Private screen / profile with PIN lock, 4K HDR quality, multi-device support.', 'Watch your favorite movies and TV shows in crystal clear 4K Ultra HD + HDR quality with spatial audio. Private profile with customizable PIN code.', '["Ultra HD (4K) + HDR Video Quality", "Spatial Audio Included", "Private Profile with PIN Lock", "Works on Smart TV, Phone, PC, Tablet", "Instant Activation", "Full Period Replacement Warranty"]', 1, 1, 1, 'POPULAR'),
(4, 'JetBrains All Products Pack', 'jetbrains-all-products', 4, 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800&auto=format&fit=crop&q=80', 'IntelliJ IDEA, PyCharm, WebStorm, ReSharper, DataGrip & 10+ IDEs on your account.', 'Get full access to JetBrains All Products Pack. Includes IntelliJ IDEA Ultimate, PyCharm Professional, WebStorm, PhpStorm, CLion, DataGrip and Rider with full license key.', '["Includes 15+ JetBrains IDEs", "Personal Educational/Commercial License", "Cross-Platform Windows/Mac/Linux", "Official Updates Enabled", "Instant Email License Key"]', 0, 1, 1, 'BEST VALUE'),
(5, 'NordVPN Ultimate 2 Years', 'nordvpn-ultimate', 5, 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=800&auto=format&fit=crop&q=80', 'Ultra-fast VPN with Threat Protection, Meshnet, 6000+ servers worldwide.', 'NordVPN provides top-tier online privacy, high-speed streaming servers, built-in malware protection, and ad blocking across all your devices.', '["6000+ High Speed Servers", "Built-in Malware & Ad Blocker", "Strict No-Logs Policy", "Supports 6 Devices Simultaneously", "4K Streaming & Torrenting Optimized"]', 1, 0, 1, 'SECURE')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- Seed Product Durations
INSERT INTO `product_durations` (`product_id`, `duration_label`, `price`, `old_price`, `is_contact_on_whatsapp`, `sort_order`) VALUES
(1, '1 Month', 12.99, 20.00, 0, 1),
(1, '3 Months', 34.99, 60.00, 0, 2),
(1, '6 Months', 64.99, 120.00, 0, 3),
(1, '1 Year', 119.99, 240.00, 0, 4),
(2, '1 Month', 4.99, 12.99, 0, 1),
(2, '1 Year', 19.99, 54.00, 0, 2),
(2, 'Lifetime Plan', 39.99, 120.00, 0, 3),
(2, 'Custom Team Pack', NULL, NULL, 1, 4),
(3, '1 Month (Private Profile)', 4.50, 9.99, 0, 1),
(3, '3 Months (Private Profile)', 12.99, 29.99, 0, 2),
(3, '6 Months (Private Profile)', 23.99, 59.99, 0, 3),
(3, '1 Year (Full Account)', NULL, NULL, 1, 4),
(4, '1 Year License', 29.99, 249.00, 0, 1),
(4, '2 Year License', 49.99, 450.00, 0, 2),
(5, '1 Year Plan', 19.99, 69.99, 0, 1),
(5, '2 Years Plan', 34.99, 129.99, 0, 2);

-- Seed Offers
INSERT INTO `offers` (`id`, `title`, `product_id`, `discount_percentage`, `old_price`, `new_price`, `expires_at`, `is_active`) VALUES
(1, 'ChatGPT Plus Mid-Season Special', 1, 40, 20.00, 12.99, DATE_ADD(NOW(), INTERVAL 7 DAY), 1),
(2, 'Canva Pro Lifetime License Deal', 2, 65, 120.00, 39.99, DATE_ADD(NOW(), INTERVAL 5 DAY), 1),
(3, 'Netflix 4K Private Profile Bundle', 3, 50, 9.99, 4.50, DATE_ADD(NOW(), INTERVAL 10 DAY), 1)
ON DUPLICATE KEY UPDATE `title`=VALUES(`title`);

-- Seed Reviews
INSERT INTO `reviews` (`customer_name`, `avatar_url`, `rating`, `review_text`, `review_date`, `is_active`) VALUES
('Hamza Tariq', 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&auto=format&fit=crop&q=80', 5, 'Got ChatGPT Plus activated on my own email within 8 minutes of messaging on WhatsApp. Flawless service by Leo Tech Lab!', '2 days ago', 1),
('Ayesha Malik', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80', 5, 'Purchased Canva Pro 1 Year plan for my digital marketing agency. Everything is premium, magic resize works perfectly. Highly recommended!', '1 week ago', 1),
('Bilal Ahmed', 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150&auto=format&fit=crop&q=80', 5, 'Netflix 4K profile is completely private with PIN code. No screens limit error or deactivation. 10/10 support on WhatsApp.', '2 weeks ago', 1);

-- Seed FAQs
INSERT INTO `faqs` (`question`, `answer`, `category`, `sort_order`, `is_active`) VALUES
('How do I receive my subscription after ordering?', 'Once you place an order on WhatsApp, our admin team verifies your payment details and delivers your account credentials or upgrade link instantly within 5–15 minutes.', 'Ordering & Delivery', 1, 1),
('Are these subscriptions on my own email or shared?', 'Most software subscriptions (like Canva Pro, Spotify, JetBrains) are activated directly on your personal email address. For Netflix & ChatGPT, we provide private dedicated profiles or private credentials with full replacement warranty.', 'Account Details', 2, 1),
('What payment methods do you accept?', 'We accept JazzCash, EasyPaisa, Bank Transfer, Binance USDT, and Crypto. Payment details will be shared directly on WhatsApp upon order creation.', 'Payment', 3, 1),
('What is your warranty policy?', 'All subscriptions come with full duration replacement warranty. If you experience any technical issues during your active period, our WhatsApp support resolves it or replaces the account immediately.', 'Warranty & Support', 4, 1),
('Can I upgrade or extend my subscription later?', 'Yes! You can contact us anytime on WhatsApp to renew or upgrade your active subscription before it expires.', 'Renewal', 5, 1);

-- Seed Pages
INSERT INTO `pages` (`slug`, `title`, `content`) VALUES
('home', 'Home', 'Welcome to Leo Tech Lab — The premier destination for affordable premium subscription licenses.'),
('about-us', 'About Leo Tech Lab', 'Leo Tech Lab is a premier digital marketplace specializing in genuine subscription software licenses, AI productivity tools, and entertainment accounts.\n\nFounded with a commitment to transparency and exceptional service, we empower students, software engineers, digital agencies, and media enthusiasts by providing top-tier digital tools at wholesale prices without compromising on security or support.'),
('contact-us', 'Contact Leo Tech Lab', 'Reach out to Leo Tech Lab 24/7 via WhatsApp or email for instant support and ordering assistance.'),
('privacy-policy', 'Privacy Policy', 'At Leo Tech Lab, we prioritize your privacy and data security.\n\n1. Information We Collect\nWe only collect basic contact information (such as your name, email, and WhatsApp phone number) required to fulfill your subscription order.\n\n2. Usage of Data\nYour information is strictly used to activate your subscription, deliver order credentials via WhatsApp, and provide ongoing replacement warranty support.\n\n3. Third-Party Sharing\nWe never sell, trade, or share your private information with third parties.\n\n4. Payment Security\nAll payment receipts and transaction records are handled securely. We do not store sensitive payment card details.'),
('terms-and-conditions', 'Terms & Conditions', 'By accessing or placing an order through Leo Tech Lab, you agree to the following terms:\n\n1. License Scope\nAll subscription licenses and accounts are provided for personal or authorized business use as stated in the product description.\n\n2. Order Delivery\nCredentials and license details are delivered via WhatsApp within 5 to 15 minutes of payment confirmation.\n\n3. Account Security\nCustomers must not tamper with billing details, payment methods, or master credentials on accounts provided by Leo Tech Lab.'),
('refund-policy', 'Refund & Replacement Policy', 'Leo Tech Lab guarantees 100% replacement protection for all active digital subscription plans.\n\n1. Full Duration Replacement Guarantee\nIf your active subscription encounters any technical failure or deactivation during your purchased period, we replace or fix the account immediately free of charge.\n\n2. Refund Conditions\nBecause digital items are non-returnable once activated, cash refunds are issued only if Leo Tech Lab is unable to provide a working replacement or alternative within 48 hours.\n\n3. Claims Process\nSimply message our WhatsApp support desk with your order details and screenshot of the issue for immediate resolution.')
ON DUPLICATE KEY UPDATE `title`=VALUES(`title`);
