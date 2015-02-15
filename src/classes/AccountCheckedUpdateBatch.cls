public with sharing class AccountCheckedUpdateBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    public Boolean afterChecked {get; set;}
    private BatchLog__c batchLog {get; set;}
    private Integer recordCount {get; set;}
    
    public AccountCheckedUpdateBatch(Boolean checked) {
        this.afterChecked = checked;
        this.batchLog = new BatchLog__c(
             RecordCount__c = 0
            ,StartDateTime__c = dateTime.now()
        );
        insert this.batchLog;
        this.recordCount = 0;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id FROM Account';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Account> scope) {
        for (Account account : scope) {
            account.Checked__c = this.afterChecked;
            this.recordCount++;
        }
        update scope;
    }
    
    public void finish(Database.BatchableContext BC) {
        this.batchLog.RecordCount__c = this.recordCount ;
        this.batchLog.EndDateTime__c = dateTime.now();
        update this.batchLog;
        CommonLimit.debugLimitsAll();
        System.debug('JobId = ' + BC.getJobId());
    }
}