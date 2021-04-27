/**
 * @description       : Controller to fetch the Program Member details based on
 *             Logged In User in the community.
 * @author            : Salesforce
 * @group             : 
 * @last modified on  : 02-09-2021
 * @last modified by  : Salesforce
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   02-09-2021   Salesforce   Initial Version
**/
public without sharing class NTOProfilePointsController {
    
    /**
    * @description method to Loyalty Program Member Information based on
    * community Logged In user.
    * @return Wrapper with Loyalty Program Member details
    */
  @AuraEnabled(cacheable=true)
    public static MemberProfile getMemberDetails() {
        List<LoyaltyProgramMember__c> programMembers;
        MemberProfile profileDetails = new MemberProfile();
        
        
        List<User> users = [SELECT  Id, ContactId FROM User
                            WHERE Id = :UserInfo.getUserId()
                            
                            LIMIT 1];
        //users[0].ContactId = '0053h000002gh4CAAQ';

        if (!users.isEmpty() && String.isNotBlank(users[0].ContactId)) {
            programMembers = [SELECT Id__c, MembershipNumber__c FROM LoyaltyProgramMember__c
                              WHERE ContactID__c = :users[0].ContactId LIMIT 1];
        }

        //MembershipNumber__c = 'M20210414-840'
        //Id__c = '0lM3m000000004cEAA'
        
        if (programMembers != null && !programMembers.isEmpty()) {
            profileDetails.memberId = programMembers[0].Id__c;
            profileDetails.membershipNumber = programMembers[0].MembershipNumber__c;
            
            
            for (LoyaltyMemberCurrency__c memberCurrency : [SELECT Name__c, PointsBalance__c FROM LoyaltyMemberCurrency__c
                                                         WHERE LoyaltyMemberId__c = :programMembers[0].Id__c
                                                         ]) 
            {
                if (memberCurrency.Name__c == 'Reward Points') {
                    profileDetails.pointBalance = integer.valueOf(memberCurrency.PointsBalance__c);
                } else if (memberCurrency.Name__c == 'Tier Points') {
                    profileDetails.tierBalance = integer.valueOf(memberCurrency.PointsBalance__c); 
                }
            }
            
            for (LoyaltyMemberTier__c memberTier :[SELECT Name__c FROM LoyaltyMemberTier__c 
                                                 WHERE LoyaltyMemberId__c = :programMembers[0].Id__c
                                                 
                                                 LIMIT 1]){
                profileDetails.tier = memberTier.Name__c;
            }
            
        }
        
        System.debug(LoggingLevel.DEBUG, 'Address :'+profileDetails);
        return profileDetails;
    }
}