import { LightningElement, wire } from 'lwc';
import getProfileDetails from '@salesforce/apex/NTOProfilePointsController.getMemberDetails';
import { refreshApex } from '@salesforce/apex';

export default class NTOInsiderProfile extends LightningElement {
    profileNumber;
    pointBalance;
    memberId;
    profileDetails;
    tierBalance;
    tier;
    memberTier;

    connectedCallback() {
        refreshApex(this.profileDetails);
    }

    pointsExpiryInfo = {
        points: 210,
        date: "Mar 18, 2021"
    };

    tierInfo = {
        name: 'Gold',
        points: 100
    }

    tierSteps = [
        {
            "label": "Silver",
            "points": 0,
            "isCompleted": (this.tierInfo.name == 'Silver')
        },
        {
            "label": "Gold",
            "points": 10000,
            "isCompleted": (this.tierInfo.name == 'Gold')
        },
        {
            "label": "Platinum",
            "points": 20000,
            "isCompleted": (this.tierInfo.name == 'Platinum')
        }
    ];

    @wire(getProfileDetails)
    wiredProfileDetails (result) {
        this.profileDetails = result;
        const { data, error } = result;
        if (data) {
            this.memberId = data.memberId;
            this.profileNumber = data.membershipNumber;
            this.pointsBalance = data.pointBalance;
            this.tierInfo.name = data.tier;
            this.tierInfo.points = data.tierBalance;
        } else if (error) {
            this.error = error;
        }
    }
}