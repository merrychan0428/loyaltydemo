/**
 * @description       : Controller class to retrieve recent Program Member Transactions
 * 						and associated Loyalty Ledgers to be shown in the NTO Profile Page.
 * @author            : Salesforce
 * @group             : 
 * @last modified on  : 02-09-2021
 * @last modified by  : Salesforce
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   02-09-2021   Salesforce   Initial Version
**/
public without sharing class NTORecentTransactionsController {
    
    /**
    * @description method to fetch Transaction Journals and associated Loyalty Ledgers as 
    * pass them to datatable in community NTO Profile Page.
    * @param programMemberId Program Member Id
    * @return List<TransactionSummary> Summary details of Transaction Journals
    */
    @AuraEnabled(cacheable=true)
    public static List<TransactionSummary> getTransactionJournals() {
        
        Map<String, TransactionSummary> transactionSummaries = new Map<String, TransactionSummary>();
        Map<String, TransactionJournal> transactionJournals = new Map<String, TransactionJournal>();
        MemberProfile profileDetails = NTOProfilePointsController.getMemberDetails();
        String programMemberId = profileDetails.memberId;
        
        for (TransactionJournal journal : [SELECT Id, ActivityDate, JournalSubType.Name FROM TransactionJournal
                                           WHERE MemberId = :programMemberId
                                           ORDER BY ActivityDate DESC
                                           LIMIT 5]) 
        {
            transactionJournals.put(journal.Id, journal);
        }
        
        if (!transactionJournals.isEmpty()) {
            for (LoyaltyLedger ledger : [SELECT LoyaltyProgramCurrency.Name, TransactionJournalId, 
                                         ActivityDate, EventType, Points, TransactionJournal.ActivityDate,
                                         TransactionJournal.JournalSubType.Id, TransactionJournal.JournalSubType.Name
                                         FROM LoyaltyLedger
                                         WHERE TransactionJournalId IN :transactionJournals.keyset()
                                          
                                         ORDER BY TransactionJournal.ActivityDate DESC]) 
            {
                
                if (!transactionSummaries.containsKey(ledger.TransactionJournalId)) {
                    transactionSummaries.put(ledger.TransactionJournalId, new TransactionSummary(ledger.TransactionJournal.ActivityDate.format('MMMMM dd, yyyy hh:mm:ss a'),
                                                                                                 ledger.TransactionJournal.JournalSubType.Name,
                                                                                                 Integer.valueOf(ledger.Points),
                                                                                                 ledger.LoyaltyProgramCurrency.Name,
                                                                                                 ledger.EventType));
                } else {
                    transactionSummaries.put(ledger.TransactionJournalId, new TransactionSummary(transactionSummaries.get(ledger.TransactionJournalId),
                                                                                                 Integer.valueOf(ledger.Points),
                                                                                                 ledger.LoyaltyProgramCurrency.Name,
                                                                                                 ledger.EventType));
                }
                
            } 
        }
        
        return transactionSummaries.values();
    }    
}