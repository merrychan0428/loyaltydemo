import { LightningElement, api } from 'lwc';
import NTOAssets from '@salesforce/resourceUrl/ntoAssets';

export default class NTOInsiderProfileRecentTransactionsCellActivity extends LightningElement {
    @api type;

    get url() {
        switch(this.type) {
            case "Instagram Post":
                return NTOAssets + '/icons/Icon_instagram.png';
            case "Facebook Post":
                return NTOAssets + '/icons/Icon_facebook.png';
            case "Redeem against order":
                return NTOAssets + '/icons/Icon_Redeem.png';
            case "Purchase":
                return NTOAssets + '/icons/Icon_Purchase.png';
            default:
                return NTOAssets + '/icons/Icon_Activity.png';
        }
    }
}