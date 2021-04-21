import { LightningElement,wire, api} from 'lwc';
import getRecentTransactions from '@salesforce/apex/NTORecentTransactionsController.getTransactionJournals';
import { refreshApex } from '@salesforce/apex';

export default class NTOInsiderProfileRecentTractions extends LightningElement {
    columns = [
        { label: 'Transaction Details', fieldName: 'transactionDetails'},
        { label: 'Date', fieldName: 'transactionDate' },
        { label: 'Reward Points', fieldName: 'rewardPoints' },
        { label: 'Tier Points', fieldName: 'tierPoints' }
    ];

    @api memberId;
    recentTransactions;
    transactionData;

    connectedCallback() {
        refreshApex(this.recentTransactions);
    }

    @wire(getRecentTransactions) 
    wiredRecentTransactions (result) {
        this.recentTransactions = result;
        const { data, error } = result;

        if (data) {
           this.transactionData = JSON.stringify(data);
        } else if (error) {
            this.error = error;
        }
    }
    

    recentTransactions1 = {
        data: [
            {
                transactionDate: 'February 16, 2021 12:56:38 AM',
                transactionDetails: 'Instagram Post',
                rewardPoints: '100',
                tierPoints: '0'
            },
            {
                transactionDate: 'February 16, 2021 12:56:38 AM',
                transactionDetails: 'Purchase',
                rewardPoints: '100',
                tierPoints: '0'
            },
            {
                transactionDate: 'February 16, 2021 12:56:38 AM',
                transactionDetails: 'Redeem against order',
                rewardPoints: '100',
                tierPoints: '0'
            },
            {
                transactionDate: 'February 16, 2021 12:56:38 AM',
                transactionDetails: 'Facebook Post',
                rewardPoints: '100',
                tierPoints: '0'
            },
            {
                transactionDate: 'February 16, 2021 12:56:38 AM',
                transactionDetails: 'Give Aways',
                rewardPoints: '100',
                tierPoints: '0'
            }
        ]
    }



    /*recentTransactions = [
        {
            id: 0,
            date: "May 21, 2020 11:12 AM",
            type: "Purchase",
            rewardPoints: 373,
            tierPoints: 249
        },{
            id: 1,
            date: "June 26, 2020 11:12 AM",
            type: "Product Review",
            rewardPoints: 268,
            tierPoints: 179
        },{
            id: 2,
            date: "Oct 08, 2020 11:12 AM",
            type: "Order",
            rewardPoints: 25,
            tierPoints: 0
        },{
            id: 3,
            date: "May 21, 2021 11:12 AM",
            type: "Purchase",
            rewardPoints: 373,
            tierPoints: 249
        },{
            id: 4,
            date: "May 21, 2021 11:12 AM",
            type: "Purchase",
            rewardPoints: 373,
            tierPoints: 249
        },{
            id: 5,
            date: "May 21, 2021 11:12 AM",
            type: "Purchase",
            rewardPoints: 373,
            tierPoints: 249
        },{
            id: 6,
            date: "May 21, 2021 11:12 AM",
            type: "Purchase",
            rewardPoints: 373,
            tierPoints: 249
        },{
            id: 7,
            date: "May 21, 2021 11:12 AM",
            type: "Purchase",
            rewardPoints: 373,
            tierPoints: 249
        },{
            id: 8,
            date: "May 21, 2021 11:12 AM",
            type: "Purchase",
            rewardPoints: 373,
            tierPoints: 249 
        },{
            id: 9,
            date: "May 21, 2021 11:12 AM",
            type: "Purchase",
            rewardPoints: 373,
            tierPoints: 249
        }
    ]*/
}