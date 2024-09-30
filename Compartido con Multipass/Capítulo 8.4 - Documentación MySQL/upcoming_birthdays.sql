-- Esta consulta obtiene los próximos cumpleaños de este mes y el próximo.

SELECT name, birth
FROM pet
WHERE DATE_FORMAT(birth, '%m-%d') BETWEEN DATE_FORMAT(CURDATE(), '%m-%d') AND DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 1 MONTH), '%m-%d')
ORDER BY DATE_FORMAT(birth, '%m-%d') ASC;
