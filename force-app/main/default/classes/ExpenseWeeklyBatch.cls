global class ExpenseWeeklyBatch implements Database.Batchable<SObject>{
    List<Expense__c> newExpenses =new  List<Expense__c> ();
    Map<String,String> daysMap = new Map<String,String>();
    String ddate;
    Date monday = Date.newInstance(1900, 1, 1);
    Integer daynum;
    Integer daystoadd;

    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, Name,Amount__c, Category__c, Expense_Date__c,Weekly_Recurrent__c,Monthly_Recurrent__c FROM Expense__c WHERE Weekly_Recurrent__c = true LIMIT 1000 ]);
    }

    global void execute(Database.BatchableContext bc, List<Expense__c> expenses){

        for(Expense__c exp : expenses){
            Expense__c newExpense = new Expense__c();
            daynum = Math.mod(monday.daysBetween(Date.today()), 7);
            daystoadd = 4-daynum < 0 ? 4-daynum+7 : 4-daynum;
            newExpense.Expense_Date__c= Date.today().addDays(daystoadd);   
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
