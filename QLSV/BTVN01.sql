-- BÀI TẬP TRUY VẤN
-- 4.1 Cho biết danh sách sinh viên khoa 'Công nghệ thông tin' khóa 2002-2006
SELECT SV.*
FROM Lop L, SinhVien SV, KhoaHoc KH
WHERE L.maKhoa = 'CNTT' AND KH.namBatDau = '2002' AND KH.namKetThuc = '2006'
AND SV.maLop = L.ma AND KH.ma = L.maKhoaHoc
-- 4.2 Cho biết các sinh viên(MSSV, Họ tên, Năm sinh) của các sinh viên học sớm hơn tuổi quy định
--(theo tuổi quy định thì sinh viên đủ 18 tuổi khi bắt đầu khóa học)
SELECT SV.ma, SV.hoTen, SV.namSinh
FROM SinhVien SV, KhoaHoc KH, Lop L
WHERE (KH.namBatDau - SV.namSinh < 18) 
AND SV.maLop = L.ma AND KH.ma = L.maKhoaHoc
--4.3 Cho biết sinh viên khoa CNTT, khóa 2002-2006 chưa học môn cấu trúc dữ liệu 1
SELECT SV.*
FROM SinhVien SV, KhoaHoc KH, Lop L, KetQua KQ
WHERE L.maKhoa = 'CNTT' AND KH.namBatDau = '2002' AND KH.namKetThuc = '2006'
AND SV.maLop = L.ma AND KH.ma = L.maKhoaHoc AND SV.ma = KQ.maSinhVien 
AND SV.ma NOT IN (SELECT KQ1.maSinhVien FROM KetQua KQ1 WHERE KQ1.maMonHoc = N'THCS01') 
-- 4.4 Cho biết sinh viên thi không đậu môn Cấu trúc dữ liệu 1 nhưng chưa thi lại
SELECT SV.*
FROM SinhVien SV, KetQua KQ
WHERE SV.ma = KQ.maSinhVien
AND KQ.maMonHoc = N'THCS01' AND KQ.diem < 5 AND KQ.lanThi < 2
-- 4.5 Với mỗi lớp thuộc khoa CNTT, cho biết mã lớp, mã khóa học, tên chương trình và số sinh viên thuộc lớp đó. 
SELECT L.ma, L.maKhoaHoc, CT.tenChuongTrinh, count(sv.maLop) AS SoLuongSinhVien
FROM Lop L, ChuongTrinh CT, SinhVien SV
WHERE L.maChuongTrinh = CT.ma AND SV.maLop = L.ma
AND L.maKhoa = 'CNTT'
GROUP BY L.ma, L.maKhoaHoc, CT.tenChuongTrinh
-- 4.6 Cho biết điểm trung bình của sinh viên có mã số 0212003 (điểm trung bình chỉ tính trên lần thi sau cùng của sinh viên)
SELECT AVG(KQ.diem) AS DiemTrungBinh
FROM KETQUA KQ
WHERE KQ.maSinhVien = '0212003'

-- BÀI TẬP FUNCTION	
-- 5.1 Với 1 mã sinh viên và 1 mã khoa, kiểm tra xem sinh viên có thuộc khoa này hay không (trả về đúng hoặc sai)
GO
ALTER FUNCTION F_KiemTra (@maSV varchar(10), @maKhoa varchar(10))
RETURNS BIT
AS
BEGIN 
	DECLARE @hopLe int
	SET @hopLe = 1
	-- Kiểm tra xem mã sinh viên có tồn tại hay không
	IF NOT EXISTS (SELECT * FROM SinhVien WHERE @maSV = ma)
		RETURN 0
	-- Kiểm tra xem mã khoa có tồn tại hay không
	IF NOT EXISTS (SELECT * FROM Khoa WHERE @maKhoa = ma)
		RETURN 0
	-- Kiểm tra sinh viên có thuộc khoa này không 
	/**Code Here**/

	RETURN 1
END
GO

-- 5.2 Tính điểm thi sau cùng của một sinh viên trong một môn học cụ thể
GO
CREATE FUNCTION F_TinhDiemTB (@maSV varchar(10), @maMH varchar(10))
RETURNS FLOAT
AS
BEGIN
	RETURN 1
END
GO
-- 5.3 Tính điểm trung bình của sinh viên (điểm trung bình dựa vào lần thi sau cùng), sử dụng function đã viết ở 5.2
-- 5.4 Nhập vào một sinh viên và một môn học, trả về điểm thi của sinh viên này trong các lần thi của môn học đó
-- 5.5 Nhập vào một sinh viên, trả về danh sách các môn học mà sinh viên này phải học 

-- BÀI TẬP STORED PROCEDURE
-- 6.1 In danh sách các sinh viên của một lớp học
GO 
CREATE PROCEDURE USP_InDanhSachSV
	@maLop varchar(10)
AS
BEGIN 
	SELECT SV.*
	FROM SinhVien SV
	WHERE @maLop = SV.maLop
END
GO 
EXEC USP_InDanhSachSV 'TH2002/02'
-- 6.2 Nhập vào 2 sinh viên, 1 môn học. Tìm xem sinh viên nào có điểm thi môn học lần đầu tiên là cao hơn
GO
ALTER PROCEDURE USP_TimSVDiemCaoHon
	@maSV1 varchar(10), @maSV2 varchar(10), @maMH varchar(10)
AS
BEGIN
	IF(SELECT diem FROM KetQua WHERE @maSV1 = maSinhVien AND @maMH = maMonHoc AND lanThi = 1) < (SELECT diem FROM KetQua WHERE @maSV2 = maSinhVien AND @maMH = maMonHoc AND lanThi = 1)
		PRINT N'Sinh viên có mã ' + @maSV1 + N' có điểm thi môn '+ @maMH  + N' cao hơn'
	ELSE 
		PRINT N'Sinh viên có mã ' + @maSV1 + N' có điểm thi môn '+ @maMH  + N' cao hơn'
END
GO
EXEC USP_TimSVDiemCaoHon '0212001', '0212003', 'THT02'
-- 6.3 Nhập vào 1 môn học và 1 mã sinh viên. Kiểm tra sinh viên có đậu môn này trong lần đầu tiên không. Nếu đậu thì xuất ra "Đậu", nếu không thì xuất ra "Không đậu"
-- 6.4 Nhập vào một khoa, in danh sách các sinh viên(mã sinh viên, họ tên, ngày sinh) thuộc khoa này
-- 6.5 Nhập vào một sinh viên và một môn học, in điểm thi của sinh viên này của các lần thi
-- 6.6 Nhập vào một sinh viên, in ra các môn học mà sinh viên này phải học
-- 6.7 Nhập vào một môn học, in danh sách các sinh viên đậu môn này trong lần thi đầu tiên
-- 6.8 In điểm các môn học của sinh viên có mã số là maSinhVien được nhập vào (điểm môn học là điểm của lần thi sau cùng)
