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
SELECT SV.ma, SV.hoTen, SV.namSinh, COUNT(*) AS soLanThi 
FROM SinhVien SV, KetQua KQ, MonHoc MH
WHERE SV.ma = KQ.maSinhVien AND MH.ma = KQ.maMonHoc
AND MH.tenMonHoc LIKE N'Cấu trúc dữ liệu 1' AND KQ.diem < 5
GROUP BY SV.ma, SV.hoTen, SV.namSinh
HAVING COUNT(*) = 1
-- 4.5 Với mỗi lớp thuộc khoa CNTT, cho biết mã lớp, mã khóa học, tên chương trình và số sinh viên thuộc lớp đó. 
SELECT L.ma, L.maKhoaHoc, CT.tenChuongTrinh, count(sv.maLop) AS SoLuongSinhVien
FROM Lop L, ChuongTrinh CT, SinhVien SV
WHERE L.maChuongTrinh = CT.ma AND SV.maLop = L.ma
AND L.maKhoa = 'CNTT'
GROUP BY L.ma, L.maKhoaHoc, CT.tenChuongTrinh
-- 4.6 Cho biết điểm trung bình của sinh viên có mã số 0212003 (điểm trung bình chỉ tính trên lần thi sau cùng của sinh viên)
SELECT AVG(KQ.diem) AS DiemTB
FROM KetQua KQ
WHERE KQ.maSinhVien = '0212003'
AND KQ.lanThi = (SELECT MAX(KQ1.lanThi) FROM KetQua KQ1 WHERE KQ1.maMonHoc = KQ.maMonHoc AND KQ1.maSinhVien = KQ.maSinhVien)
-- BÀI TẬP FUNCTION	
-- 5.1 Với 1 mã sinh viên và 1 mã khoa, kiểm tra xem sinh viên có thuộc khoa này hay không (trả về đúng hoặc sai)
GO
CREATE FUNCTION F_KiemTraSV (@maSV varchar(10), @maKhoa varchar(10))
RETURNS BIT
AS
BEGIN 
	IF EXISTS (SELECT * FROM SinhVien SV, Khoa K, Lop L WHERE SV.ma = @maSV and K.ma = @maKhoa AND L.ma = SV.maLop AND L.maKhoa = K.ma)
		RETURN 1  -- True
	RETURN 0      -- False
END
GO
SELECT dbo.F_KiemTraSV('0212001', 'CNTT') -- True
SELECT dbo.F_KiemTraSV('0212002', 'VL')   -- False
-- 5.2 Tính điểm thi sau cùng của một sinh viên trong một môn học cụ thể
GO
-- ALTER
CREATE FUNCTION F_TinhDiemThi (@maSV varchar(10), @maMH varchar(10))
RETURNS FLOAT
AS
BEGIN
	DECLARE @diem float
	SET @diem = 0

	SELECT @diem = KQ.diem FROM KetQua KQ 
	WHERE @maSV = KQ.maSinhVien AND @maMH = KQ.maMonHoc
	ORDER BY KQ.lanThi DESC

	RETURN @diem
END
GO
SELECT dbo.F_TinhDiemThi('0212001', 'THCS01')
-- 5.3 Tính điểm trung bình của sinh viên (điểm trung bình dựa vào lần thi sau cùng), sử dụng function đã viết ở 5.2
GO
ALTER FUNCTION F_TinhDiemTB (@maSV varchar(10))
RETURNS FLOAT
AS
BEGIN
	DECLARE @diemTB FLOAT
	SET @diemTB = 0
	SELECT @diemTB = avg(dbo.F_TinhDiemThi(@maSV, KQ.maMonHoc)) 
	FROM KetQua KQ
	WHERE KQ.maSinhVien = @maSV

	RETURN @diemTB
END 
GO
SELECT dbo.F_TinhDiemTB('0212001')
-- 5.4 Nhập vào một sinh viên và một môn học, trả về điểm thi của sinh viên này trong các lần thi của môn học đó
GO
CREATE FUNCTION F_InRaDiemTheoLanThi (@maSV varchar(10), @maMH varchar(10))
RETURNS TABLE
AS
	RETURN SELECT KQ.lanThi, KQ.diem FROM KetQua KQ
		   WHERE @maSV = KQ.maSinhVien and @maMH = KQ.maMonHoc
GO
SELECT * FROM dbo.F_InRaDiemTheoLanThi('0212001', 'THT01')
-- 5.5 Nhập vào một sinh viên, trả về danh sách các môn học mà sinh viên này phải học 
GO
CREATE FUNCTION F_InDanhSachMonHoc (@maSV varchar(10))
RETURNS TABLE
AS
	RETURN 
		SELECT MH.tenMonHoc 
		FROM MonHoc MH
		LEFT JOIN Khoa K ON MH.maKhoa = K.ma
		LEFT JOIN Lop L ON L.maKhoa = K.ma
		LEFT JOIN ChuongTrinh CT ON CT.ma = L.maChuongTrinh
		LEFT JOIN KhoaHoc KH ON KH.ma = L.maKhoaHoc
		LEFT JOIN SinhVien SV ON SV.maLop = L.ma
		WHERE @maSV = SV.ma
GO
SELECT * FROM dbo.F_InDanhSachMonHoc('0212001')
-- BÀI TẬP STORED PROCEDURE
-- 6.1 In danh sách các sinh viên của một lớp học
GO 
ALTER PROCEDURE USP_InDanhSachSV
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
-- 6.3 Nhập vào 1 môn học và 1 mã sinh viên. Kiểm tra sinh viên có đậu môn này trong lần đầu tiên không. 
--Nếu đậu thì xuất ra "Đậu", nếu không thì xuất ra "Không đậu"
GO 
CREATE PROCEDURE USP_KiemTraSVThiDau 
	@maSV varchar(10), @maMH varchar(10)
AS
BEGIN 
	IF EXISTS (SELECT * FROM KetQua WHERE @maSV = maSinhVien AND @maMH = maMonHoc AND diem >= 5 AND lanThi = 1)
		PRINT N'Đậu'
	ELSE
		PRINT N'Không đậu'
END
GO
EXEC USP_KiemTraSVThiDau '0212003', 'THT02'
-- 6.4 Nhập vào một khoa, in danh sách các sinh viên(mã sinh viên, họ tên, ngày sinh) thuộc khoa này
GO
CREATE PROCEDURE USP_InDanhSachSinhVien 
	@maKhoa varchar(10)
AS
BEGIN 
	IF NOT EXISTS (SELECT * FROM Khoa WHERE @maKhoa = ma)
		PRINT N'Mã khoa không tồn tại'
	ELSE
		SELECT SV.ma, SV.hoTen, SV.namSinh 
		FROM SinhVien SV, Lop L
		WHERE L.maKhoa = @maKhoa AND L.ma = SV.maLop
END
GO
EXEC USP_InDanhSachSinhVien 'CNTT'
-- 6.5 Nhập vào một sinh viên và một môn học, in điểm thi của sinh viên này của các lần thi
GO
CREATE PROCEDURE USP_InDiemThi
	@maSV varchar(10), @maMH varchar(10)
AS
	SELECT KQ.lanThi, KQ.diem
	FROM KetQua KQ
	WHERE KQ.maSinhVien = @maSV AND KQ.maMonHoc = @maMH
GO
EXEC USP_InDiemThi '0212001', 'THT01'
-- 6.6 Nhập vào một sinh viên, in ra các môn học mà sinh viên này phải học (Không in được ds môn học khoa Vật Lý)
GO
CREATE PROCEDURE USP_InRaMonHoc
	@maSV varchar(10)
AS
BEGIN 
	SELECT MH.ma, MH.tenMonHoc
	FROM MonHoc MH, Lop L, SinhVien SV
	WHERE MH.maKhoa = L.maKhoa AND L.ma = SV.maLop and @maSV = SV.ma
END
GO
EXEC USP_InRaMonHoc '0311002'
-- 6.7 Nhập vào một môn học, in danh sách các sinh viên đậu môn này trong lần thi đầu tiên
GO
CREATE PROCEDURE USP_InDanhSachSinhVienDauMonHoc
	@maMH varchar(10)
AS
BEGIN 
	SELECT KQ.maSinhVien, SV.hoTen, SV.namSinh
	FROM KetQua KQ, SinhVien SV
	WHERE KQ.maMonHoc = @maMH AND SV.ma = KQ.maSinhVien AND KQ.lanThi = 1 AND KQ.diem >= 5
END
GO
EXEC USP_InDanhSachSinhVienDauMonHoc 'THT01'
-- 6.8 In điểm các môn học của sinh viên có mã số là maSinhVien được nhập vào (điểm môn học là điểm của lần thi sau cùng)
GO
CREATE PROCEDURE USP_InDiem
	@maSV varchar(10)
AS
BEGIN
	-- 6.8.1 Chỉ in ra các môn đã có điểm
	SELECT KQ.maMonHoc, KQ.diem
	FROM KetQua KQ
	WHERE @maSV = KQ.maSinhVien AND KQ.diem >= 5
	-- 6.8.2 Các môn chưa có điểm thì ghi điểm là NULL
	-- 6.8.3 Các môn chưa có điểm thì ghi điểm là <chưa có điểm>
END
GO
EXEC USP_InDiem '0212002'


-- BÀI TẬP TRIGGER
-- 7.1 Mã chương trình chỉ có thể là 'CQ' hoặc 'CD' hoặc 'TC'
GO
CREATE TRIGGER TG_KiemTraMaChuongTrinh 
ON ChuongTrinh
FOR INSERT, UPDATE
AS
	SELECT * FROM inserted
	-- Điều kiện vi phạm 
	IF EXISTS (SELECT * FROM ChuongTrinh CT JOIN inserted I ON I.ma = CT.ma AND I.ma <> 'CQ' AND I.ma <> 'CD' AND I.ma <> 'TC')
		BEGIN 
			RAISERROR('ER1: LOI THEM CHUONG TRINH', 16, 1)
			ROLLBACK TRAN
		END
GO

--7.2 Một học kì chỉ có hai học kì là 'HK1' và 'HK2'
GO
CREATE TRIGGER TG_KiemTraHK
ON GiangKhoa
FOR UPDATE, INSERT
AS
	SELECT * FROM inserted
	-- Điều kiện vi phạm
	IF EXISTS (SELECT * FROM GiangKhoa GK JOIN inserted I ON GK.maChuongTrinh = I.maChuongTrinh AND GK.maKhoa = I.maKhoa 
	AND GK.maMonHoc = I.maMonHoc AND I.hocKy <> 1 AND I.hocKy <> 2)
		BEGIN
			RAISERROR('ER1: LOI SO HOC KY', 16, 1)
			ROLLBACK TRAN
		END
GO

-- 7.3 Số tiết lý thuyết tối đa là 120
GO
CREATE TRIGGER TG_KiemTraSoTietLyThuyet
ON GiangKhoa
FOR INSERT, UPDATE
AS	
	SELECT * FROM inserted
	-- Điều kiện vi phạm 
	IF EXISTS (SELECT * FROM GiangKhoa GK JOIN inserted I ON GK.maChuongTrinh = I.maChuongTrinh AND GK.maKhoa = I.maKhoa 
	AND GK.maMonHoc = I.maMonHoc AND I.soTietLyThuyet > 120)
		BEGIN
			RAISERROR('ER1: LOI SO TIET LY THUYET', 16, 1)
			ROLLBACK TRAN
		END
GO

-- 7.4 Số tiết thực hành tối đa là 120
GO
CREATE TRIGGER TG_KiemTraSoTietThựcHành
ON GiangKhoa
FOR UPDATE, INSERT
AS	
	SELECT * FROM inserted
	-- Điều kiện vi phạm 
	IF EXISTS (SELECT * FROM GiangKhoa GK JOIN inserted I ON GK.maChuongTrinh = I.maChuongTrinh AND GK.maKhoa = I.maKhoa 
	AND GK.maMonHoc = I.maMonHoc AND I.soTietThucHanh > 120)
		BEGIN
			RAISERROR('ER1: LOI SO TIET THUC HANH', 16, 1)
			ROLLBACK TRAN
		END
GO

-- 7.5 Số tín chỉ tối đa của một môn học là 6
GO
CREATE TRIGGER TG_KiemTraSoTinChi
ON GiangKhoa
FOR UPDATE, INSERT
AS	
	SELECT * FROM inserted
	-- Điều kiện vi phạm 
	IF EXISTS (SELECT * FROM GiangKhoa GK JOIN inserted I ON GK.maChuongTrinh = I.maChuongTrinh AND GK.maKhoa = I.maKhoa 
	AND GK.maMonHoc = I.maMonHoc AND I.soTinChi > 6)
		BEGIN
			RAISERROR('ER1: LOI SO TIN CHI', 16, 1)
			ROLLBACK TRAN
		END
GO

-- 7.6 Điểm thi được chấm theo thang điểm 10 và chính xác đến 0.5 
--(kiểm tra và báo lỗi nếu không đúng quy định; tự động làm tròn về độ chính xác nếu không đúng quy định)

-- 7.7 Năm kết thúc khóa học phải lớn hơn hoặc bằng năm bắt đầu
GO
ALTER TRIGGER TG_KiemTraNamKetThuc
ON KhoaHoc 
FOR UPDATE, INSERT
AS
	SELECT * FROM inserted
	SELECT * FROM deleted
	-- Điều kiện vi phạm
	IF EXISTS (SELECT * FROM KhoaHoc KH JOIN inserted I ON KH.ma = I.ma AND I.namKetThuc < I.namBatDau)
		BEGIN
			RAISERROR('ER1: LOI NAM KET THUC', 16, 1)
			ROLLBACK TRAN
		END
GO

-- 7.8 Số tiết lý thuyết của mỗi giảng khóa không nhỏ hơn số tiết thực hành
GO
CREATE TRIGGER TG_KiemTraSoTiet
ON GiangKhoa 
FOR INSERT, UPDATE
AS
	SELECT * FROM inserted
	-- Điều kiện vi phạm
	IF EXISTS (SELECT * FROM GiangKhoa GK JOIN inserted I ON GK.maChuongTrinh = I.maChuongTrinh AND GK.maKhoa = I.maKhoa 
	AND GK.maMonHoc = I.maMonHoc AND I.soTietLyThuyet < I.soTietThucHanh)
		BEGIN
			RAISERROR('ER: SO TIET LY THUYET PHAI LON HON SO TIET THUC HANH', 16, 1)
			ROLLBACK TRAN
		END
GO
-- 7.9 Tên chương trình phải phân biệt
ALTER TABLE ChuongTrinh
ADD CONSTRAINT U_TenCT unique(tenChuongTrinh)
-- 7.10 Tên khoa phải phân biệt
ALTER TABLE Khoa
ADD CONSTRAINT U_TenKhoa unique(tenKhoa)
-- 7.11 Tên môn học phải là duy nhất
ALTER TABLE MonHoc 
ADD CONSTRAINT U_TenMH unique(tenMonHoc)
-- 7.12 Sinh viên chỉ được thi tối đa 2 lần cho một môn học
ALTER TABLE KetQua
ADD CONSTRAINT C_lanThi check(lanThi <= 2)
-- 7.14 Năm bắt đầu khóa học của một lớp học không thể nhỏ hơn năm thành lập của khoa quản lý lớp đó
GO
CREATE TRIGGER TG_Cau14 
ON KhoaHoc
FOR INSERT, UPDATE
AS
	SELECT * FROM inserted 
	-- Điều kiện vi phạm
	IF EXISTS (SELECT * FROM inserted I
				LEFT JOIN Lop L ON L.maKhoaHoc = I.ma
				LEFT JOIN Khoa K ON K.ma = L.maKhoa
				WHERE I.namBatDau < K.namThanhLap)
		BEGIN
			RAISERROR('ERROR: NAM BAT DAY CUA MOT LOP KHONG THE NHO HON NAM THANH LAP CUA MOT KHOA', 16, 1)
			ROLLBACK TRAN
		END
GO
-- 7.15 Sinh viên chỉ có thể dự thi các môn học có trong chương trình và thuộc về khoa mà sinh viên đó theo học

-- 7.16 Bổ sung vào quan hệ LOP thuộc tính SISO và kiểm tra sĩ số của một lớp phải bằng số lượng sinh viên đang theo học lớp đó



