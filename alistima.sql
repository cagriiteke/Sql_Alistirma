SELECT TOP 5 * FROM company_divisions 
SELECT TOP 5 * FROM company_regions
SELECT TOP 5 * FROM staff

/* Bu þirkette toplam kaç çalýþan var */ 

SELECT COUNT(*) FROM staff

/* Cinsiyet daðýlýmý nedir? */ 

SELECT gender AS CÝNSÝYET, COUNT(id) AS TOPLAMKÝÞÝ FROM staff
GROUP BY gender

/* Her departmanda kaç çalýþan var */ 

SELECT department as ÞÝRKET, COUNT(id) as TOPLAMKÝÞÝ FROM staff
GROUP BY department
ORDER BY TOPLAMKÝÞÝ DESC

/* Kaç farklý departman var */ 

SELECT COUNT(DISTINCT(department)) FROM staff  

/* Çalýþanlarýn en yüksek ve en düþük maaþý nedir? */ 
SELECT TOP 1 last_name , MAX(salary) AS EN_ÇOK_MAAÞ FROM staff
GROUP BY last_name
ORDER BY MAX(salary) DESC;

SELECT TOP 1 last_name , MIN(salary) AS EN_DÜÞÜK_MAAÞ FROM staff
GROUP BY last_name
ORDER BY MIN(salary) ASC;

/* Cinsiyet grubuna göre maaþ daðýlýmý ne olacak? */

SELECT gender AS CÝNSÝYET, AVG(salary) AS ORTALAMA_MAAS  FROM staff
GROUP BY gender
/* Veri Yorumlama: Erkek ve kadýn grubu arasýndaki ortalamanýn oldukça yakýn olduðu görülüyor, Kadýn grubu için ortalama maaþ biraz daha yüksek*/ 


/* Þirket her yýl toplam ne kadar maaþ harcýyor? */ 

SELECT SUM(salary) AS TOPLAMMAAÞ FROM staff

/* departmana göre minimum, maksimum ortalama maaþýn daðýlýmýný bilmek istiyorum */

SELECT
	department,
	MIN(salary) AS EN_DÜÞÜK_MAAÞ,
	MAX(salary) AS EN_YÜKSEK_MAAÞ,
	AVG(salary) AS ORTALAMA_MAAÞ
FROM staff
GROUP BY department
ORDER BY AVG(salary) DESC





/* en yüksek maaþ daðýlýmý hangi departmanda ? */

SELECT 
	department, 
	MIN(salary) As EN_DÜÞÜK_MAAÞ, 
	MAX(salary) AS EN_YÜKSEK_MAAÞ, 
	ROUND(AVG(salary),2)   AS ORTALAMA_MAAÞ,
	STDEV(salary) AS STANDART_SAPMA,
	COUNT(*) AS TOPLAM_ÇALIÞAN
FROM staff
WHERE salary IS NOT NULL
GROUP BY department
ORDER BY 5 DESC;





/* Saðlýk Bakanlýðý'nýn maaþ kazanma durumunu görmek için 3 kova yapacaðýz */ 

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




/* Outdoors departmaný maaþýný öðrenelim */

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

/* kiþinin maaþýný departman ortalama maaþýna göre bilmek istiyoruz */ 

SELECT * FROM staff

SELECT	
	last_name,
	salary,
	department,
	(SELECT AVG(salary) FROM staff WHERE department = SF.department GROUP BY department )  AS ORTALAMA
FROM staff SF
group by last_name
HAVING salary > (SELECT AVG(salary) FROM staff WHERE department = SF.department GROUP BY department )



/* kaç kiþi kendi bölümünün ortalama maaþýnýn üstünde/altýnda kazanýyor? */ 

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




/* En az 100.000 maaþ alan kiþilerin Executive olduðunu varsayalým.
Her departman için yöneticiler için ortalama maaþý bilmek istiyoruz.
*/ 


SELECT department, ROUND(AVG(salary),2) AS average_salary
FROM staff
WHERE salary >= 100000
GROUP BY department
ORDER BY 2 DESC



/* þirkette en çok kim kazanýyor?
*/ 
SELECT last_name, department, salary
FROM staff
WHERE salary = (
	SELECT MAX(s2.salary)
	FROM staff s2
);



/* kendi bölümünde en çok kazanan kiþi */ 
SELECT s.department, s.last_name, s.salary
FROM staff s
WHERE s.salary = (
	SELECT MAX(s2.salary)
	FROM staff s2
	WHERE s2.department = s.department
)
ORDER BY 1




/* þirket bölümü ile çalýþanlarýn tüm detay bilgileri
*/ 

SELECT s.last_name, s.department, cd.company_division
FROM staff s
JOIN company_divisions cd
	ON cd.department = s.department


/* þimdi 1000 personelin tamamý iade edildi, ancak 47 kiþinin eksik þirketi var - bölüm.*/ 

SELECT s.last_name, s.department, cd.company_division
FROM staff s
LEFT JOIN company_divisions cd
	ON cd.department = s.department

/* þirket bölümü eksik olan kiþiler kim?*/

SELECT s.last_name, s.department, cd.company_division
FROM staff s
LEFT JOIN company_divisions cd
	ON cd.department = s.department
WHERE company_division IS NULL







