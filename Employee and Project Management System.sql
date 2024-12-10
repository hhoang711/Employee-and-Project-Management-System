--Tim nhan vien lam viec o phong so 4
SELECT *
FROM NHANVIEN
WHERE PHG = 4
--Tim NV co luong tren 30000
SELECT *
FROM NHANVIEN N
WHERE N.LUONG>30000
--
SELECT *
FROM NHANVIEN N
WHERE (N.LUONG>25000 AND N.PHG=4) OR (N.LUONG>30000 AND N.PHG=5)
--
SELECT HONV+' '+TENLOT+ ' ' +TENNV AS N'HỌ TÊN NV Ở TPHCM'
FROM NHANVIEN N
WHERE N.DCHI LIKE '% TPHCM'
--
select HONV+ ' ' +TENLOT+ ' ' +TENNV as N'Họ Và Tên' 
from NHANVIEN 
where HONV like 'N%'
--
SELECT n.NGSINH as N'Ngày sinh', N.DCHI AS N'ĐỊA CHỈ'
FROM NHANVIEN N
WHERE N.HONV =N'Đinh' and n.TENLOT= N'Bá' and n.TENNV= N'Tiến'
--
select * from NHANVIEN where year(NGSINH) BETWEEN 1960 AND 1965
--Với mỗi phòng ban, cho biết tên phòng ban và địa điểm phòng
SELECT P.TENPHG, D.DIADIEM
FROM PHONGBAN P, DIADIEM_PHG D
WHERE P.MAPHG=D.MAPHG
--Với mỗi nhân viên, cho biết họ tên của nhân viên đó, họ tên người trưởng phòng và họ tên người quản lý trực tiếp của nhân viên đó.
SELECT N1.HONV+ ' ' +N1.TENLOT+ ' ' +N1.TENNV as N'Họ Và Tên', N2.HONV+ ' ' +N2.TENLOT+ ' ' +N2.TENNV as N'Họ Và Tên NQL', N3.HONV+ ' ' +N3.TENLOT+ ' ' +N3.TENNV as N'Họ Và Tên Trưởng phòng'
FROM NHANVIEN N1, NHANVIEN N2, NHANVIEN N3, PHONGBAN P
WHERE N1.MA_NQL=N2.MANV AND N1.PHG = P.MAPHG AND P.TRPHG=N3.MANV
--Cho biết số lượng đề án của công ty
SELECT COUNT(D.MADA) AS N'SỐ LƯỢNG DA'
FROM DEAN D
--Cho biết số lượng đề án do phòng ‘Nghiên Cứu’ chủ trì
SELECT COUNT(D.MADA)AS N'SỐ LƯỢNG DA CỦA PHÒNG NC'
FROM DEAN D, PHONGBAN P
WHERE D.PHONG=P.MAPHG AND P.TENPHG=N'NGHIÊN CỨU'

--Cho biết lương trung bình của các nữ nhân viên
SELECT AVG(N.LUONG) AS N'LƯƠNG TB CỦA NỮ NV'
FROM NHANVIEN N
WHERE N.PHAI=N'NỮ'
--Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên tham dự đề án đó.
SELECT D.TENDA, SUM(P.THOIGIAN) AS N'TỔNG THGIAN LÀM VIỆC'
FROM DEAN D, PHANCONG P
WHERE D.MADA=P.MADA
GROUP BY  P.MADA, D.TENDA
--Với mỗi đề án, cho biết có bao nhiêu nhân viên tham gia đề án đó
SELECT P.MADA, COUNT(P.MA_NVIEN) AS N'SỐ LƯỢNG NV TG'
FROM PHANCONG P
GROUP BY P.MADA
--Với mỗi nhân viên, cho biết họ và tên nhân viên và số lượng thân nhân của nhân viên đó.
SELECT N.HONV+ ' ' +N.TENLOT+ ' ' +N.TENNV as N'Họ Và Tên NV', COUNT(T.TENNV) AS N'SỐ LƯỢNG TN'
FROM NHANVIEN N, THANNHAN T
WHERE N.MANV=T.MA_NVIEN
GROUP  BY T.MA_NVIEN, N.HONV, N.TENLOT, N.TENNV
--Cho biết danh sách các đề án (MADA) có: nhân công với họ (HONV) là ‘Dinh’ hoặc  có người trưởng phòng chủ trì đề án với họ (HONV) là ‘Dinh’.
SELECT D.MADA, D.TENDA
FROM DEAN D, PHANCONG P, NHANVIEN N1
WHERE D.MADA=P.MADA	AND P.MA_NVIEN=N1.MANV AND N1.HONV LIKE N'Đinh'
UNION
SELECT D.MADA, D.TENDA
FROM DEAN D, PHONGBAN P, NHANVIEN N
WHERE D.PHONG=P.MAPHG AND P.TRPHG=N.MANV AND N.HONV LIKE N'ĐINH'

--Danh sách những nhân viên (HONV, TENLOT, TENNV) có trên 2 thân nhân.
SELECT N.HONV+ ' ' +N.TENLOT+ ' ' +N.TENNV as N'Họ Và Tên NV', COUNT(T.TENNV) AS N'SỐ LƯỢNG TN'
FROM NHANVIEN N, THANNHAN T
WHERE N.MANV=T.MA_NVIEN
GROUP  BY T.MA_NVIEN, N.HONV, N.TENLOT, N.TENNV
HAVING COUNT(T.TENNV)>2
--Danh sách những nhân viên (HONV, TENLOT, TENNV) không có thân nhân nào.
SELECT N.HONV, N.TENLOT, N.TENNV
FROM NHANVIEN N
WHERE N.MANV NOT IN (SELECT T.MA_NVIEN
					FROM THANNHAN T)
--Danh sách những nhân viên (HONV, TENLOT, TENNV) làm việc trong mọi đề án của công ty
--R:PHANCONG
--S: DEAN
SELECT DISTINCT R1.MA_NVIEN, N.HONV, N.TENLOT, N.TENNV
FROM PHANCONG R1, NHANVIEN N
WHERE R1.MA_NVIEN=N.MANV AND  NOT EXISTS (SELECT *
					FROM DEAN S
					WHERE NOT EXISTS (SELECT *
										FROM PHANCONG R2
										WHERE R2.MADA=S.MADA AND R2.MA_NVIEN=R1.MA_NVIEN))
--Danh sách những nhân viên (HONV, TENLOT, TENNV) được phân công tất cả đề án do phòng số 4 chủ trì.
--R: PHANCONG
--S: DE AN DO PHONG 4 CHU TRI
SELECT DISTINCT R1.MA_NVIEN, N.HONV, N.TENLOT, N.TENNV
FROM PHANCONG R1, NHANVIEN N
WHERE R1.MA_NVIEN=N.MANV AND  NOT EXISTS (SELECT *
					FROM DEAN S
					WHERE S.PHONG= 4 AND NOT EXISTS (SELECT *
										FROM PHANCONG R2
										WHERE R2.MADA=S.MADA AND R2.MA_NVIEN=R1.MA_NVIEN))