USE master
GO
IF DB_ID('QLSV') IS NOT NULL
	DROP DATABASE QLSV
GO
	CREATE DATABASE QLSV
GO
	USE QLSV
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_GiangKhoa_ChuongTrinh]') AND type = 'F')
ALTER TABLE [dbo].[GiangKhoa] DROP CONSTRAINT [FK_GiangKhoa_ChuongTrinh]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_GiangKhoa_Khoa]') AND type = 'F')
ALTER TABLE [dbo].[GiangKhoa] DROP CONSTRAINT [FK_GiangKhoa_Khoa]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_GiangKhoa_MonHoc]') AND type = 'F')
ALTER TABLE [dbo].[GiangKhoa] DROP CONSTRAINT [FK_GiangKhoa_MonHoc]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_KetQua_MonHoc]') AND type = 'F')
ALTER TABLE [dbo].[KetQua] DROP CONSTRAINT [FK_KetQua_MonHoc]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_KetQua_SinhVien]') AND type = 'F')
ALTER TABLE [dbo].[KetQua] DROP CONSTRAINT [FK_KetQua_SinhVien]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_Lop_ChuongTrinh]') AND type = 'F')
ALTER TABLE [dbo].[Lop] DROP CONSTRAINT [FK_Lop_ChuongTrinh]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_Lop_Khoa]') AND type = 'F')
ALTER TABLE [dbo].[Lop] DROP CONSTRAINT [FK_Lop_Khoa]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_Lop_KhoaHoc]') AND type = 'F')
ALTER TABLE [dbo].[Lop] DROP CONSTRAINT [FK_Lop_KhoaHoc]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_MonHoc_Khoa]') AND type = 'F')
ALTER TABLE [dbo].[MonHoc] DROP CONSTRAINT [FK_MonHoc_Khoa]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_SinhVien_Lop]') AND type = 'F')
ALTER TABLE [dbo].[SinhVien] DROP CONSTRAINT [FK_SinhVien_Lop]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GiangKhoa]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[GiangKhoa]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[KetQua]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[KetQua]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Lop]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[Lop]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[MonHoc]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[MonHoc]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ChuongTrinh]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[ChuongTrinh]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Khoa]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[Khoa]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[KhoaHoc]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[KhoaHoc]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SinhVien]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[SinhVien]


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ChuongTrinh]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[ChuongTrinh](
	[ma] [varchar](10) NOT NULL,
	[tenChuongTrinh] [nvarchar](100) NULL,
 CONSTRAINT [PK_ChuongTrinh] PRIMARY KEY CLUSTERED 
(
	[ma] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[KhoaHoc]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[KhoaHoc](
	[ma] [varchar](10) NOT NULL,
	[namBatDau] [int] NULL,
	[namKetThuc] [int] NULL,
 CONSTRAINT [PK_KhoaHoc] PRIMARY KEY CLUSTERED 
(
	[ma] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Khoa]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[Khoa](
	[ma] [varchar](10) NOT NULL,
	[tenKhoa] [nvarchar](100) NULL,
	[namThanhLap] [int] NULL,
 CONSTRAINT [PK_Khoa] PRIMARY KEY CLUSTERED 
(
	[ma] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[KetQua]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[KetQua](
	[maSinhVien] [varchar](10) NOT NULL,
	[maMonHoc] [varchar](10) NOT NULL,
	[lanThi] [int] NOT NULL,
	[diem] [float] NULL,
 CONSTRAINT [PK_KetQua] PRIMARY KEY CLUSTERED 
(
	[maSinhVien] ASC,
	[maMonHoc] ASC,
	[lanThi] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SinhVien]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[SinhVien](
	[ma] [varchar](10) NOT NULL,
	[hoTen] [nvarchar](100) NULL,
	[namSinh] [int] NULL,
	[danToc] [nvarchar](20) NULL,
	[maLop] [varchar](10) NULL,
 CONSTRAINT [PK_SinhVien] PRIMARY KEY CLUSTERED 
(
	[ma] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GiangKhoa]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[GiangKhoa](
	[maChuongTrinh] [varchar](10) NOT NULL,
	[maKhoa] [varchar](10) NOT NULL,
	[maMonHoc] [varchar](10) NOT NULL,
	[namHoc] [int] NULL,
	[hocKy] [int] NULL,
	[soTietLyThuyet] [int] NULL,
	[soTietThucHanh] [int] NULL,
	[soTinChi] [int] NULL,
 CONSTRAINT [PK_GiangKhoa] PRIMARY KEY CLUSTERED 
(
	[maChuongTrinh] ASC,
	[maKhoa] ASC,
	[maMonHoc] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Lop]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[Lop](
	[ma] [varchar](10) NOT NULL,
	[maKhoaHoc] [varchar](10) NULL,
	[maKhoa] [varchar](10) NULL,
	[maChuongTrinh] [varchar](10) NULL,
	[soThuTu] [int] NULL,
 CONSTRAINT [PK_Lop] PRIMARY KEY CLUSTERED 
(
	[ma] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[MonHoc]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[MonHoc](
	[ma] [varchar](10) NOT NULL,
	[tenMonHoc] [nvarchar](100) NULL,
	[maKhoa] [varchar](10) NULL,
 CONSTRAINT [PK_MonHoc] PRIMARY KEY CLUSTERED 
(
	[ma] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_KetQua_MonHoc]') AND type = 'F')
ALTER TABLE [dbo].[KetQua]  WITH CHECK ADD  CONSTRAINT [FK_KetQua_MonHoc] FOREIGN KEY([maMonHoc])
REFERENCES [dbo].[MonHoc] ([ma])
GO
ALTER TABLE [dbo].[KetQua] CHECK CONSTRAINT [FK_KetQua_MonHoc]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_KetQua_SinhVien]') AND type = 'F')
ALTER TABLE [dbo].[KetQua]  WITH CHECK ADD  CONSTRAINT [FK_KetQua_SinhVien] FOREIGN KEY([maSinhVien])
REFERENCES [dbo].[SinhVien] ([ma])
GO
ALTER TABLE [dbo].[KetQua] CHECK CONSTRAINT [FK_KetQua_SinhVien]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_SinhVien_Lop]') AND type = 'F')
ALTER TABLE [dbo].[SinhVien]  WITH CHECK ADD  CONSTRAINT [FK_SinhVien_Lop] FOREIGN KEY([maLop])
REFERENCES [dbo].[Lop] ([ma])
GO
ALTER TABLE [dbo].[SinhVien] CHECK CONSTRAINT [FK_SinhVien_Lop]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_GiangKhoa_ChuongTrinh]') AND type = 'F')
ALTER TABLE [dbo].[GiangKhoa]  WITH CHECK ADD  CONSTRAINT [FK_GiangKhoa_ChuongTrinh] FOREIGN KEY([maChuongTrinh])
REFERENCES [dbo].[ChuongTrinh] ([ma])
GO
ALTER TABLE [dbo].[GiangKhoa] CHECK CONSTRAINT [FK_GiangKhoa_ChuongTrinh]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_GiangKhoa_Khoa]') AND type = 'F')
ALTER TABLE [dbo].[GiangKhoa]  WITH CHECK ADD  CONSTRAINT [FK_GiangKhoa_Khoa] FOREIGN KEY([maKhoa])
REFERENCES [dbo].[Khoa] ([ma])
GO
ALTER TABLE [dbo].[GiangKhoa] CHECK CONSTRAINT [FK_GiangKhoa_Khoa]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_GiangKhoa_MonHoc]') AND type = 'F')
ALTER TABLE [dbo].[GiangKhoa]  WITH CHECK ADD  CONSTRAINT [FK_GiangKhoa_MonHoc] FOREIGN KEY([maMonHoc])
REFERENCES [dbo].[MonHoc] ([ma])
GO
ALTER TABLE [dbo].[GiangKhoa] CHECK CONSTRAINT [FK_GiangKhoa_MonHoc]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_Lop_ChuongTrinh]') AND type = 'F')
ALTER TABLE [dbo].[Lop]  WITH CHECK ADD  CONSTRAINT [FK_Lop_ChuongTrinh] FOREIGN KEY([maChuongTrinh])
REFERENCES [dbo].[ChuongTrinh] ([ma])
GO
ALTER TABLE [dbo].[Lop] CHECK CONSTRAINT [FK_Lop_ChuongTrinh]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_Lop_Khoa]') AND type = 'F')
ALTER TABLE [dbo].[Lop]  WITH CHECK ADD  CONSTRAINT [FK_Lop_Khoa] FOREIGN KEY([maKhoa])
REFERENCES [dbo].[Khoa] ([ma])
GO
ALTER TABLE [dbo].[Lop] CHECK CONSTRAINT [FK_Lop_Khoa]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_Lop_KhoaHoc]') AND type = 'F')
ALTER TABLE [dbo].[Lop]  WITH CHECK ADD  CONSTRAINT [FK_Lop_KhoaHoc] FOREIGN KEY([maKhoaHoc])
REFERENCES [dbo].[KhoaHoc] ([ma])
GO
ALTER TABLE [dbo].[Lop] CHECK CONSTRAINT [FK_Lop_KhoaHoc]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_MonHoc_Khoa]') AND type = 'F')
ALTER TABLE [dbo].[MonHoc]  WITH CHECK ADD  CONSTRAINT [FK_MonHoc_Khoa] FOREIGN KEY([maKhoa])
REFERENCES [dbo].[Khoa] ([ma])
GO
ALTER TABLE [dbo].[MonHoc] CHECK CONSTRAINT [FK_MonHoc_Khoa]


insert into Khoa
values('CNTT', N'Công nghệ thông tin', 1995)
insert into Khoa
values('VL', N'Vật lý', 1970)

insert into KhoaHoc
values('K2002', 2002, 2006)
insert into KhoaHoc
values('K2003', 2003, 2007)
insert into KhoaHoc
values('K2004', 2004, 2008)

insert into ChuongTrinh
values('CQ', N'Chính qui')

insert into Lop
values('TH2002/01', 'K2002', 'CNTT', 'CQ', 1)
insert into Lop
values('TH2002/02', 'K2002', 'CNTT', 'CQ', 2)
insert into Lop
values('VL2003/01', 'K2003', 'VL', 'CQ', 1)

insert into SinhVien
values('0212001', N'Nguyễn Vĩnh An', 1984, N'Kinh', 'TH2002/01')
insert into SinhVien
values('0212002', N'Nguyễn Thanh Bình', 1985, N'Kinh', 'TH2002/01')
insert into SinhVien
values('0212003', N'Nguyễn Thanh Cường', 1984, N'Kinh', 'TH2002/02')
insert into SinhVien
values('0212004', N'Nguyễn Quốc Duy', 1983, N'Kinh', 'TH2002/02')
insert into SinhVien
values('0312001', N'Phan Tuấn Anh', 1985, N'Kinh', 'VL2003/01')
insert into SinhVien
values('0312002', N'Huỳnh Thanh Sang', 1984, N'Kinh', 'VL2003/01')

insert into MonHoc
values('THT01', N'Toán Cao cấp A1', 'CNTT')
insert into MonHoc
values('VLT01', N'Vật lý Cao cấp A1', 'VL')
insert into MonHoc
values('THT02', N'Toán rời rạc', 'CNTT')
insert into MonHoc
values('THCS01', N'Cấu trúc dữ liệu 1', 'CNTT')
insert into MonHoc
values('THCS02', N'Hệ điều hành', 'CNTT')

insert into KetQua
values('0212001', 'THT01', 1, 4)
insert into KetQua
values('0212001', 'THT01', 2, 7)
insert into KetQua
values('0212002', 'THT01', 1, 8)
insert into KetQua
values('0212003', 'THT01', 1, 6)
insert into KetQua
values('0212004', 'THT01', 1, 9)
insert into KetQua
values('0212001', 'THT02', 1, 8)
insert into KetQua
values('0212002', 'THT02', 1, 5.5)
insert into KetQua
values('0212003', 'THT02', 1, 4)
insert into KetQua
values('0212003', 'THCS01', 2, 6)
insert into KetQua
values('0212001', 'THCS01', 1, 6.5)
insert into KetQua
values('0212002', 'THCS01', 1, 4)
insert into KetQua
values('0212003', 'THCS01', 1, 7)

insert into GiangKhoa
values('CQ', 'CNTT', 'THT01', 2003, 1, 60, 0, 5)
insert into GiangKhoa
values('CQ', 'CNTT', 'THT02', 2003, 2, 45, 0, 4)
insert into GiangKhoa
values('CQ', 'CNTT', 'THCS01', 2004, 1, 45, 30, 4)