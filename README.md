
Salesforce Development Challenge
**Create an Expense Tracker on Salesforce Lightning**

# Requirements
\1. We need to be able to register expenses using a label, a date, and an amount; 

\2. We need to be able to categorize expenses. Assume the following as allowed options for the list: a. Housing b. Transportation c. Food d. Medical Healthcare e. Others 

\3. We need to be able to create recurrent expenses on a weekly basis. Assume that each recurrent expense is due by Fridays 

\4. We need to be able to create recurrent expenses on a monthly basis. Assume that each recurrent expense is due on the 15th of the month 

\5. We want to be able to know, on a monthly basis, how much was spent per each of the categories (item 2 of the requirements) 

# Implementation
**Expense Creator**

To register expenses I created a component called **expenseCreator** as mentioned in the instructions where I implement the Lightning Record Form to quickly create an Expense record by populating its custom fields.

On the html file for this component I added the object api name, the fields from the object and a listener to the onsuccess action.

I imported all the fields from the Expense object with the salesforce/schema notation for Lightning Web Components and added them to the variable fields and added an Show Toast event to the handleSuccess method to display a message after successfully saving the new record.

**Expense List**

This component is structured on a lightning card with a title, has two action buttons and implements the lightning datatable module where it takes the data, columns and onrowselection action.

For this component I created an Apex Class calles **ExpenseController** and then imported the used methods **getExpenses** and **deleteExpenses**. Also imported refreshapex.

I created a const array containing the correct structure of the object fields to be accepted by the lightning datatable specifying type and other parameters.

The method **wireExpenses** that wires the **getExpenses** apex method executes a query to retrieve all the Expenses objects including all the custom fields created for this project. if the result is successful then each object will be used on the **mapExpense** which will map each field accordingly so the data table can display them correctly.

I implemented the NavigationMixin originally to have a quick way to create records as I was developing the features for this project.

The last two methods were created to handle the deletion of records in **hadleRowSelection** I capture on one variable the selected rows that will be passed to the **deleteSelectedExpenses** method which will call the apex method **deleteExpenses** that receives a list of ids of the expense object to delete, after this I used the refresh apex to reload the data after deletion and update the list. As final action I deselect the rows and reset the variable **selectedExpenses** to prevent errors.

**Recurrent Expenses**

As per my understanding of the requirements, if we create an expense with weekly recurrence that would mean this expense will be created recurrently each week and will have a due date of the next Friday, the same for the monthly expenses but setting the due date to the 15 of the month.

To do this I created two batch clases and two schedulable classes. On the batch classes first we set the data on the start method with a query on the expenses that have the Monthly\_Recurrent\_\_c or the Weekly\_Recurrent\_\_c field as true respectively.

Then on the execute method we will create a new expense object for each record of the previous list copying the same fields except for the Expense\_Date\_\_c which will be calculated differently for each week or monthly recurring expense. 

If it is monthly since the due date should be the 15th of the month, if the original date of the expense was previous to the 15th it will be set to the 15th of the current month, in case it is pass the 15th we will not create an expense with a overdue due date so it will take the 15th of the next month.

In the case of the weekly expense recurrence to set the expense date I first set a date to use as a reference for a day week (in this case I know 1/1/1900 is Monday) then I used the function daysBetween() to know how much days the actual date and the reference date are apart, and using the Math.mod() function with 7 (days of the week) I will then know the position of the current day (0=Monday, 1=Tuesday, etc..) after this I will finally calculate the days to add to the current date to set the expense date based on the day of the week it is, if it is pass friday it will be set to the next friday coming after.

To execute these batch classes I created two Schedulable classes respectively and scheduled via setup to run these jobs, once per week and once per month.

**Dashboard**

Finally to display the relevant data I created a report with and then a dashboard based on this with two charts that displays  how much was spent per each of the categories. I added the dashboard to the Lightning App
# Learning
This project helped me improve my development skills on the Salesforce platform since I am more used to working with existing complex apex logic, several custom objects and nested components but on this project I practice creating components from scratch and recreating some salesforce standard actions as a create record page on Lightning Web Components.

I learned about lightning record form as it doesn't require additional Apex controllers to create or edit record data and how it takes care of field-level security and sharing. Also its limitations since it is less customizable and for this matter it is recommended to use the lightning record view or edit form to add more functionality for example pre populating fields

I found challenge using lightning data table where I face trouble trying to display the object fields correctly and after some research I had to create a map method to map the fields of the custom object to be displayed correctly by the component

Creating the feature of a delete button I ran into a problem because when a DML is performed in an Apex method with @AuraEnabled(Cacheable=true)  and it's called from an LWC method using @wire the System.LimitException: Too many DML statements: 1 error will be thrown. I luckily found information about this issue and could fix the code successfully.

# Notes and future changes
As part of this development I came with some features I think will be interesting to implement on this project to add and enhance functionalities. Some of these I tried to implement but finally decided to rollback either because they weren’t on the original requirements or because I wasn’t able to make fully functional

-Column sorting

-Dynamic search bar on the List component using SOSL

-Creating a button to run the jobs manually from the component in case the user needs to.

-Creating a button that implements refreshApex to refresh the list view component since when a record is created on the Expense Creator component it will not reflect automatically on the Expense List component

-Quick User Guide as a side text component on the App

-Component Styling

-Fields descriptions and Help Texts

# Resources
I list below most of the resources I used to create this project 

[lightning-datatable - documentation - Salesforce Lightning Component Library](https://developer.salesforce.com/docs/component-library/bundle/lightning-datatable/documentation)

[lightning-record-form - documentation - Salesforce Lightning Component Library](https://developer.salesforce.com/docs/component-library/bundle/lightning-record-form/documentation)

[Client-Side Caching of Apex Method Results - Salesforce Lightning Component Library](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.apex_result_caching)

[Understand the Wire Service - Salesforce Lightning Component Library](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.data_wire_service_about)

[Datetime Class | Apex Reference Guide | Salesforce Developers](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_datetime.htm#apex_System_Datetime_format_2)

[Components - Salesforce Lightning Component Library](https://developer.salesforce.com/docs/component-library/overview/components)

[apex - How Can I Tell the Day of the Week of a Date? - Salesforce Stack Exchange](https://salesforce.stackexchange.com/questions/1192/how-can-i-tell-the-day-of-the-week-of-a-date)

[LWC System.LimitException: Too many DML statements: 1 (levelupsalesforce.com)](https://www.levelupsalesforce.com/lwc-too-many-dml-statements-1)
![pie de página](Aspose.Words.867b6df4-13c8-4be1-a00c-d310d16f7c5f.003.png)
