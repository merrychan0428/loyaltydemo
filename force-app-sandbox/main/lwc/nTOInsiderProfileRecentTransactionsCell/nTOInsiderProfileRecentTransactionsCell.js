import { LightningElement, api } from 'lwc';

export default class NTOInsiderProfileRecentTransactionsCell extends LightningElement {
    @api row;
    @api cell;

    get value() {
        return this.row[this.cell.fieldName];
    }

    get isActivityType() {
        return this.cell.label == 'Activity Type';
    }
}