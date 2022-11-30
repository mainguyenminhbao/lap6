create trigger trg_checkSalary15000
   on NHANVIEN
   FOR INSERT, UPDATE
AS
   IF (SELECT LUONG FROM inserted)<15000
   BEGIN
      PRINT N'Lương > 15000';
	  rollback tran;
   END;

INSERT INTO [dbo].[NHANVIEN]
           ([HONV]
           ,[TENLOT]
           ,[TENNV]
           ,[MANV]
           ,[NGSINH]
           ,[DCHI]
           ,[PHAI]
           ,[LUONG]
           ,[MA_NQL]
           ,[PHG])
     VALUES
           (N'Nguyễn'
           ,N'Quang'
           ,N'Hùng'
           ,'098'
           ,'09-13-2020'
           ,'Le Duan - HCM'
           ,'Nam'
           ,20000
           ,'005'
           ,1)
GO
--cau 1b
create trigger trg_CheckValidAge
   on NHANVIEN
   FOR INSERT
AS
   Declare @age int;
   Select @age = DATEDIFF(YEAR, NGSINH, GETDATE())+1 FROM inserted;
   if @age <18 or @age >65
   begin
      print N'Tuổi của nhân viên không hợp lệ 18<= tuổi <= 65';
	  rollback transaction;
   end
---kiểm tra câu lệnh
INSERT INTO [dbo].[NHANVIEN] ([HONV],[TENLOT],[TENNV] ,[MANV] ,[NGSINH],[DCHI],[PHAI],[LUONG],[MA_NQL],[PHG])
     VALUES(N'Nguyễn',N'Quang',N'Hùng','098','09-13-2020','Le Duan - HCM','Nam',90000,'005',1)
GO
---câu 1c
create trigger trg_CheckUpdateOnAddress
   on NHANVIEN
   FOR UPDATE
AS
   IF EXISTS (SELECT DCHI FROM inserted where DCHI LIKE '%HCM%')
   BEGIN
      PRINT N'Không thể cập nhật nhân viên ở HCM';
	  rollback tran;
   END;
---câu lệnh kiểm tra
UPDATE [dbo].[NHANVIEN]
   SET [PHAI] = 'Nam'
 WHERE MaNV = '001';
GO

----bài 2
create trigger trg_SumEmps
   on NHANVIEN
   AFTER INSERT
AS
   Declare @male int, @female int;
   select @female = count(Manv) from NHANVIEN where PHAI = N'Nữ';
   select @male = count(Manv) from NHANVIEN where PHAI = N'Nam';
   print N'Tổng số nhân viên là nữ: ' + cast(@female as varchar);
   print N'Tổng số nhân viên là nam: ' + cast(@male as varchar);

---CÂU LỆNH KIỂM TRA
INSERT INTO [dbo].[NHANVIEN]
           ([HONV]
           ,[TENLOT]
           ,[TENNV]
           ,[MANV]
           ,[NGSINH]
           ,[DCHI]
           ,[PHAI]
           ,[LUONG]
           ,[MA_NQL]
           ,[PHG])
     VALUES ('A','B','C','345','7-12-1999','HCM','Nam',600000,'005',1)
GO
 --BÀI 2B
 create trigger trg_SumEmpsForUpdate
   on NHANVIEN
   AFTER update
AS
   if (select top 1 PHAI FROM deleted) != (select top 1 PHAI FROM inserted)
   begin
      Declare @male int, @female int;
      select @female = count(Manv) from NHANVIEN where PHAI = N'Nữ';
      select @male = count(Manv) from NHANVIEN where PHAI = N'Nam';
      print N'Tổng số nhân viên là nữ: ' + cast(@female as varchar);
      print N'Tổng số nhân viên là nam: ' + cast(@male as varchar);
   end;
--câu lệnh kiểm tra
UPDATE [dbo].[NHANVIEN]
   SET [HONV] = 'Tín'
      ,[PHAI] = N'Nữ'
 WHERE  MaNV = '345'
GO
---BÀI 2C
CREATE TRIGGER trg_SumForDelete
   on DEAN
   AFTER DELETE
AS
   SELECT MA_NVIEN, COUNT(MaDA) as 'Tổng sô đề án đã tham gia' from PHANCONG
      GROUP BY MA_NVIEN

Câu 3:a)

delete NHANVIEN where MANV='001'

create trigger trg_deleteNhanThanNV on NhanVien
instead of delete
as 
begin
	delete from THANNHAN where MA_NVIEN in (select MANV from deleted)
	delete from NHANVIEN where MANV in (select MANV from deleted)
end

delete NHANVIEN where MANV='025'
select * from NHANVIEN

b)

alter trigger trg_insertNhanVien3b on nhanvien
after insert
as begin
	insert into PHANCONG values ((select MANV from inserted,1,1,100)
end

insert into NHANVIEN
values('Tran','Thanh','Huy','055','1980-12-12', 'Da Nang', N'Nữ, 16000,'006',1)