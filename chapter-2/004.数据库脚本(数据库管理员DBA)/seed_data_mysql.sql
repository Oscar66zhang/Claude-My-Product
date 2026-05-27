-- ============================================
-- 轻账本 Light Account Book - MySQL 初始化数据
-- ============================================
-- 版本: v1.0.1
-- 创建日期: 2026-05-27
-- 说明: 预设分类、默认预算等初始化数据
-- ============================================

USE light_account_book;

-- ============================================
-- 一、预设分类 (支出)
-- ============================================
INSERT INTO categories (id, name, icon, type, parent_id, display_order, is_system) VALUES
-- 餐饮 (一级分类)
('food', '餐饮', 'restaurant', 'expense', NULL, 10, 1),
-- 餐饮子分类
('food_breakfast', '早餐', 'cafe', 'expense', 'food', 11, 1),
('food_lunch', '午餐', 'lunch_dining', 'expense', 'food', 12, 1),
('food_dinner', '晚餐', 'dinner_dining', 'expense', 'food', 13, 1),
('food_snack', '下午茶', 'cake', 'expense', 'food', 14, 1),
('food_other', '零食', 'cookie', 'expense', 'food', 15, 1),

-- 交通 (一级分类)
('transport', '交通', 'directions_bus', 'expense', NULL, 20, 1),
-- 交通子分类
('transport_taxi', '打车', 'local_taxi', 'expense', 'transport', 21, 1),
('transport_subway', '地铁', 'subway', 'expense', 'transport', 22, 1),
('transport_bus', '公交', 'directions_bus', 'expense', 'transport', 23, 1),
('transport_parking', '停车', 'local_parking', 'expense', 'transport', 24, 1),
('transport_gas', '油费', 'gas_station', 'expense', 'transport', 25, 1),

-- 购物 (一级分类)
('shopping', '购物', 'shopping_bag', 'expense', NULL, 30, 1),
-- 购物子分类
('shopping_clothing', '服装', 'checkroom', 'expense', 'shopping', 31, 1),
('shopping_electronics', '电子产品', 'devices', 'expense', 'shopping', 32, 1),
('shopping_daily', '日用品', 'soap', 'expense', 'shopping', 33, 1),
('shopping_cosmetics', '化妆品', 'face_retouching', 'expense', 'shopping', 34, 1),

-- 居住 (一级分类)
('living', '居住', 'home', 'expense', NULL, 40, 1),
-- 居住子分类
('living_rent', '房租', 'house', 'expense', 'living', 41, 1),
('living_utilities', '水电煤', 'electrical_services', 'expense', 'living', 42, 1),
('living_property', '物业', 'property_management', 'expense', 'living', 43, 1),
('living_repair', '维修', 'handyman', 'expense', 'living', 44, 1),

-- 娱乐 (一级分类)
('entertainment', '娱乐', 'sports_esports', 'expense', NULL, 50, 1),
-- 娱乐子分类
('entertainment_movie', '电影', 'movie', 'expense', 'entertainment', 51, 1),
('entertainment_game', '游戏', 'sports_esports', 'expense', 'entertainment', 52, 1),
('entertainment_travel', '旅游', 'flight', 'expense', 'entertainment', 53, 1),
('entertainment_show', '演出', 'confirmation_number', 'expense', 'entertainment', 54, 1),

-- 医疗 (一级分类)
('medical', '医疗', 'medical_services', 'expense', NULL, 60, 1),
-- 医疗子分类
('medical_clinic', '门诊', 'local_hospital', 'expense', 'medical', 61, 1),
('medical_pharmacy', '药品', 'medication', 'expense', 'medical', 62, 1),
('medical_checkup', '体检', 'health_and_safety', 'expense', 'medical', 63, 1),

-- 教育 (一级分类)
('education', '教育', 'school', 'expense', NULL, 70, 1),
-- 教育子分类
('education_book', '书籍', 'menu_book', 'expense', 'education', 71, 1),
('education_course', '课程', 'school', 'expense', 'education', 72, 1),
('education_training', '培训', 'terminal', 'expense', 'education', 73, 1),

-- 其他 (一级分类)
('other', '其他', 'more_horiz', 'expense', NULL, 90, 1),
-- 其他子分类
('other_social', '社交', 'diversity_3', 'expense', 'other', 91, 1),
('other_donation', '捐赠', 'volunteer_activism', 'expense', 'other', 92, 1),
('other_loss', '意外丢失', 'report', 'expense', 'other', 93, 1);

-- ============================================
-- 二、预设分类 (收入)
-- ============================================
INSERT INTO categories (id, name, icon, type, parent_id, display_order, is_system) VALUES
-- 工资
('salary', '工资', 'payments', 'income', NULL, 10, 1),

-- 奖金
('bonus', '奖金', 'card_giftcard', 'income', NULL, 20, 1),

-- 投资
('investment', '投资', 'trending_up', 'income', NULL, 30, 1),
-- 投资子分类
('investment_stock', '股票', 'show_chart', 'income', 'investment', 31, 1),
('investment_fund', '基金', 'area_chart', 'income', 'investment', 32, 1),
('investment_interests', '利息', 'savings', 'income', 'investment', 33, 1),

-- 礼金
('gift', '礼金', 'redeem', 'income', NULL, 40, 1),
-- 礼金子分类
('gift_red', '红包', 'redeem', 'income', 'gift', 41, 1),
('gift_wedding', '礼金', 'card_giftcard', 'income', 'gift', 42, 1),

-- 其他收入
('income_other', '其他', 'more_horiz', 'income', NULL, 90, 1);

-- ============================================
-- 三、应用配置
-- ============================================
INSERT INTO app_config (config_key, value, description) VALUES
('default_currency', '"CNY"', '默认货币 CNY=人民币 USD=美元'),
('default_monthly_budget', '5000', '默认月预算金额'),
('version', '"1.0.1"', '数据库版本号');