-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2025-11-03 19:59:03
-- 服务器版本： 8.0.36
-- PHP 版本： 8.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `foadmin`
--

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_audit_log`
--

CREATE TABLE `foadmin_audit_log` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `trace_id` varchar(64) NOT NULL COMMENT '请求关联ID（串联同一请求）',
  `level` enum('SECURITY','BUSINESS','SYSTEM') NOT NULL COMMENT '日志级别：安全/业务/系统',
  `actor_id` bigint DEFAULT NULL COMMENT '操作者用户ID（匿名为空）',
  `actor_name` varchar(128) DEFAULT NULL COMMENT '操作者姓名快照',
  `actor_roles` json DEFAULT NULL COMMENT '操作者角色快照（JSON）',
  `ip` varchar(64) DEFAULT NULL COMMENT '来源IP',
  `user_agent` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '浏览器或客户端UA',
  `method` varchar(16) DEFAULT NULL COMMENT 'HTTP方法：GET/POST/PUT/DELETE等',
  `path` varchar(255) DEFAULT NULL COMMENT '请求路径',
  `action` varchar(64) NOT NULL COMMENT '动作：create/update/delete/approve/login等',
  `resource_type` varchar(64) NOT NULL COMMENT '资源类型：user/role/media/order等',
  `resource_id` varchar(64) DEFAULT NULL COMMENT '资源ID（字符串，兼容多种主键）',
  `status` enum('SUCCESS','FAIL') NOT NULL COMMENT '执行结果：成功/失败',
  `http_status` int DEFAULT NULL COMMENT 'HTTP状态码（若有）',
  `latency_ms` int DEFAULT NULL COMMENT '耗时(毫秒)',
  `message` varchar(512) DEFAULT NULL COMMENT '简要说明或错误信息',
  `diff_before` json DEFAULT NULL COMMENT '变更前快照（JSON）',
  `diff_after` json DEFAULT NULL COMMENT '变更后快照（JSON）',
  `extra` json DEFAULT NULL COMMENT '附加上下文（JSON）',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='操作/审计日志';

--
-- 转存表中的数据 `foadmin_audit_log`
--

INSERT INTO `foadmin_audit_log` (`id`, `trace_id`, `level`, `actor_id`, `actor_name`, `actor_roles`, `ip`, `user_agent`, `method`, `path`, `action`, `resource_type`, `resource_id`, `status`, `http_status`, `latency_ms`, `message`, `diff_before`, `diff_after`, `extra`, `created_at`) VALUES
(433, '21e60d42e61b4d40ad23815979694774', 'BUSINESS', 1, 'admin', '[\"admin\"]', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/audit/logs', 'operate', 'system', NULL, 'SUCCESS', 200, 17, NULL, NULL, NULL, NULL, '2025-10-08 08:56:43'),
(434, '00079342f38b4d248b63e66e513b0876', 'BUSINESS', NULL, NULL, 'null', '139.162.119.196', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-08 09:36:00'),
(435, '198f0f6348534905a4f1a8c60ac2badb', 'BUSINESS', NULL, NULL, 'null', '139.162.119.196', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-08 09:36:00'),
(436, '662846a336ad4215b086a737fff5af0e', 'BUSINESS', NULL, NULL, 'null', '61.142.42.201', 'Mozilla/5.0(WindowsNT10.0;Win64;x64)AppleWebKit/537.36(KHTML,likeGecko)Chrome/86.0.4240.111Safari/537.36', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-08 12:08:54'),
(437, 'e82081c7cf2a48989b7bd02ffb5373bd', 'BUSINESS', NULL, NULL, 'null', '61.142.42.201', 'Mozilla/5.0(WindowsNT10.0;Win64;x64)AppleWebKit/537.36(KHTML,likeGecko)Chrome/86.0.4240.111Safari/537.36', 'POST', '/sdk', 'operate', 'system', NULL, 'SUCCESS', 404, 2, NULL, NULL, NULL, NULL, '2025-10-08 12:08:54'),
(438, '290672d8399b4a4d8716dad9d8a4f64b', 'BUSINESS', NULL, NULL, 'null', '60.191.125.35', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-08 18:09:22'),
(439, 'ef719f83c98b4d93a68b308f136e3b00', 'BUSINESS', NULL, NULL, 'null', '43.247.4.40', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-09 04:59:39'),
(440, '6627f9fd53af4195b42d1dc24c2baa48', 'BUSINESS', NULL, NULL, 'null', '172.234.231.111', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-09 17:10:30'),
(441, 'edcc3b8aa2a4413e826d7bc411d410d0', 'BUSINESS', NULL, NULL, 'null', '172.234.231.111', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-09 17:10:32'),
(442, '0bb78a169e7e4ea7b1f5d0cc932d50c6', 'BUSINESS', NULL, NULL, 'null', '172.234.231.111', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'PROPFIND', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-09 17:11:19'),
(443, 'ad0c78cb25ea4438a3d68aa32d7d0651', 'BUSINESS', NULL, NULL, 'null', '172.234.231.111', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-09 17:12:11'),
(444, '3e5778e8601a4fff8583803af174be48', 'BUSINESS', NULL, NULL, 'null', '172.234.231.111', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-09 17:12:49'),
(445, '0b88d6b1eb594ce896f260a530b021a3', 'BUSINESS', NULL, NULL, 'null', '172.234.231.111', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-09 17:12:50'),
(446, '8fea1e7756c44411b98abe15085013d4', 'BUSINESS', NULL, NULL, 'null', '172.234.231.111', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-09 17:12:50'),
(447, 'c6b10e567c7043ef938c9b980fd63e1d', 'BUSINESS', NULL, NULL, 'null', '172.234.231.111', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-09 17:12:51'),
(448, '404504256c2f4a3f80b1ee4766dee5cd', 'BUSINESS', NULL, NULL, 'null', '43.247.4.40', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-09 23:13:09'),
(449, '3970f4f7361b4f44948798c47b9c7f76', 'BUSINESS', NULL, NULL, 'null', '139.162.119.196', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-10 05:21:25'),
(450, 'db79c60d33814dc4a2b15442b3c161d3', 'BUSINESS', NULL, NULL, 'null', '139.162.119.196', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-10 05:21:25'),
(451, '2594b5748cb44025b330f7f350006e5b', 'BUSINESS', NULL, NULL, 'null', '47.99.62.117', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'POST', '/sdk', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-10 23:15:25'),
(452, '6fbe80bc30644b83935203ace2c7bb67', 'BUSINESS', NULL, NULL, 'null', '27.43.207.120', 'Hello, World', 'POST', '/GponForm/diag_Form', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-11 13:00:32'),
(453, '155b09daecdd4370a83ccd7f22f5ccfe', 'BUSINESS', NULL, NULL, 'null', '111.33.154.219', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-11 14:52:40'),
(454, '41ad52f2d61c484ab789515f31770d81', 'BUSINESS', NULL, NULL, 'null', '79.124.40.174', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', 'POST', '/Autodiscover/Autodiscover.xml', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-11 14:54:09'),
(455, 'f4521f7952714ae389a6fb701e76437e', 'BUSINESS', NULL, NULL, 'null', '111.33.154.219', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-11 15:19:51'),
(456, 'a95fcd763ed6415fbc5ba2fe1edd7a01', 'BUSINESS', NULL, NULL, 'null', '217.154.83.80', 'Mozilla/5.0 (X11; Linux x86_64; rv:101.0) Gecko/20100101 Firefox/101.0', 'POST', '/cgi-bin/luci/;stok=/locale', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-11 20:37:26'),
(457, '474be36476fb43b18b8071214b1770d7', 'BUSINESS', NULL, NULL, 'null', '122.231.191.3', 'Mozilla/5.0(WindowsNT10.0;Win64;x64)AppleWebKit/537.36(KHTML,likeGecko)Chrome/86.0.4240.111Safari/537.36', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-12 07:51:34'),
(458, 'a171883e3aac4f55b436f977a40b9fb3', 'BUSINESS', NULL, NULL, 'null', '36.255.18.61', 'Hello, World', 'POST', '/GponForm/diag_Form', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-12 14:45:11'),
(459, '49dca86aa7b64da68ffb2a3128a57bd8', 'BUSINESS', NULL, NULL, 'null', '46.17.249.206', 'Hello, World', 'POST', '/GponForm/diag_Form', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-12 15:56:07'),
(460, '227eb63fd5184af8b50ee511fa1427bc', 'BUSINESS', NULL, NULL, 'null', '43.247.4.40', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-12 17:16:04'),
(461, 'ffad0101ad504666be36f753ba85380b', 'BUSINESS', NULL, NULL, 'null', '221.238.131.250', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-12 18:14:04'),
(462, '21f59bf560b54005a3518f1fa5658f02', 'BUSINESS', NULL, NULL, 'null', '221.238.131.250', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-12 18:59:45'),
(463, '19d6503cf7354530ba8396b6423fe2d7', 'BUSINESS', NULL, NULL, 'null', '111.33.154.219', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-12 19:02:59'),
(464, '7481bc4b0d7346eda6a59dc4b7aa98b6', 'BUSINESS', NULL, NULL, 'null', '111.33.154.219', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-12 19:34:08'),
(465, '75a80d44432641958dd7dfa69e902a9c', 'BUSINESS', NULL, NULL, 'null', '111.33.154.219', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 06:03:08'),
(466, '7a94598dd7424301b4baf8a49d8aaf7b', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:47:18'),
(467, '760575d5c9d64a06ac1f5edca629a24e', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:47:28'),
(468, 'ce6810773c7e4a53877f6968f10323c9', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:47:33'),
(469, '8d29b846285f4c099ae5a86b153aa2d6', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:47:39'),
(470, '932f856a3c1a48a287ca4a0ad0bb484c', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:47:39'),
(471, '93e50f10404b4be8a81b959cfb6e242f', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:47:39'),
(472, '8af0063741234997ac2ce606947f6259', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:47:39'),
(473, 'cd95040d001c4fc8831e3ed906d82f94', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:47:44'),
(474, '6261bb88e82e49498068a7032e7ce2a1', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:47:55'),
(475, '88b0ab7b866042cd90f10a7ed14df28d', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:48:48'),
(476, 'febd4d102fad49d4a1ae48f58ddba2b0', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:48:48'),
(477, '6b6d5b915ab34bcdb1293143631181c7', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:48:54'),
(478, '7409c338ce1042279dc652eef46720e5', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:48:54'),
(479, 'cd4c8da80d8b412ab76ecf8ce0c7e23c', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:48:54'),
(480, '17b9fce5e2f74d4f83145ce0e93206f1', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 2, NULL, NULL, NULL, NULL, '2025-10-13 12:48:54'),
(481, '45aee73eed004e58aeb6e0bcea18b58d', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 4, NULL, NULL, NULL, NULL, '2025-10-13 12:48:54'),
(482, '3909a3cfb71e40a7a0a5792addbbc562', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:48:54'),
(483, '1398e6efece146ce81d39330b3ef9710', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:48:59'),
(484, '04a1ca5932fd4bde831a0f525b83c8cb', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 4, NULL, NULL, NULL, NULL, '2025-10-13 12:48:59'),
(485, 'c383cd27a8dd400496d6daa9057d1af5', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:48:59'),
(486, '3ed0789322ae4afda7c46c5c896808fe', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:48:59'),
(487, '12da4c4b611e40c7b91dfbdb07fbf26f', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:48:59'),
(488, '3a0220bd175b49b1961006cd4576c003', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:48:59'),
(489, '7178a3e0ea264451aac4cdc599366cad', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:48:59'),
(490, 'a3a2d890b5294b5bb4dac4ecd6124486', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:48:59'),
(491, 'd9f0da24aac74afc82d92c02b94b4932', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 3, NULL, NULL, NULL, NULL, '2025-10-13 12:48:59'),
(492, '92ec546658fa419e98b348bc633905cf', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:48:59'),
(493, '8830675465084f86a5380c6dd698616f', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-13 12:49:04'),
(494, 'bb9cbbd618fa467aa6a0c2c459dedf28', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 4, NULL, NULL, NULL, NULL, '2025-10-13 12:49:04'),
(495, 'a0d5880b17004340b478940f7e736259', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:04'),
(496, '874a5ea6558548d89c81ff05bd7612f9', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:04'),
(497, '6e0a83292aeb4eaab6f0c9bddfbb3921', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:04'),
(498, '0e2e659f2c30427d96d163c620b0062e', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:04'),
(499, '8c13aafd2bd542f29f1e6d22ee3d7c27', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 4, NULL, NULL, NULL, NULL, '2025-10-13 12:49:04'),
(500, 'f1ffbab9174941fbaa738bd5c55d5d0c', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:04'),
(501, 'b66479b9d9ac4831824da7c567457f57', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:04'),
(502, '376bc37105b34ec995183f2814d7535b', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:04'),
(503, '68235d6f3fcc4ccf894a1b56ffb39d60', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:04'),
(504, 'db4495a14eb34d8ab32de22ad6fdc31b', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:09'),
(505, 'd8a6581acb38408d992a5f9f9bf6645c', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:09'),
(506, '6f36170c5ed547e49a646110963daeef', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:09'),
(507, '0f6a97a4ae014283b3afce6a226446ec', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:09'),
(508, '41ccb2aac34f46e2b35b84aaae2fd637', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:09'),
(509, '2a835c6d020c4a7e972294ab9832b0a3', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:09'),
(510, '2bd9c684c52e4a9286416c6edd46db81', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:09'),
(511, '08775dc5ada341a0a40de9e574459660', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:09'),
(512, '53d7efd7e8da4c78914c0f99e65dc961', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-13 12:49:09'),
(513, '00fc065e560348a699dace5077963f01', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 3, NULL, NULL, NULL, NULL, '2025-10-13 12:49:09'),
(514, 'dbe82e90f1524fb1941ae21c6efb754f', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:09'),
(515, 'd05e26b4490249d085db59270d9285a3', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:09'),
(516, '3ffca3fdeab44b4a9c013404e9704327', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:09'),
(517, '5d23537ac8374f99a1f875899a8287c2', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:14'),
(518, 'b696338f5af1490eba71e117550824ab', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:14'),
(519, '7ad211a60977415dbf5b9cabbb10e9a8', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:14'),
(520, '3766dea575144a45bc71a7a7fda36037', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:14'),
(521, '0e8a0fa5ab7f40f2b947dea2bf13cd54', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:14'),
(522, '2fbb5a78dd024238a5e41359d9047a72', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 4, NULL, NULL, NULL, NULL, '2025-10-13 12:49:14'),
(523, '5e86ee97bc2b439185e9a679424f8793', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:14'),
(524, 'ed54a42a6c9341ddbf1747ad94b0d256', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:14'),
(525, 'e1860ae2c42d43e49c5948692f6909c0', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:14'),
(526, 'c5db725d6bce4520bd7127d3764137ae', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:14'),
(527, '4c1a1547597e4e86aa3b8864fe17685d', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:19'),
(528, 'd48ec650211c4250bf99ba4e166e16c5', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:19'),
(529, '0159ab1f80ca438b931ea59d0458c67b', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:19'),
(530, '0331aa28644f41d4a71e4d9aab9d55c1', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:19'),
(531, '777ab520a9ff431b9f8828a9b4c70db4', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:19'),
(532, 'dcaafc5279e34f099c41c444c01507d6', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-13 12:49:20'),
(533, '65d3a3fb83cb49769cd90c0a714267f4', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:20'),
(534, '3fcfb26e438a4681990290691dbd57e7', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:20'),
(535, 'fe7e5da0ba4e48f1b6a2c9fc2961cab5', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:20'),
(536, '01eb3446ab0543558a01c39d5d95eff6', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:20'),
(537, '6211492a92da40389ae8efd3bfcf4937', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:20'),
(538, '7efdcc71036d4662bca5f7536b289ae0', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:25'),
(539, '9d113dd69fda4cbbad9bac82e134db66', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-13 12:49:25'),
(540, '717bdad426ab45c781bd2e20662b26a5', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 4, NULL, NULL, NULL, NULL, '2025-10-13 12:49:25'),
(541, 'd49786af783348e3b52ae9d7d4156e4d', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 7, NULL, NULL, NULL, NULL, '2025-10-13 12:49:25'),
(542, '549ad714f8834d298c789f43d8751857', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:25'),
(543, 'db9e32c5bd1e4e12b06edfc8860cf791', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:25'),
(544, 'b92ba8682d2f484491acc2977c9495b2', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:25'),
(545, '5e46aacf43a74e358da8be06229a0964', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:25'),
(546, 'af2f37e32aa140c0a2577c92807ac2a8', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:25'),
(547, 'aba7a94d48dc4d919e5b89f395c1de80', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:25'),
(548, '9b2f0bcdb78a4396977500ac6026d849', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:30'),
(549, '80213d416ae34154a4b7e11f93f34abf', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:30'),
(550, 'b548585b443a460bbadf009b435b62a9', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:30'),
(551, 'e023475527ea4ddea11016d70d02e7a0', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:30'),
(552, '830d98b29e184fdbbf5b0b88babc4bea', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:30'),
(553, '2c2c85c263094b6291e90209dd1939aa', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:30'),
(554, 'c9c803206a7d4c4188bb0d8bb4a7e739', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 3, NULL, NULL, NULL, NULL, '2025-10-13 12:49:30'),
(555, '95fef62b20fd4603a5583da0654ac171', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:30'),
(556, '485f8d6f1d0f44d58f20568def2f10e3', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:30'),
(557, 'ff6d04fffd1d451699126899625af7ca', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:30'),
(558, '98d23c903b58427a98dd7bcd0ddce5ce', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:35'),
(559, '9fcd739eb7f148a6bb64ae74abbe7109', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:35'),
(560, 'fdcf6d6aebbc485ca538e3e03b990773', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-13 12:49:35'),
(561, 'b795a04bb1fc4006aff479a684e196b8', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 4, NULL, NULL, NULL, NULL, '2025-10-13 12:49:35'),
(562, 'dc7ee67336ec422994c8be48f86c26b3', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 7, NULL, NULL, NULL, NULL, '2025-10-13 12:49:35'),
(563, 'e1b6aa05589c4b24a8ebda8c86daed10', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-13 12:49:35'),
(564, '00eb37d9b3e447899bfbf6640f85e3df', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 4, NULL, NULL, NULL, NULL, '2025-10-13 12:49:35'),
(565, '622aafaf387043adaa106124379760ec', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-13 12:49:35'),
(566, '196ed2beefab4d669322b29a67e6a658', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 3, NULL, NULL, NULL, NULL, '2025-10-13 12:49:35'),
(567, 'cbab1cef9d2e42ceac82888d4b5dcde1', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:35'),
(568, '2df0578b8cf84721a86346a6c9296c30', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:35'),
(569, 'a0ac20454a264f779d437f421f2a1c18', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:35'),
(570, '81bd471725c741849cd2ad3fe1f562f8', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:35'),
(571, '3055e543f5c3436b9e6b8526e696209e', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:40'),
(572, '51fd27c6d29841989d2427c0906eb4b6', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:40'),
(573, 'b32eef877db14972b4a75691670ee005', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:40'),
(574, 'a54fcedb38394a66bd12d42f40686ab1', 'BUSINESS', NULL, NULL, 'null', '206.119.178.111', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 12:49:40'),
(575, 'b1a23d5f2f434124939083dfa574adcf', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:45'),
(576, 'a07dc37e68a54f7f8c069555aeb2abca', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//admin/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:45'),
(577, 'ed27b2f4b24545e4bff55bdcb948c024', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//api/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:45'),
(578, '71c7e6ddd14d4a81a71f85c0e1b3d49e', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//backup/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:45'),
(579, 'd420d4dc00b848eb8c606c1c77aac15e', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//blog/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:45'),
(580, 'eeea91ec1702480c87970c6068b4aa5a', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//cms/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:45'),
(581, '7edf7ba41bc54154bbf55ee8a913c5d5', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//demo/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:45'),
(582, '1f386648476e4b1bb1d04b67f876947e', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//dev/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:45'),
(583, '17b68e03b32549f38a11959ef7c95a66', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//laravel/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:45'),
(584, '008db07afd074e71ab2e11f982c6684d', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//lib/phpunit/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:45'),
(585, '41bd70927bbd4f1c91efbc4612a48c63', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//lib/phpunit/phpunit/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:46'),
(586, '0a0bd63d222747ca94e0b646877c437b', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//lib/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:46'),
(587, '7ad439d0b42749749841d22dc9aed201', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//lib/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:46'),
(588, 'c9f976d110e946688461707120047f16', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//new/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:46'),
(589, '2a437c98c9a6467fb220c7d2f0ece7e3', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//old/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:46'),
(590, '8e54643d5068421286e5e5a5a85eab9e', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//panel/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:46'),
(591, 'f4f276d45965430f97864168ade4e5e4', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//phpunit/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:46'),
(592, '6c7c9eb50a1a4ec1be0021dcb12719af', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//phpunit/phpunit/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:46'),
(593, 'b270d293f9d843a0a91aebba3652ad66', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:46'),
(594, '9a80ffba0b93462380d11ae7d85e2ea3', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:46'),
(595, 'acbfd8012b62480ab3a866b883b126f5', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//protected/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:46'),
(596, '1a93f26640c14daaa2733657540dbce9', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//sites/all/libraries/mailchimp/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:46'),
(597, '71dd261b7ef1423889d994a7d891004f', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//vendor/phpunit/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:47'),
(598, '182855b62ca8438d9f275ed95fb6047a', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//vendor/phpunit/phpunit/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:47'),
(599, '4c72c43e92344dbeac689b035d5c606b', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:47'),
(600, '74098aa656454adeb87f80156d36a996', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//vendor/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:47'),
(601, '9ac524f10b2346a8b1efc7798541c74f', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//wp-content/plugins/cloudflare/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:47'),
(602, '9547484685ca4cf9aeadced4758efef6', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//wp-content/plugins/dzs-videogallery/class_parts/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:47'),
(603, '66629da208234b54b400adb05fb4c6e0', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//wp-content/plugins/jekyll-exporter/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:47'),
(604, 'df8eca0fb2e74dcd9926acd81d8917f9', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//wp-content/plugins/mm-plugin/inc/vendors/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:47'),
(605, '1641236353a6481f9fb0d7ab55703e40', 'BUSINESS', NULL, NULL, 'null', '13.212.225.156', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4_0) AppleWebKit/535.10 (KHTML, like Gecko) Chrome/16.0.838.25 Safari/535.28', 'POST', '//www/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-13 15:35:47'),
(606, 'd8914fa28f1043feaa5a54448fcbd4f9', 'BUSINESS', NULL, NULL, 'null', '111.33.154.219', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-14 01:00:27'),
(607, '411063ae06c340cfb497656509d26585', 'BUSINESS', NULL, NULL, 'null', '139.162.119.196', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-14 05:33:15'),
(608, '75363ecd100e44b5bc9be6acccecdcf9', 'BUSINESS', NULL, NULL, 'null', '139.162.119.196', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-14 05:33:16'),
(609, '7ae807ec506a4338b5467a4de822b6ae', 'BUSINESS', NULL, NULL, 'null', '221.238.131.250', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-14 09:39:13'),
(610, '377e4556f89740c08d3c53b735933e33', 'BUSINESS', NULL, NULL, 'null', '124.131.191.122', 'Hello, World', 'POST', '/GponForm/diag_Form', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-14 12:03:39'),
(611, '0d7cc7b5f7ee4bdda7e1ada4abc670a9', 'BUSINESS', NULL, NULL, 'null', '139.162.3.141', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-14 18:39:03'),
(612, '21edc1fabf0348aa9df64fd0ae9d1d5a', 'BUSINESS', NULL, NULL, 'null', '139.162.3.141', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-14 18:39:03'),
(613, 'd31c1183257240d197d1365c1f42ccf2', 'BUSINESS', NULL, NULL, 'null', '43.247.4.40', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-14 22:55:44'),
(614, '9e9750dec1b74b658e86b5706fb70b27', 'BUSINESS', NULL, NULL, 'null', '111.33.154.219', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 00:15:50'),
(615, '79fd43c9bda7405789b1aba76d149fb5', 'BUSINESS', NULL, NULL, 'null', '58.212.123.7', 'Mozilla/5.0(WindowsNT10.0;Win64;x64)AppleWebKit/537.36(KHTML,likeGecko)Chrome/86.0.4240.111Safari/537.36', 'POST', '/sdk', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 06:53:04'),
(616, '76c203ad1d6c41cab49e83f2902b8df4', 'BUSINESS', NULL, NULL, 'null', '58.212.123.7', 'Mozilla/5.0(WindowsNT10.0;Win64;x64)AppleWebKit/537.36(KHTML,likeGecko)Chrome/86.0.4240.111Safari/537.36', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-15 06:53:04'),
(617, 'caf6f876b6d6433eb8dcfbaacf061679', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:12'),
(618, '12bc2a0417b0481ca185f8de02e7e659', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//admin/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:12'),
(619, 'f825499c729545a79064959e9eb2386c', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//api/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:12'),
(620, '68e21331619b49548b3cb9c23c1354cc', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//backup/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:12'),
(621, 'db3f59ecca754b0eb8e94ca29db21105', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//blog/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:12'),
(622, '57874889ae6e45d8ae8a7fe3b2a516f8', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//cms/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:12'),
(623, 'fd2e5130ce7e45e19fed203426b55907', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//demo/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:12'),
(624, '355e4a26940246ad8f1c1722f0eaf67a', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//dev/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:13'),
(625, '0e8436f9a30442969433e13e6268cbf0', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//laravel/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:13'),
(626, '5f364e71c45749bb848bacf9a40e4800', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//lib/phpunit/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:13'),
(627, '5d5e1256d19d43afbed833c5dba477e0', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//lib/phpunit/phpunit/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:13');
INSERT INTO `foadmin_audit_log` (`id`, `trace_id`, `level`, `actor_id`, `actor_name`, `actor_roles`, `ip`, `user_agent`, `method`, `path`, `action`, `resource_type`, `resource_id`, `status`, `http_status`, `latency_ms`, `message`, `diff_before`, `diff_after`, `extra`, `created_at`) VALUES
(628, '9178d9c7fa524d1f84645a9bace1b3b8', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//lib/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:13'),
(629, '4ee68a1330344879a746eb385cb013bd', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//lib/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:13'),
(630, 'd6e65031dca946ac9be29fd9ed3f432e', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//new/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:13'),
(631, 'b7438632f2994171971b9b9e209dc30f', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//old/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:14'),
(632, '8bb222e4651247a893028878c1ecbf90', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//panel/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:14'),
(633, 'db17142b7a1c477582e571257bf2b0e3', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//phpunit/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:14'),
(634, '09d2bb838cc44089987109cce50850b8', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//phpunit/phpunit/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:14'),
(635, '802a83a449da46eca9aeb4383e926248', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:14'),
(636, 'ddf19fb70c1541d8bac4f61820465ea8', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:14'),
(637, 'f7956386714e4b2697aafcdf0293b927', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//protected/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:14'),
(638, '330071f778bd4fa5b6902cf2178386f4', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//sites/all/libraries/mailchimp/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:15'),
(639, '8360a7a7d3db4e228f762e8c6398c643', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//vendor/phpunit/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:15'),
(640, '673b606df5c04904b60be12b3fcafe4e', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//vendor/phpunit/phpunit/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:15'),
(641, '449270aa6a014d639c88dce16c6da060', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:15'),
(642, '51c2aef868364f6a8beafe0aed4f13df', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//vendor/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:15'),
(643, '1ab0b16e217644eab2579bbe00c4833d', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//wp-content/plugins/cloudflare/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:15'),
(644, '591772d5f81049128d1d5240f2c90912', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//wp-content/plugins/dzs-videogallery/class_parts/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:15'),
(645, 'e2989a723d3b46bb95d9cfcb8b7d11fe', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//wp-content/plugins/jekyll-exporter/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:16'),
(646, '8487fa7bb2e34707b7b5e660b7375f5b', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//wp-content/plugins/mm-plugin/inc/vendors/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:16'),
(647, 'ec31d9286bd14e1bb8b1ee58480dfdb0', 'BUSINESS', NULL, NULL, 'null', '63.179.147.42', 'Mozilla/5.0 (Linux i386; X11) Gecko/20021202 Firefox/10.0', 'POST', '//www/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-15 19:11:16'),
(648, 'beb5c550337740c89b7dd8391681ff72', 'BUSINESS', NULL, NULL, 'null', '195.170.172.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-16 13:46:39'),
(649, '98e5d7f7e8f145b4825f2395833a8af3', 'BUSINESS', NULL, NULL, 'null', '195.170.172.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-16 13:46:40'),
(650, 'c8dbbf72089f4ed780ec5d2e9a8bbde9', 'BUSINESS', NULL, NULL, 'null', '195.170.172.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-16 13:46:50'),
(651, 'bbff7d942370450c91bddc955a875cd1', 'BUSINESS', NULL, NULL, 'null', '101.22.82.45', NULL, 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-16 19:26:23'),
(652, 'c5489028d3004c7f99a5923da83383c0', 'BUSINESS', NULL, NULL, 'null', '45.33.70.128', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-16 23:39:50'),
(653, 'cae487ad9ed64f378746c15b8afac74f', 'BUSINESS', NULL, NULL, 'null', '45.33.70.128', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-16 23:39:52'),
(654, 'da42e2593678437b99bd48509ae9cb11', 'BUSINESS', NULL, NULL, 'null', '45.33.70.128', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-16 23:41:04'),
(655, '301ba7b5c1ea4412bc8fc17cf7c7ad19', 'BUSINESS', NULL, NULL, 'null', '45.33.70.128', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-16 23:41:06'),
(656, '1c55d4d6a05341c6aad0ec1839ac0eaf', 'BUSINESS', NULL, NULL, 'null', '45.33.70.128', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-16 23:41:06'),
(657, '07a233da74ad410e82108882d49ec702', 'BUSINESS', NULL, NULL, 'null', '45.33.70.128', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-16 23:41:07'),
(658, '8240b1228d5346ed9c91936e91becac6', 'BUSINESS', NULL, NULL, 'null', '139.224.0.39', NULL, 'HEAD', '/pscc/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-17 08:21:10'),
(659, '7c266394604242379f8aac3c0dc093f6', 'BUSINESS', NULL, NULL, 'null', '139.224.0.39', NULL, 'HEAD', '/start/index.html', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-17 08:21:10'),
(660, 'd40bac18689e4ad59d3a262453f62b6c', 'BUSINESS', NULL, NULL, 'null', '43.247.4.40', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-17 10:05:59'),
(661, '9eed5fbd3e714b7db4b136a481064a79', 'BUSINESS', NULL, NULL, 'null', '111.33.154.219', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-17 10:09:29'),
(662, 'aec24501668e4db9b2883054d8838572', 'BUSINESS', NULL, NULL, 'null', '111.33.154.219', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-17 10:13:16'),
(663, '05627b4eddd24cf1998af60abf506ce8', 'BUSINESS', NULL, NULL, 'null', '221.238.131.250', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-17 10:43:09'),
(664, 'c734c3100610499cbb092244e5885aaa', 'BUSINESS', NULL, NULL, 'null', '139.162.3.144', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-17 23:17:23'),
(665, '5905e16022994952b283e84e7276886c', 'BUSINESS', NULL, NULL, 'null', '139.162.3.144', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-17 23:17:23'),
(666, 'b001042637444b7294515759b9643b35', 'BUSINESS', NULL, NULL, 'null', '121.199.161.218', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'POST', '/sdk', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-17 23:35:31'),
(667, 'd03035d8c1c340c8b7031ed37845c86e', 'BUSINESS', NULL, NULL, 'null', '121.199.172.223', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'POST', '/sdk', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-17 23:51:13'),
(668, 'a6d387233986430c8b66de91bb783f3f', 'BUSINESS', NULL, NULL, 'null', '139.162.3.144', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-18 13:38:44'),
(669, '1d171bcebb9a40de8bf6b6eb7adfa48c', 'BUSINESS', NULL, NULL, 'null', '139.162.3.144', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-18 13:38:44'),
(670, 'a31fcb3fae4e44f0be220e1b320df1ce', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 200, 94, NULL, NULL, NULL, NULL, '2025-10-19 15:20:00'),
(671, '030237262fac47cabac7e73470d8aee9', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/common/profile', 'operate', 'system', NULL, 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-19 15:20:04'),
(672, '91f6a30c20904e67bd7d245435f9293d', 'BUSINESS', NULL, NULL, 'null', '176.65.149.157', 'Go-http-client/1.1', 'POST', '/goform/set_LimitClient_cfg', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-19 15:23:45'),
(673, '760c56ed69fd4eb7936c579bad59360d', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/common/profile', 'operate', 'system', NULL, 'SUCCESS', 200, 11, NULL, NULL, NULL, NULL, '2025-10-19 15:32:30'),
(674, '6f6b9340225246f0a0c32b51943873e4', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 200, 43, NULL, NULL, NULL, NULL, '2025-10-19 15:32:37'),
(675, '57a4536bf29b4bdbb42de4105a8bc463', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/common/profile', 'operate', 'system', NULL, 'SUCCESS', 200, 7, NULL, NULL, NULL, NULL, '2025-10-19 15:32:38'),
(676, '28ed4c128b6d4024a39fd992a36924db', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/media/1', 'operate', 'system', NULL, 'SUCCESS', 200, 9, NULL, NULL, NULL, NULL, '2025-10-19 15:33:56'),
(677, '4c05eb7f86f74187bc971a34d86b6f49', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/common/profile', 'operate', 'system', NULL, 'SUCCESS', 200, 4, NULL, NULL, NULL, NULL, '2025-10-19 15:34:32'),
(678, 'ec708b2223644be98a05e185fb70f016', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 17, NULL, NULL, NULL, NULL, '2025-10-20 02:52:10'),
(679, '4cec19d92ebb4537878a19dd601781b5', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 12, NULL, NULL, NULL, NULL, '2025-10-20 02:52:16'),
(680, 'a5a82b3de8e443e09539063b1c5a0298', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 200, 59, NULL, NULL, NULL, NULL, '2025-10-20 03:18:50'),
(681, 'fbbf27512527473d87e5be492d6c65a1', 'BUSINESS', NULL, NULL, 'null', '139.162.3.141', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-20 03:26:34'),
(682, 'a2831d17d74e45f482b1e84b219da6ff', 'BUSINESS', NULL, NULL, 'null', '139.162.3.141', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-20 03:26:35'),
(683, '44c04b8ca2ca4422b4ee2b56e3811747', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 16, NULL, NULL, NULL, NULL, '2025-10-20 03:42:28'),
(684, '812f16ee115644f0ad14c308e459ed52', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/common/profile', 'operate', 'system', NULL, 'SUCCESS', 200, 7, NULL, NULL, NULL, NULL, '2025-10-20 05:37:28'),
(685, 'cd94e47e989c4c0db7b75ee71d9b72a0', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/common/profile', 'operate', 'system', NULL, 'SUCCESS', 200, 14, NULL, NULL, NULL, NULL, '2025-10-20 05:43:12'),
(686, '64b65150a7d84cf3b193703a1ae220e8', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/common/profile', 'operate', 'system', NULL, 'SUCCESS', 200, 9, NULL, NULL, NULL, NULL, '2025-10-20 05:43:22'),
(687, '24103e4a5bcf4d57b7c34eb574965651', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/convert/pdf', 'operate', 'system', NULL, 'SUCCESS', 200, 174, NULL, NULL, NULL, NULL, '2025-10-20 05:43:42'),
(688, '52715c567cfc4275be9bb87349802884', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 200, 67, NULL, NULL, NULL, NULL, '2025-10-20 05:44:06'),
(689, '9293c43876284c84968c0c81e0c8bb2a', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/media/4', 'operate', 'system', NULL, 'SUCCESS', 200, 36, NULL, NULL, NULL, NULL, '2025-10-20 05:48:41'),
(690, 'bf745029656b4bb5b29f997e3c4bc1e6', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/media/5', 'operate', 'system', NULL, 'SUCCESS', 200, 15, NULL, NULL, NULL, NULL, '2025-10-20 05:48:53'),
(691, 'dc11b1af799d4a0780ee2267b5b13a20', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/media/3', 'operate', 'system', NULL, 'SUCCESS', 200, 15, NULL, NULL, NULL, NULL, '2025-10-20 05:49:25'),
(692, 'c709f6fbca894b0bb835e3cb9649c53a', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 14, NULL, NULL, NULL, NULL, '2025-10-20 05:50:58'),
(693, 'd03da1df13c0488a815241db58a98c66', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 400, 47, NULL, NULL, NULL, NULL, '2025-10-20 06:06:58'),
(694, 'a6103b9cdb434160a6b84dd3c09ce854', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 16, NULL, NULL, NULL, NULL, '2025-10-20 06:07:13'),
(695, '664319d351fa45bcad5d14cc59e488b6', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 400, 40, NULL, NULL, NULL, NULL, '2025-10-20 06:07:22'),
(696, 'c14dbccd6fb246dda372feba6b996196', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 400, 39, NULL, NULL, NULL, NULL, '2025-10-20 06:07:32'),
(697, 'e6ea80761cc543519e8733ae13992c9b', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 7, NULL, NULL, NULL, NULL, '2025-10-20 06:07:41'),
(698, '8d2ed5b73e5a4bc4b0a4874f81f8dbe4', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 400, 36, NULL, NULL, NULL, NULL, '2025-10-20 06:07:48'),
(699, '07274a975a524ad495f1d9782dbae879', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 200, 91, NULL, NULL, NULL, NULL, '2025-10-20 06:08:05'),
(700, '615298ffc5924164a69b7b192437b9b0', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/media/5', 'operate', 'system', NULL, 'SUCCESS', 200, 12, NULL, NULL, NULL, NULL, '2025-10-20 06:08:11'),
(701, '606dbb7fd25a41c18f673835d0b39d31', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 30, NULL, NULL, NULL, NULL, '2025-10-20 06:14:26'),
(702, '2084ac49ef804bd1b2b6ba53d0f9cd95', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 400, 45, NULL, NULL, NULL, NULL, '2025-10-20 06:14:32'),
(703, 'c2b64b65b5db4603882bd774cfbea004', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 10, NULL, NULL, NULL, NULL, '2025-10-20 06:14:41'),
(704, 'd482933b483543aba6b9a21f9f0d1fe0', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 400, 38, NULL, NULL, NULL, NULL, '2025-10-20 06:14:48'),
(705, 'bb5bb3adebd74cbc8fac4f1a9130d177', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 400, 35, NULL, NULL, NULL, NULL, '2025-10-20 06:14:54'),
(706, '1bbbf55d36924c6281ea833ec0f4b673', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 400, 37, NULL, NULL, NULL, NULL, '2025-10-20 06:15:08'),
(707, 'abeaeb40e1404174ad605de91c859846', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 26, NULL, NULL, NULL, NULL, '2025-10-20 06:17:19'),
(708, '423aeb9ff3d14919a492a424357490aa', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 200, 70, NULL, NULL, NULL, NULL, '2025-10-20 06:17:25'),
(709, 'bb09f8b71ac5434d9068be8e53134f4d', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/media/5', 'operate', 'system', NULL, 'SUCCESS', 200, 12, NULL, NULL, NULL, NULL, '2025-10-20 06:17:29'),
(710, 'f5196f7326f84947a9aa5cfbaaa4da58', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 11, NULL, NULL, NULL, NULL, '2025-10-20 06:17:35'),
(711, '519a8927874e497590de1b2976a10cff', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 400, 42, NULL, NULL, NULL, NULL, '2025-10-20 06:17:39'),
(712, 'c8554cd928954eafa3e1d6a5bc2a1354', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 18, NULL, NULL, NULL, NULL, '2025-10-20 06:55:22'),
(713, 'a8efe52e5771427385f7b2ebe2221da0', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/admin/system/config/15', 'operate', 'system', NULL, 'SUCCESS', 200, 11, NULL, NULL, NULL, NULL, '2025-10-20 06:58:54'),
(714, 'c62fd488f78046a69a4a177c027d4d24', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 13, NULL, NULL, NULL, NULL, '2025-10-20 07:00:07'),
(715, 'c97b01aebd574a24b7a9b64ed3b96136', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 13, NULL, NULL, NULL, NULL, '2025-10-20 07:07:07'),
(716, '11481e8211474af0be23f54824f7ee25', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 13, NULL, NULL, NULL, NULL, '2025-10-20 07:07:45'),
(717, '4e6e08dfa5cd4f1ca61701df4ccb7fd6', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 13, NULL, NULL, NULL, NULL, '2025-10-20 07:09:52'),
(718, '3ff5c49cb5244c6798aa1d141375cfae', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 14, NULL, NULL, NULL, NULL, '2025-10-20 07:10:09'),
(719, '13c81db86ee844f788ebb63025ce659e', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 14, NULL, NULL, NULL, NULL, '2025-10-20 07:12:42'),
(720, '9133209fdb7143f897e50eee519676f1', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/common/profile', 'operate', 'system', NULL, 'SUCCESS', 400, 295, NULL, NULL, NULL, NULL, '2025-10-20 07:12:54'),
(721, 'd0c69329ec4447e98837a96852c06431', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/common/profile', 'operate', 'system', NULL, 'SUCCESS', 200, 316, NULL, NULL, NULL, NULL, '2025-10-20 07:13:09'),
(722, '4786572adfe44e5abca2046ec38eec3d', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/common/profile', 'operate', 'system', NULL, 'SUCCESS', 200, 42, NULL, NULL, NULL, NULL, '2025-10-20 07:13:17'),
(723, 'e4eb7178b41e4c18b4bcbef786377893', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/admin/system/users/2', 'operate', 'system', '2', 'SUCCESS', 200, 26, NULL, NULL, NULL, NULL, '2025-10-20 07:13:37'),
(724, '5f72ef19d7d24581a0a8a230ef2c86e7', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/common/profile', 'operate', 'system', NULL, 'SUCCESS', 400, 30, NULL, NULL, NULL, NULL, '2025-10-20 07:27:51'),
(725, 'a8df0f9fdb0d498386e1a0b39be82631', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 21, NULL, NULL, NULL, NULL, '2025-10-20 07:28:09'),
(726, 'c486dfbd14b14699be19ef0f3718c2c3', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/common/profile', 'operate', 'system', NULL, 'SUCCESS', 200, 44, NULL, NULL, NULL, NULL, '2025-10-20 07:28:56'),
(727, 'f364044d639e4de69943d417fae61900', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/common/profile', 'operate', 'system', NULL, 'SUCCESS', 200, 42, NULL, NULL, NULL, NULL, '2025-10-20 07:29:15'),
(728, '3c39b86d4e2645a3be108250bd94e327', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/admin/system/users/2', 'operate', 'system', '2', 'SUCCESS', 200, 32, NULL, NULL, NULL, NULL, '2025-10-20 07:30:48'),
(729, '40c38845820a43e0a2e98b59cb5da410', 'BUSINESS', NULL, NULL, 'null', '81.29.134.51', 'Mozilla/5.0 (Windows NT 6.1; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-20 11:03:37'),
(730, '349744b19cec468c8ab041e778ad57f9', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/admin/system/roles/1/perms', 'operate', 'system', '1', 'SUCCESS', 200, 15, NULL, NULL, NULL, NULL, '2025-10-20 15:48:13'),
(731, 'fa4d9212dada417f9d363d0c30807418', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 17, NULL, NULL, NULL, NULL, '2025-10-20 15:55:49'),
(732, '2a69281c8a9749478566f10043c93e11', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 12, NULL, NULL, NULL, NULL, '2025-10-20 15:56:19'),
(733, 'd4414f131f5145bb9892574f13b1830c', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 9, NULL, NULL, NULL, NULL, '2025-10-20 15:57:32'),
(734, 'fc474e21a7d6466ba5f7a494a7880c69', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-connection', 'operate', 'system', NULL, 'SUCCESS', 200, 141, NULL, NULL, NULL, NULL, '2025-10-20 16:08:01'),
(735, '27ea2275835e417d977746bc3dfb765e', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-connection', 'operate', 'system', NULL, 'SUCCESS', 200, 129, NULL, NULL, NULL, NULL, '2025-10-20 16:11:05'),
(736, '034b13bb34624609a3926d206c7ae5ee', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-send', 'operate', 'system', NULL, 'SUCCESS', 400, 134, NULL, NULL, NULL, NULL, '2025-10-20 16:11:30'),
(737, '437de008a0cf4ff9885c3561665c44b9', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-connection', 'operate', 'system', NULL, 'SUCCESS', 200, 138, NULL, NULL, NULL, NULL, '2025-10-20 16:13:15'),
(738, '989fb712494b43a9ae1cacd85890181b', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-connection', 'operate', 'system', NULL, 'SUCCESS', 200, 681, NULL, NULL, NULL, NULL, '2025-10-20 16:15:53'),
(739, 'f8e8fc14f2484effa43615e9663b5510', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-send', 'operate', 'system', NULL, 'SUCCESS', 400, 1095, NULL, NULL, NULL, NULL, '2025-10-20 16:16:07'),
(740, 'd7671acd2e404f40999145f5fcc13446', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-send', 'operate', 'system', NULL, 'SUCCESS', 400, 1036, NULL, NULL, NULL, NULL, '2025-10-20 16:16:39'),
(741, '6d4f10bd4d324a96aeea474a4f25fa48', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-send', 'operate', 'system', NULL, 'SUCCESS', 400, 1032, NULL, NULL, NULL, NULL, '2025-10-20 16:16:45'),
(742, 'd0f775f09fd64a4499873cc015b1f973', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-send', 'operate', 'system', NULL, 'SUCCESS', 400, 1039, NULL, NULL, NULL, NULL, '2025-10-20 16:18:58'),
(743, '460743990fbe4776803143eef274a027', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-connection', 'operate', 'system', NULL, 'SUCCESS', 200, 508, NULL, NULL, NULL, NULL, '2025-10-20 16:19:12'),
(744, 'f05840044d8944b79348d7a48532e9fb', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-send', 'operate', 'system', NULL, 'SUCCESS', 400, 931, NULL, NULL, NULL, NULL, '2025-10-20 16:19:37'),
(745, '50be6822301b4c8296188e4b925f8008', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 15, NULL, NULL, NULL, NULL, '2025-10-20 16:20:40'),
(746, 'fab6f45118cb42faaa1e287a9557d678', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 9, NULL, NULL, NULL, NULL, '2025-10-20 16:20:52'),
(747, 'e93e5bf9303c41599838995a743c18dd', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-connection', 'operate', 'system', NULL, 'SUCCESS', 200, 116, NULL, NULL, NULL, NULL, '2025-10-20 16:21:00'),
(748, '9d7581643892484b944ca9fa81a3846a', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 12, NULL, NULL, NULL, NULL, '2025-10-20 16:21:13'),
(749, 'f04b60fd34c943049613b6e02da784b0', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-connection', 'operate', 'system', NULL, 'SUCCESS', 200, 531, NULL, NULL, NULL, NULL, '2025-10-20 16:21:16'),
(750, 'a5d7ef72d8d6490b8fee07aa6347aedf', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-connection', 'operate', 'system', NULL, 'SUCCESS', 200, 529, NULL, NULL, NULL, NULL, '2025-10-20 16:23:05'),
(751, '80bdccc016fc4be09051d870924f6821', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-send', 'operate', 'system', NULL, 'SUCCESS', 400, 921, NULL, NULL, NULL, NULL, '2025-10-20 16:23:16'),
(752, 'db4b111a265d40bfb28b7c97cdbed571', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-connection', 'operate', 'system', NULL, 'SUCCESS', 200, 422, NULL, NULL, NULL, NULL, '2025-10-20 16:24:32'),
(753, 'be4ed6ae483e4a939278127f54b32e5f', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/email/test-send', 'operate', 'system', NULL, 'SUCCESS', 200, 916, NULL, NULL, NULL, NULL, '2025-10-20 16:24:36'),
(754, '2745d62134e04f3e9f631191642029b4', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 20, NULL, NULL, NULL, NULL, '2025-10-20 18:07:36'),
(755, 'a6d1712b7b1145539d5764023afd864f', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 14, NULL, NULL, NULL, NULL, '2025-10-20 18:07:44'),
(756, 'af7ccdb03d2d4b8b8b8359ed47758ebf', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 18, NULL, NULL, NULL, NULL, '2025-10-20 18:08:57'),
(757, '8c44493350774c84bc15bc0f51a174fa', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 14, NULL, NULL, NULL, NULL, '2025-10-20 18:09:03'),
(758, 'fbb8aeab5f7d4b42ac9c1afe3f875d46', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/config/batch', 'operate', 'system', NULL, 'SUCCESS', 200, 12, NULL, NULL, NULL, NULL, '2025-10-20 18:11:16'),
(759, '10e0bec4ea444a50be4f0600d2203321', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 200, 63, NULL, NULL, NULL, NULL, '2025-10-21 06:27:18'),
(760, '7ff56c51c789460286b926e06b8822dd', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/media/6', 'operate', 'system', NULL, 'SUCCESS', 200, 11, NULL, NULL, NULL, NULL, '2025-10-21 06:28:07'),
(761, 'c2d52dfb6fa74a90b5e5dcf862925d65', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 200, 29, NULL, NULL, NULL, NULL, '2025-10-21 06:28:14'),
(762, '3b3244d2882f466ebe53f37ec0ea7613', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/media/6/permanent', 'operate', 'system', NULL, 'SUCCESS', 200, 16, NULL, NULL, NULL, NULL, '2025-10-21 06:28:35'),
(763, 'bb093c1e86c64b9c8b8d72d8902991aa', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:24'),
(764, 'fc8abbc903eb4794872109f795c8673a', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:25'),
(765, 'da781edc51324ca996f4f8e20a14615f', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:26'),
(766, '114f8e3e497b4102a1546ba62ff30721', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:26'),
(767, '386d41d8e15b45f6a43301964d552fbf', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:30'),
(768, 'edbbc9b78f08409ca07991d645b4d1ec', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:30'),
(769, 'd38f9cd0b8ad49c6886edc23c0428591', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:30'),
(770, '78fb7a79f671438890670be1f7fba5a7', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:30'),
(771, '33ec5e810f0d4ae0bde72f06c7a89c01', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:30'),
(772, 'e85a56af62bd4f498d96017a56982ed2', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:30'),
(773, 'a77ed223dbf24c3fbff85e2c44017a9a', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:31'),
(774, '78d3f8c24b054bec8b5f0e498ab412c3', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:31'),
(775, '111829d5cca34ae293ebf1d1895d9764', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:31'),
(776, '6a86f9defedd4ef1abdfa39730a22132', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:31'),
(777, 'f83afde6958149bbb895b1876e2f76e4', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:33'),
(778, '827e8a62b59c4cafbaa4bd4acf326d6d', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:33'),
(779, 'a81b2027f03c425ca221dc90560036b4', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:44'),
(780, '8c7086d4b4fc46b6a87d34678781a6fd', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:44'),
(781, '0c24ae06bf524063acbc7ca65ba684d3', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:44'),
(782, '73d6fb96925d49d3b66539d336b8d6ed', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:44'),
(783, 'e4eb5e844ffa401eb2d82c0847c5586d', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(784, '36f57331c36947f0a94faa48d6248caa', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(785, 'b0376d637d0047189e564accf0cba4cf', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(786, '43e7eb286c264e0f8d9efe5038a03fcb', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(787, '28ea036a53f643eea182a75ba7f2fe68', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(788, '64308fdc17d1452dbdecb60468bc570b', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(789, '103437d5b6ed4fe6850e9bef8fa7db7c', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(790, '5ebda2149d104e6aa5b4abc2de3b0129', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(791, 'd0ed0b77faf24fbabbdfe023e94e2ee6', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45');
INSERT INTO `foadmin_audit_log` (`id`, `trace_id`, `level`, `actor_id`, `actor_name`, `actor_roles`, `ip`, `user_agent`, `method`, `path`, `action`, `resource_type`, `resource_id`, `status`, `http_status`, `latency_ms`, `message`, `diff_before`, `diff_after`, `extra`, `created_at`) VALUES
(792, '91dc0fdaccdf47cdaccb5c5b06c89ce7', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(793, 'bee709e83811460681d7c053a5fa48f7', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(794, '890e634a71ce4f64968de75f42b784ec', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(795, '3dc6440f5e694687a40549b69bb6b7d9', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(796, 'b212e5c92f524218bba6d28c6e024659', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(797, 'c1fdc3963dbc4707851fd650adae213a', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(798, '24c9635c09a84aaa85e8a8818e68e1a2', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(799, '242d0550558b433db470cbe510f369cf', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(800, 'ab08b2ea647a4770b729a21e53b9c3c5', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 4, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(801, '9c588df7286442478112d868c5f45032', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(802, 'ac4627c4c0db4e418167bf71077c91ec', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(803, '28147b80409d42918cb548331e2bf1e0', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(804, '32396dbc9d0c4da49b5234662e33bb8a', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(805, 'e88fc0ff17f94f2d9632800edb3ca006', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:45'),
(806, '519427fe860e4281a91b65938bf77ebd', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(807, 'e0ad0f6fcf4f4246ba687fc7ddcdc373', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(808, '2203a5e0ce144567999c30d469ac137f', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(809, '6a12264524ba461c86220600591fd3d6', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(810, '62afbf94c25f4e59bdd7f85c9cb96aec', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(811, 'f80a7f1bb1754e50985edee7fe024b15', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(812, 'eeae3f02f95a4a4399f899bfcdbd5e0f', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(813, 'f5ca701936564a2ba2bf0cf9221ae67c', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(814, '15cf4f67f7684f18a9a89157b504d017', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(815, 'c26129527538482881f7063b937cffaf', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(816, 'b0f53e3c52d94f558d03546c1ea70e88', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(817, '07673cb547264fa6b1cb2dd61e46dad6', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(818, '0024f67a007e477d871729bbb117ad12', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(819, '6a6bf6a157724981bd487e0a8f9f1100', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(820, 'b04ddced6ac34753b135f1abce30a29e', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(821, '7cee56d359cc46b785c06144bf9d60c1', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(822, '65fdcfd17ebd491cb98bb17a3956d884', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(823, '120d5fbd58b0417f9ae481e6fb492b23', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(824, '4421b37eb1b545b18a3530e2b14f6adc', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 4, NULL, NULL, NULL, NULL, '2025-10-21 13:12:46'),
(825, '4a7cfa9579c94a0c9cbd9763a183b54c', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:47'),
(826, 'deadfd8be9974dfb968d416c27feb5f6', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:47'),
(827, '0867e815c8ac44d1b7977ca2b3178705', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:47'),
(828, 'b5f076ccdb4c4b4688d10ce237d7aaa2', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:47'),
(829, '1f3f41258002459ba18dfba3f416cfb8', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:47'),
(830, 'd04830829ba44951bc2a33898e7820b1', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:47'),
(831, '31ebed8f4adc4dfe80e7481790c138f8', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:47'),
(832, 'aedb2e2fe279451387f06d58a2ce4d6a', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:47'),
(833, '4a8c1a9256474cfdabde0f35fdddf490', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:47'),
(834, '9ea59c05b3f44a6c92f7c1c431b360fd', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:47'),
(835, '611cc836a0e149109e772f1ab1905099', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:47'),
(836, '930488aeec0f4e75a9604e93b0d73ab4', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:47'),
(837, 'bc83de07fde24792862b4fb8800cc32b', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:47'),
(838, '634585238afe4f46903dddc62f5798fd', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:47'),
(839, '925562e3616a4c7cbf3f60eda8570c7f', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-21 13:12:47'),
(840, 'a2e82a8cdf534a94908acd6f10f9bf59', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:48'),
(841, 'f949585819b642d8867ef6f04118196d', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:48'),
(842, 'b1abed0177184e4cab07ce5e6c85946d', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:48'),
(843, '93535095bd81463cae71b49ca27bae74', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:48'),
(844, 'dee5ffa9125a43318ee9e811514011b8', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:48'),
(845, '5b676115632a4160b28faf9922c61590', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:48'),
(846, '266464146d2b4cbdae859ddeda99fe82', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:48'),
(847, '817275a3bc4144719e59aaf33abb5848', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:48'),
(848, '4720b48e34e04d16b5b4d89d128e267c', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:48'),
(849, '69c0f590830448ae9016126dcd86dbcf', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(850, 'bb2cafa04885456881d7fb9a7160d407', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(851, '3bf9f41b954d460f9906c708e4f7a7ef', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(852, '9316b6864c0744768a73013ff960ec9e', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(853, 'efabbfa1ce27428093bbdadc24af7281', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(854, 'e3a51348528c4bee80b3a754c2a6578e', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(855, '045a275740634a23b3269c82a0d6f9d3', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(856, 'df03c8f3582f4e3cb59cf466a6a4459e', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(857, '399f54850e67418dbad620cf4fb7c930', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(858, 'e394172fc612408ea83143b5f0cc18c1', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(859, '1697022e1e794068b00392559f5c7583', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(860, '25b2f922336941ce8f7d9156fd0442ce', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(861, 'a5a762cfbc724724b18fd73647fbe498', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(862, '0907c88f54d141e6990d7d7877bdad80', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(863, '5dc41616422e439797abbbc23ca98b53', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(864, 'f690674475f24182917d85f9e45ea0a0', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(865, '5608debcd1ac4e7bbb24831a89cc8956', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(866, 'd49a75e2011648928d91a43e45393e29', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(867, '55bbfbb35ce9468895430dc824fd8c5b', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(868, '9f15ec4ba89a4de2b9600648c20feca7', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:49'),
(869, 'f869009faac348ba95212ee0c4ac3f55', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:50'),
(870, 'b94dfde15efc4d9ebea8d79ad46db111', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:50'),
(871, '0535960d2c6540ed9d3ca8c5c74556b9', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:50'),
(872, '8b05e20b570740edb8d9094751c9687a', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:50'),
(873, '1557a29073a443aaae21d0490e1f3388', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:50'),
(874, '0036158f3b984d4fbd1ab6285af9c972', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:50'),
(875, 'e33dd223e2d54e8180e28043de91a424', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:50'),
(876, 'f163da164ae247d0ab740d21cbb76015', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:50'),
(877, '9a77aab0f28248b2accdae73e825acbf', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:51'),
(878, '45c4dbb42ea4437481a4294139b24c69', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:51'),
(879, '39f66e54fcf44c36ab7b478671ca591c', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:51'),
(880, '365e16321cc44bfab20f24b47e7846e3', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:51'),
(881, '7a9ff488231649548fb6636038f66d59', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:51'),
(882, '81ad6b21cb1b4fecbf0f6414eb28acc0', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:51'),
(883, 'e272ff8c3e914761b793f316d5ae1e37', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:51'),
(884, 'e490a245288549cf91a99af23ff35f6a', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:51'),
(885, 'd60302c741d740e188d4e26160363be5', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:51'),
(886, '0f67e6d10ced46768417b577af7576a4', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:51'),
(887, 'ebdc8f140d994a7fab4c4ffe5f20938d', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:51'),
(888, 'b6a0f79e50b0459eb99c01a121312766', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:51'),
(889, '456eec29aa3c40dab14cb7a29d35b29f', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:51'),
(890, 'a3b073553bed4d75acc8522e464bd3bf', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:51'),
(891, '5ad846f1190b44bbbd65858f4be97abe', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:52'),
(892, 'b462afe2437042ffa2e39bffcf38d20d', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:52'),
(893, '609c5dba853840b2a28afb036f06d9b3', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:52'),
(894, 'a93d639efdc74a8c8f4896ecbc6ee132', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:52'),
(895, 'd19ecb6f490e41b2be48bf5c5e237c16', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:52'),
(896, '4f5ee2d2170444459ad2ef3f111b2fef', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:52'),
(897, 'b56f9201c0bc4c52a87519af0eea164e', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:52'),
(898, 'e65bf98864d349cab4998e1ecee19597', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:52'),
(899, '2a526d82c74b42dfacd5adfa50d905b1', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:52'),
(900, 'f6b566a8c0f542b088425ddb90a345ed', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:52'),
(901, 'aca63f572e574afd8ecdc5c0d14ed351', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:52'),
(902, '6db1bcc48761455e8663fa94e6f96386', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:53'),
(903, '3555ba2f6f3a409ab2100e8aac839eef', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:53'),
(904, '0e10954b083940d6926685f2b123b43c', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:53'),
(905, 'ba57d5f442b34179a6661e46f607e2e7', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:53'),
(906, '85c6fe29ef464d28a8710521f368d63f', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:53'),
(907, 'e7e1c53dae2041619c47730d75b8e0f9', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:53'),
(908, 'f587a75e84824d38af255e358d30e2b1', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:53'),
(909, '951ca2b1599a4859902b00913bed6a2b', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:54'),
(910, 'df0bbcc2a3cb46be92fc378b94c387bb', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:54'),
(911, '70a0629d5f8f486ebf55578a41b810cc', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:54'),
(912, '7c2c129530434faaaaa6db5b54b72c32', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:54'),
(913, '21fab5d0af57483aacb0ee25f9292d04', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:54'),
(914, 'dfd6f556e7764dfab23c0fadb723433c', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:54'),
(915, '67f5aa5d182a4af395ecc520fe2cc736', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:54'),
(916, '7ec342b482b840138fffe68abf69bb59', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:55'),
(917, 'a3520f9b4ac046f99f12ed499e49568a', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:55'),
(918, 'c88db46a60804165916a8109adc31132', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:55'),
(919, '6f3af836a8cd47ab83730f432fcc6f99', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:55'),
(920, '47df466bbe254ae792ce416e0284d627', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:55'),
(921, 'a5495b40026d4ee0a1e1267b59028b1b', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:55'),
(922, '57804fb028974c6fb03abffd99f3e6a4', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(923, '30dbb89a98234d7cbfda4220944e86c9', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(924, '9474dcd2d1a14348a95e65b2e21d360b', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(925, '15df2ec1c3184769a52442d1d188be6a', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(926, '870e286592b24ee2a175cb943b8b7df0', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(927, '4c7e41415e0046efbec133f35bbf193f', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(928, '9f2dc708ae1843159ad92e519711dee4', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(929, '24f2e6cb026240c78a1d0b10fdf2beb8', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(930, '61f97f6a07b44126b2ef58b3ab70b3c3', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(931, '8d7b81d0772440f88bfaddfff640c8ef', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(932, 'd3230f6b96274c4fa39a6cc0b75c35b9', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(933, '544eab93d58e45b9b77c30269f5c7d3a', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(934, '83e1594db1a64333b344326ba6daafb8', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(935, '8941f249352b4bfe9ee698470da0c61e', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(936, '2a624ce9acc744808adaddb24e40b2d5', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(937, '750b0bce8fef4fa9ba35a8ed19bbc374', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(938, 'd17d28e754624a03884b1f3d8ba24603', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:56'),
(939, 'e67bdfb5e79b4148ac046751bbacb907', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:57'),
(940, '1e58c47d73d746eb87833d21ef406762', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:57'),
(941, '33d2a702c3444d169430e62dc595533e', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:57'),
(942, '7b0a3bf750ce4c1fa8f42e9afa83e2c6', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:57'),
(943, '955e6a41a3f740d7813853f3f5570df6', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:57'),
(944, '0d6a8d5bfc234f9c9da522f2f5d1b9a2', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:57'),
(945, 'd25326e8f3844bfc8d63a802776b1b25', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:57'),
(946, 'b885926c4b964c73aacfdec6642fbe51', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:57'),
(947, 'fea46840cbca466eac8a1ac9c033dfad', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:57'),
(948, 'cbaae53f32724ce1adaf2d05ce6c6cb3', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:57'),
(949, '908688d6fe6f482c9aaed1cad2f79b37', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 2, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(950, 'c2c0bf6af8144a718e657ba89af8dd36', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 6, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(951, 'f3f76c9033f24f86872cc5a61743d8d9', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(952, 'e8d7dcb88b9148fab62830815a2b4519', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(953, 'b84370ea1a034376afe647fb2da8c488', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(954, 'f6598b7a1d6e43788ccba7055d74d492', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(955, '122c9105f9774bd5a313a07252388364', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 4, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(956, 'ac9b18c7fd4c471a96eecddc711ddf77', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(957, '286cc97fc65640c083735022f67eee5f', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(958, 'e79705499b664d07a61e4769caa06b97', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(959, '23fe9a3ed9b24902a5cda506a354f13b', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(960, '5a6ac19d6db54bb7b0f5260507e14ca7', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(961, 'a2efd470ad21499296538155997d6a20', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(962, 'ba3deeb3e3304b97bd49ff7b0a39e87a', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(963, 'e39f1a273c79400ea723aef8864caade', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(964, 'baa4c17610544ced9ff0492c9c61d007', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(965, 'd39c1b70663e45c180213b09a1b6a609', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(966, '0e207c203a314c07abc765db493a18ee', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:58'),
(967, '117a471a3b46402380781980b1602228', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:59'),
(968, '596eee96dec74e729a6a2b411805770d', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:59'),
(969, '23b9a6d5b67f4b3b8ed0b6326da77be1', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:59'),
(970, '8f19bcb891d0471592dc73e4f7d51ff6', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:59'),
(971, '5d95bae206ab4f7fbbad66c5c54b3091', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:59'),
(972, '951533024b4d4355a471b97592d78248', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:59'),
(973, 'abb934dc9f5c425397b45e27774939c4', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:59'),
(974, '72cd538d069e4dbca47457f54935b4f6', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:59'),
(975, '105de23fecf34608b45547ff1ed161fa', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:59'),
(976, '8ebe1aba56274b829c1342b9f2026964', 'BUSINESS', NULL, NULL, 'null', '8.138.159.84', 'Python-urllib/3.10', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-21 13:12:59'),
(977, '336dddaec9cd44e0a7ada64aac669f53', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/admin/system/roles/1/perms', 'operate', 'system', '1', 'SUCCESS', 200, 14, NULL, NULL, NULL, NULL, '2025-10-21 15:25:58'),
(978, '5bd21d8a9a0c49bd9e5adb2c6e3a8705', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1104', 'operate', 'system', '1104', 'SUCCESS', 200, 10, NULL, NULL, NULL, NULL, '2025-10-21 15:40:26'),
(979, '2e419d6c30084c8894c39158dca1835a', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1103', 'operate', 'system', '1103', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:40:28'),
(980, 'f60d3d72e54d4c8ea7645a85231f0f20', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1102', 'operate', 'system', '1102', 'SUCCESS', 200, 7, NULL, NULL, NULL, NULL, '2025-10-21 15:40:30'),
(981, '569dbd3ca4234d539d68fe988e30eaaf', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1101', 'operate', 'system', '1101', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:40:32'),
(982, '6b50d0a567c24a7384c297efbdd52eeb', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1100', 'operate', 'system', '1100', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:40:34'),
(983, '2500fa3d065b4e74978a79382fb7ee24', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1001', 'operate', 'system', '1001', 'SUCCESS', 200, 7, NULL, NULL, NULL, NULL, '2025-10-21 15:40:37'),
(984, '5b236f916d974d2d9c6b13ed8fe46a26', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1002', 'operate', 'system', '1002', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:40:40'),
(985, '9e3d59041bd742e1a871380c04d90a12', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1003', 'operate', 'system', '1003', 'SUCCESS', 200, 7, NULL, NULL, NULL, NULL, '2025-10-21 15:40:44'),
(986, '00296b19b7d1486cb99619bc0336365b', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1004', 'operate', 'system', '1004', 'SUCCESS', 200, 9, NULL, NULL, NULL, NULL, '2025-10-21 15:40:47'),
(987, 'a2f9e2ca1064497281b0957de50df054', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1200', 'operate', 'system', '1200', 'SUCCESS', 200, 7, NULL, NULL, NULL, NULL, '2025-10-21 15:40:56'),
(988, '08cbf14e52064cd0ad875434276a8d8d', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1302', 'operate', 'system', '1302', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:40:59'),
(989, 'f78cf4ecfb584d24a0c29c30e56211b1', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1301', 'operate', 'system', '1301', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:41:02'),
(990, '0e7f36aa93c7429ba58d72d471f8f6cc', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1300', 'operate', 'system', '1300', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:41:05'),
(991, '57ef335d6fcf4673bf73d9385f7f97c4', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1401', 'operate', 'system', '1401', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:41:09'),
(992, 'a5ef03104d544cc7b63446675f916116', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1400', 'operate', 'system', '1400', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:41:12'),
(993, '3109e766a8a048049456684b433e694e', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1502', 'operate', 'system', '1502', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:41:16'),
(994, '51268ac5d1d740b09ed778bb660d8a38', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1501', 'operate', 'system', '1501', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:41:19'),
(995, '8defc9b32a7941e7846f2002991a5770', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1500', 'operate', 'system', '1500', 'SUCCESS', 200, 7, NULL, NULL, NULL, NULL, '2025-10-21 15:41:22'),
(996, '704b47fe72574454a4b4d48c3c59b8ac', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1605', 'operate', 'system', '1605', 'SUCCESS', 200, 7, NULL, NULL, NULL, NULL, '2025-10-21 15:41:26'),
(997, '6374c6e1b1b7459f8e5b19944ec6d081', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1604', 'operate', 'system', '1604', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:41:29'),
(998, '685b4ad7836b4ed3bf21aa5c1a8d2f8d', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1603', 'operate', 'system', '1603', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:41:31'),
(999, 'a86a917a87964d9790ad12f92840e58c', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1602', 'operate', 'system', '1602', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:41:32'),
(1000, '28511b5408464c6781cdabd557f443ff', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1601', 'operate', 'system', '1601', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:41:35'),
(1001, 'b97e8b7cf53540db979bd694b368b8a5', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1600', 'operate', 'system', '1600', 'SUCCESS', 200, 7, NULL, NULL, NULL, NULL, '2025-10-21 15:41:37'),
(1002, '8174be83ad6f48c782b5260a51991d41', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1701', 'operate', 'system', '1701', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:41:42'),
(1003, '424a59b6b22c4ca7bdc227fcbf27902e', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1702', 'operate', 'system', '1702', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:41:45');
INSERT INTO `foadmin_audit_log` (`id`, `trace_id`, `level`, `actor_id`, `actor_name`, `actor_roles`, `ip`, `user_agent`, `method`, `path`, `action`, `resource_type`, `resource_id`, `status`, `http_status`, `latency_ms`, `message`, `diff_before`, `diff_after`, `extra`, `created_at`) VALUES
(1004, '69e165879d274c4a915af0a87c7f5994', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1801', 'operate', 'system', '1801', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:41:55'),
(1005, 'c812903243934a2eb2cb7dacf88f2d3a', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1802', 'operate', 'system', '1802', 'SUCCESS', 200, 7, NULL, NULL, NULL, NULL, '2025-10-21 15:41:58'),
(1006, '27e03573dfca4e61ac4dd7c43574db3f', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1803', 'operate', 'system', '1803', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:42:03'),
(1007, '457213f499124963a00d466ec7e6d3d3', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1804', 'operate', 'system', '1804', 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 15:42:06'),
(1008, '1a49e3bcdad0456a8980821f657de347', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1805', 'operate', 'system', '1805', 'SUCCESS', 200, 7, NULL, NULL, NULL, NULL, '2025-10-21 15:42:09'),
(1009, '89976054d60541d79bde283d9a385b75', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/perms/1006', 'operate', 'system', '1006', 'SUCCESS', 200, 7, NULL, NULL, NULL, NULL, '2025-10-21 15:42:15'),
(1010, '4f3091ae7a254de783f11d1191764db7', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/admin/system/roles/1/perms', 'operate', 'system', '1', 'SUCCESS', 200, 14, NULL, NULL, NULL, NULL, '2025-10-21 16:32:56'),
(1011, '61666ef120434937ac862318d747e06d', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/dict/data', 'operate', 'system', NULL, 'SUCCESS', 200, 80, NULL, NULL, NULL, NULL, '2025-10-21 16:37:05'),
(1012, '069db10fe3904a3bbc3774e63ec75dcd', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/dict/data/10', 'operate', 'system', NULL, 'SUCCESS', 200, 8, NULL, NULL, NULL, NULL, '2025-10-21 16:37:11'),
(1013, '57b06c8271bd4ab1b432bf6ed1340ddb', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/admin/system/roles/1/perms', 'operate', 'system', '1', 'SUCCESS', 200, 14, NULL, NULL, NULL, NULL, '2025-10-21 16:57:26'),
(1014, 'ed80eb923d8e472898e666faeab2da8f', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/admin/system/perms/3239', 'operate', 'system', '3239', 'SUCCESS', 200, 14, NULL, NULL, NULL, NULL, '2025-10-21 17:02:21'),
(1015, 'e5662c7d3aab4cb79026e1af43712c28', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/system/job/logs/clear', 'operate', 'system', NULL, 'SUCCESS', 200, 6, NULL, NULL, NULL, NULL, '2025-10-21 17:03:07'),
(1016, '5de4cf219c5a4317b62bdda0bf518aa9', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/4', 'operate', 'system', NULL, 'SUCCESS', 500, 7, NULL, NULL, NULL, NULL, '2025-10-21 17:03:34'),
(1017, 'ec57c5f587ae463ab5864bb524fe9e63', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/4', 'operate', 'system', NULL, 'SUCCESS', 500, 6, NULL, NULL, NULL, NULL, '2025-10-21 17:03:39'),
(1018, '36cc8ee054114cb3983953f68d768c9a', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/3', 'operate', 'system', NULL, 'SUCCESS', 500, 6, NULL, NULL, NULL, NULL, '2025-10-21 17:03:51'),
(1019, 'a308b13e312840f98f2f04d8c8c2be1f', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/admin/system/perms/3239', 'operate', 'system', '3239', 'SUCCESS', 200, 7, NULL, NULL, NULL, NULL, '2025-10-21 17:05:46'),
(1020, '22c9ead1c24e43be892212341f72a3e0', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/4', 'operate', 'system', NULL, 'SUCCESS', 500, 78, NULL, NULL, NULL, NULL, '2025-10-21 17:06:44'),
(1021, '02063aa4c6ad446ab24cddb324d2ce0c', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/2', 'operate', 'system', NULL, 'SUCCESS', 500, 6, NULL, NULL, NULL, NULL, '2025-10-21 17:06:52'),
(1022, 'ae2a6558567b4b8296eb100477cdfb2d', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/3', 'operate', 'system', NULL, 'SUCCESS', 500, 5, NULL, NULL, NULL, NULL, '2025-10-21 17:06:55'),
(1023, '7b7d93de453c42cfa7d09d1535960f40', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/1', 'operate', 'system', NULL, 'SUCCESS', 500, 6, NULL, NULL, NULL, NULL, '2025-10-21 17:07:05'),
(1024, '01d010c32f564e958f04a51e131af01a', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/4', 'operate', 'system', NULL, 'SUCCESS', 500, 5, NULL, NULL, NULL, NULL, '2025-10-21 17:08:36'),
(1025, '76eb9c4117404d95a50d782055ed37b8', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/4', 'operate', 'system', NULL, 'SUCCESS', 500, 17, NULL, NULL, NULL, NULL, '2025-10-21 17:14:32'),
(1026, 'a4ee1ae5278f4816b64f27f0ba7e45f8', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/4', 'operate', 'system', NULL, 'SUCCESS', 500, 16, NULL, NULL, NULL, NULL, '2025-10-21 17:17:13'),
(1027, '4082e0ff0097411b93017f9a42645c94', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/4', 'operate', 'system', NULL, 'SUCCESS', 500, 6, NULL, NULL, NULL, NULL, '2025-10-21 17:17:22'),
(1028, 'a2449cfdfb864e2391db34c8f73e7bf0', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/3', 'operate', 'system', NULL, 'SUCCESS', 500, 6, NULL, NULL, NULL, NULL, '2025-10-21 17:17:24'),
(1029, '0c5f64309fc94d18b716c1986079e899', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/2', 'operate', 'system', NULL, 'SUCCESS', 500, 6, NULL, NULL, NULL, NULL, '2025-10-21 17:17:25'),
(1030, 'fd810078a1d743028961ecc0967bc51a', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/1', 'operate', 'system', NULL, 'SUCCESS', 500, 10, NULL, NULL, NULL, NULL, '2025-10-21 17:17:26'),
(1031, '3ae95048aa0d40d0b2f677b599ae1b1c', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/4', 'operate', 'system', NULL, 'SUCCESS', 200, 15, NULL, NULL, NULL, NULL, '2025-10-21 17:20:00'),
(1032, 'a3163260c88b443189fde9b57548b8bc', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/system/job/run/1', 'operate', 'system', NULL, 'SUCCESS', 200, 12, NULL, NULL, NULL, NULL, '2025-10-21 17:20:19'),
(1033, '550eab5675944a7eb09cba27de02b638', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/admin/system/roles/1/perms', 'operate', 'system', '1', 'SUCCESS', 200, 14, NULL, NULL, NULL, NULL, '2025-10-21 17:31:11'),
(1034, '3ab9773ce378410bb8487471c6290a03', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'PUT', '/api/admin/system/dict/data/2', 'operate', 'system', NULL, 'SUCCESS', 200, 10, NULL, NULL, NULL, NULL, '2025-10-21 18:08:55'),
(1035, '605a9419ec8a4dbaa843db91b705602f', 'BUSINESS', NULL, NULL, 'null', '111.33.154.219', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-22 00:09:34'),
(1036, 'c5b33eacf6d541ab83efe52b71a536d2', 'BUSINESS', NULL, NULL, 'null', '219.139.136.2', 'Mozilla/5.0(WindowsNT10.0;Win64;x64)AppleWebKit/537.36(KHTML,likeGecko)Chrome/86.0.4240.111Safari/537.36', 'POST', '/sdk', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-22 15:24:09'),
(1037, 'e0c52e687efc431fb8d23c5211493317', 'BUSINESS', NULL, NULL, 'null', '219.139.136.2', 'Mozilla/5.0(WindowsNT10.0;Win64;x64)AppleWebKit/537.36(KHTML,likeGecko)Chrome/86.0.4240.111Safari/537.36', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-22 15:24:09'),
(1038, '5918b743b83d4fa6bdf50a625cad6b46', 'BUSINESS', NULL, NULL, 'null', '51.159.103.23', 'curl/7.81.0', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-23 07:08:30'),
(1039, '3bf5264b91f848a2ad5e60fe23501361', 'BUSINESS', NULL, NULL, 'null', '60.191.125.35', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-23 16:09:38'),
(1040, '85881905e8b04a4294c022710b7074e8', 'BUSINESS', NULL, NULL, 'null', '45.33.70.128', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-23 16:17:44'),
(1041, '118ba954c5314b54933aaed77f7e22c9', 'BUSINESS', NULL, NULL, 'null', '45.33.70.128', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-23 16:17:47'),
(1042, 'aa80f227e89d47a9be1ceb8aa32aa6af', 'BUSINESS', NULL, NULL, 'null', '45.33.70.128', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-23 16:19:47'),
(1043, '3b5d1fe7b8994dc39e46a29110a67106', 'BUSINESS', NULL, NULL, 'null', '45.33.70.128', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'PROPFIND', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-23 16:19:47'),
(1044, '338a144d3d534404aa18510d02d23fae', 'BUSINESS', NULL, NULL, 'null', '45.33.70.128', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-23 16:19:47'),
(1045, '9e5ccd40702e44e9bf2e716f130ae089', 'BUSINESS', NULL, NULL, 'null', '45.33.70.128', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-23 16:19:49'),
(1046, '2a6d7e3d277a490b92adc15b4fcc12c2', 'BUSINESS', NULL, NULL, 'null', '45.33.70.128', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-23 16:19:50'),
(1047, '71ea64403dd344188502c81f5df6d4d4', 'BUSINESS', NULL, NULL, 'null', '45.33.70.128', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-23 16:19:51'),
(1048, '7f31c8e8ad20493ba14eba058eea3f74', 'BUSINESS', NULL, NULL, 'null', '45.33.70.128', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'PROPFIND', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-23 16:20:08'),
(1049, '6b3974ff45a140a28e8cbdd25898c745', 'BUSINESS', NULL, NULL, 'null', '223.244.235.136', 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0', 'HEAD', '/invoker/EJBInvokerServlet', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-24 02:35:46'),
(1050, '9e2241e0a7d644b9bd895d16db3591e1', 'BUSINESS', NULL, NULL, 'null', '223.244.235.136', 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0', 'HEAD', '/jmx-console/HtmlAdaptor', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-24 02:35:49'),
(1051, '92c7fa8459d74d6585d608820bf74528', 'BUSINESS', NULL, NULL, 'null', '223.244.235.136', 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0', 'HEAD', '/invoker/JMXInvokerServlet', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-24 02:35:54'),
(1052, 'ca40369bdc874025bb10d4e9264cd4a9', 'BUSINESS', NULL, NULL, 'null', '223.244.235.136', 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0', 'HEAD', '/web-console/ServerInfo.jsp', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-24 02:35:58'),
(1053, '51a23a7ee2194982ac3df3445500ecf4', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 400, 7, NULL, NULL, NULL, NULL, '2025-10-24 05:43:59'),
(1054, 'a5668b90dbd1480c99a3904ebced4df8', 'BUSINESS', NULL, NULL, 'null', '18.229.255.49', 'Mozilla/5.0 (compatible; MSIE 6.0; Linux i386; .NET CLR 3.3.16098; X11)', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-24 07:49:15'),
(1055, '1d1fb4ce5a574e638a60ce4662b5a368', 'BUSINESS', NULL, NULL, 'null', '23.180.120.244', 'ip9max/1.0', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-24 09:01:19'),
(1056, 'a96302998269495bb6cbbb4cba2094dc', 'BUSINESS', NULL, NULL, 'null', '23.180.120.244', 'ip9max/1.0', 'HEAD', '/.well-known/security.txt', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-24 09:01:21'),
(1057, '70e623e702534f4982785f8c643b1748', 'BUSINESS', NULL, NULL, 'null', '23.180.120.244', 'ip9max/1.0', 'HEAD', '/robots.txt', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-24 09:01:23'),
(1058, '1c057ed55f5945c0a83188acea546561', 'BUSINESS', NULL, NULL, 'null', '23.180.120.244', 'Go-http-client/1.1', 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-24 09:01:23'),
(1059, '84d51eac828b4baa875ac1f8d459ab73', 'BUSINESS', NULL, NULL, 'null', '185.50.148.169', 'Hello, World', 'POST', '/GponForm/diag_Form', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-24 12:30:50'),
(1060, 'b674637bf63d4f02b8c8155a23478251', 'BUSINESS', NULL, NULL, 'null', '121.40.40.105', 'Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)', 'POST', '/sdk', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-25 01:26:14'),
(1061, 'febb972914134ae895d79118357eeb85', 'BUSINESS', NULL, NULL, 'null', '192.252.182.19', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-25 03:07:41'),
(1062, 'bd3d808979cb4d6da6c707a5a542463c', 'BUSINESS', NULL, NULL, 'null', '45.192.104.18', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-27 12:58:39'),
(1063, '6a372c56f7dc4cbeaec95774de381e61', 'BUSINESS', NULL, NULL, 'null', '45.192.104.18', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-27 13:14:49'),
(1064, '8f71b4b136ee4479b4761563f5684b43', 'BUSINESS', NULL, NULL, 'null', '154.82.111.22', 'Mozilla/5.0', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-28 16:10:25'),
(1065, 'c072fc40de0a43148cc334c94e75dbc6', 'BUSINESS', NULL, NULL, 'null', '54.36.144.237', NULL, 'POST', '/goform/set_LimitClient_cfg', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-28 17:13:37'),
(1066, '845ac793448e40e68ed7a1326c7bbd0e', 'BUSINESS', NULL, NULL, 'null', '139.162.3.141', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 00:27:57'),
(1067, '35220c14d9ed4fda805c8b657cb92dc2', 'BUSINESS', NULL, NULL, 'null', '139.162.3.141', NULL, 'OPTIONS', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 00:27:57'),
(1068, 'c5e17c3d3ce541429061db9a01f95f08', 'BUSINESS', NULL, NULL, 'null', '123.150.138.194', 'Mozilla/5.0(WindowsNT10.0;Win64;x64)AppleWebKit/537.36(KHTML,likeGecko)Chrome/86.0.4240.111Safari/537.36', 'POST', '/sdk', 'operate', 'system', NULL, 'SUCCESS', 404, 3, NULL, NULL, NULL, NULL, '2025-10-29 06:32:15'),
(1069, '0d4327b96b4944aa891aab17072e9ad0', 'BUSINESS', NULL, NULL, 'null', '123.150.138.194', 'Mozilla/5.0(WindowsNT10.0;Win64;x64)AppleWebKit/537.36(KHTML,likeGecko)Chrome/86.0.4240.111Safari/537.36', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 10, NULL, NULL, NULL, NULL, '2025-10-29 06:32:15'),
(1070, 'f7dbb139d3dd49bc848b35edc425802a', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-29 12:15:22'),
(1071, '0ef82b4b96524019b23e6745f25517b1', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:15:29'),
(1072, '2e9c7d55d621487d8846ea7ce5c5315f', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:15:35'),
(1073, '55bc5f2f84354555b49db7e0df06b461', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:15:45'),
(1074, '491a3e212c1040a1b1c78a93c2176f89', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:00'),
(1075, '7ea51ea1644e4cbcacb04be018762b31', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:01'),
(1076, 'b6892a4f318644ec9412083ce6394a88', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:01'),
(1077, '0ed0246f366945b0b937adc5d333c766', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:02'),
(1078, 'f2066c30df1b4151b7c0ba3a9a428c77', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:02'),
(1079, 'bc148462cbb244b3b9602e3e86af7d5b', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:12'),
(1080, '4d933d4a3ad640d489c9ac5bfbc9b595', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:36'),
(1081, '407c750f55b14f74bb8ea4019d679e5d', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:36'),
(1082, '2d87dba88aa34674bb41dd564a1085b3', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:47'),
(1083, '8ae816af1bd640e1a484d7f16c36a794', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:47'),
(1084, 'e2d7655331f24ff1b6a66641bac5fe2c', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:47'),
(1085, 'd4eb4ed2035d4fcd83a4c2934a7d15b3', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:47'),
(1086, 'e512b5f0f8ab4195b2ad6a128c3b0cb2', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:47'),
(1087, 'c8e4f00c8db647eaa6b19f45c2c91373', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:47'),
(1088, '79673f311cd24008a6539b6aef7239a6', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:47'),
(1089, '6129904866de4630bd483f3a22605d4a', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:47'),
(1090, '1e074e2f2ef9463b8973608f5710971e', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:47'),
(1091, '4226fb293a4c4268838cb599d3dd6919', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:47'),
(1092, 'c44e88072b87405ba023c36d62ab5afb', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:48'),
(1093, 'e2223609e0bc4ded9e7021fcea841351', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:48'),
(1094, 'deb73f7e5c7844bb9d8c4c4be0d1efea', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:48'),
(1095, '3815c0b168594806a7475515716b8031', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:51'),
(1096, 'c51165f63eab4c8abe20f8f88bc9be7c', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:54'),
(1097, '06a8d4dfd40b465f8cd2a108edcbdc4d', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:54'),
(1098, '908bafb7d00b4f71b8977e0a200f0869', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:54'),
(1099, '3fb82f19e44f45d09c89641a47f9fabe', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:54'),
(1100, '245ea81d485d406b8906f19663062c54', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:55'),
(1101, '19dfe4666b754853b8371d375eedf481', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:55'),
(1102, '278d44437f4a485a8c546374e6550ec3', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:55'),
(1103, 'c1338f199a824a9ab37bfa33bd4140fb', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:55'),
(1104, 'ba4903e8d8a34b9fbf66b3ffe3329ade', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 2, NULL, NULL, NULL, NULL, '2025-10-29 12:16:55'),
(1105, 'caeaa8eb101a41da9413f6d452b2aa7f', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 5, NULL, NULL, NULL, NULL, '2025-10-29 12:16:55'),
(1106, 'e8d211456cd9462889e5fd8e513fcce4', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:55'),
(1107, '358a6b9c9e874bdd88524506891eb81c', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-29 12:16:55'),
(1108, '1f1e66f5efbf4a4e8637e4e940b65512', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:55'),
(1109, '69e5b4bd42d0458bbad16ca7fc48b560', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:55'),
(1110, '04b4cc54e254425582c851cc14fd94fe', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:55'),
(1111, 'f2222354963241d6b90735fe4f6fafba', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:55'),
(1112, '81e2c04584a74cb89391f8a46031d87d', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:55'),
(1113, 'f1eb876df60f49a7a9692b8070ef73ee', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:56'),
(1114, '6df198f585c14727863042becf818ec1', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:56'),
(1115, '6fc4db2ac6494cea8a562b07dd43e60d', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:56'),
(1116, '4dd57f5eb0a74798a172ec003c5391eb', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:57'),
(1117, '5d370cd17ccd434d8fd6cd240707b542', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:16:57'),
(1118, '547922a4223946df8473ca1e06d59a87', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1119, '06cc95c1ad0344d2bb7d1a534575f277', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1120, '3a65c22505064f2fb73a5393e5f5acd9', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1121, '94547c49d77c4e929a6c21a3cd765a50', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1122, '1b094809a181482ca590917fab1afc0f', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1123, '64dbd266d0ab4f629524feb7fc609a55', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1124, '06c414d7184447a1817a1030de2b105d', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1125, '47e694485c2c45eeae1a73a4bbc736d4', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1126, '33594be300aa403187e3e75173237da7', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1127, '080960f92af94c2482150fe385b68499', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1128, 'f3b9256171124b73ae12eaee3f9ffba0', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1129, '92826d0934704cc481e9523e001a4d36', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1130, '4c426ab7d44042c580e6cf7bac512abf', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1131, '6e448be4df02489cb9f55392e2b2b870', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1132, 'cea389641e4d4f34a278b887d9e63478', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1133, 'd353e023616d43a09ea034f3d912d7d0', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:02'),
(1134, '5faa4c3e535f4acdae583f4c5d013540', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:03'),
(1135, 'c6aeaa15240f40d0a36afc9abf345a72', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:03'),
(1136, '7e5ddd2fcd264b378157fba710ad06b9', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:03'),
(1137, '6b30d0eac1b64a6492f57fe2cbc6b745', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:03'),
(1138, 'a041a96116d146a78afebce002e666bb', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:03'),
(1139, 'cb5f106218a3419ea268451d32961587', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:09'),
(1140, '8372f73fe0fb4edfb9451caa4a2b3449', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:09'),
(1141, 'c9e7ed3fb9d442ec8aa36af13764e5ff', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:09'),
(1142, 'aef948148ca94937885ab05375202d7e', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:09'),
(1143, 'bb4c7f26a0bb411ba6b2978e293c1609', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:09'),
(1144, '03c1a6eca5aa4fb78375fcdbb9dc59c1', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:09'),
(1145, '4a231e9c575c4eb89c7dcee328498212', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:09'),
(1146, 'e5f65ccf27c240b8abfa35af43688ec6', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:09'),
(1147, '70925008a7a54e5d96e1a74086717444', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-29 12:17:09'),
(1148, '8d2b7298aa5640249d00f04778adb46a', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:09'),
(1149, 'b454ba4296194221bfdbc2ac67a30ef0', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:09'),
(1150, 'b08540d2efd64cee98e38ee795c4abd3', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:09'),
(1151, '945e9f8cd7bb4394b06eaad9c8e27ca7', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:09'),
(1152, 'ab6b70a032a843138450c1854531ad71', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:09'),
(1153, '7f8fe1eec19c4336ba8362a75ef407f4', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:10'),
(1154, 'ba4f652f77c346e8879599fa3a836428', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:10'),
(1155, '60c37666382f4a5b9825ba2e1426c175', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:10'),
(1156, '437aba5f51c44e3b82dda4c43197f0fd', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:10'),
(1157, '4cadd516b44f4ef08a8a930cbc6b518b', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:10'),
(1158, '4f97a902e0cf4b39a0c185358dcda9d5', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:10'),
(1159, '846066faacc54ec49407d65b14456ad5', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:11'),
(1160, '74aed4a68e5340599352fb2ca3afe2b8', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-10-29 12:17:16'),
(1161, '82543e156aaf4201b3272dddb3e61ca0', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 4, NULL, NULL, NULL, NULL, '2025-10-29 12:17:16'),
(1162, 'ddc3d2c45d9d4bf0bfe2780ddb950bc8', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:16'),
(1163, '675caede20d5473281cccf66a1cdc172', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:16'),
(1164, '7925d331bd444f7ba556d1e4199ee63c', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:16'),
(1165, 'f933b3eefa974b79bc3c6c28fad405e1', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:16'),
(1166, '7c82c7f052504cc1ad7de424ed06d41e', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:16'),
(1167, 'e9e444b985da49d5b83db3e68ad65429', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:16'),
(1168, 'cc6d250a201d46cbb8a27a65c870573a', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:16'),
(1169, 'de1a0bfa3499476690e42cf6ff76ac07', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:16'),
(1170, 'c1e7e64da87f40f4bc64de5053b5e807', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:16'),
(1171, '83394e5e23d049e8ba90d93ac96497e1', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:16'),
(1172, '165ca2953177473594388bd2695f23f3', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:16'),
(1173, '2c1135dbc07843a2b943323539d2d770', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:16'),
(1174, 'dcdbcd2faff5400ca86d3a8c9e9ace66', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:17'),
(1175, '6022d5bf4bfe4d889ccc00017d16c013', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:17'),
(1176, '3322be2de1034befbbfd5cae3b0017e3', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:17'),
(1177, '33e9c982b3e847aaacfff57c201970fe', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:17'),
(1178, '10e1dd35901c4344b66e5635632a25c6', 'BUSINESS', NULL, NULL, 'null', '107.148.80.68', 'Mozilla/5.0', 'POST', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-29 12:17:18'),
(1179, 'c8c2dfa8a7d44179bfbf1a7c0a018fb1', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.9.145', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'POST', '/api/admin/media/upload', 'operate', 'system', NULL, 'SUCCESS', 200, 114, NULL, NULL, NULL, NULL, '2025-10-29 15:42:50'),
(1180, '91219545c97c4792afe2a839749c3134', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.9.145', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'DELETE', '/api/admin/media/7/permanent', 'operate', 'system', NULL, 'SUCCESS', 200, 82, NULL, NULL, NULL, NULL, '2025-10-29 16:33:38'),
(1181, 'b044529d59c44c6f94f8bb7ce335b581', 'BUSINESS', NULL, NULL, 'null', '45.192.104.18', 'Mozilla/5.0', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-30 09:59:36'),
(1182, '1123048f81524c11a88e55f3a0b46dad', 'BUSINESS', NULL, NULL, 'null', '45.192.104.18', 'Mozilla/5.0', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-30 14:17:33'),
(1183, 'c0850bf3a100464088fb37793359971d', 'BUSINESS', NULL, NULL, 'null', '154.23.181.216', 'Mozilla/5.0', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-31 00:03:50'),
(1184, '7c9f70e4a7ca4c0e81b3ea83c77ba4c8', 'BUSINESS', NULL, NULL, 'null', '111.33.154.219', 'PycURL/7.45.6 libcurl/7.68.0 OpenSSL/1.0.2k-fips zlib/1.2.7', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-31 14:43:47'),
(1185, '65cb07f44ca64afdbe49468232046bc6', 'BUSINESS', NULL, NULL, 'null', '106.75.186.101', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36', 'POST', '/token', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-10-31 21:24:02'),
(1186, 'fbfa283762a14c9ca88fa64843b08413', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.150', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'POST', '/api/admin/system/perms', 'operate', 'system', NULL, 'SUCCESS', 200, 20, NULL, NULL, NULL, NULL, '2025-11-01 19:06:02'),
(1187, 'b735ee0c65c6443182d4d82e402d5454', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.150', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'PUT', '/api/admin/system/perms/3251', 'operate', 'system', '3251', 'SUCCESS', 200, 9, NULL, NULL, NULL, NULL, '2025-11-01 19:06:29'),
(1188, '3ae88ebfa81f44a99a17d51c9124bbfa', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.150', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'PUT', '/api/admin/system/roles/1/perms', 'operate', 'system', '1', 'SUCCESS', 200, 15, NULL, NULL, NULL, NULL, '2025-11-01 19:08:41'),
(1189, 'd9ecc80807b4417cac1da784567c4e28', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.150', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'POST', '/api/admin/system/perms', 'operate', 'system', NULL, 'SUCCESS', 200, 8, NULL, NULL, NULL, NULL, '2025-11-01 19:13:54'),
(1190, 'f7fba69af4714b80aa008d6c88fb6df0', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.150', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'PUT', '/api/admin/system/perms/1000', 'operate', 'system', '1000', 'SUCCESS', 200, 9, NULL, NULL, NULL, NULL, '2025-11-01 19:14:01'),
(1191, '63af838dbf0245d48932e83fe7cbcc7e', 'BUSINESS', 1, 'admin', '[\"admin\"]', '218.67.0.150', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'PUT', '/api/admin/system/roles/1/perms', 'operate', 'system', '1', 'SUCCESS', 200, 16, NULL, NULL, NULL, NULL, '2025-11-01 19:14:07'),
(1192, '537b6b4129da45c5b79aa6eadce42a1d', 'BUSINESS', NULL, NULL, 'null', '139.224.0.39', NULL, 'HEAD', '/pscc/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-11-02 00:13:16'),
(1193, 'd562bf640c514c68aa063b83b06ae680', 'BUSINESS', NULL, NULL, 'null', '139.224.0.39', NULL, 'HEAD', '/start/index.html', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-11-02 00:13:16'),
(1194, '727c4a2a770e4ead89fbd20bde213553', 'BUSINESS', NULL, NULL, 'null', '219.148.163.2', '\"Mozilla/5.0', 'HEAD', '/', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-11-02 02:06:44'),
(1195, 'abcc50d5220d40e9af14b376e9ac42f7', 'BUSINESS', NULL, NULL, 'null', '219.148.163.2', '\"Mozilla/5.0', 'POST', '/sdk', 'operate', 'system', NULL, 'SUCCESS', 404, 1, NULL, NULL, NULL, NULL, '2025-11-02 02:06:44'),
(1196, 'b56603a616214354a9938ac2e5cb9e40', 'BUSINESS', NULL, NULL, 'null', '124.29.194.114', 'Hello, World', 'POST', '/GponForm/diag_Form', 'operate', 'system', NULL, 'SUCCESS', 404, 0, NULL, NULL, NULL, NULL, '2025-11-02 04:59:39');

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_login_log`
--

CREATE TABLE `foadmin_login_log` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `trace_id` varchar(64) NOT NULL COMMENT '请求关联ID',
  `actor_id` bigint DEFAULT NULL COMMENT '登录用户ID（失败可为空）',
  `actor_name` varchar(128) DEFAULT NULL COMMENT '登录用户名/姓名快照',
  `ip` varchar(64) DEFAULT NULL COMMENT '来源IP',
  `user_agent` varchar(255) DEFAULT NULL COMMENT 'UA',
  `status` enum('SUCCESS','FAIL') NOT NULL COMMENT '登录是否成功',
  `message` varchar(255) DEFAULT NULL COMMENT '失败原因或补充说明',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='登录日志';

--
-- 转存表中的数据 `foadmin_login_log`
--

INSERT INTO `foadmin_login_log` (`id`, `trace_id`, `actor_id`, `actor_name`, `ip`, `user_agent`, `status`, `message`, `created_at`) VALUES
(1, '00859ac436264591a3b8ead84c65ae29', NULL, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 04:50:00'),
(2, '5cf9222f37df4f5bb1cb4ec06f254a87', NULL, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 05:09:15'),
(3, '9de8f010f8bb4d119ba57ff2432e7255', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 05:18:39'),
(4, '4c44c42d664d49489069e248a89dc2ed', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 05:25:24'),
(5, 'f24963ef0ff94f95a6315e5d0327d4f9', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 05:29:52'),
(6, '89d1d8cfc7c640989037edeb6fc822b5', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 05:41:07'),
(7, 'd7fc2a3d40b6428487f90f863db3f681', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 05:47:24'),
(8, 'a42cb2222a7b4871a6e86d7ee34f962b', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 06:16:03'),
(9, '2701cdf121c14cc4a51ea58806bc55c4', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 06:24:45'),
(10, '7613333290d146ec89d629e0f878bd48', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 06:24:48'),
(11, '593c5e9edbd24ed6b37d6efcd68f4dbb', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 06:35:26'),
(12, '9bb736bea7e64ef7b992e029ada2ce08', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 06:37:53'),
(13, 'b106525271d1418aba7d8190a26a34ac', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 06:45:37'),
(14, '2bcd0d9dd26e4cf99402dba557e92f44', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 06:48:40'),
(15, '753fc311e3ce459187f5ad7edfb5c50a', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 06:50:03'),
(16, '263c413bae6c40d9bae42a527ba58173', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 06:51:52'),
(17, 'd716a8aa63fe4b0d964e98482e9a5d88', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 06:53:47'),
(18, '31ccb793423e4e76afa2d2afd658f122', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 07:54:32'),
(19, '61cd5b3551f04526a19fd7e5853173cc', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 08:00:01'),
(20, 'd49ad762ab8a46318b5dc8b07c56016d', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 12:33:58'),
(21, '1d1ecc7d5140414083e63bcfdf66ad59', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 14:39:09'),
(22, '8df7c60995054190983a7676d2c81ce9', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-16 16:43:55'),
(23, 'af815ac26c8c47f594a0aaa73ba73174', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-17 07:57:32'),
(24, '81c0041188a0439eb2c6f3ae10af519c', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-17 08:31:09'),
(25, '98c8ae9cb0e8455d961851877ab289fa', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-17 13:17:30'),
(26, 'cf35acdc10404348b17be65fc4be908d', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-17 13:23:25'),
(27, '69c353292ba340d6b9d2370b84b4a2fe', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-17 13:59:07'),
(28, '98f7f0b58bfb414490cf1221bd7cc301', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-17 14:06:46'),
(29, '687c315a97ad437ca916eddb419c21d3', 1, 'admin', '218.67.0.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-17 16:16:08'),
(30, 'eb1a09d3b66c4c579912553f3eacbb98', 1, 'admin', '218.67.0.204', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-22 17:03:55'),
(31, 'b2bb2efc811f45cfb57deb15e5a39d19', 1, 'admin', '218.67.0.204', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-23 02:29:15'),
(32, '79198073e1d64a26a4f3aff129fc1fed', 1, 'admin', '218.67.0.204', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/4.3.5.483', 'SUCCESS', NULL, '2025-08-23 03:32:24'),
(33, 'ac058d2a7d854365b485c94120475fe1', 1, 'admin', '218.67.0.204', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36 Edg/139.0.0.0', 'SUCCESS', NULL, '2025-08-23 04:13:32'),
(34, 'af18d392a957454fafd116b1d46ab196', 1, 'admin', '218.67.0.204', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-23 06:17:54'),
(35, '8f0dc379c92240d5a16a6b7243192038', 1, 'admin', '218.67.0.204', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-23 15:37:51'),
(36, '84a45043878f446c9b69f45b361218d4', 1, 'admin', '218.67.0.204', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-24 18:04:51'),
(37, 'f865ae3c9dd4415d87a5e4b814ffc7fb', 1, 'admin', '218.67.0.204', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-26 11:31:58'),
(38, 'c20ca3919a7f46b8a8a646be661533d9', 1, 'admin', '218.67.0.204', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-26 16:30:34'),
(39, '8bda44957f0842b7ae22547e8bc2a23c', 1, 'admin', '218.67.0.204', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-26 17:46:00'),
(40, 'f58f224013e14c439cced1094829d584', 1, 'admin', '220.161.60.244', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-27 06:14:42'),
(41, 'bbe8b26e5f51429caf63c1dee13f4242', 1, 'admin', '220.161.60.244', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-27 12:26:55'),
(42, '55d567e7c4d44e32b616e5295bcc9cf2', 1, 'admin', '220.161.60.244', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-28 17:51:53'),
(43, '361d66c60be54b11bab0e7806ab5595b', 1, 'admin', '220.161.60.244', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-30 18:18:38'),
(44, '43a1ea12b36443189d0707abf0d23e13', 1, 'admin', '220.161.60.244', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-08-31 06:42:16'),
(45, '1b3875fbcc3744ccb2649ea9681fcbb8', 1, 'admin', '220.161.60.244', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-09-01 17:19:40'),
(46, 'c0110e6493904ccfaa4ce2a9e641412e', 1, 'admin', '218.67.0.107', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-09-07 19:04:46'),
(47, 'c0fa90aa3a7a4635934c8a92cb16bf01', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:28:53'),
(48, '16449851307a486e8b969b7bbb1fe5a3', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:29:19'),
(49, 'bced47ba3f1b4d109189f6497c557a31', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:29:22'),
(50, '0be0b8904b7443dead117f88746d3e3b', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:29:25'),
(51, 'fda74cca4af848ccaf953fd6b30addb0', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:30:17'),
(52, '94ebda49da514cbeb29ed50285222636', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:31:58'),
(53, '24362091c7c848a6ac3486a6408e8f9c', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:32:42'),
(54, '7475a5f3a7fb4d8cbaf152051b171ba7', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:32:42'),
(55, '4085d4b6cb07432d876d7f4aad6e073d', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:32:48'),
(56, '7c470b07d2634de58f93e6334717f0b4', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:33:50'),
(57, '42c60db7a1964126a04e82a1355234a6', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:33:51'),
(58, '2d93843101e34da696f9cfb3ba8dc7e1', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:33:52'),
(59, '7e438a6407ba48968bb0ba3c274edb83', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:34:09'),
(60, '3e57a0d0dbb141eaab0988fdfe66541b', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:34:11'),
(61, '060184e9094a42498a944a8814c3a4f7', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:34:12'),
(62, '78523f309dd943f89971cf4012195286', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:34:12'),
(63, 'cc27b2a05cff4800b4c4a74f26c8722a', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:35:18'),
(64, '9e3b7c6bd9204c2f8a5da5fcfafaefd9', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:37:01'),
(65, 'a0c59fbd45f4439bbe277e561dd62f69', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:37:05'),
(66, 'bde2c04a5ae84f64904d73179978db35', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:38:17'),
(67, '191f5715205d4b058dc2c278a6cdc021', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:38:17'),
(68, '5d14a0c8f69b4754a14f15d70ab2f945', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:38:21'),
(69, '6f0090b66e48413f8221e86ebf7698c2', NULL, NULL, '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-07 23:38:49'),
(70, 'dbd90d9bca04431886a2c6b8f0d59a32', NULL, NULL, '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-07 23:38:52'),
(71, 'ff932d2d2dd34723ab591d5f194947fd', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:04'),
(72, '17681c607695416fae1e55186874f5bb', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:22'),
(73, '11b033d60f2d4c1ba1060e37f22a5681', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:23'),
(74, '98f1796608594bf0aa8b49bf6ecb5dcf', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:24'),
(75, '4cc53a8f4fe34a8cad8f17bb6909dcbb', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:24'),
(76, '5da2bc69384d47e0bf485fedc128b89a', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:25'),
(77, 'c3023574897748228a5dcf4a31200469', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:25'),
(78, '7a3697f5e58a46a29a059c6e56c49ce1', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:25'),
(79, '61cd1d70e6bd4d9dbd8bd35215047a81', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:26'),
(80, '962a75b51afb4de5b92a1695d8455857', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:26'),
(81, 'e294d636f0e245499f5941924557c1ca', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:26'),
(82, '81ec069d6611484cafaf36ab53316abf', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:26'),
(83, '94c69015eada4651991bc48637315829', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:27'),
(84, '8badd33030294ca8a1afc06af214955f', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:27'),
(85, '6aa87a3d04ca4ee8873e979753a213d9', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:27'),
(86, '97d97c57efef46428895e66fe3e21b38', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:27'),
(87, '0c30d1e418e04960be6a4be79963645f', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:39:27'),
(88, '1df5a14823d44120b66c11dbbb2dd9f8', NULL, NULL, '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-07 23:41:52'),
(89, 'c40686d4dcef49e782f9a365ea23e152', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:42:02'),
(90, 'e226135674f8423ab178a2b52f14f879', 1, 'admin', '220.161.60.110', 'PostmanRuntime/7.48.0', 'FAIL', 'HTTP 422', '2025-10-07 23:43:32'),
(91, '9ae824d18661466e97df4cc8a4669eca', 1, 'admin', '220.161.60.110', 'PostmanRuntime/7.48.0', 'FAIL', 'HTTP 422', '2025-10-07 23:44:37'),
(92, '34ecd87583324a729aeb1d336d4f0e97', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:46:38'),
(93, '0a13c9767d11460cbce89e07b128c615', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:46:39'),
(94, 'ee2ff1a5d3794c508459997ef59df785', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:46:43'),
(95, '055f7d585eb34b5ca4321d1c801f0c68', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:46:44'),
(96, '1e17870355a14f8bb0a380ec45e2045f', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:46:44'),
(97, 'c6891e76d011439f90c13627c021ae14', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:46:44'),
(98, 'ac2a4e5237d544b798632d2c4a0481a7', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:49:54'),
(99, 'cfe38fe2f17c48959a137cdf378f3550', 1, 'admin', '220.161.60.110', 'PostmanRuntime/7.48.0', 'FAIL', 'HTTP 422', '2025-10-07 23:50:47'),
(100, 'edee5c045620451b88c42f8363cdc314', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:53:52'),
(101, 'f9c38dfc1e044053b409eb6c0dd20ee8', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:53:53'),
(102, '3e584f23837742cc91b110171779e35d', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:54:12'),
(103, '3f46742d9c91431b8cf457d21e032c60', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-07 23:54:13'),
(104, '6834cc3b697f4583ad4005ccbf086c56', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:01:08'),
(105, '0cf32f6414204ae7bcf9b49cb95362ef', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:06:31'),
(106, 'fbe0e03c9af54c329a9b653271f809f3', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:06:31'),
(107, 'd5a1fac7170b43e5997ecd39f6bc5450', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:09:28'),
(108, '3930ea4d805e45eeb7c5173af8c1aed2', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:15:51'),
(109, '18d268b4a60343daab4ad10486fdce02', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:16:17'),
(110, '0d29563f20fd4932b40036033f61ea2e', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:16:44'),
(111, '49f482f53ba2478fb7af1b6b13e6d328', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:16:45'),
(112, '14b4dfc895274739959718942e3e59d5', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:17:17'),
(113, '67350e24f613496585cfab897c4a7df3', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'hash could not be identified', '2025-10-08 00:17:46'),
(114, 'b26791d0adc0428c9fc3ada2c2b2fb28', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:18:43'),
(115, '8d6ae5118dc0418d92ff6dc6fa6a4eeb', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:21:17'),
(116, '1b0f070c53fa412084e933d93bc8a264', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:21:18'),
(117, 'c0b3fb4060434824a3bf7cc8ae8f1e52', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:23:23'),
(118, '14186138e57a43c8aa534c9d0b0f3f9e', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:24:36'),
(119, '28d0164427a2492ca660f7d2f82f8c2a', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:28:46'),
(120, 'c3749dbe0e414e75af719042c95ad6ba', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'hash could not be identified', '2025-10-08 00:29:42'),
(121, '1c75a2c5ac0748328091bd3a7bbdf615', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'hash could not be identified', '2025-10-08 00:29:55'),
(122, '68d19c2b09724480b2fde02d6d4ca32d', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'hash could not be identified', '2025-10-08 00:30:30'),
(123, '25709d486f694586ba3faaebbae843cc', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:31:49'),
(124, '92feea7fa8f54db19c1c6809a1e9bad6', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:32:08'),
(125, '014a09e3ee2a443ba52aff2cc8227814', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:32:36'),
(126, '13f35a70add847b681743c9ee90d0863', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'password cannot be longer than 72 bytes, truncate manually if necessary (e.g. my_password[:72])', '2025-10-08 00:33:05'),
(127, 'fa6453a3b6714d62bbe970342d87a9a5', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-08 00:33:40'),
(128, '95be1b24974142f6a6c583ccb9d23b01', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-08 00:34:28'),
(129, '3f850cfb3ab54be7bb610ef0e308f17a', 1, 'admin', '220.161.60.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-08 14:02:39'),
(130, '74408fe45f7c45cdb96181fd19363497', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-19 14:31:24'),
(131, 'ef218dac9f49414b8761d4ca6628f792', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-19 14:31:30'),
(132, '748c1d0fb5fe41098294dedb3632e7e0', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-19 14:44:19'),
(133, 'e08c7d6bb71e472ab6d86f24d727416e', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-19 14:58:02'),
(134, '34095ce2db33469a892fea1bebe94707', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-19 15:01:19'),
(135, '718012cfd92b432dbe16d8de2bc4beda', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-19 15:01:32'),
(136, '7f1ee9ca8513400ab2b519965b2a7d64', NULL, '00011', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-19 15:06:02'),
(137, 'c9dd90095a524486bb6d5267ffa13e30', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-19 15:06:16'),
(138, 'b84f2b0aaf344c908cefbcf54c6a6949', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-19 15:32:56'),
(139, 'f1293b26daff4c8898c881afbe9d8623', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-19 15:33:03'),
(140, '3ddaa8dce4664ebb893ae38db23eff77', NULL, '2', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-19 15:46:09'),
(141, '36b9b023760d4ec49af15618de9b077a', NULL, '0', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-19 16:31:58'),
(142, '05b1173b80d94b3a915847da2d55418b', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-19 16:53:58'),
(143, 'fa946f86478a4b00b4529c2facc228c9', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-19 17:02:43'),
(144, 'cfed83104a604d62a05c9840a97d1f6b', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-19 17:05:53'),
(145, 'a812331f16b24fd68474d9be026b546c', NULL, '1', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-19 17:42:29'),
(146, 'bc9cbb63508b40f1a2139b4fac04823f', NULL, '1', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-19 17:59:15'),
(147, '6230b8877f9c49b195dbe23cdb211bf2', NULL, '1', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-19 18:06:49'),
(148, '9ebd0c66624f420b8e748d2395731fdb', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-19 18:10:33'),
(149, 'f3b7fcfbbd00484d804ea39e7f5c0787', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-19 19:21:22'),
(150, 'fff470e2ff3848a194bb862f001342bf', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 02:47:18'),
(151, 'f98507021d29435eb9ba0f8a5df4e87c', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 05:33:58'),
(152, 'e5795610fd29463fa0d16f3e9bcc3ec1', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', '\'>\' not supported between instances of \'float\' and \'str\'', '2025-10-20 06:33:57'),
(153, '022e27a98a8944eb8ea7e78c5d6a4fe2', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', '\'>\' not supported between instances of \'float\' and \'str\'', '2025-10-20 06:34:06'),
(154, 'c9ef08f842044e18baaf432352cbf1e6', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 06:37:00'),
(155, 'fe5b3c161cfc4446b221c351f60f6ff3', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-20 06:38:21'),
(156, 'e107b5f17d2f46ff88b25981d884ba13', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-20 06:38:32'),
(157, 'b9521b62861e411d83aa8bd22060ed2c', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-20 06:38:36'),
(158, '1b2bfe0d67834687890c2b0dd2f06fda', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-20 06:38:44'),
(159, 'c7dd24ef18ac493b8f9da33cda4e7233', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 403', '2025-10-20 06:38:48'),
(160, '8713e391d82941cfb5ac439e10a9cb14', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 403', '2025-10-20 06:42:44'),
(161, '258694eded2a4baea7f6fe1315f7f513', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 06:55:06'),
(162, '3b9a52c7c56a4d10ae09e2dbc1643092', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 06:55:34'),
(163, '16c67944004349bb909a79090171ecef', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 06:58:36'),
(164, 'aa22db3d07434e98aaa90ca39288faea', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 06:59:58'),
(165, 'bf3a774c05624eb395e2fcb4d4e294cf', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 07:00:15'),
(166, '2e99c49db7e647e5862399ad8a0ee82f', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 07:00:36'),
(167, '92c82061f8034e6bb334075d74904b48', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-20 07:03:30'),
(168, '5de9d055106041e085348cb38e961206', NULL, '1', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-20 07:05:15'),
(169, '047d3283588b4dd787509d08b86ac469', NULL, '1', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-20 07:05:26'),
(170, '3c3a943b706a4e83a41388305ea6f28d', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 07:06:57'),
(171, 'edaa311952bd48388e2fd10a0dd8e85c', NULL, '1', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-20 07:07:11'),
(172, '2cdcec1a8dec416e88bd42b26b631858', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 07:07:20'),
(173, 'ea45cbd11ffd4e0899a4ca7213f5b326', NULL, '1', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'FAIL', 'HTTP 400', '2025-10-20 07:07:28'),
(174, 'e362cdc509824ef89312c3ecd0913445', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 07:07:36'),
(175, '9de8a156cc6a4203883783dd37b13f6d', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 07:09:43'),
(176, '77867a3052c04c42a6a43a9693a931c7', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 07:10:01'),
(177, '5e452493717f4b2fb07ae2d45948f2e3', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 07:10:24'),
(178, '60ecb0d25f9d4ec7acae48f0df6874b3', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 07:29:28'),
(179, '931cc2ef59024014a251d925872f0725', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 15:47:40'),
(180, '8ffd46a773c04ed684524cfa11641ff2', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 15:48:32'),
(181, 'f9f9aa7acef14914b1b5ea063b6f1418', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-20 17:54:38'),
(182, '29bb59a44e534b1d98026547fff0438d', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-21 05:33:34'),
(183, 'd33367a768f34b97bc7df374126345f8', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-21 15:26:12'),
(184, 'a559088745e1489db664645090d78b84', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-21 15:40:02'),
(185, '47832783a5ff46d69c92ebd33de231ab', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-21 16:33:13'),
(186, 'ec0d80198f4142faa04e5ce24a0519b1', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-21 16:57:04'),
(187, '913151cfc6d44257a91c1d52f7b6bb7c', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-21 16:57:45'),
(188, 'b906cca264a340b5a9a89e78d7e65d63', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-21 17:02:46'),
(189, 'b35285f70a434873a9b694b85bb96402', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-21 17:06:33'),
(190, '5c3dfe38100044f09f9e156d764c8b37', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-21 17:31:24'),
(191, '1086e5233a0b4dff85ca3783b30dd154', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-21 18:33:53'),
(192, '5e3f1bd67cc74106b390d5ad1c4340b3', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-22 06:17:32'),
(193, '3913f7444db14329b3376fba9231caf1', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-23 07:09:29'),
(194, '0da788aff1a94662ad8d5cf041277bd9', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-23 17:09:41');
INSERT INTO `foadmin_login_log` (`id`, `trace_id`, `actor_id`, `actor_name`, `ip`, `user_agent`, `status`, `message`, `created_at`) VALUES
(195, '858fd75d705f4bdca524663683f03118', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-24 04:13:11'),
(196, '40254fc8c6024ba2bc563415b89b9509', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-24 06:38:52'),
(197, '07bf0450db8a45d7ac96cf474b616008', 1, 'admin', '218.67.0.210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-24 07:13:42'),
(198, '9bb3d29e38f64acb9220c6c5898e31a1', 1, 'admin', '218.67.9.145', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-10-29 15:42:34'),
(199, 'd89a0ee838ac418d8234bd6fd2a41d90', 1, 'admin', '218.67.0.150', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-11-01 19:01:56'),
(200, 'adafda8d00e146639fec9494680755a5', 1, 'admin', '218.67.0.150', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-11-01 19:08:18'),
(201, '44389640a10b40d1b3426f26c29703ac', 1, 'admin', '218.67.0.150', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-11-01 19:08:56'),
(202, '6045f74fc00b4132849ddf377144fa6a', 1, 'admin', '218.67.0.150', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-11-01 19:14:20'),
(203, '16e678e00bfa4dbbb63947b7e5906abf', 1, 'admin', '218.67.0.150', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'SUCCESS', NULL, '2025-11-02 06:47:22');

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_media_audit`
--

CREATE TABLE `foadmin_media_audit` (
  `id` bigint NOT NULL,
  `file_id` bigint NOT NULL,
  `action` varchar(32) NOT NULL,
  `actor_id` bigint NOT NULL,
  `ip` varchar(64) DEFAULT NULL,
  `ua` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 转存表中的数据 `foadmin_media_audit`
--

INSERT INTO `foadmin_media_audit` (`id`, `file_id`, `action`, `actor_id`, `ip`, `ua`, `created_at`) VALUES
(1, 1, 'upload', 1, NULL, NULL, '2025-10-19 15:20:01'),
(2, 2, 'upload', 1, NULL, NULL, '2025-10-19 15:32:37'),
(3, 1, 'delete', 1, NULL, NULL, '2025-10-19 15:33:56'),
(4, 3, 'upload', 1, NULL, NULL, '2025-10-20 03:18:50'),
(5, 5, 'upload', 1, NULL, NULL, '2025-10-20 05:44:07'),
(6, 4, 'delete_physical', 1, NULL, NULL, '2025-10-20 05:48:42'),
(7, 4, 'delete', 1, NULL, NULL, '2025-10-20 05:48:42'),
(8, 5, 'delete_physical', 1, NULL, NULL, '2025-10-20 05:48:53'),
(9, 5, 'delete', 1, NULL, NULL, '2025-10-20 05:48:53'),
(10, 3, 'delete_physical', 1, NULL, NULL, '2025-10-20 05:49:25'),
(11, 3, 'delete', 1, NULL, NULL, '2025-10-20 05:49:25'),
(12, 5, 'restore', 1, NULL, NULL, '2025-10-20 06:08:05'),
(13, 5, 'delete', 1, NULL, NULL, '2025-10-20 06:08:12'),
(14, 5, 'restore', 1, NULL, NULL, '2025-10-20 06:17:25'),
(15, 5, 'delete', 1, NULL, NULL, '2025-10-20 06:17:30'),
(16, 6, 'upload', 1, NULL, NULL, '2025-10-21 06:27:19'),
(17, 6, 'soft_delete', 1, NULL, NULL, '2025-10-21 06:28:08'),
(18, 6, 'restore', 1, NULL, NULL, '2025-10-21 06:28:15'),
(19, 6, 'delete_physical', 1, NULL, NULL, '2025-10-21 06:28:35'),
(20, 6, 'hard_delete', 1, NULL, NULL, '2025-10-21 06:28:35'),
(21, 7, 'upload', 1, NULL, NULL, '2025-10-29 15:42:51'),
(22, 7, 'delete_physical', 1, NULL, NULL, '2025-10-29 16:33:38'),
(23, 7, 'hard_delete', 1, NULL, NULL, '2025-10-29 16:33:38');

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_media_convert_cache`
--

CREATE TABLE `foadmin_media_convert_cache` (
  `id` bigint NOT NULL,
  `kind` varchar(16) NOT NULL,
  `src_sha256` varchar(64) NOT NULL,
  `html` text,
  `file_ids` text,
  `pages` int DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_media_dir`
--

CREATE TABLE `foadmin_media_dir` (
  `id` bigint NOT NULL,
  `parent_id` bigint DEFAULT NULL,
  `name` varchar(128) NOT NULL,
  `sort` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 转存表中的数据 `foadmin_media_dir`
--

INSERT INTO `foadmin_media_dir` (`id`, `parent_id`, `name`, `sort`) VALUES
(1, NULL, 'image', 0),
(2, 1, 'www', 0);

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_media_file`
--

CREATE TABLE `foadmin_media_file` (
  `id` bigint NOT NULL,
  `dir_id` bigint DEFAULT NULL,
  `filename` varchar(255) NOT NULL,
  `ext` varchar(20) DEFAULT NULL,
  `mime` varchar(100) DEFAULT NULL,
  `size` bigint NOT NULL,
  `sha256` char(64) NOT NULL,
  `width` int DEFAULT NULL,
  `height` int DEFAULT NULL,
  `duration` int DEFAULT NULL,
  `storage` varchar(20) NOT NULL,
  `path` varchar(512) NOT NULL,
  `url` varchar(512) DEFAULT NULL,
  `uploader_id` bigint NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 转存表中的数据 `foadmin_media_file`
--

INSERT INTO `foadmin_media_file` (`id`, `dir_id`, `filename`, `ext`, `mime`, `size`, `sha256`, `width`, `height`, `duration`, `storage`, `path`, `url`, `uploader_id`, `remark`, `created_at`, `deleted_at`) VALUES
(2, NULL, 'T.jpg', 'jpg', 'image/jpeg', 78329, '904b959f014b6ec429cbc4facb07e650c3073bbf2f8ab3f26e6da3c1271c28d7', 1024, 1024, NULL, 'local', 'media/2025/10/19/904b959f014b6ec4.jpg', NULL, 1, NULL, '2025-10-19 15:32:37', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_media_tag`
--

CREATE TABLE `foadmin_media_tag` (
  `id` bigint NOT NULL,
  `name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_rel_media_file_tag`
--

CREATE TABLE `foadmin_rel_media_file_tag` (
  `file_id` bigint NOT NULL,
  `tag_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_rel_role_perm`
--

CREATE TABLE `foadmin_rel_role_perm` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `perm_id` bigint NOT NULL COMMENT '权限ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 转存表中的数据 `foadmin_rel_role_perm`
--

INSERT INTO `foadmin_rel_role_perm` (`role_id`, `perm_id`) VALUES
(1, 1000),
(1, 1005),
(1, 1007),
(1, 1201),
(1, 1202),
(1, 1203),
(1, 1204),
(1, 1205),
(1, 1206),
(1, 1700),
(1, 1703),
(1, 1800),
(1, 1806),
(1, 3001),
(1, 3007),
(1, 3008),
(1, 3009),
(1, 3010),
(1, 3011),
(1, 3012),
(1, 3013),
(1, 3014),
(1, 3015),
(1, 3016),
(1, 3017),
(1, 3018),
(1, 3019),
(1, 3020),
(1, 3021),
(1, 3022),
(1, 3023),
(1, 3024),
(1, 3025),
(1, 3026),
(1, 3027),
(1, 3028),
(1, 3029),
(1, 3031),
(1, 3032),
(1, 3033),
(1, 3034),
(1, 3035),
(1, 3036),
(1, 3037),
(1, 3038),
(1, 3039),
(1, 3040),
(1, 3041),
(1, 3042),
(1, 3043),
(1, 3057),
(1, 3058),
(1, 3059),
(1, 3060),
(1, 3061),
(1, 3062),
(1, 3063),
(1, 3100),
(1, 3101),
(1, 3102),
(1, 3200),
(1, 3201),
(1, 3202),
(1, 3203),
(1, 3204),
(1, 3205),
(1, 3206),
(1, 3207),
(1, 3208),
(1, 3209),
(1, 3210),
(1, 3211),
(1, 3212),
(1, 3213),
(1, 3214),
(1, 3215),
(1, 3216),
(1, 3217),
(1, 3218),
(1, 3219),
(1, 3220),
(1, 3221),
(1, 3222),
(1, 3223),
(1, 3224),
(1, 3225),
(1, 3226),
(1, 3227),
(1, 3228),
(1, 3229),
(1, 3230),
(1, 3231),
(1, 3232),
(1, 3233),
(1, 3234),
(1, 3235),
(1, 3236),
(1, 3237),
(1, 3238),
(1, 3239),
(1, 3240),
(1, 3241),
(1, 3242),
(1, 3243),
(1, 3244),
(1, 3245),
(1, 3246),
(1, 3247),
(1, 3248),
(1, 3249),
(1, 3250),
(1, 3251),
(1, 3252);

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_rel_user_role`
--

CREATE TABLE `foadmin_rel_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 转存表中的数据 `foadmin_rel_user_role`
--

INSERT INTO `foadmin_rel_user_role` (`user_id`, `role_id`) VALUES
(1, 1),
(2, 2);

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_sys_config`
--

CREATE TABLE `foadmin_sys_config` (
  `id` bigint NOT NULL COMMENT '配置ID',
  `category` varchar(64) NOT NULL COMMENT '配置分类',
  `key` varchar(128) NOT NULL COMMENT '配置键名（唯一）',
  `value` text COMMENT '配置值',
  `value_type` varchar(32) DEFAULT 'string' COMMENT '值类型',
  `name` varchar(128) NOT NULL COMMENT '配置名称',
  `description` varchar(512) DEFAULT NULL COMMENT '配置说明',
  `options` text COMMENT '可选项（JSON）',
  `default_value` text COMMENT '默认值',
  `is_public` tinyint DEFAULT '0' COMMENT '是否公开',
  `is_encrypted` tinyint DEFAULT '0' COMMENT '是否加密',
  `sort` int DEFAULT '0' COMMENT '排序',
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` bigint DEFAULT NULL COMMENT '更新人ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统配置表';

--
-- 转存表中的数据 `foadmin_sys_config`
--

INSERT INTO `foadmin_sys_config` (`id`, `category`, `key`, `value`, `value_type`, `name`, `description`, `options`, `default_value`, `is_public`, `is_encrypted`, `sort`, `updated_at`, `updated_by`) VALUES
(1, 'system', 'site_name', 'Foadmin', 'string', '网站名称', '显示在浏览器标题栏', NULL, NULL, 1, 0, 1, '2025-10-20 10:52:10', 1),
(2, 'system', 'site_logo', 'https://foadmin.sslphp.com/api/admin/media/preview/904b959f014b6ec429cbc4facb07e650c3073bbf2f8ab3f26e6da3c1271c28d7', 'file', '网站Logo', '左上角显示的Logo', NULL, NULL, 1, 0, 2, '2025-10-20 13:50:58', 1),
(3, 'system', 'site_keywords', 'Foadmin,后台管理', 'string', '网站关键词', 'SEO优化用', NULL, NULL, 1, 0, 3, '2025-10-20 10:52:10', 1),
(4, 'system', 'site_description', '最智能的后台开发框架', 'textarea', '网站描述', 'SEO优化用', NULL, NULL, 1, 0, 4, '2025-10-20 10:52:16', 1),
(5, 'system', 'site_icp', '', 'string', 'ICP备案号', '网站备案信息', NULL, NULL, 1, 0, 5, '2025-10-20 10:52:10', 1),
(6, 'system', 'site_copyright', '© 2025 厦门市知序技术服务工作室', 'string', '版权信息', '页脚显示', NULL, NULL, 1, 0, 7, '2025-10-20 15:46:19', 1),
(7, 'upload', 'upload_max_size', '10', 'number', '最大上传大小(MB)', '单个文件最大限制', NULL, NULL, 0, 0, 1, '2025-10-20 14:07:13', 1),
(8, 'upload', 'upload_allowed_exts', 'jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx,zip', 'string', '允许的文件后缀', '逗号分隔', NULL, NULL, 0, 0, 2, '2025-10-20 14:17:35', 1),
(9, 'upload', 'upload_storage', 'local', 'select', '存储方式', '文件存储位置', '[{\"label\":\"本地存储\",\"value\":\"local\"},{\"label\":\"阿里云OSS\",\"value\":\"oss\"},{\"label\":\"腾讯云COS\",\"value\":\"cos\"}]', NULL, 0, 0, 3, '2025-10-20 14:07:13', 1),
(10, 'upload', 'upload_path', './runtime/uploads', 'string', '本地上传路径', '本地存储时的根目录', NULL, NULL, 0, 0, 4, '2025-10-20 14:07:13', 1),
(11, 'security', 'login_max_fails', '5', 'number', '登录最大失败次数', '超过后锁定账号', NULL, NULL, 0, 0, 1, '2025-10-20 14:55:22', 1),
(12, 'security', 'login_lock_seconds', '600', 'number', '账号锁定时长(秒)', '失败次数过多后的锁定时间', NULL, NULL, 0, 0, 2, '2025-10-20 14:55:22', 1),
(13, 'security', 'password_min_length', '6', 'number', '密码最小长度', '用户密码要求', NULL, NULL, 0, 0, 3, '2025-10-20 14:55:22', 1),
(14, 'security', 'password_complexity_enabled', '', 'boolean', '启用密码复杂度要求', '是否启用密码复杂度验证', NULL, NULL, 0, 0, 4, '2025-10-20 15:28:09', 1),
(15, 'security', 'enable_captcha', 'true', 'boolean', '启用验证码', '登录时是否需要验证码', NULL, NULL, 1, 0, 5, '2025-10-20 15:10:09', 1),
(16, 'security', 'session_expire_minutes', '120', 'number', 'Session过期时间(分钟)', 'JWT Token有效期', NULL, NULL, 0, 0, 6, '2025-10-20 14:55:22', 1),
(17, 'email', 'smtp_host', '', 'string', 'SMTP服务器', '邮件发送服务器地址', NULL, NULL, 0, 0, 1, '2025-10-21 02:11:16', 1),
(18, 'email', 'smtp_port', '465', 'number', 'SMTP端口', '通常为465(SSL)或25', NULL, NULL, 0, 0, 2, '2025-10-21 00:21:13', 1),
(19, 'email', 'smtp_user', '', 'string', 'SMTP用户名', '发件邮箱账号', NULL, NULL, 0, 0, 3, '2025-10-21 02:11:16', 1),
(20, 'email', 'smtp_password', '', 'string', 'SMTP密码', '邮箱授权码', NULL, NULL, 0, 0, 4, '2025-10-21 02:11:16', 1),
(21, 'email', 'smtp_from', '', 'string', '发件人邮箱', '显示的发件人地址', NULL, NULL, 0, 0, 5, '2025-10-21 02:11:16', 1),
(22, 'email', 'smtp_ssl', 'true', 'boolean', '启用SSL', '是否使用SSL加密', NULL, NULL, 0, 0, 6, '2025-10-20 23:55:49', 1),
(23, 'security', 'login_rate_limit_requests', '20', 'number', '登录速率限制(次数)', '单位时间内同一IP最多请求次数', NULL, NULL, 0, 0, 7, '2025-10-20 14:55:22', 1),
(24, 'security', 'login_rate_limit_window', '60', 'number', '登录速率限制(时间窗口秒)', '速率限制的时间窗口', NULL, NULL, 0, 0, 8, '2025-10-20 14:55:22', 1),
(25, 'security', 'password_require_uppercase', 'true', 'boolean', '要求大写字母', '密码必须包含至少一个大写字母', NULL, NULL, 0, 0, 9, '2025-10-20 15:28:09', 1),
(26, 'security', 'password_require_lowercase', 'true', 'boolean', '要求小写字母', '密码必须包含至少一个小写字母', NULL, NULL, 0, 0, 10, '2025-10-20 15:28:09', 1),
(27, 'security', 'password_require_digit', 'true', 'boolean', '要求数字', '密码必须包含至少一个数字', NULL, NULL, 0, 0, 11, '2025-10-20 15:28:09', 1),
(28, 'security', 'password_require_special', 'true', 'boolean', '要求特殊字符', '密码必须包含至少一个特殊字符(!@#$%^&*()等)', NULL, NULL, 0, 0, 12, '2025-10-20 15:28:09', 1),
(29, 'system', 'site_security_record', '', 'string', '公网安备案号', '网站公安备案信息', NULL, NULL, 1, 0, 6, NULL, NULL),
(30, 'upload', 'enable_static_access', '', 'boolean', '启用静态文件直接访问', '是否允许通过URL直接访问上传文件（如/runtime/uploads/media/xxx.jpg）。关闭时只能通过API接口访问。', NULL, 'false', 0, 0, 11, '2025-10-21 02:09:03', 1),
(31, 'upload', 'static_url_prefix', '/runtime/uploads', 'string', '静态文件URL前缀', '静态文件访问的URL路径前缀。例如：/runtime/uploads、/static、/files', NULL, '/runtime/uploads', 0, 0, 12, '2025-10-21 02:07:36', 1),
(32, 'upload', 'static_access_auth', '', 'boolean', '静态文件需要认证', '是否要求认证后才能访问静态文件（未来功能）', NULL, 'false', 0, 0, 13, '2025-10-21 02:07:36', 1),
(33, 'upload', 'static_allowed_types', 'jpg,jpeg,png,gif,webp,svg,pdf,mp4,mp3,zip,doc,docx,xls,xlsx', 'string', '静态访问允许的文件类型', '允许直接访问的文件扩展名，逗号分隔。留空表示允许所有类型。', NULL, '', 0, 0, 14, '2025-10-21 02:07:36', 1);

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_sys_dept`
--

CREATE TABLE `foadmin_sys_dept` (
  `id` bigint NOT NULL,
  `parent_id` bigint DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(64) DEFAULT NULL,
  `sort` int DEFAULT '0',
  `status` tinyint DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 转存表中的数据 `foadmin_sys_dept`
--

INSERT INTO `foadmin_sys_dept` (`id`, `parent_id`, `name`, `code`, `sort`, `status`) VALUES
(1, NULL, '总部', 'HQ', 0, 1),
(2, 1, '研发部', 'DEV', 1, 1),
(3, 1, '市场部', 'MARKET', 2, 1),
(4, 2, '后端组', 'BACKEND', 1, 1),
(5, 2, '前端组', 'FRONTEND', 2, 1),
(6, 3, '区域推广组', 'REGION', 1, 1);

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_sys_dict_data`
--

CREATE TABLE `foadmin_sys_dict_data` (
  `id` bigint NOT NULL COMMENT '字典数据ID',
  `type_code` varchar(128) NOT NULL COMMENT '字典类型编码',
  `label` varchar(128) NOT NULL COMMENT '字典标签（显示值）',
  `value` varchar(128) NOT NULL COMMENT '字典键值（实际值）',
  `tag_type` varchar(32) DEFAULT NULL COMMENT '标签类型：success/info/warning/danger/primary',
  `css_class` varchar(128) DEFAULT NULL COMMENT '自定义CSS类',
  `remark` text COMMENT '备注',
  `status` int DEFAULT '1' COMMENT '状态：1-启用，0-禁用',
  `sort` int DEFAULT '0' COMMENT '排序'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='数据字典数据表';

--
-- 转存表中的数据 `foadmin_sys_dict_data`
--

INSERT INTO `foadmin_sys_dict_data` (`id`, `type_code`, `label`, `value`, `tag_type`, `css_class`, `remark`, `status`, `sort`) VALUES
(1, 'sys_user_sex', '男', '1', 'primary', NULL, NULL, 1, 1),
(2, 'sys_user_sex', '女', '2', 'danger', NULL, NULL, 1, 2),
(3, 'sys_user_sex', '未知', '0', 'info', NULL, NULL, 1, 3),
(4, 'sys_status', '启用', '1', 'success', NULL, NULL, 1, 1),
(5, 'sys_status', '禁用', '0', 'danger', NULL, NULL, 1, 2),
(6, 'sys_notice_type', '通知', 'notice', 'primary', NULL, NULL, 1, 1),
(7, 'sys_notice_type', '公告', 'announcement', 'warning', NULL, NULL, 1, 2),
(8, 'sys_job_status', '正常', '1', 'success', NULL, NULL, 1, 1),
(9, 'sys_job_status', '暂停', '0', 'warning', NULL, NULL, 1, 2);

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_sys_dict_type`
--

CREATE TABLE `foadmin_sys_dict_type` (
  `id` bigint NOT NULL COMMENT '字典类型ID',
  `name` varchar(128) NOT NULL COMMENT '字典名称',
  `code` varchar(128) NOT NULL COMMENT '字典编码，唯一标识',
  `description` varchar(512) DEFAULT NULL COMMENT '字典描述',
  `status` int DEFAULT '1' COMMENT '状态：1-启用，0-禁用',
  `sort` int DEFAULT '0' COMMENT '排序'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='数据字典类型表';

--
-- 转存表中的数据 `foadmin_sys_dict_type`
--

INSERT INTO `foadmin_sys_dict_type` (`id`, `name`, `code`, `description`, `status`, `sort`) VALUES
(1, '用户性别', 'sys_user_sex', '用户性别列表', 1, 1),
(2, '系统状态', 'sys_status', '通用状态：启用/禁用', 1, 2),
(3, '通知类型', 'sys_notice_type', '系统通知类型', 1, 3),
(4, '任务状态', 'sys_job_status', '定时任务状态', 1, 4);

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_sys_job`
--

CREATE TABLE `foadmin_sys_job` (
  `id` bigint NOT NULL COMMENT '任务ID',
  `name` varchar(128) NOT NULL COMMENT '任务名称',
  `job_id` varchar(128) NOT NULL COMMENT '任务唯一标识',
  `job_type` varchar(32) NOT NULL COMMENT '任务类型：cron/interval/date',
  `func_name` varchar(256) NOT NULL COMMENT '执行函数路径',
  `func_args` text COMMENT '函数参数，JSON格式',
  `func_kwargs` text COMMENT '函数关键字参数，JSON格式',
  `cron_expression` varchar(128) DEFAULT NULL COMMENT 'cron表达式',
  `interval_seconds` int DEFAULT NULL COMMENT 'interval间隔秒数',
  `run_date` datetime DEFAULT NULL COMMENT 'date单次执行时间',
  `status` int DEFAULT '1' COMMENT '状态：1-启用，0-暂停',
  `description` varchar(512) DEFAULT NULL COMMENT '任务描述',
  `remark` text COMMENT '备注',
  `last_run_time` datetime DEFAULT NULL COMMENT '最后执行时间',
  `next_run_time` datetime DEFAULT NULL COMMENT '下次执行时间',
  `run_count` int DEFAULT '0' COMMENT '执行次数',
  `fail_count` int DEFAULT '0' COMMENT '失败次数',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务表';

--
-- 转存表中的数据 `foadmin_sys_job`
--

INSERT INTO `foadmin_sys_job` (`id`, `name`, `job_id`, `job_type`, `func_name`, `func_args`, `func_kwargs`, `cron_expression`, `interval_seconds`, `run_date`, `status`, `description`, `remark`, `last_run_time`, `next_run_time`, `run_count`, `fail_count`, `created_at`, `updated_at`) VALUES
(1, 'Hello任务', 'hello_task', 'interval', 'app.tasks.demo.hello_task', '[]', '{\"name\": \"Scheduler\"}', NULL, 60, NULL, 0, '每60秒执行一次的示例任务', NULL, '2025-10-22 01:20:19', NULL, 1, 0, '2025-10-22 00:53:35', '2025-10-22 01:20:19'),
(2, '清理旧日志', 'cleanup_logs', 'cron', 'app.tasks.demo.cleanup_old_logs', '[]', '{}', '0 2 * * *', NULL, NULL, 0, '每天凌晨2点清理30天前的任务日志', NULL, NULL, NULL, 0, 0, '2025-10-22 00:53:35', '2025-10-22 00:53:35'),
(3, '数据库备份', 'db_backup', 'cron', 'app.tasks.demo.database_backup', '[]', '{}', '0 3 * * 0', NULL, NULL, 0, '每周日凌晨3点执行数据库备份', NULL, NULL, NULL, 0, 0, '2025-10-22 00:53:35', '2025-10-22 00:53:35'),
(4, '发送日报', 'daily_report', 'cron', 'app.tasks.demo.send_daily_report', '[]', '{}', '0 9 * * 1-5', NULL, NULL, 0, '工作日每天上午9点发送日报', NULL, '2025-10-22 01:20:00', NULL, 1, 0, '2025-10-22 00:53:35', '2025-10-22 01:20:00');

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_sys_job_log`
--

CREATE TABLE `foadmin_sys_job_log` (
  `id` bigint NOT NULL COMMENT '日志ID',
  `job_id` varchar(128) NOT NULL COMMENT '任务ID',
  `job_name` varchar(128) NOT NULL COMMENT '任务名称',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `duration` int DEFAULT NULL COMMENT '执行耗时（毫秒）',
  `status` int NOT NULL COMMENT '状态：1-成功，0-失败',
  `result` text COMMENT '执行结果',
  `error` text COMMENT '错误信息',
  `traceback` text COMMENT '异常堆栈',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务执行日志表';

--
-- 转存表中的数据 `foadmin_sys_job_log`
--

INSERT INTO `foadmin_sys_job_log` (`id`, `job_id`, `job_name`, `start_time`, `end_time`, `duration`, `status`, `result`, `error`, `traceback`, `created_at`) VALUES
(1, 'daily_report', '发送日报', '2025-10-22 01:20:00', '2025-10-22 01:20:00', 0, 1, 'Daily report sent', NULL, NULL, '2025-10-22 01:20:00'),
(2, 'hello_task', 'Hello任务', '2025-10-22 01:20:19', '2025-10-22 01:20:19', 0, 1, 'Hello, Scheduler! Current time: 2025-10-22 01:20:19.095221', NULL, NULL, '2025-10-22 01:20:19');

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_sys_level`
--

CREATE TABLE `foadmin_sys_level` (
  `id` bigint NOT NULL,
  `name` varchar(64) NOT NULL,
  `code` varchar(64) NOT NULL,
  `weight` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 转存表中的数据 `foadmin_sys_level`
--

INSERT INTO `foadmin_sys_level` (`id`, `name`, `code`, `weight`) VALUES
(1, '一级', 'L1', 100),
(2, '二级', 'L2', 80),
(3, '三级', 'L3', 60);

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_sys_permission`
--

CREATE TABLE `foadmin_sys_permission` (
  `id` bigint NOT NULL COMMENT '权限ID，主键自增',
  `type` enum('menu','api','button') NOT NULL COMMENT '权限类型：menu-菜单，api-接口，button-按钮',
  `platform` varchar(10) DEFAULT NULL COMMENT '所属平台标识',
  `name` varchar(128) NOT NULL COMMENT '权限名称',
  `code` varchar(128) DEFAULT NULL COMMENT '权限编码，唯一标识',
  `method` varchar(10) DEFAULT NULL COMMENT 'HTTP方法（GET/POST/PUT/DELETE等），仅API类型需要',
  `path` varchar(255) DEFAULT NULL COMMENT 'API路径，仅API类型需要',
  `parent_id` bigint DEFAULT NULL COMMENT '父权限ID，用于构建权限树',
  `icon` varchar(64) DEFAULT NULL COMMENT '菜单图标',
  `route_name` varchar(64) DEFAULT NULL COMMENT '路由名称，前端使用',
  `route_path` varchar(255) DEFAULT NULL COMMENT '路由路径，前端使用',
  `route_component` varchar(128) DEFAULT NULL COMMENT '路由组件，前端使用',
  `route_cache` tinyint DEFAULT '0' COMMENT '是否缓存路由：1-是，0-否',
  `visible` tinyint DEFAULT '1' COMMENT '是否可见：1-是，0-否',
  `sort` int DEFAULT '0' COMMENT '排序字段，数字越小排序越靠前'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 转存表中的数据 `foadmin_sys_permission`
--

INSERT INTO `foadmin_sys_permission` (`id`, `type`, `platform`, `name`, `code`, `method`, `path`, `parent_id`, `icon`, `route_name`, `route_path`, `route_component`, `route_cache`, `visible`, `sort`) VALUES
(1000, 'menu', 'admin', '工作台', 'dashboard:view', NULL, NULL, NULL, 'Monitor', '', '', '', 0, 1, 1),
(1005, 'menu', 'admin', '企业中枢', 'central:view', NULL, NULL, NULL, 'Grid', 'central', '/central', 'dashboard/index', 0, 1, 6),
(1007, 'menu', 'admin', '超级中心', 'super:view', NULL, NULL, NULL, 'Coin', 'central-super', '/central/super', 'central/super/index', 0, 1, 9),
(1201, 'menu', 'admin', '企业组织', 'central-auth-org:view', NULL, NULL, 1005, NULL, 'central-auth-org', '/central/auth/org', 'dashboard/index', 0, 1, 0),
(1202, 'menu', 'admin', '角色管理', 'central-auth-org-role:view', NULL, NULL, 1201, NULL, 'central-auth-org-role', '/central/auth/org/role', 'central/org/role/index', 0, 1, 1),
(1203, 'menu', 'admin', '用户管理', 'central-auth-org-user:view', NULL, NULL, 1201, NULL, 'central-auth-org-user', '/central/auth/org/user', 'central/org/user/index', 0, 1, 2),
(1204, 'menu', 'admin', '目录管理', 'central-auth-org-catalog:view', NULL, NULL, 1201, NULL, 'central-auth-org-catalog', '/central/auth/org/catalog', 'central/org/catalog/index', 0, 1, 3),
(1205, 'menu', 'admin', '用户层级', 'central-auth-org-level:view', NULL, NULL, 1201, NULL, 'central-auth-org-level', '/central/auth/org/level', 'central/org/level/index', 0, 1, 4),
(1206, 'menu', 'admin', '组织管理', 'central-auth-org-orgmgmt:view', NULL, NULL, 1201, NULL, 'central-auth-org-orgmgmt', '/central/auth/org/orgmgmt', 'central/org/orgmgmt/index', 0, 1, 5),
(1700, 'menu', 'admin', '日志系统', 'central-auth-logs:view', NULL, NULL, 1005, NULL, 'central-auth-logs', '/central/auth/logs', 'dashboard/index', 0, 1, 6),
(1703, 'menu', 'admin', '登入日志', 'central-auth-logs-login:view', NULL, NULL, 1700, NULL, 'central-auth-logs-login', '/central/auth/logs/login', 'central/logs/login/index', 0, 1, 3),
(1800, 'menu', 'admin', '系统配置', 'central-auth-config:view', NULL, NULL, 1005, NULL, 'central-auth-config', '/central/auth/config', 'dashboard/index', 0, 1, 7),
(1806, 'menu', 'admin', '系统配置', 'system:config:view', NULL, NULL, 1800, NULL, 'central-auth-config-system', '/central/auth/config/system', 'central/config/index', 0, 1, 0),
(3001, 'api', 'admin', '用户列表', NULL, 'GET', '/api/admin/system/users', NULL, NULL, NULL, NULL, NULL, 0, 1, 0),
(3002, 'api', 'front', '示例前台接口', NULL, 'GET', '/api/front/hello', NULL, NULL, NULL, NULL, NULL, 0, 1, 0),
(3007, 'api', 'admin', '用户-新增', NULL, 'POST', '/api/admin/system/users', 1203, NULL, NULL, NULL, NULL, 0, 1, 10),
(3008, 'api', 'admin', '用户-修改', NULL, 'PUT', '/api/admin/system/users/{uid}', 1203, NULL, NULL, NULL, NULL, 0, 1, 11),
(3009, 'api', 'admin', '用户-删除', NULL, 'DELETE', '/api/admin/system/users/{uid}', 1203, NULL, NULL, NULL, NULL, 0, 1, 12),
(3010, 'api', 'admin', '用户-角色查询', NULL, 'GET', '/api/admin/system/users/{uid}/roles', 1203, NULL, NULL, NULL, NULL, 0, 1, 13),
(3011, 'api', 'admin', '用户-角色绑定', NULL, 'PUT', '/api/admin/system/users/{uid}/roles', 1203, NULL, NULL, NULL, NULL, 0, 1, 14),
(3012, 'api', 'admin', '角色-列表', NULL, 'GET', '/api/admin/system/roles', 1202, NULL, NULL, NULL, NULL, 0, 1, 20),
(3013, 'api', 'admin', '角色-新增', NULL, 'POST', '/api/admin/system/roles', 1202, NULL, NULL, NULL, NULL, 0, 1, 21),
(3014, 'api', 'admin', '角色-修改', NULL, 'PUT', '/api/admin/system/roles/{rid}', 1202, NULL, NULL, NULL, NULL, 0, 1, 22),
(3015, 'api', 'admin', '角色-删除', NULL, 'DELETE', '/api/admin/system/roles/{rid}', 1202, NULL, NULL, NULL, NULL, 0, 1, 23),
(3016, 'api', 'admin', '角色-权限查询', NULL, 'GET', '/api/admin/system/roles/{rid}/perms', 1202, NULL, NULL, NULL, NULL, 0, 1, 24),
(3017, 'api', 'admin', '角色-权限绑定', NULL, 'PUT', '/api/admin/system/roles/{rid}/perms', 1202, NULL, NULL, NULL, NULL, 0, 1, 25),
(3018, 'api', 'admin', '权限-列表', NULL, 'GET', '/api/admin/system/perms', 1204, NULL, NULL, NULL, NULL, 0, 1, 30),
(3019, 'api', 'admin', '权限-新增', NULL, 'POST', '/api/admin/system/perms', 1204, NULL, NULL, NULL, NULL, 0, 1, 31),
(3020, 'api', 'admin', '权限-修改', NULL, 'PUT', '/api/admin/system/perms/{pid}', 1204, NULL, NULL, NULL, NULL, 0, 1, 32),
(3021, 'api', 'admin', '权限-删除', NULL, 'DELETE', '/api/admin/system/perms/{pid}', 1204, NULL, NULL, NULL, NULL, 0, 1, 33),
(3022, 'api', 'admin', '层级-列表', NULL, 'GET', '/api/admin/system/levels', NULL, NULL, NULL, NULL, NULL, 0, 1, 10),
(3023, 'api', 'admin', '层级-新增', NULL, 'POST', '/api/admin/system/levels', NULL, NULL, NULL, NULL, NULL, 0, 1, 11),
(3024, 'api', 'admin', '层级-修改', NULL, 'PUT', '/api/admin/system/levels/{id}', NULL, NULL, NULL, NULL, NULL, 0, 1, 12),
(3025, 'api', 'admin', '层级-删除', NULL, 'DELETE', '/api/admin/system/levels/{id}', NULL, NULL, NULL, NULL, NULL, 0, 1, 13),
(3026, 'api', 'admin', '组织-树', NULL, 'GET', '/api/admin/system/orgs/tree', NULL, NULL, NULL, NULL, NULL, 0, 1, 10),
(3027, 'api', 'admin', '组织-新增', NULL, 'POST', '/api/admin/system/orgs', NULL, NULL, NULL, NULL, NULL, 0, 1, 11),
(3028, 'api', 'admin', '组织-修改', NULL, 'PUT', '/api/admin/system/orgs/{id}', NULL, NULL, NULL, NULL, NULL, 0, 1, 12),
(3029, 'api', 'admin', '组织-删除', NULL, 'DELETE', '/api/admin/system/orgs/{id}', NULL, NULL, NULL, NULL, NULL, 0, 1, 13),
(3031, 'menu', 'admin', '媒体库', 'media:view', NULL, NULL, 1005, 'Picture', 'media', '/central/media', 'central/media/index', 0, 1, 8),
(3032, 'button', 'admin', '上传', 'media:upload', NULL, NULL, 3031, NULL, NULL, NULL, NULL, 0, 1, 1),
(3033, 'button', 'admin', '删除', 'media:delete', NULL, NULL, 3031, NULL, NULL, NULL, NULL, 0, 1, 2),
(3034, 'button', 'admin', '重命名', 'media:rename', NULL, NULL, 3031, NULL, NULL, NULL, NULL, 0, 1, 3),
(3035, 'button', 'admin', '目录管理', 'media:dir', NULL, NULL, 3031, NULL, NULL, NULL, NULL, 0, 1, 4),
(3036, 'menu', 'admin', '操作日志', 'audit:log:view', NULL, NULL, 1700, 'Document', 'audit-log', '/central/auth/logs/audit', 'central/logs/audit/index', 0, 1, 4),
(3037, 'button', 'admin', '导出', 'audit:log:export', NULL, NULL, 3036, NULL, NULL, NULL, NULL, 0, 1, 1),
(3038, 'button', 'admin', '清理', 'audit:log:purge', NULL, NULL, 3036, NULL, NULL, NULL, NULL, 0, 1, 2),
(3039, 'button', 'admin', '查看详情', 'audit:log:detail', NULL, NULL, 3036, NULL, NULL, NULL, NULL, 0, 1, 3),
(3040, 'api', 'admin', '日志-列表', 'audit:log:list', 'GET', '/api/admin/audit/logs', 3036, NULL, NULL, NULL, NULL, 0, 1, 10),
(3041, 'api', 'admin', '日志-导出', 'audit:log:exportApi', 'GET', '/api/admin/audit/export', 3036, NULL, NULL, NULL, NULL, 0, 1, 11),
(3042, 'api', 'admin', '日志-详情', 'audit:log:detailApi', 'GET', '/api/admin/audit/logs/{id}', 3036, NULL, NULL, NULL, NULL, 0, 1, 12),
(3043, 'api', 'admin', '日志-清理', 'audit:log:purgeApi', 'DELETE', '/api/admin/audit/logs', 3036, NULL, NULL, NULL, NULL, 0, 1, 13),
(3057, 'api', 'admin', '登入日志-列表', 'login:log:list', 'GET', '/api/admin/logs/login', 1703, NULL, NULL, NULL, NULL, 0, 1, 10),
(3058, 'api', 'admin', '登入日志-导出', 'login:log:exportApi', 'GET', '/api/admin/logs/login/export', 1703, NULL, NULL, NULL, NULL, 0, 1, 11),
(3059, 'api', 'admin', '登入日志-详情', 'login:log:detailApi', 'GET', '/api/admin/logs/login/{id}', 1703, NULL, NULL, NULL, NULL, 0, 1, 12),
(3060, 'api', 'admin', '登入日志-清理', 'login:log:purgeApi', 'DELETE', '/api/admin/logs/login', 1703, NULL, NULL, NULL, NULL, 0, 1, 13),
(3061, 'button', 'admin', '导出', 'login:log:export', NULL, NULL, 1703, NULL, NULL, NULL, NULL, 0, 1, 1),
(3062, 'button', 'admin', '清理', 'login:log:purge', NULL, NULL, 1703, NULL, NULL, NULL, NULL, 0, 1, 2),
(3063, 'button', 'admin', '查看详情', 'login:log:detail', NULL, NULL, 1703, NULL, NULL, NULL, NULL, 0, 1, 3),
(3100, 'api', 'admin', '导入PDF', 'pdf:import', 'POST', '/api/convert/pdf', 3031, NULL, NULL, NULL, NULL, 0, 1, 5),
(3101, 'api', 'admin', '导入PPT', 'pptx:import', 'POST', '/api/convert/pptx', 3031, NULL, NULL, NULL, NULL, 0, 1, 6),
(3102, 'api', 'admin', '导入Word', 'docx:import', 'POST', '/api/convert/docx', 3031, NULL, NULL, NULL, NULL, 0, 1, 7),
(3200, 'button', 'admin', '编辑配置', 'system:config:edit', NULL, NULL, 1806, NULL, NULL, NULL, NULL, 0, 1, 1),
(3201, 'api', 'admin', '配置-列表', NULL, 'GET', '/api/admin/system/config', 1806, NULL, NULL, NULL, NULL, 0, 1, 10),
(3202, 'api', 'admin', '配置-新增', NULL, 'POST', '/api/admin/system/config', 1806, NULL, NULL, NULL, NULL, 0, 1, 11),
(3203, 'api', 'admin', '配置-更新', NULL, 'PUT', '/api/admin/system/config/{cid}', 1806, NULL, NULL, NULL, NULL, 0, 1, 12),
(3204, 'api', 'admin', '配置-删除', NULL, 'DELETE', '/api/admin/system/config/{cid}', 1806, NULL, NULL, NULL, NULL, 0, 1, 13),
(3205, 'api', 'admin', '配置-批量更新', NULL, 'POST', '/api/admin/system/config/batch', 1806, NULL, NULL, NULL, NULL, 0, 1, 14),
(3206, 'api', 'admin', '配置-获取公开', NULL, 'GET', '/api/admin/system/config/public', 1806, NULL, NULL, NULL, NULL, 0, 1, 15),
(3207, 'button', 'admin', '发送邮件', 'system:email:send', NULL, NULL, 1806, NULL, NULL, NULL, NULL, 0, 1, 10),
(3208, 'api', 'admin', '邮件-测试连接', 'email:test:connection', 'POST', '/api/admin/email/test-connection', 1806, NULL, NULL, NULL, NULL, 0, 1, 20),
(3209, 'api', 'admin', '邮件-发送测试', 'email:test:send', 'POST', '/api/admin/email/test-send', 1806, NULL, NULL, NULL, NULL, 0, 1, 21),
(3210, 'api', 'admin', '邮件-发送', 'email:send:api', 'POST', '/api/admin/email/send', 1806, NULL, NULL, NULL, NULL, 0, 1, 22),
(3211, 'api', 'admin', '邮件-模板发送', 'email:send:template', 'POST', '/api/admin/email/send-template', 1806, NULL, NULL, NULL, NULL, 0, 1, 23),
(3212, 'api', 'admin', '邮件-模板列表', 'email:templates:list', 'GET', '/api/admin/email/templates', 1806, NULL, NULL, NULL, NULL, 0, 1, 24),
(3213, 'menu', 'admin', '邮件管理', 'system:email:view', NULL, NULL, 1800, 'Message', 'central-auth-config-email', '/central/auth/config/email', 'central/email/index', 0, 1, 7),
(3214, 'menu', 'admin', '数据字典', 'dict:view', NULL, NULL, 1800, 'Collection', 'central-auth-config-dict', '/central/auth/config/dict', 'central/dict/index', 0, 1, 5),
(3215, 'button', 'admin', '新增类型', 'dict:type:add', NULL, NULL, 3214, NULL, NULL, NULL, NULL, 0, 1, 1),
(3216, 'button', 'admin', '编辑类型', 'dict:type:edit', NULL, NULL, 3214, NULL, NULL, NULL, NULL, 0, 1, 2),
(3217, 'button', 'admin', '删除类型', 'dict:type:delete', NULL, NULL, 3214, NULL, NULL, NULL, NULL, 0, 1, 3),
(3218, 'button', 'admin', '查看类型', 'dict:type:view', NULL, NULL, 3214, NULL, NULL, NULL, NULL, 0, 1, 4),
(3219, 'button', 'admin', '新增数据', 'dict:data:add', NULL, NULL, 3214, NULL, NULL, NULL, NULL, 0, 1, 5),
(3220, 'button', 'admin', '编辑数据', 'dict:data:edit', NULL, NULL, 3214, NULL, NULL, NULL, NULL, 0, 1, 6),
(3221, 'button', 'admin', '删除数据', 'dict:data:delete', NULL, NULL, 3214, NULL, NULL, NULL, NULL, 0, 1, 7),
(3222, 'button', 'admin', '查看数据', 'dict:data:view', NULL, NULL, 3214, NULL, NULL, NULL, NULL, 0, 1, 8),
(3223, 'api', 'admin', '字典类型-列表', NULL, 'GET', '/api/admin/system/dict/types', 3214, NULL, NULL, NULL, NULL, 0, 1, 10),
(3224, 'api', 'admin', '字典类型-新增', NULL, 'POST', '/api/admin/system/dict/types', 3214, NULL, NULL, NULL, NULL, 0, 1, 11),
(3225, 'api', 'admin', '字典类型-修改', NULL, 'PUT', '/api/admin/system/dict/types/{type_id}', 3214, NULL, NULL, NULL, NULL, 0, 1, 12),
(3226, 'api', 'admin', '字典类型-删除', NULL, 'DELETE', '/api/admin/system/dict/types/{type_id}', 3214, NULL, NULL, NULL, NULL, 0, 1, 13),
(3227, 'api', 'admin', '字典数据-列表', NULL, 'GET', '/api/admin/system/dict/data', 3214, NULL, NULL, NULL, NULL, 0, 1, 20),
(3228, 'api', 'admin', '字典数据-新增', NULL, 'POST', '/api/admin/system/dict/data', 3214, NULL, NULL, NULL, NULL, 0, 1, 21),
(3229, 'api', 'admin', '字典数据-修改', NULL, 'PUT', '/api/admin/system/dict/data/{data_id}', 3214, NULL, NULL, NULL, NULL, 0, 1, 22),
(3230, 'api', 'admin', '字典数据-删除', NULL, 'DELETE', '/api/admin/system/dict/data/{data_id}', 3214, NULL, NULL, NULL, NULL, 0, 1, 23),
(3231, 'api', 'admin', '字典数据-按编码获取', NULL, 'GET', '/api/admin/system/dict/data/by-code/{type_code}', 3214, NULL, NULL, NULL, NULL, 0, 1, 24),
(3232, 'menu', 'admin', '定时任务', 'job:menu', NULL, NULL, 1800, 'Timer', 'central-system-job', '/central/system/job', 'central/job/index', 0, 1, 10),
(3233, 'button', 'admin', '新增任务', 'job:add', NULL, NULL, 3232, NULL, NULL, NULL, NULL, 0, 1, 1),
(3234, 'button', 'admin', '编辑任务', 'job:edit', NULL, NULL, 3232, NULL, NULL, NULL, NULL, 0, 1, 2),
(3235, 'button', 'admin', '删除任务', 'job:delete', NULL, NULL, 3232, NULL, NULL, NULL, NULL, 0, 1, 3),
(3236, 'button', 'admin', '执行任务', 'job:run', NULL, NULL, 3232, NULL, NULL, NULL, NULL, 0, 1, 4),
(3237, 'button', 'admin', '查看日志', 'job:log:view', NULL, NULL, 3232, NULL, NULL, NULL, NULL, 0, 1, 5),
(3238, 'button', 'admin', '清理日志', 'job:log:delete', NULL, NULL, 3232, NULL, NULL, NULL, NULL, 0, 1, 6),
(3239, 'api', 'admin', '任务-列表', 'job:list', 'GET', '/api/admin/system/job/list', 3232, NULL, NULL, NULL, NULL, 0, 1, 10),
(3240, 'api', 'admin', '任务-新增', 'job:create', 'POST', '/api/admin/system/job/create', 3232, NULL, NULL, NULL, NULL, 0, 1, 11),
(3241, 'api', 'admin', '任务-修改', 'job:update', 'PUT', '/api/admin/system/job/update/{job_id}', 3232, NULL, NULL, NULL, NULL, 0, 1, 12),
(3242, 'api', 'admin', '任务-删除', 'job:del', 'DELETE', '/api/admin/system/job/delete/{job_id}', 3232, NULL, NULL, NULL, NULL, 0, 1, 13),
(3243, 'api', 'admin', '任务-暂停', 'job:pause', 'POST', '/api/admin/system/job/pause/{job_id}', 3232, NULL, NULL, NULL, NULL, 0, 1, 14),
(3244, 'api', 'admin', '任务-恢复', 'job:resume', 'POST', '/api/admin/system/job/resume/{job_id}', 3232, NULL, NULL, NULL, NULL, 0, 1, 15),
(3245, 'api', 'admin', '任务-立即执行', 'job:exec', 'POST', '/api/admin/system/job/run/{job_id}', 3232, NULL, NULL, NULL, NULL, 0, 1, 16),
(3246, 'api', 'admin', '日志-列表', 'job:log:list', 'GET', '/api/admin/system/job/logs', 3232, NULL, NULL, NULL, NULL, 0, 1, 20),
(3247, 'api', 'admin', '日志-清理', 'job:log:clear', 'DELETE', '/api/admin/system/job/logs/clear', 3232, NULL, NULL, NULL, NULL, 0, 1, 21),
(3248, 'menu', 'admin', '可视化分析', 'audit:log:visualization', NULL, NULL, 3036, 'DataAnalysis', 'audit-log-visualization', '/central/auth/logs/audit/visualization', 'central/logs/audit/visualization', 0, 1, 1),
(3249, 'button', 'admin', '查看图表', 'audit:log:visualization:view', NULL, NULL, 3248, NULL, NULL, NULL, NULL, 0, 1, 1),
(3250, 'api', 'admin', '可视化-列表', 'audit:log:visualization:list', 'GET', '/api/admin/audit/logs', 3248, NULL, NULL, NULL, NULL, 0, 1, 10),
(3251, 'menu', 'admin', '系统信息', 'system:about:view', '', '', 1000, 'Platform', 'central-about', '/central/about', 'central/about/index', 0, 1, 0),
(3252, 'menu', 'admin', '大屏统计', 'Statistical_Dashboard:view', '', '', 1000, '', 'dashboard', '/dashboard', 'dashboard/index', 0, 1, 0);

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_sys_role`
--

CREATE TABLE `foadmin_sys_role` (
  `id` bigint NOT NULL COMMENT '角色ID，主键自增',
  `code` varchar(64) NOT NULL COMMENT '角色编码，唯一标识',
  `name` varchar(64) NOT NULL COMMENT '角色名称',
  `status` tinyint DEFAULT '1' COMMENT '角色状态：1-启用，0-禁用',
  `sort` int DEFAULT '0' COMMENT '排序字段，数字越小排序越靠前'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 转存表中的数据 `foadmin_sys_role`
--

INSERT INTO `foadmin_sys_role` (`id`, `code`, `name`, `status`, `sort`) VALUES
(1, 'admin', '管理员', 1, 1),
(2, 'viewer', '观察者', 1, 2);

-- --------------------------------------------------------

--
-- 表的结构 `foadmin_sys_user`
--

CREATE TABLE `foadmin_sys_user` (
  `id` bigint NOT NULL COMMENT '用户ID，主键自增',
  `username` varchar(64) NOT NULL COMMENT '用户名，唯一登录标识',
  `password_hash` varchar(255) NOT NULL COMMENT '密码哈希值，存储加密后的密码',
  `nick_name` varchar(64) DEFAULT NULL COMMENT '用户昵称，显示名称',
  `avatar_file_id` bigint DEFAULT NULL COMMENT '头像文件ID，关联 media_file 表',
  `avatar_url` varchar(255) DEFAULT NULL COMMENT '自定义头像外链 URL',
  `dept_id` bigint DEFAULT NULL COMMENT '所属部门ID',
  `level_id` bigint DEFAULT NULL COMMENT '用户层级ID',
  `status` tinyint DEFAULT '1' COMMENT '用户状态：1-启用，0-禁用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统用户表';

--
-- 转存表中的数据 `foadmin_sys_user`
--

INSERT INTO `foadmin_sys_user` (`id`, `username`, `password_hash`, `nick_name`, `avatar_file_id`, `avatar_url`, `dept_id`, `level_id`, `status`) VALUES
(1, 'admin', '$pbkdf2-sha256$29000$dY4xBmAMgbD2PkeIMcaY8w$em7AnfO51yPmiMkpf/WBQMAlyKc490oiLT7wg44Zk6o', '超级管理员', 2, NULL, NULL, NULL, 1),
(2, 'demo', '$pbkdf2-sha256$29000$m7M2Zmxt7b1XSgkhxHjPuQ$tTN1HgU5ZglScxC57y9kl5TfXe7imgkaWhYZINq01/s', 'demo', NULL, NULL, 1, 1, 1);

--
-- 转储表的索引
--

--
-- 表的索引 `foadmin_audit_log`
--
ALTER TABLE `foadmin_audit_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_time` (`created_at`),
  ADD KEY `idx_actor` (`actor_id`),
  ADD KEY `idx_res` (`resource_type`,`resource_id`),
  ADD KEY `idx_trace` (`trace_id`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `foadmin_login_log`
--
ALTER TABLE `foadmin_login_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_time` (`created_at`),
  ADD KEY `idx_actor` (`actor_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_trace` (`trace_id`),
  ADD KEY `idx_actor_name` (`actor_name`),
  ADD KEY `idx_ip` (`ip`);

--
-- 表的索引 `foadmin_media_audit`
--
ALTER TABLE `foadmin_media_audit`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_file` (`file_id`);

--
-- 表的索引 `foadmin_media_convert_cache`
--
ALTER TABLE `foadmin_media_convert_cache`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `foadmin_media_dir`
--
ALTER TABLE `foadmin_media_dir`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_dir_parent_name` (`parent_id`,`name`);

--
-- 表的索引 `foadmin_media_file`
--
ALTER TABLE `foadmin_media_file`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_sha256_size` (`sha256`,`size`),
  ADD KEY `idx_dir` (`dir_id`),
  ADD KEY `idx_uploader` (`uploader_id`);

--
-- 表的索引 `foadmin_media_tag`
--
ALTER TABLE `foadmin_media_tag`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- 表的索引 `foadmin_rel_media_file_tag`
--
ALTER TABLE `foadmin_rel_media_file_tag`
  ADD PRIMARY KEY (`file_id`,`tag_id`);

--
-- 表的索引 `foadmin_rel_role_perm`
--
ALTER TABLE `foadmin_rel_role_perm`
  ADD PRIMARY KEY (`role_id`,`perm_id`);

--
-- 表的索引 `foadmin_rel_user_role`
--
ALTER TABLE `foadmin_rel_user_role`
  ADD PRIMARY KEY (`user_id`,`role_id`);

--
-- 表的索引 `foadmin_sys_config`
--
ALTER TABLE `foadmin_sys_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_config_key` (`key`),
  ADD KEY `idx_category` (`category`);

--
-- 表的索引 `foadmin_sys_dept`
--
ALTER TABLE `foadmin_sys_dept`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_dept_code` (`code`);

--
-- 表的索引 `foadmin_sys_dict_data`
--
ALTER TABLE `foadmin_sys_dict_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_type_value` (`type_code`,`value`),
  ADD KEY `idx_type_code` (`type_code`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `foadmin_sys_dict_type`
--
ALTER TABLE `foadmin_sys_dict_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_code` (`code`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `foadmin_sys_job`
--
ALTER TABLE `foadmin_sys_job`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_job_id` (`job_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_job_type` (`job_type`);

--
-- 表的索引 `foadmin_sys_job_log`
--
ALTER TABLE `foadmin_sys_job_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_job_id` (`job_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- 表的索引 `foadmin_sys_level`
--
ALTER TABLE `foadmin_sys_level`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_level_code` (`code`);

--
-- 表的索引 `foadmin_sys_permission`
--
ALTER TABLE `foadmin_sys_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD UNIQUE KEY `code_2` (`code`);

--
-- 表的索引 `foadmin_sys_role`
--
ALTER TABLE `foadmin_sys_role`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD UNIQUE KEY `code_2` (`code`);

--
-- 表的索引 `foadmin_sys_user`
--
ALTER TABLE `foadmin_sys_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `username_2` (`username`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `foadmin_audit_log`
--
ALTER TABLE `foadmin_audit_log`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID', AUTO_INCREMENT=1197;

--
-- 使用表AUTO_INCREMENT `foadmin_login_log`
--
ALTER TABLE `foadmin_login_log`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID', AUTO_INCREMENT=204;

--
-- 使用表AUTO_INCREMENT `foadmin_media_audit`
--
ALTER TABLE `foadmin_media_audit`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- 使用表AUTO_INCREMENT `foadmin_media_convert_cache`
--
ALTER TABLE `foadmin_media_convert_cache`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `foadmin_media_dir`
--
ALTER TABLE `foadmin_media_dir`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `foadmin_media_file`
--
ALTER TABLE `foadmin_media_file`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- 使用表AUTO_INCREMENT `foadmin_media_tag`
--
ALTER TABLE `foadmin_media_tag`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `foadmin_sys_config`
--
ALTER TABLE `foadmin_sys_config`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置ID', AUTO_INCREMENT=34;

--
-- 使用表AUTO_INCREMENT `foadmin_sys_dept`
--
ALTER TABLE `foadmin_sys_dept`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- 使用表AUTO_INCREMENT `foadmin_sys_dict_data`
--
ALTER TABLE `foadmin_sys_dict_data`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典数据ID', AUTO_INCREMENT=11;

--
-- 使用表AUTO_INCREMENT `foadmin_sys_dict_type`
--
ALTER TABLE `foadmin_sys_dict_type`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典类型ID', AUTO_INCREMENT=5;

--
-- 使用表AUTO_INCREMENT `foadmin_sys_job`
--
ALTER TABLE `foadmin_sys_job`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID', AUTO_INCREMENT=5;

--
-- 使用表AUTO_INCREMENT `foadmin_sys_job_log`
--
ALTER TABLE `foadmin_sys_job_log`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID', AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `foadmin_sys_level`
--
ALTER TABLE `foadmin_sys_level`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `foadmin_sys_permission`
--
ALTER TABLE `foadmin_sys_permission`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '权限ID，主键自增', AUTO_INCREMENT=3253;

--
-- 使用表AUTO_INCREMENT `foadmin_sys_role`
--
ALTER TABLE `foadmin_sys_role`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID，主键自增', AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `foadmin_sys_user`
--
ALTER TABLE `foadmin_sys_user`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID，主键自增', AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
