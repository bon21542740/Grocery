SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `grocery`
--

-- --------------------------------------------------------

--
-- Table structure for table `ORDERS`
--

CREATE TABLE `ORDERS` (
  `id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `store_id` int DEFAULT NULL,
  `date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ORDER_ITEMS`
--

CREATE TABLE `ORDER_ITEMS` (
  `id` int NOT NULL,
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `PRODUCTS`
--

CREATE TABLE `PRODUCTS` (
  `id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `availability` tinyint(1) DEFAULT NULL,
  `expiration_date` date DEFAULT NULL,
  `store_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `RATINGS`
--

CREATE TABLE `RATINGS` (
  `id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `store_id` int DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `comment` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `STORES`
--

CREATE TABLE `STORES` (
  `id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `STORES`
--

INSERT INTO `STORES` (`id`, `name`, `location`) VALUES
(1, 'ABC Grocery', 'New York'),
(2, 'XYZ Supermarket', 'Los Angeles'),
(3, 'PQR Convenience Store', 'Chicago');

-- --------------------------------------------------------

--
-- Table structure for table `USERS`
--

CREATE TABLE `USERS` (
  `id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `role` enum('customer','store owner') COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `USERS`
--

INSERT INTO `USERS` (`id`, `name`, `email`, `password`, `role`) VALUES
(1, 'John Doe', 'johndoe@example.com', 'password', 'customer'),
(2, 'Jane Doe', 'janedoe@example.com', 'password', 'store owner'),
(3, 'Bob Smith', 'bobsmith@example.com', 'password', 'customer'),
(4, 'Alice Jones', 'alicejones@example.com', 'password', 'store owner');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ORDERS`
--
ALTER TABLE `ORDERS`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `store_id` (`store_id`);

--
-- Indexes for table `ORDER_ITEMS`
--
ALTER TABLE `ORDER_ITEMS`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `PRODUCTS`
--
ALTER TABLE `PRODUCTS`
  ADD PRIMARY KEY (`id`),
  ADD KEY `store_id` (`store_id`);

--
-- Indexes for table `RATINGS`
--
ALTER TABLE `RATINGS`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `store_id` (`store_id`);

--
-- Indexes for table `STORES`
--
ALTER TABLE `STORES`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `USERS`
--
ALTER TABLE `USERS`
  ADD PRIMARY KEY (`id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ORDERS`
--
ALTER TABLE `ORDERS`
  ADD CONSTRAINT `ORDERS_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `USERS` (`id`),
  ADD CONSTRAINT `ORDERS_ibfk_2` FOREIGN KEY (`store_id`) REFERENCES `STORES` (`id`);

--
-- Constraints for table `ORDER_ITEMS`
--
ALTER TABLE `ORDER_ITEMS`
  ADD CONSTRAINT `ORDER_ITEMS_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `ORDERS` (`id`),
  ADD CONSTRAINT `ORDER_ITEMS_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `PRODUCTS` (`id`);

--
-- Constraints for table `PRODUCTS`
--
ALTER TABLE `PRODUCTS`
  ADD CONSTRAINT `PRODUCTS_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `STORES` (`id`);

--
-- Constraints for table `RATINGS`
--
ALTER TABLE `RATINGS`
  ADD CONSTRAINT `RATINGS_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `USERS` (`id`),
  ADD CONSTRAINT `RATINGS_ibfk_2` FOREIGN KEY (`store_id`) REFERENCES `STORES` (`id`);
COMMIT;
