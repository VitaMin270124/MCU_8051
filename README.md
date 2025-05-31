# Máy Tính Đơn Giản Sử Dụng Vi Điều Khiển 8051
Đây là một dự án máy tính đơn giản được xây dựng dựa trên vi điều khiển 8051, sử dụng bàn phím ma trận 4x4 để nhập dữ liệu và màn hình LCD 16x2 để hiển thị kết quả. Dự án có thể thực hiện các phép tính cơ bản như:
- Cộng (+)
- Trừ (−)
- Nhân (×)
- Chia (÷)
# 📦 Thành Phần Phần Cứng
Vi điều khiển 8051 là một trong những dòng vi điều khiển 8-bit phổ biến nhất được sử dụng trong hệ thống nhúng, tự động hóa, thiết bị điện tử và các ứng dụng nhúng nhỏ gọn. Nó được phát triển lần đầu tiên bởi Intel vào năm 1980, và đến nay có nhiều biến thể được sản xuất bởi các hãng như Atmel (nay là Microchip), STC, Nuvoton, Silicon Labs,…

## Các thành phần
| Thiết Bị           | Mô Tả                                       |
| ------------------ | ------------------------------------------- |
| Vi điều khiển 8051 | Dùng AT89S52 hoặc tương đương               |
| Keypad 4x4         | Bàn phím ma trận 16 phím (0-9, A-D, \*, #)  |
| LCD 16x2           | Màn hình hiển thị 2 dòng, 16 ký tự mỗi dòng |
| Điện trở, dây nối  | Cho kết nối các linh kiện                   |
| Breadboard / PCB   | Gắn mạch                                    |

## Tần số
- 12 MHz Crystal Oscillator
# 🔌 Sơ Đồ Kết Nối
## Kết Nối Keypad 4x4
Keypad có 8 chân: 4 hàng (R1–R4), 4 cột (C1–C4)

Kết nối các chân keypad với các chân GPIO của vi điều khiển (ví dụ: P2.0–P2.7)
## Kết Nối LCD 16x2 (Chế độ 4-bit)
RS → P1.0

RW → P1.1

EN → P1.2

D4 → P3.4

D5 → P3.5

D6 → P3.6

D7 → P3.7

VSS → GND, VDD → 5V, VO → chiết áp điều chỉnh độ tương phản

# 🧾 Nguyên Lý Hoạt Động
1. Người dùng nhập số và toán tử thông qua keypad (VD: 1, +, 2, =)

2. Vi điều khiển đọc và xử lý tín hiệu từ keypad

3. Thực hiện phép tính, sau đó hiển thị kết quả trên LCD

4. Hỗ trợ nhập tối đa 2 số và 1 phép toán mỗi lần tính

# 🛠 Công Cụ Phát Triển
Keil uVision: Biên dịch mã C cho 8051

Proteus: Mô phỏng mạch (keypad, LCD, 8051)

STC-ISP hoặc USBASP: Nạp code vào vi điều khiển thực tế

# 📚 Tham Khảo
[Tài liệu vi điều khiển 8051 của Intel](https://www.alldatasheet.com/view.jsp?Searchword=At89s52&gad_source=1&gad_campaignid=170327939&gbraid=0AAAAADcdDU-NQS6BKdJsWmEn4WiOAVgIA&gclid=Cj0KCQjw0erBBhDTARIsAKO8iqRABw4MM1R34fyiPTWJ92ijF3yuD07OgrMnrm-s3OCnfmoTCoslpCkaAlOzEALw_wcB)


[Datasheet LCD 1602](https://www.vishay.com/docs/37484/lcd016n002bcfhet.pdf)

[Các sơ đồ kết nối keypad 4x4](https://cdn.sparkfun.com/assets/f/f/a/5/0/DS-16038.pdf)
