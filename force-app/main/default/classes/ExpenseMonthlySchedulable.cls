global class ExpenseMonthlySchedulable implements Schedulable {
    global void execute(schedulableContext sc)
    {
        ExpenseBatch eb = new ExpenseBatch();
		Database.executeBatch(eb, 200);
    }

}
