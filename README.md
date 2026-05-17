# PhamMinhTai_IT202_Session13_bai3

# [Vận dụng nâng cao] - Kiểm soát và lưu lịch sử biến động giá thuốc

## 1. Mô tả vấn đề

Phòng khám thường xuyên thay đổi giá thuốc trong bảng `Medicines`.

Ban quản lý yêu cầu:

- Khi giá thuốc thay đổi phải tự động lưu lịch sử.
- Ghi nhận:
  - Giá cũ
  - Giá mới
  - Trạng thái tăng/giảm
  - Số tiền chênh lệch

Ngoài ra:

- Nếu chỉ cập nhật tồn kho hoặc tên thuốc thì không được sinh log.
- Nếu nhập giá mới <= 0 thì phải chặn cập nhật và báo lỗi.

---

# 2. Phân tích giải pháp

## Bảng log cần lưu

Bảng `Price_Changes_Log` dùng để lưu:

- Mã thuốc
- Giá cũ
- Giá mới
- Loại thay đổi
- Số tiền chênh lệch
- Thời gian thay đổi

---

## Trigger nên dùng

```sql id="j7d2ps"
BEFORE UPDATE
