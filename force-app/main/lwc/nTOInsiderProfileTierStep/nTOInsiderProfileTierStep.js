import { LightningElement, api } from 'lwc';

export default class NTOInsiderProfileTierStep extends LightningElement {
    @api stepLabel;
    @api stepPoints;
    @api points;

    get pointsLabel() {
        return `${this.stepPoints}pts`;
    }

    get computedClassNames() {
        let classNames = 'tier-step slds-grid slds-grid_vertical slds-grid_vertical-align-center';
        if(this.points >= this.stepPoints) {
            classNames = classNames + ' completed';
        }
        return classNames;
    }
}