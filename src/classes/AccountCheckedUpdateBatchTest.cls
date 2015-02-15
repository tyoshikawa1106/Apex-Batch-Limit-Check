@isTest
private class AccountCheckedUpdateBatchTest {
    
    private static User testAdminUser = new User(Id = UserInfo.getUserId());

    /**
     * executeBatchTest1
     */
    static testMethod void executeBatchTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            Boolean afterChecked = true;
            AccountCheckedUpdateBatch batch = new AccountCheckedUpdateBatch(afterChecked);
            Database.executeBatch(batch, 200);
            
            Test.stopTest();

            // Results
            List<Account> resultAccounts = [SELECT Id, Checked__c FROM Account LIMIT 200];
            System.assertEquals(resultAccounts.isEmpty(), true);

            // Results
            List<BatchLog__c> resultBatchLog = [SELECT Id,StartDateTime__c,EndDateTime__c,RecordCount__c FROM BatchLog__c LIMIT 200];
            System.assertEquals(resultBatchLog.size(), 1);
            System.assertEquals(resultBatchLog[0].StartDateTime__c != null, true);
            System.assertEquals(resultBatchLog[0].EndDateTime__c != null, true);
            System.assertEquals(resultBatchLog[0].RecordCount__c, 0);
        }
    }

    /**
     * executeBatchTest2
     */
    static testMethod void executeBatchTest2() {
        
        System.runAs(testAdminUser) {

            List<Account> accounts = new List<Account>();
            for (Integer i = 0, j = 200; i < j; i++) {
                Account a = new Account(
                     Name = 'Sample'
                    ,Checked__c = false
                );
                accounts.add(a);
            }
            insert accounts;
            System.assertEquals(accounts.size(), 200);

            Test.startTest();
            
            Boolean afterChecked = true;
            AccountCheckedUpdateBatch batch = new AccountCheckedUpdateBatch(afterChecked);
            Database.executeBatch(batch, 200);
            
            Test.stopTest();

            // Results
            List<Account> resultAccounts = [SELECT Id,Checked__c FROM Account LIMIT 200];
            System.assertEquals(resultAccounts.size(), 200);
            for (Account a : resultAccounts) {
                System.assertEquals(a.Checked__c, afterChecked);
            }

            // Results
            List<BatchLog__c> resultBatchLog = [SELECT Id,StartDateTime__c,EndDateTime__c,RecordCount__c FROM BatchLog__c LIMIT 200];
            System.assertEquals(resultBatchLog.size(), 1);
            System.assertEquals(resultBatchLog[0].StartDateTime__c != null, true);
            System.assertEquals(resultBatchLog[0].EndDateTime__c != null, true);
            System.assertEquals(resultBatchLog[0].RecordCount__c, 200);
        }
    }

    /**
     * executeBatchTest3
     */
    static testMethod void executeBatchTest3() {
        
        System.runAs(testAdminUser) {

            List<Account> accounts = new List<Account>();
            for (Integer i = 0, j = 200; i < j; i++) {
                Account a = new Account(
                     Name = 'Sample'
                    ,Checked__c = true
                );
                accounts.add(a);
            }
            insert accounts;
            System.assertEquals(accounts.size(), 200);

            Test.startTest();
            
            Boolean afterChecked = false;
            AccountCheckedUpdateBatch batch = new AccountCheckedUpdateBatch(afterChecked);
            Database.executeBatch(batch, 200);
            
            Test.stopTest();

            // Results
            List<Account> resultAccounts = [SELECT Id,Checked__c FROM Account LIMIT 200];
            System.assertEquals(resultAccounts.size(), 200);
            for (Account a : resultAccounts) {
                System.assertEquals(a.Checked__c, afterChecked);
            }

            // Results
            List<BatchLog__c> resultBatchLog = [SELECT Id,StartDateTime__c,EndDateTime__c,RecordCount__c FROM BatchLog__c LIMIT 200];
            System.assertEquals(resultBatchLog.size(), 1);
            System.assertEquals(resultBatchLog[0].StartDateTime__c != null, true);
            System.assertEquals(resultBatchLog[0].EndDateTime__c != null, true);
            System.assertEquals(resultBatchLog[0].RecordCount__c, 200);
        }
    }
}