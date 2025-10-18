-- TechCorp Solutions Database Schema
-- Web Programming II Homework Database

CREATE DATABASE IF NOT EXISTS `company_db`
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `company_db`;

-- Users table for authentication
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL UNIQUE,
  `email` varchar(100) NOT NULL UNIQUE,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('visitor', 'registered', 'admin') NOT NULL DEFAULT 'registered',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Products table for displaying company products/services
CREATE TABLE IF NOT EXISTS `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `price` decimal(10,2),
  `category_id` int(11),
  `image_url` varchar(255),
  `status` enum('active', 'inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Categories table for product categorization
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Contact messages table
CREATE TABLE IF NOT EXISTS `contact_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `subject` varchar(200),
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('new', 'read', 'replied') DEFAULT 'new',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Projects table for showcasing company work
CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` text,
  `client_name` varchar(100),
  `start_date` date,
  `end_date` date,
  `status` enum('planning', 'in_progress', 'completed', 'on_hold') DEFAULT 'planning',
  `image_url` varchar(255),
  `technologies` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add foreign key constraint
ALTER TABLE `products` ADD CONSTRAINT `fk_products_category` 
FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`) ON DELETE SET NULL;

-- Insert default admin user (password: admin123)
INSERT INTO `users` (`username`, `email`, `password_hash`, `role`) VALUES
('admin', 'admin@techcorp.com', 'b3d17ebbe4f2b75d27b6db8c9d77e7b8ba07e1b8c8d8e7b123456789abcdef01', 'admin'),
('testuser', 'test@techcorp.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'registered');

-- Insert sample categories
INSERT INTO `categories` (`name`, `description`) VALUES
('Web Development', 'Custom web applications and websites'),
('Mobile Apps', 'iOS and Android mobile applications'),
('Software Solutions', 'Desktop and enterprise software'),
('Consulting', 'Technology consulting and advisory services'),
('Cloud Services', 'Cloud infrastructure and migration services');

-- Insert sample products/services
INSERT INTO `products` (`name`, `description`, `price`, `category_id`, `status`) VALUES
('Custom Website Development', 'Professional website development with modern technologies', 2500.00, 1, 'active'),
('E-commerce Platform', 'Full-featured online store with payment integration', 5000.00, 1, 'active'),
('Mobile App Development', 'Native iOS and Android app development', 8000.00, 2, 'active'),
('Cloud Migration Service', 'Complete cloud infrastructure migration', 3500.00, 5, 'active'),
('Business Process Automation', 'Custom software for business process automation', 4500.00, 3, 'active'),
('IT Consulting', 'Professional technology consulting services', 150.00, 4, 'active'),
('Database Design & Optimization', 'Database architecture and performance optimization', 2000.00, 3, 'active'),
('API Development', 'RESTful API development and integration', 1800.00, 1, 'active');

-- Insert sample projects
INSERT INTO `projects` (`title`, `description`, `client_name`, `start_date`, `end_date`, `status`, `technologies`) VALUES
('E-commerce Platform for RetailCorp', 'Complete online shopping platform with inventory management', 'RetailCorp Ltd.', '2024-01-15', '2024-04-30', 'completed', 'Node.js, React, MySQL, Docker'),
('Mobile Banking App', 'Secure mobile banking application with biometric authentication', 'SecureBank', '2024-03-01', '2024-08-15', 'completed', 'React Native, Node.js, PostgreSQL, AWS'),
('Hospital Management System', 'Comprehensive hospital management and patient tracking system', 'City Medical Center', '2024-05-01', '2024-12-31', 'in_progress', 'Vue.js, Express.js, MongoDB, Redis'),
('Smart City Dashboard', 'Real-time monitoring dashboard for city infrastructure', 'Metro City Council', '2024-07-15', '2025-02-28', 'in_progress', 'Angular, Python, InfluxDB, Grafana'),
('Supply Chain Optimization', 'AI-powered supply chain management system', 'LogiFlow Inc.', '2024-09-01', '2025-03-15', 'planning', 'Python, TensorFlow, PostgreSQL, Kubernetes');

-- Insert sample contact messages
INSERT INTO `contact_messages` (`name`, `email`, `subject`, `message`, `status`) VALUES
('John Smith', 'john.smith@email.com', 'Web Development Inquiry', 'Hi, I am interested in your web development services for my startup. Could you please provide more details about your packages and pricing?', 'new'),
('Sarah Johnson', 'sarah.j@company.com', 'Mobile App Development', 'We need a mobile app for our retail business. Can we schedule a consultation to discuss our requirements?', 'read'),
('Michael Brown', 'mbrown@techstartup.com', 'Cloud Migration Services', 'Our company is looking to migrate to cloud infrastructure. What is your experience with AWS migrations?', 'new'),
('Lisa Davis', 'lisa.davis@nonprofit.org', 'Consulting Services', 'We are a non-profit organization looking for IT consulting. Do you offer any special rates for non-profits?', 'replied'),
('Robert Wilson', 'rwilson@manufacturing.com', 'Custom Software Development', 'We need custom software for our manufacturing process automation. Can you help us with this project?', 'new');