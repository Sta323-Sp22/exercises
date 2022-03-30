## Exercise 1

### 1. The total costs in payroll for this company

```sql
SELECT sum(salary) FROM employees;

SELECT total(salary) FROM employees;
```

### 2. The average salary within each department

```sql
SELECT dept, avg(salary) FROM employees GROUP BY dept;
```