/**
 * @description       : Wrapper class to construct recent Transaction information
 * 						with Reward and Tier Points calculation.
 * @author            : Salesforce
 * @group             : 
 * @last modified on  : 02-09-2021
 * @last modified by  : Salesforce
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   02-09-2021   Salesforce   Initial Version
**/
public without sharing class TransactionSummary {
    
    @AuraEnabled
    public String transactionDate { get; set; }
    
    @AuraEnabled
    public String transactionDetails { 
        get {
            if (string.isBlank(transactionDetails)) {
                transactionDetails = 'Points Adjusted';
            }
            return transactionDetails;
        } set; 
    }
    
    @AuraEnabled
    public Integer rewardPoints { 
        get {
            if (rewardPoints == null) {
                rewardPoints = 0;
            }
            return rewardPoints;
        } 
        set; 
    }
    
    @AuraEnabled
    public Integer tierPoints { 
        get {
            if (tierPoints == null) {
                tierPoints = 0;
            }
            return tierPoints;
        } 
        set; 
    }
    
    public TransactionSummary(String transactionDate, String transactionDetails, Integer points, String currencyName, String eventType) {
        this.transactionDate = transactionDate;
        this.transactionDetails = transactionDetails;
        
        if (currencyName == 'Reward Points') {
            this.rewardPoints = (eventType == 'Credit' ?  points : (-1 * points)); 
        } else if (currencyName == 'Tier Points') {
            this.tierPoints = (eventType == 'Credit' ? points : (-1 * points));
        }
        
    }
    
    public TransactionSummary(TransactionSummary summary, Integer points, String currencyName, String eventType) {
        this.transactionDate = summary.transactionDate;
        this.transactionDetails = summary.transactionDetails;
        
        if (currencyName == 'Reward Points') {
            this.rewardPoints = (eventType == 'Credit' ? (summary.rewardPoints + points) : ((-1 * points) + summary.rewardPoints)); 
            this.tierPoints = summary.tierPoints;
        } else if (currencyName == 'Tier Points') {
            this.tierPoints = (eventType == 'Credit' ? (summary.tierPoints + points) : ((-1 * points) + summary.tierPoints));
            this.rewardPoints = summary.rewardPoints;
        }
    }
}