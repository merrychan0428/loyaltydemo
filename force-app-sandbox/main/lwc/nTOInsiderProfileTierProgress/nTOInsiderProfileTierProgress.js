import { LightningElement, api, track } from 'lwc';

export default class NTOInsiderProfileTierProgress extends LightningElement {
    @api currentPoints = 0;
    @api steps = [];

    get value() {
        const length = this.steps.length - 1;
        const cPoints = this.currentPoints || 0;
        return (cPoints / this.steps[length].points) * 100;
    }

}