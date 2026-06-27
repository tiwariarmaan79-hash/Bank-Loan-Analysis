-- CREATE DATABASE Bank_Loan_db;
USE Bank_Loan_db;
-- Q1. How many loan applications were received?
SELECT COUNT(id) AS Total_Loans_Applications
FROM bank_loan_analysis;

-- Q2.What is the total amount funded by the bank?
SELECT sum(loan_amount) AS Total_Funded_Amount
FROM bank_loan_analysis;

-- Q3.How much money has the bank received back?
SELECT SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_analysis;

-- Q4.What is the average interest rate?
SELECT ROUND(AVG(int_rate),2) AS Average_Interest_Rate
FROM bank_loan_analysis;

-- Q5.What is the average Debt-to-Income Ratio?
SELECT ROUND(AVG(dti),2) AS Average_DTI 
FROM bank_loan_analysis

-- 	Q6.Good Loans issued.
a.Good Loan Percentage:
SELECT 
CONCAT(ROUND(COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'current' THEN id 
END)*100/COUNT(id),2),'%') AS Good_Loan_Percentage FROM bank_loan_analysis;

-- b.Good Loan Applications
SELECT COUNT(id) AS Good_Loan_Application
FROM bank_loan_analysis
WHERE loan_status = 'Fully Paid' OR loan_Status = 'current' 

-- c.Good Loan Funded Amount.
SELECT SUM(loan_amount) AS Good_Funded_Amount 
FROM bank_loan_analysis
WHERE loan_status = 'Fully Paid' OR loan_Status = 'current'

-- d.Good Loan Total Received Amount
SELECT SUM(total_payment) AS Good_Loan_Amount_Received
FROM bank_loan_analysis
WHERE loan_status = 'Fully Paid' OR loan_Status = 'current'

-- Q7. Bad Loans Issued.
-- a.Bad Loan Percentage:
SELECT 
CONCAT(ROUND(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END)*100/COUNT(id),2),'%') 
AS Bad_Loan_Percentage 
FROM bank_loan_analysis;

-- b.Bad Loan Applications
SELECT COUNT(id) AS Bad_Loan_Application
FROM bank_loan_analysis
WHERE loan_status = 'Charged Off'

-- c.Bad Loan Funded Amount.
SELECT SUM(loan_amount) AS Bad_Funded_Amount 
FROM bank_loan_analysis
WHERE loan_status = 'Charged Off'

-- d.Bad Loan Total Received Amount
SELECT SUM(total_payment) AS Bad_Loan_Amount_Received
FROM bank_loan_analysis
WHERE loan_status = 'Charged Off'

-- Q8. Loan Status.
SELECT loan_status,
COUNT(id) AS Total_ID,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Recieved,
ROUND(AVG(int_rate),2) AS Average_Intrest_Rate,
ROUND(AVG(dti),2) AS Average_DTI
FROM bank_loan_analysis
GROUP BY loan_status;

-- Q9.How many loan applications were received each month?
SELECT
    YEAR(issue_date) AS Loan_Year,
    MONTH(issue_date) AS Loan_Month_Number,
    MONTHNAME(issue_date) AS Loan_Month,
    COUNT(*) AS Total_Applications
FROM bank_loan_analysis
GROUP BY
    YEAR(issue_date),
    MONTH(issue_date),
    MONTHNAME(issue_date)
ORDER BY Loan_Year,Loan_Month_Number;

-- Q10.Which states receive the highest number of loan applications?
SELECT 
address_state,
COUNT(id) AS Total_Loan_Application,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_analysis
GROUP BY address_state
ORDER BY address_state;

-- 11.What are customers borrowing money for?
SELECT purpose,
count(*) AS Total_Applications,
SUM(loan_Amount) AS Total_Funded_Amount FROM bank_loan_analysis
GROUP BY purpose
ORDER BY Total_Applications DESC; 

-- 12.Does home ownership affect loan applications?
SELECT 
home_ownership AS Home_Ownership,
COUNT(*) AS Total_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_analysis
GROUP BY home_ownership
ORDER BY Total_Applications DESC;

-- 13.Which loan grades account for the highest funded amount?
SELECT grade,
COUNT(*) AS Total_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Received_Amount
FROM bank_loan_analysis
GROUP BY grade
ORDER BY grade;

-- 14.Which states have received the highest total loan funding?
SELECT address_state,
COUNT(*) AS Total_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
RANK () OVER (ORDER BY SUM(loan_amount) DESC) AS State_Rank
FROM bank_loan_analysis
GROUP BY address_state;

-- Q15.How many loans fall into different funding categories?
SELECT
CASE WHEN loan_amount< 5000 THEN 'Small Loan'
	 WHEN loan_amount>5000 AND loan_amount<100000 THEN 'Medium Loan'
     ELSE 'Large Loan'
     END AS Loan_Category,
     COUNT(*) AS Total_Loans,
     SUM(loan_Amount) AS Total_Funded_Amount
FROM bank_loan_analysis
GROUP BY Loan_Category
ORDER BY Total_Funded_Amount DESC;

-- Q16. Which loan purposes contribute the most to total lending?
SELECT
purpose,
SUM(loan_amount) AS Total_Funded_Amount,
ROUND(SUM(loan_amount)*100/SUM(SUM(loan_amount)) OVER(),2) AS Percentage_Contribution
FROM bank_loan_analysis
GROUP BY purpose
ORDER BY Percentage_Contribution DESC;

CREATE VIEW vw_loan_analysis AS
SELECT
    id,
    issue_date,
    address_state,
    purpose,
    home_ownership,
    grade,
    loan_status,
    annual_income,
    loan_amount,
    total_payment,
    int_rate,
    dti
FROM bank_loan_analysis;

SELECT * FROM vw_loan_analysis;
 

