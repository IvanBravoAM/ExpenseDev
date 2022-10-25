import { LightningElement, wire } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import getExpenses from '@salesforce/apex/ExpenseController.getExpenses';
import deleteExpenses from '@salesforce/apex/ExpenseController.deleteExpenses';
import { refreshApex } from '@salesforce/apex';

const COLUMNS = [{label: 'Name', fieldName: 'link', type: 'url', typeAttributes: {label: {fieldName: 'ExpenseName'}}},
{
    label: 'Amount',
    fieldName: 'Amount__c',
    type: 'currency',
    typeAttributes: { currencyCode: 'USD', step: '0.01' },
},
{ label: 'Category', fieldName: 'Category__c', type:'text' },
{
    label: "Due Date",
    fieldName: "Expense_Date__c",
    type: "date-local",
    typeAttributes:{
        month: "2-digit",
        day: "2-digit"
    }
},{label:'Monthly Recurrent' ,fieldName:'Monthly_Recurrent__c', type:'boolean'},
{label:'Weekly Recurrent' ,fieldName:'Weekly_Recurrent__c', type:'boolean'}]


export default class ExpenseList extends NavigationMixin(LightningElement) {
    
    expenses;
    selectedExpenses;
    wiredExpenses;
    columns=COLUMNS;
    
    @wire(getExpenses)
    wireExpenses(result){
        this.wiredExpenses=result;
        if(result.data){
            this.expenses=result.data.map((row) => {
                return this.mapExpense(row);
            });
            console.log(result.data);
        }
        if(result.error){
            console.error(error);
        }
    }

    navigateNewExpense(){
        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                objectApiName: "Expense__c",
                actionName: "new"
            },
        });
    }

    mapExpense(row){

        var category = row.Category__c;
        
        var amount = row.Amount__c;

        var wrecurrent= row.Weekly_Recurrent__c;

        var mrecurrent= row.Monthly_Recurrent__c;

        var date=row.Expense_Date__c;

        return {...row,
         ExpenseName: `${row.Name}`,
         link: `/${row.Id}`,
         Weekly_Recurrent__c:wrecurrent,
         Monthly_Recurrent__c:mrecurrent,
         Amount__c:amount,
         Category__c:category,  
         Expense_Date__c:date
        };
        
    }

    handleRowSelection(event){
        this.selectedExpenses = event.detail.selectedRows;
    }

    deleteSelectedExpenses(){
        const idList = this.selectedExpenses.map( row => { return row.Id })
        deleteExpenses({expIds : idList}).then( () => {
            refreshApex(this.wiredExpenses);
        })
        this.template.querySelector('lightning-datatable').selectedRows = [];
        this.selectedExpenses = undefined;
    }

}