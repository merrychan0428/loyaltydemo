public without sharing class NTOVouchersController {
/**
* @param programMemberId Program Member Id
* @return List<AvailVouchers> Available Vouchers per customer
Voucher is the name of our new object
*/
@AuraEnabled(cacheable=true)
    public static List<Voucher> getVouchers() {
        List<Voucher> vouchers = new List<Voucher>();
        MemberProfile profileDetails = NTOProfilePointsController.getMemberDetails();
        String programMemberId = '';

        if(String.isNotEmpty(profileDetails.memberId)){
            programMemberId = profileDetails.memberId;
        } else {
            //Just for testing
            // System.debug('Error: No Member Found')
            // return null;
            programMemberId = '0lM3m0000000006EAA';
        }

        try{ 
            vouchers = [ SELECT Name, VoucherCode, VoucherDefinitionId, ExpirationDate, VoucherDefinition.Name, VoucherDefinition.Type, VoucherDefinition.Description, Discount_Code__c FROM Voucher WHERE LoyaltyProgramMemberId = :programMemberId LIMIT 5];
            // System.debug(vouchers.size());
            // System.debug(vouchers);
            return vouchers; 

        } catch( Exception e){
            System.debug(e.getMessage());
            return null;
        }

   }
   
}