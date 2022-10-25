import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/Expense__c.Name';
import AMOUNT_FIELD from '@salesforce/schema/Expense__c.Amount__c';
import CATEGORY_FIELD from '@salesforce/schema/Expense__c.Category__c';
import DATE_FIELD from '@salesforce/schema/Expense__c.Expense_Date__c';
import WRECURRENT_FIELD from '@salesforce/schema/Expense__c.Weekly_Recurrent__c';
import MRECURRENT_FIELD from '@salesforce/schema/Expense__c.Monthly_Recurrent__c';

export default class ExpenseCreator extends LightningElement {

    @api objectApiName='Expense__c';

    fields = [NAME_FIELD, AMOUNT_FIELD, DATE_FIELD,CATEGORY_FIELD, WRECURRENT_FIELD, MRECURRENT_FIELD];

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: 'Expense created',
            message: 'Record ID: ' + event.detail.id,
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }

}