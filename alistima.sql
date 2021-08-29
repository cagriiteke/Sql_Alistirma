SELECT TOP 5 * FROM company_divisions 
SELECT TOP 5 * FROM company_regions
SELECT TOP 5 * FROM staff

/* Bu �irkette toplam ka� �al��an var */ 

SELECT COUNT(*) FROM staff

/* Cinsiyet da��l�m� nedir? */ 

SELECT gender AS C�NS�YET, COUNT(id) AS TOPLAMK��� FROM staff
GROUP BY gender

/* Her departmanda ka� �al��an var */ 

SELECT department as ��RKET, COUNT(id) as TOPLAMK��� FROM staff
GROUP BY department
ORDER BY TOPLAMK��� DESC

/* Ka� farkl� departman var */ 

SELECT COUNT(DISTINCT(department)) FROM staff  

/* �al��anlar�n en y�ksek ve en d���k maa�� nedir? */ 
SELECT TOP 1 last_name , MAX(salary) AS EN_�OK_MAA� FROM staff
GROUP BY last_name
ORDER BY MAX(salary) DESC;

SELECT TOP 1 last_name , MIN(salary) AS EN_D���K_MAA� FROM staff
GROUP BY last_name
ORDER BY MIN(salary) ASC;

/* Cinsiyet grubuna g�re maa� da��l�m� ne olacak? */

SELECT gender AS C�NS�YET, AVG(salary) AS ORTALAMA_MAAS  FROM staff
GROUP BY gender
/* Veri Yorumlama: Erkek ve kad�n grubu aras�ndaki ortalaman�n olduk�a yak�n oldu�u g�r�l�yor, Kad�n grubu i�in ortalama maa� biraz daha y�ksek*/ 


/* �irket her y�l toplam ne kadar maa� harc�yor? */ 

SELECT SUM(salary) AS TOPLAMMAA� FROM staff

/* departmana g�re minimum, maksimum ortalama maa��n da��l�m�n� bilmek istiyorum */

SELECT
	department,
	MIN(salary) AS EN_D���K_MAA�,
	MAX(salary) AS EN_Y�KSEK_MAA�,
	AVG(salary) AS ORTALAMA_MAA�
FROM staff
GROUP BY department
ORDER BY AVG(salary) DESC





/* en y�ksek maa� da��l�m� hangi departmanda ? */

SELECT 
	department, 
	MIN(salary) As EN_D���K_MAA�, 
	MAX(salary) AS EN_Y�KSEK_MAA�, 
	ROUND(AVG(salary),2)   AS ORTALAMA_MAA�,
	STDEV(salary) AS STANDART_SAPMA,
	COUNT(*) AS TOPLAM_�ALI�AN
FROM staff
WHERE salary IS NOT NULL
GROUP BY department
ORDER BY 5 DESC;





/* Sa�l�k Bakanl���'n�n maa� kazanma durumunu g�rmek i�in 3 kova yapaca��z */ 

CREATE VIEW health_dept_earning_status
AS 
	SELECT 
		CASE
			WHEN salary >= 100000 THEN 'high earner'
			WHEN salary >= 50000 AND salary < 100000 THEN 'middle earner'
			ELSE 'low earner'
		END AS earning_status
	FROM staff
	WHERE department LIKE 'Health'


SELECT earning_status, COUNT(*)
FROM health_dept_earning_status
GROUP BY earning_status




/* Outdoors departman� maa��n� ��renelim */

CREATE VIEW outdoors_dept_earning_status
AS 
	SELECT 
		CASE
			WHEN salary >= 100000 THEN 'high earner'
			WHEN salary >= 50000 AND salary < 100000 THEN 'middle earner'
			ELSE 'low earner'
		END AS earning_status
	FROM staff
	WHERE department LIKE 'Outdoors';
	

SELECT earning_status, COUNT(*)
FROM outdoors_dept_earning_status
GROUP BY 1;


DROP VIEW health_dept_earning_status
DROP VIEW outdoors_dept_earning_status

/* ki�inin maa��n� departman ortalama maa��na g�re bilmek istiyoruz */ 

SELECT * FROM staff

SELECT	
	last_name,
	salary,
	department,
	(SELECT AVG(salary) FROM staff WHERE department = SF.department GROUP BY department )  AS ORTALAMA
FROM staff SF
group by last_name
HAVING salary > (SELECT AVG(salary) FROM staff WHERE department = SF.department GROUP BY department )



/* ka� ki�i kendi b�l�m�n�n ortalama maa��n�n �st�nde/alt�nda kazan�yor? */ 

CREATE VIEW vw_salary_comparision_by_department
AS
	SELECT 
	s.department,
	s.salary AS is_higher_than_dept_avg_salary
	FROM staff s
	WHERE s.salary > (SELECT ROUND(AVG(s2.salary),2)
					  FROM staff s2
					  WHERE s2.department = s.department);
	
	
	
	
SELECT * FROM vw_salary_comparision_by_department;

SELECT department, COUNT(*) AS total_employees
FROM vw_salary_comparision_by_department
GROUP BY department




/* En az 100.000 maa� alan ki�ilerin Executive oldu�unu varsayal�m.
Her departman i�in y�neticiler i�in ortalama maa�� bilmek istiyoruz.
*/ 


SELECT department, ROUND(AVG(salary),2) AS average_salary
FROM staff
WHERE salary >= 100000
GROUP BY department
ORDER BY 2 DESC



/* �irkette en �ok kim kazan�yor?
*/ 
SELECT last_name, department, salary
FROM staff
WHERE salary = (
	SELECT MAX(s2.salary)
	FROM staff s2
);



/* kendi b�l�m�nde en �ok kazanan ki�i */ 
SELECT s.department, s.last_name, s.salary
FROM staff s
WHERE s.salary = (
	SELECT MAX(s2.salary)
	FROM staff s2
	WHERE s2.department = s.department
)
ORDER BY 1




/* �irket b�l�m� ile �al��anlar�n t�m detay bilgileri
*/ 

SELECT s.last_name, s.department, cd.company_division
FROM staff s
JOIN company_divisions cd
	ON cd.department = s.department


/* �imdi 1000 personelin tamam� iade edildi, ancak 47 ki�inin eksik �irketi var - b�l�m.*/ 

SELECT s.last_name, s.department, cd.company_division
FROM staff s
LEFT JOIN company_divisions cd
	ON cd.department = s.department

/* �irket b�l�m� eksik olan ki�iler kim?*/

SELECT s.last_name, s.department, cd.company_division
FROM staff s
LEFT JOIN company_divisions cd
	ON cd.department = s.department
WHERE company_division IS NULL







