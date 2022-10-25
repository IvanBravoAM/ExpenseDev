global class ExpenseBatch implements Database.Batchable<SObject>{
    List<Expense__c> newExpenses =new  List<Expense__c> ();

    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, Name,Amount__c, Category__c, Expense_Date__c,Weekly_Recurrent__c,Monthly_Recurrent__c FROM Expense__c WHERE Monthly_Recurrent__c = true LIMIT 1000 ]);
    }

    global void execute(Database.BatchableContext bc, List<Expense__c> expenses){

        for(Expense__c exp : expenses){
            Expense__c newExpense = new Expense__c();

            newExpense.Expense_Date__c= (exp.Expense_Date__c.day() >= 15 ? Date.newInstance(exp.Expense_Date__c.year(),exp.Expense_Date__c.month(),15).addMonths(1) : Date.newInstance(exp.Expense_Date__c.year(),exp.Expense_Date__c.month(),15));   
            newExpense.Name=exp.Name;
            newExpense.Category__c=exp.Category__c;
            newExpense.Amount__c=exp.Amount__c;
            newExpense.Monthly_Recurrent__c=false;
            newExpense.Weekly_Recurrent__c=false;
            newExpenses.add(newExpense);           
        }
        insert newExpenses;
    }

    global void finish(Database.BatchableContext bc)
    {

        Messaging.SingleEmailMessage mail  = new Messaging.SingleEmailMessage();
        String[] ToAddress = new String[]{'ivanbravo.2201@gmail.com'};
        mail.setToAddresses(ToAddress);
        mail.setSubject('Batch Job Completed');
        mail.setPlainTextBody('The batch job succesfully executed records');
        messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }

}
