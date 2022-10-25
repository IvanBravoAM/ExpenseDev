global class ExpenseWeeklySchedulable implements Schedulable{
    global void execute(schedulableContext sc)
    {
        ExpenseWeeklyBatch eb = new ExpenseWeeklyBatch();
		Database.executeBatch(eb, 200);
    }
}
