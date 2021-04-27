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
        List<LoyaltyProgramMember> programMembers;
        MemberProfile profileDetails = new MemberProfile();
        MemberProfile.Address mailingAddress = new MemberProfile.Address();
        MemberProfile.Address otherAddress = new MemberProfile.Address();
        
        
        List<User> users = [SELECT Id, ContactId FROM User
                            WHERE Id = :UserInfo.getUserId()
                            
                            LIMIT 1];
        //users[0].ContactId = '0034C00000O4XuTQAV';

        if (!users.isEmpty() && String.isNotBlank(users[0].ContactId)) {
            programMembers = [SELECT Id, MembershipNumber, Contact.MailingStreet, Contact.MailingState, 
                              Contact.MailingCity, Contact.MailingCountry, Contact.MailingPostalCode, 
                              Contact.OtherStreet, Contact.OtherState, Contact.OtherCity, Contact.OtherCountry, 
                              Contact.OtherPostalCode, Contact.Name  FROM LoyaltyProgramMember
                              WHERE contactId = :users[0].ContactId LIMIT 1];
        }
        
        if (programMembers != null && !programMembers.isEmpty()) {
            profileDetails.memberId = programMembers[0].Id;
            profileDetails.membershipNumber = programMembers[0].MembershipNumber;
            profileDetails.memberName = programMembers[0].Contact.Name;
            
            mailingAddress.street = programMembers[0].Contact.MailingStreet;
            mailingAddress.city = programMembers[0].Contact.MailingCity;
            mailingAddress.state = programMembers[0].Contact.MailingState;
            mailingAddress.country = programMembers[0].Contact.MailingCountry;
            mailingAddress.postalCode = programMembers[0].Contact.MailingPostalCode;
            profileDetails.mailingAddress = mailingAddress;
            
            otherAddress.street = programMembers[0].Contact.OtherStreet;
            otherAddress.city = programMembers[0].Contact.OtherCity;
            otherAddress.state = programMembers[0].Contact.OtherState;
            otherAddress.country = programMembers[0].Contact.OtherCountry;
            otherAddress.postalCode = programMembers[0].Contact.OtherPostalCode;
            profileDetails.otherAddress = otherAddress;
            
            for (LoyaltyMemberCurrency memberCurrency : [SELECT Name, PointsBalance FROM LoyaltyMemberCurrency
                                                         WHERE LoyaltyMemberId = :programMembers[0].Id
                                                         ]) 
            {
                if (memberCurrency.Name == 'Reward Points') {
                    profileDetails.pointBalance = integer.valueOf(memberCurrency.PointsBalance);
                } else if (memberCurrency.Name == 'Tier Points') {
                    profileDetails.tierBalance = integer.valueOf(memberCurrency.PointsBalance); 
                }
            }
            
            for (LoyaltyMemberTier memberTier :[SELECT Name FROM LoyaltyMemberTier 
                                                 WHERE LoyaltyMemberId = :programMembers[0].Id
                                                 
                                                 LIMIT 1]){
                profileDetails.tier = memberTier.Name;
            }
            
        }
        
        System.debug(LoggingLevel.DEBUG, 'Address :'+profileDetails);
        return profileDetails;
    }
}