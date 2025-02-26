--SELECT 
--	EMP_NAME, EMAIL, LENGTH(EMAIL) AS "이메일 길이"
--FROM
--	EMPLOYEE 
--WHERE 
--	LENGTH(EMAIL) <= 12
--ORDER BY
--	"이메일 길이" ASC; -- 16행 조회

-- 1번
-- 춘 기술대학교의 학과 이름과 계열을 조회하시오.
-- 단, 출력 헤더(컬럼명)는 "학과 명", "계열"으로 표시하도록 한다.

SELECT 
	DEPARTMENT_NAME "학과 명"
	, CATEGORY "계열"
FROM 
	TB_DEPARTMENT;

-- 2 번
-- 학과의 학과 정원을 다음과 같은 형태로 조회하시오

SELECT 
	DEPARTMENT_NAME || '의 정원은 ' || CAPACITY || '명 입니다.' AS "학과별 정원"
FROM 
	TB_DEPARTMENT;

-- 3번
-- "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생을 조회하시오.
-- (국문학과의 학과코드(DEPARTMENT_NO)는 001)

SELECT 
	STUDENT_NAME
FROM 
	TB_STUDENT
WHERE
	DEPARTMENT_NO = '001'
	AND 
	ABSENCE_YN = 'Y'
	AND
	STUDENT_SSN LIKE '%-2%';

-- 4번
-- 도서관에서 대출 도서 장기 연체자들을 찾아 이름을 게시하고자 한다.
-- 그 대상자들의 학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL구문을 작성하시오.
-- A513079, A513090, A513091, A513110, A513119

SELECT 
	STUDENT_NAME
FROM
	TB_STUDENT
WHERE
	STUDENT_NO IN ('A513079','A513090', 'A513091', 'A513110', 'A513119');
	


----------------------------------------------------------------------------------------------------------
-- 워크북 2번 문제

-- 1번
-- 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를
-- 입학 년도가 빠른 순으로 표시하는 SQL을 작성하시오.
-- (단, 헤더는 "학번", "이름", "입학년도" 가 표시되도록 한다.)
	
SELECT 
	STUDENT_NO AS 학번 ,STUDENT_NAME AS 이름 ,TO_CHAR(ENTRANCE_DATE, 'YYYY-MM-DD') AS 입학년도
FROM
	TB_STUDENT
WHERE
	DEPARTMENT_NO = '002'
ORDER BY
	ENTRANCE_DATE ASC;
	
-- 2번
-- 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 두 명 있다고 한다.
-- 그 교수의 이름과 주민번호를 조회하는 SQL을 작성하시오	

SELECT 
    PROFESSOR_NAME, PROFESSOR_SSN 
FROM 
    TB_PROFESSOR
WHERE 
    LENGTH(PROFESSOR_NAME) != 3;

-- 3번
-- 춘 기술대학교의 남자 교수들의 이름과 나이를 나이 오름차순으로 조회하시오.
-- (단, 교수 중 2000년 이후 출생자는 없으며 출력 헤더는 "교수이름"으로 한다.
-- 나이는 '만'으로 계산한다.)

SELECT 
    PROFESSOR_NAME AS 교수이름, 
    FLOOR(
        MONTHS_BETWEEN(SYSDATE, 
            TO_DATE('19' || SUBSTR(PROFESSOR_SSN, 1, 6), 'YYYYMMDD')
        ) / 12
    ) AS "나이", PROFESSOR_SSN
FROM 
    TB_PROFESSOR
ORDER BY 
    "나이";

-- 4번
-- 교수들의 이름 중 성을 제외한 이름만 조회하시오. 출력 헤더는 "이름"이 찍히도록 한다.
-- (성이 2자인 경우의 교수는 없다고 가정)

SELECT 
    SUBSTR(PROFESSOR_NAME, 2) AS "이름"
FROM 
    TB_PROFESSOR;	
	
-- 5번
-- 춘 기술대학교의 재수생 입학자를 조회하시오.
-- (19살에 입학하면 재수를 하지 않은 것!)
SELECT 
    STUDENT_NO,
    STUDENT_NAME
FROM 
    TB_STUDENT
WHERE 
    EXTRACT(YEAR FROM ENTRANCE_DATE) - 
    (
        TO_NUMBER('19' || SUBSTR(STUDENT_SSN, 1, 2))
    ) >= 20;
	
-- 6번
-- 춘 기술대학교의 2000년도 이후 입학자들은 학번이 A로 시작하게 되어있다.
-- 2000년도 이전 학번을 받은 학생들의 학번과 이름 조회하는 SQL을 작성하시오.	
SELECT 
	STUDENT_NO , STUDENT_NAME 
FROM
	TB_STUDENT
WHERE
	STUDENT_NO NOT LIKE 'A%';
	
-- 7번
-- 학번이 A517178인 한아름 학생의 학점 총 평점을 구하는 SQL문을 작성하시오.
-- 단, 이때 출력 화면의 헤더는 "평점"이라고 찍히게 하고,
-- 점수는 반올림하여 소수점 이하 한자리까지만 표시한다.	
	
-- 11번
-- 학과 별 휴학생 수를 파악하고자 한다.
-- 학과 번호와 휴학생 수를 조회하는 SQL을 작성하시오.	

SELECT 
	DEPARTMENT_NO AS "학과코드명",
	 COUNT(DECODE(ABSENCE_YN, 'Y','휴학생', 'N' , '휴학생 아님')) AS "휴학생 수" 
	,SUM(DECODE(ABSENCE_YN, 'Y','1', 'N', '0')) AS "휴학생 수" 
FROM 
	TB_STUDENT
GROUP BY
	DEPARTMENT_NO 
ORDER BY 
	DEPARTMENT_NO ASC;


-- 13번
-- 학번이 A112113인 김고운 학생의 학점을 조회하려고 한다.
-- 년도, 학기 별 평점과 년도 별 누적 평점, 총 평점을 구하는 SQL을 작성하시오.
-- (단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)

SELECT 
	NVL(SUBSTR(TERM_NO,1,4), ' ') AS "년도",
	NVL(SUBSTR(TERM_NO,5), ' ') AS "학기",	
	ROUND(AVG(POINT), 1) AS "평점" 
FROM
	TB_GRADE
WHERE 
	STUDENT_NO = 'A112113'
GROUP BY
	ROLLUP(SUBSTR(TERM_NO,1,4)), SUBSTR(TERM_NO,5)
ORDER BY
	SUBSTR(TERM_NO,1,4) ASC;












