# Zephyr Bank: Digital Transaction Health Monitoring & Risk Analytics
## Project Overview
Digital banks process thousands of transactions daily, making it critical to monitor operational performance, fraud exposure, customer behavior, and payment activity in near real time.

This project delivers an end-to-end transaction analytics solution for a UK fintech neobank, **Zephyr Bank**, using transaction data from January-May 2026.

The analysis transforms raw transaction records into business-ready insights through data cleaning, SQL-based analytics, and dashboard reporting.

Key objectives include:
* Monitoring transaction health and operational performance
* Identifying fraud and high-risk transaction patterns
* Understanding customer spending behavior
* Evaluating merchant category performance
* Analyzing channel and device usage
* Assessing international transaction activity and FX usage

## Dataset Overview
The project uses a star-schema banking dataset consisting of:
|**Table** |**Type** |**Records** |
|----------|---------|------------|
|Customer Dimension |Dimension |20 |
|Transaction Type Dimension |Dimension |15 |
|Merchant Category Dimension |Dimension |18 |
|Transaction Fact Table |Fact |1500 |

## Analytical Approach
### Data Preparation
* Validated primary and foreign key intergrity
* Standardized data types
* Resolved transaction failure inconsistencies
* Corrected FX rate anomalies
* Investigated transaction outliers

### SQL-Based Business Analysis
Analysis was performed across six business areas:
1. Transaction Performance
2. Fraud Analysis
3. Customer Segment Analysis
4. Merchant Category Analysis
5. Channel & Device Analysis
6. International Transaction Analysis

### Dashboard Development
Insights were prepared for reporting using Power BI

## Key Insights
### Transaction Operations
* 1500 transactions processed during the analysis period
* Transaction outcomes included Completed, Pending, Declined, and Reversed statuses
* High-value transactions contributed disproportionately to overall transaction value

### Fraud & Risk
* 20% of transactions were flagged fraud
* Fraud activity was concentrated within specific transaction types and customer groups
* High-value fraud cases were predominantly reversed transactions

### Customer Behavior
* Transaction activity varied significantly across customer segments
* Customer tenure and region emerged as major behavioral drivers
* Premium and Business customers contributed a disproportionate share of transaction value

### Merchant Activity
* Spending concentration was observed across a limited number of merchant categories
* Higher-risk merchant categories exhibited elevated fraud exposure

### International Payments
* International transactions generated fee revenue opportunities
* FX-related anomalies highlighted potential operational monitoring requirements

## Forecasting Experiment
A transaction value forecasting was conducted using Random Forest Regression. The model achieved moderate predictive performance but struggled to capture the high volatility present in daily transaction activity.

As a result, forecasting was treated as an exploratory exercise rather than a production-ready business solution.

## Business Decisions Supported
This analysis can support:
* Transaction failure reduction initiatives
* Fraud monitoring and investigation prioritization
* Customer segmentation and engagement strategies
* Merchant risk assessment
* Fee revenue monitoring
* International payment oversight
* Executive performance reporting

## Dataset Ethics
This project uses a synthetic banking dataset.
* No real customer information is included
* Findings should not be used for lending, credit or regulatory decisions
* Fraud indicators are intended for analytical support and not automated enforcement

## Tools & Technologies
* Python (Pandas, NumPy, Scikit-Learn)
* MySQL
* Power BI
* Jupyter Notebook
* Git & GitHub

## Author
**Nandhitha**

Data Analytics | Business Intelligence | Financial Services Analytics
