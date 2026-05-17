
USE RikkeiClinicDB;

CREATE TABLE IF NOT EXISTS Price_Changes_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT,
    old_price DECIMAL(18,2),
    new_price DECIMAL(18,2),
    change_type VARCHAR(20),
    difference_amount DECIMAL(18,2),
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


DROP TRIGGER IF EXISTS TrackMedicinePriceChanges;

DELIMITER //

CREATE TRIGGER TrackMedicinePriceChanges
BEFORE UPDATE ON Medicines
FOR EACH ROW
BEGIN


    IF NEW.price <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Loi: Gia thuoc moi khong hop le';

    END IF;


    IF NEW.price > OLD.price THEN

        INSERT INTO Price_Changes_Log (
            medicine_id,
            old_price,
            new_price,
            change_type,
            difference_amount
        )
        VALUES (
            OLD.medicine_id,
            OLD.price,
            NEW.price,
            'TANG GIA',
            NEW.price - OLD.price
        );

    END IF;


    IF NEW.price < OLD.price THEN

        INSERT INTO Price_Changes_Log (
            medicine_id,
            old_price,
            new_price,
            change_type,
            difference_amount
        )
        VALUES (
            OLD.medicine_id,
            OLD.price,
            NEW.price,
            'GIAM GIA',
            OLD.price - NEW.price
        );

    END IF;

END //

DELIMITER ;


-- =====================================================
-- PHẦN D: KIỂM THỬ
-- =====================================================

-- =====================================================
-- TEST 1: Tăng giá hợp lệ
-- =====================================================

UPDATE Medicines
SET price = 20000
WHERE medicine_id = 1;


-- =====================================================
-- TEST 2: Giảm giá hợp lệ
-- =====================================================

UPDATE Medicines
SET price = 12000
WHERE medicine_id = 1;


-- =====================================================
-- TEST 3: Cập nhật tồn kho
-- Giá không đổi -> không sinh log
-- =====================================================

UPDATE Medicines
SET stock = 300
WHERE medicine_id = 1;


-- =====================================================
-- TEST 4: Giá âm -> phải bị chặn
-- =====================================================

UPDATE Medicines
SET price = -5000
WHERE medicine_id = 1;


-- =====================================================
-- XEM LOG
-- =====================================================

SELECT *
FROM Price_Changes_Log;