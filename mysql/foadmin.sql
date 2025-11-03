-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2025-11-03 20:01:53
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
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID';

--
-- 使用表AUTO_INCREMENT `foadmin_login_log`
--
ALTER TABLE `foadmin_login_log`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID';

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
