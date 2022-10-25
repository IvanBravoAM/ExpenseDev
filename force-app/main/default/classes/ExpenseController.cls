public with sharing class ExpenseController {
    
    @AuraEnabled(cacheable=true)
    public static List<Expense__c> getExpenses(){
        try {
            return [SELECT Id, Name,Amount__c, Category__c, Expense_Date__c,Weekly_Recurrent__c,Monthly_Recurrent__c FROM Expense__c ORDER BY Expense_Date__c ASC LIMIT 1000 ];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteExpenses(List<Id> expIds){
        try {
            if(!expIds.isEmpty()){
               delete [SELECT Id FROM Expense__c WHERE Id in:expIds LIMIT 1000 ]; 
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}
