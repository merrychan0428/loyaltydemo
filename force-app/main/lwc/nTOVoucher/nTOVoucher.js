import {
    LightningElement,
    wire,
    api,
    track
} from 'lwc';
import getVouchers from '@salesforce/apex/NTOVouchersController.getVouchers';
import {
    refreshApex
} from '@salesforce/apex';

export default class NTOVoucher extends LightningElement {

    @api memberId;
    vouchers;
    error;

    get ifHasVoucher() {
        if (this.vouchers) {
            return this.vouchers.length > 0;
        }
        return false;
    }


    connectedCallback() {
        this.initialise();
    }


    initialise() {
        getVouchers().then(result => {
            console.log('getVouchers: ' + JSON.stringify(result));
            if (result) {
                //this.vouchers = data;
                this.vouchers = JSON.parse(JSON.stringify(result));
                this.vouchers.forEach(voucher => voucher.image = this.getVoucherImage(voucher.Type__c));
            } else {
                alert('error');
            }
        }).catch(error => {
            this.error = error;
        });
    }



    @wire(getVouchers)
    wiredVouchers(result) {
        const {
            data,
            error
        } = result;
        if (data) {
            this.vouchers = data;
            // this.VoucherDescriptionId = data.VoucherId;      
        } else if (error) {
            this.error = error;
        }
    }

    getVoucherImage(type) {
        switch (type) {
            case 'FixedValue':
                return 'https://rcg-ido.s3.us-east-2.amazonaws.com/dollars_rewards_icon.png';
            case 'ProductOrService':
                return 'https://rcg-ido.s3.us-east-2.amazonaws.com/merch_rewards_icon.png';
            default:
                return 'https://rcg-ido.s3.us-east-2.amazonaws.com/offers_rewards_icon2.png';
        }
    }

}