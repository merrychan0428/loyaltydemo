public without sharing class NTOVouchersController {
/**
* @param programMemberId Program Member Id
* @return List<AvailVouchers> Available Vouchers per customer
Voucher is the name of our new object
*/
@AuraEnabled(cacheable=true)
    public static List<Voucher__c> getVouchers() {
        List<Voucher__c> vouchers = new List<Voucher__c>();
        MemberProfile profileDetails = NTOProfilePointsController.getMemberDetails();
        String programMemberId = '';

        if(String.isNotEmpty(profileDetails.memberId)){
            programMemberId = profileDetails.memberId;
        } else {
            //Just for testing
            // System.debug('Error: No Member Found')
            // return null;
            programMemberId = '0lM3m000000004cEAA';
        }

        try{ 
            vouchers = [ SELECT Name, VoucherCode__c, ExpirationDate__c, Discount_Code_c__c, Description__c, Type__c FROM Voucher__c WHERE LoyaltyProgramMemberId__c = :programMemberId LIMIT 5];
            // System.debug(vouchers.size());
            // System.debug(vouchers);
            return vouchers; 

        } catch( Exception e){
            System.debug(e.getMessage());
            return null;
        }

   }
   
}