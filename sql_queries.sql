--1. Display all customer details.
select * 
from customer;


--2. Display only customer name and city.
select customer_name, city 
from customer;


--3. Find all customers who live in Badlapur.
select customer_name, city 
from customer 
where city = 'BADLAPUR';


--4. Display all accounts with balance greater than 50000.
select account_id, balance 
from account 
where balance > 50000;


--5. Display all transactions where transaction type is 'Deposit'.
select transaction_id, transaction_type 
from bank_transaction 
where transaction_type = 'Deposit';


--6. Find customers whose name starts with 'S'.
select customer_name 
from customer 
where customer_name like 'S%';


--7. Display all female customers.
select customer_name, gender 
from customer 
where gender = 'F';


--8. Display accounts opened after January 2024.
select account_id, open_date 
from account 
where open_date > date '2024-01-31';


--9. Find total number of customers.
select count(customer_id) as "Total Customers" 
from customer;


--10. Find total bank balance across all accounts.
select sum(balance) as "Total Bank Balance" 
from account;


--11. Find the maximum account balance.
select max(balance) as "Maximum Account Balance" 
from account ;


--12. Find the minimum transaction amount.
select min(amount) as "Minimum Transaction Amount" 
from bank_transaction;


--13. Find average account balance.
select avg(balance) as "Average Account Balance" 
from account;


--14. Count number of accounts by account type.
select account_type, count(account_type) as "Count of Accounts" 
from account 
group by account_type;


--15. Find total transaction amount.
select sum(amount) as " Total Transaction Amount" 
from bank_transaction;


--16. Find total balance maintained by each account type.
select account_type, sum(balance) as "Total Balance"  
from account 
group by account_type;


--17. Find number of customers in each city.
select city, count(customer_id) as "Number of Customers" 
from customer 
group by city;


--18. Find total transactions done by each transaction type.
select transaction_type, 
    count(transaction_id) as " Number of Trnsaction" 
from bank_transaction 
group by transaction_type;


--19. Find total transaction amount handled by each branch.
select b.branch_name, 
    sum(t.amount) as "Total Transaction" 
from bank_transaction t 
join branch b
on b.branch_id = t.branch_id 
group by b.branch_name;


--20. Find average balance of each account type.
select account_type, 
    avg(balance) as "Average Balance" 
from account 
group by account_type;


--21. Display customer name with their account details.
select c.customer_name, a.account_id, a.account_type, a.open_date, a.balance 
from customer c 
inner join account a 
on c.customer_id = a.customer_id;


--22. Display customer name and their transactions.
select c.customer_name, t.transaction_id, t.account_id, t.branch_id, t.transaction_date, t.transaction_type, t.amount 
from customer c 
inner join bank_transaction t 
on c.customer_id = t.customer_id ;


--23. Display branch name with transaction details.
select b.branch_name, t.customer_id, t.transaction_id, t.account_id, t.transaction_date, t.transaction_type, t.amount 
from branch b 
inner join bank_transaction t 
on b.branch_id = t.branch_id;


--24. Find customers who have more than one account.
select c.customer_name, 
    count(a.account_id) 
from customer c 
join account a 
on c.customer_id = a.customer_id 
group by c.customer_name 
having count(a.account_id) > 1;


--25. Display customers who performed transactions in March 2024.
select distinct c.customer_name 
from customer c 
inner join bank_transaction t 
on c.customer_id = t.customer_id 
where '28-FEB-2024'<t.transaction_date and t.transaction_date<'1-APR-2024';

select distinct c.customer_name 
from customer c 
inner join bank_transaction t 
on c.customer_id = t.customer_id 
where t.transaction_date between '01-MAR-2024' and '31-MAR-2024';


--26. Find total money deposited by each customer.
select c.customer_name, 
    sum(t.amount) 
from customer c 
inner join bank_transaction t 
on c.customer_id = t.customer_id 
where t.transaction_type = 'Deposit' 
group by c.customer_name ;


--27. Find customers who have withdrawal transactions.
select distinct c.customer_name 
from customer c 
inner join bank_transaction t 
on c.customer_id = t.customer_id 
where t.transaction_type = 'Withdrawal';


--28. Find customers whose account balance is greater than average balance.
select c.customer_name, a.balance 
from customer c 
inner join account a 
on c.customer_id = a.customer_id 
where a.balance > (select avg(balance) from account);


--29. Find the customer with the highest account balance.
select c.customer_name, a.balance 
from customer c 
inner join account a 
on c.customer_id = a.customer_id  
where a.balance=(select max(balance) from account);


--30. Find the second highest account balance.
select max(balance) as " Second Highest Balance" 
from account 
where balance<(select max(balance) from account);

select balance as " Second Highest Balance" 
from (select balance, dense_rank() over(order by balance desc) as rank 
from account) 
where rank = 2;


--31. Find customers who have never made any transaction.
select c.customer_id, c.customer_name 
from customer c 
left join bank_transaction t 
on c.customer_id = t.customer_id 
where transaction_id is null ;


--32. Find branches having transactions greater than average transaction amount.
select b.branch_name 
from branch b 
inner join bank_transaction t 
on b.branch_id = t.branch_id 
where t.amount > (select avg(amount) from bank_transaction);


--33. Find customers born after 2005-08-10.
select customer_name, dob 
from customer 
where dob > DATE '2005-08-10';


--34. Find transactions done in April 2024.
select transaction_id, transaction_date 
from bank_transaction 
where transaction_date 
between Date '2024-04-01' and date '2024-04-30';


--35. Find the top 3 customers with highest total balance.
select c.customer_name, sum(a.balance)
from customer c 
join account a 
on c.customer_id = a.customer_id
group by c.customer_name
order by sum(a.balance) desc 
fetch next 3 rows only;

select customer_id, balance, 
    row_number() over(order by balance desc) as "Rank" 
from account 
fetch next 3 rows only;


--36. Rank customers based on account balance.
select account_id, balance, 
    dense_rank() over(order by balance desc) as "Rank" 
from account;


--37. Find running total of transactions.
select transaction_id, amount, 
    sum(amount) over(order by transaction_date asc) as "Running Total" 
from bank_transaction;


--38. Find branch-wise transaction ranking
select transaction_id, branch_id,
    dense_rank() over(partition by branch_id order by amount desc) 
from  bank_transaction;

--39. Which city has the highest banking activity?
select b.city, 
    count(transaction_id) as "Number of Transactions" 
from branch b 
join bank_transaction t
on b.branch_id = t.branch_id 
group by b.city 
order by count(transaction_id) desc
fetch next 1 row only;


--40. Which branch handles the highest transaction amount?
select b.branch_name, 
    sum(t.amount) as "Total Amount" 
from branch b 
join bank_transaction t 
on b.branch_id = t.branch_id 
group by b.branch_name 
order by sum(t.amount) desc 
fetch next 1 row only;


--41. Find customers whose total transaction amount is greater than 10,000.
select c.customer_name, 
    sum(t.amount) as "Total Transaction Amount" 
from customer c 
join bank_transaction t 
on c.customer_id = t.customer_id 
group by c.customer_name 
having sum(t.amount) > 10000;


--42. Find the customer who made the highest number of transactions.
select c.customer_name, 
    count(transaction_id) 
from customer c 
join bank_transaction t 
on c.customer_id = t.customer_id 
group by c.customer_name 
order by count(transaction_id) desc 
fetch next 2 rows only;

select customer, Number_of_Transactions, rnk  from (select c.customer_name as customer ,
                                count(t.transaction_id) as Number_of_Transactions, 
                                dense_rank() 
                                    over(order by count(t.transaction_id) desc) as rnk
                            from customer c 
                            join bank_transaction t 
                            on c.customer_id = t.customer_id
                            group by c.customer_name)
where rnk = 1;


--43. Find customers whose total account balance is greater than the average total balance of all customers.
select c.customer_name, 
    sum(a.balance) as "Total Balance"
from customer c 
join account a 
on c.customer_id = a.customer_id
group by c.customer_name 
having sum(a.balance) > (select 
                            avg(TotalBalance) 
                        from (select 
                                    sum(balance) as TotalBalance 
                                from account 
                                group by customer_id
                                )
                        );


--44. Display customers who have both Savings (SA) and Current (CA) accounts.
select c.customer_name 
from customer c 
join account a 
on c.customer_id = a.customer_id 
where account_type in ('SA','CA')
group by customer_name
having count(distinct account_type)=2;


--45. Find customers who have accounts but never made a Deposit transaction.
select c.customer_name, c.customer_id 
from customer c 
join account a 
on c.customer_id = a.customer_id 
where c.customer_id 
    not in (select customer_id from bank_transaction where transaction_type = 'Deposit');


--46. Rank customers based on their total transaction amount.
select customer_id, 
    sum(amount), 
    rank() over(order by sum(amount)desc) as rank 
from bank_transaction 
group by customer_id ;

select c.customer_name, 
    sum(t.amount), 
    rank() over(order by sum(t.amount) desc) 
from customer c
join bank_transaction t 
on c.customer_id = t.customer_id 
group by c.customer_name ;


--47. Find the top transaction in each branch.
select b.branch_name,
    max(t.amount) as "Transaction amount" 
from branch b 
join bank_transaction t 
on b.branch_id = t.branch_id 
group by b.branch_name;


--48. Show each transaction along with the previous transaction amount of the same customer (using LAG).
select customer_id, transaction_id, amount, 
    lag(amount) 
        over(partition by customer_id order by transaction_id) as PreviousAmount 
from bank_transaction;


--49. Show each transaction along with the next transaction amount of the same customer (using LEAD).
select customer_id, transaction_id, amount, 
    lead(amount) over(partition by customer_id order by transaction_id) as NextAmount 
from bank_transaction;


--50. Find the average transaction amount for each customer.
select c.customer_name, 
    avg(t.amount) "Average Amount"
from customer c 
join bank_transaction t 
on c.customer_id = t.customer_id 
group by c.customer_name;


--51. Find the branch with the highest average transaction amount.
select b.branch_name, 
    avg(t.amount) 
from branch b 
join bank_transaction t 
on b.branch_id = t.branch_id 
group by b.branch_name 
order by avg(t.amount) desc 
fetch next 1 row only;

select branch, average_amount, rnk
from (
    select b.branch_name as branch, 
        avg(t.amount) as average_amount,
        dense_rank() over(order by avg(t.amount) desc ) as rnk
    from branch b 
    join bank_transaction t 
    on b.branch_id = t.branch_id 
    group by b.branch_name
    )
where rnk = 1;


--52. Find inactive customers who have an account but no transactions.
select c.customer_name, a.account_id, t.transaction_type
from customer c 
join account a 
on c.customer_id = a.customer_id 
left join bank_transaction t
on a.account_id = t.account_id 
where t.transaction_ID is null and a.account_id is not null;


--53. Find customers who have accounts in more than one account type.
select c.customer_name, 
    count(unique a.account_type) 
from customer c 
join account a 
on c.customer_id = a.customer_id 
group by c.customer_name 
having count(unique a.account_type) > 1; 


--54. Find the branch that serves the highest number of unique customers.
select b.branch_name, 
    count(distinct c.customer_name) 
from customer c
join bank_transaction t 
on c.customer_id = t.customer_id 
join branch b 
on t.branch_id = b.branch_id 
group by b.branch_name
order by count(distinct c.customer_name) desc
fetch next 2 rows only;

select branch, no_customer, rnk 
from (
    select b.branch_name as branch, 
        count(distinct c.customer_name) as no_customer,
        dense_rank() over(order by count(distinct c.customer_name) desc) as rnk
    from customer c
    join bank_transaction t 
    on c.customer_id = t.customer_id 
    join branch b 
    on t.branch_id = b.branch_id 
    group by b.branch_name
    )
where rnk = 1;


--55. Find customers who made both Deposit and Withdrawal transactions.
select c.customer_name 
from customer c 
join bank_transaction t 
on c.customer_id = t.customer_id 
where t.transaction_type in ('Deposit','Withdrawal') 
group by c.customer_name
having count(distinct t.transaction_type) = 2;
