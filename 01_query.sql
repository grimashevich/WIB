# А) какую сумму в среднем в месяц тратит:
#   - пользователи в возрастном диапазоне от 18 до 25 лет включительно
#   - пользователи в возрастном диапазоне от 26 до 35 лет включительно

SELECT ages_sum.ages AS ages,
       avg(ages_sum.sum) AS avg_sum
FROM (SELECT '18-25' AS ages,
             SUM(i.price) AS sum
      FROM purchases p
               JOIN items i ON p.itemid = i.itemid
               JOIN users u ON p.userid = u.userid
      WHERE u.age BETWEEN 18 AND 25
      GROUP BY YEAR(p.date), MONTH(p.date)
      UNION
      SELECT '26-35' AS ages,
             SUM(i.price) AS sum
      FROM purchases p
               JOIN items i ON p.itemid = i.itemid
               JOIN users u ON p.userid = u.userid
      WHERE u.age BETWEEN 26 AND 35
      GROUP BY YEAR(p.date), MONTH(p.date)) AS ages_sum
GROUP BY ages_sum.ages;

# Б)  в каком месяце года выручка от пользователей в возрастном диапазоне 35+ самая большая
SELECT MONTH(p.date) AS month, SUM(i.price) AS sum
FROM purchases p
         JOIN items i ON p.itemid = i.itemid
         JOIN users u ON p.userid = u.userid
WHERE u.age >= 35
GROUP BY MONTH(p.date)
ORDER BY sum DESC
LIMIT 1;

# В)  какой товар обеспечивает наибольший вклад в выручку за последний год
SELECT i.itemid AS itemid, SUM(i.price) AS isum
FROM purchases p
         JOIN items i ON p.itemid = i.itemid
WHERE p.date > DATE_SUB(now(), INTERVAL 1 YEAR)
GROUP BY i.itemid
ORDER BY isum DESC
LIMIT 1;

# Г) топ-3 товаров по выручке и их доля в общей выручке за любой год
SELECT i.itemid AS itemid,
       round((SUM(i.price) /
              (SELECT SUM(i.price)
               FROM items i
                        JOIN purchases p ON i.itemid = p.itemid
               WHERE year(p.date) = 2019)
                 ) * 100, 2) AS perc
FROM purchases p
         JOIN items i ON p.itemid = i.itemid
WHERE YEAR(p.date) = 2019
GROUP BY i.itemid
ORDER BY perc DESC
LIMIT 3;