import { LightningElement, api } from 'lwc';
import NTOProfileResources from '@salesforce/resourceUrl/ntoprofile';

export default class NTOInsiderProfilePoints extends LightningElement {
    @api pointsBalance = 0;
    @api expiringPoints = 0;
    @api expiryDate = '';
    @api tierName = '';
    @api tierPoints = 0;
    @api tierSteps = []; 
 

    get expiringInfo() {
        return `${this.expiringPoints} on ${this.expiryDate}`;
    }

    get tierPointsLabel() {
        return `Tier Points: ${this.tierPoints}`;
    }

    get tierBgImg() {
        return NTOProfileResources + '/img/tier-bg.png';
    }

    get styles() {
        return `
            background-image: url(${this.tierBgImg});
            background-position: center;
            background-size: cover;
        `;
    }

}